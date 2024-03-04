import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vivo_vivo_app/src/commons/validators.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/screens/Login/login_view.dart';
import 'package:vivo_vivo_app/src/screens/Register/components/map_direcctions.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';

class StepTwoRegisterView extends StatefulWidget {
  const StepTwoRegisterView({super.key});
  static const String id = 'second_register_view';

  @override
  State<StepTwoRegisterView> createState() => _StepTwoRegisterViewState();
}

class _StepTwoRegisterViewState extends State<StepTwoRegisterView> {
  bool _loading = false;
  bool isSwitched = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  TextEditingController address = TextEditingController();
  String textButtonSesion = "Registrarse";
  Person? personArguments;
  LatLng? directions;

  bool isMatchPaswwords = false;

  var serviceUser = ApiRepositoryUserImpl();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    personArguments = ModalRoute.of(context)!.settings.arguments as Person;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Styles.transparent,
        elevation: 0,
        title: const Text("Información de Registro"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(0, 150, 136, 1),
                Color.fromRGBO(56, 56, 76, 1),
              ]),
            ),
          ),
          Center(
            child: SizedBox(
              child: Card(
                semanticContainer: false,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 90, bottom: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.house_outlined),
                                    const Gap(20),
                                    Text(
                                      "Domicilio",
                                      style: Styles.textStyleTitle,
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.location_on_outlined),
                                    label: Text("Obtener Dirección"),
                                  ),
                                  onSaved: (value) => {address.text = value!},
                                  readOnly: true,
                                  controller: address,
                                  onTap: () => {_navigateAndReturnDirecction()},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese su Dirección";
                                    }
                                    return null;
                                  },
                                ),
                                const Gap(30),

                                //TODO: ¨***********CUENTA*****************
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.account_box_outlined),
                                    const Gap(20),
                                    Text(
                                      "Cuenta",
                                      style: Styles.textStyleTitle,
                                    ),
                                  ],
                                ),

                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        Validations.exprOnlyDigits),
                                  ],
                                  controller: phone,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: "Ej. 09673803004",
                                    prefixIcon:
                                        const Icon(Icons.phone_outlined),
                                    label: Text(
                                      "Teléfono",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {phone.text = value!},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese su telefono";
                                    } else if (value.length != 10 ||
                                        value.substring(0, 2) != "09") {
                                      return "Ingrese un teléfono correcto";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                    FilteringTextInputFormatter.deny(
                                        Validations.expDenyWhitespace),
                                  ],
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    label: Text(
                                      "Email",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {email.text = value!},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese su Email";
                                    } else if (!Validators.validateEmail(
                                        value)) {
                                      return "Ingrese un correo valido";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.deny(
                                        Validations.expDenyWhitespace),
                                  ],
                                  controller: password,
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_person),
                                    label: Text(
                                      "Contraseña",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) => {password.text = value!},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese su contraseña";
                                    } else if (value.length < 8) {
                                      return "La contraseña debe tener almenos 8 caracteres";
                                    }
                                    password.text = value;
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.deny(
                                        Validations.expDenyWhitespace),
                                  ],
                                  controller: passwordConfirm,
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_person),
                                    label: Text(
                                      "Confirmar contraseña",
                                      style: Styles.textLabel,
                                    ),
                                  ),
                                  onSaved: (value) =>
                                      {passwordConfirm.text = value!},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese su contraseña";
                                    } else if (value.length < 8) {
                                      return "La contraseña debe tener al menos 6 caracteres";
                                    }
                                    if (!(password.text == value)) {
                                      return "Las contraseñas no coinciden";
                                    }

                                    return null;
                                  },
                                ),
                              ]),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  maximumSize: Size(
                                    (size.width * 0.35),
                                    (size.width * 0.35),
                                  ),
                                  elevation: 10,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(textButtonSesion),
                                    if (_loading)
                                      Container(
                                        width: 20,
                                        height: 20,
                                        margin: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                  ],
                                ),
                                onPressed: () {
                                  _showHomePage(context);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHomePage(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        textButtonSesion = "Registrando";
        _loading = true;
      });
      personArguments!.personInfo!.phone = phone.text;
      personArguments!.personInfo!.address = address.text;

      FamilyGroup user = FamilyGroup(
        password: passwordConfirm.text,
        email: email.text,
      );
      var res = await serviceUser.saveUser(
        user,
        personArguments!,
        personArguments!.personInfo!,
        personArguments!.personDisability,
      );
      // ignore: unnecessary_null_comparison
      if (res == null || res.error) {
        setState(() {
          textButtonSesion = "Registrarse";
          _loading = false;
        });
        return;
      }
      // final size = AppLayout.getSize(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                      color: Styles.primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "¡Perfecto!",
                        style: Styles.textStyleBody,
                      ),
                    ],
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${res.data["message"]}",
                      style: Styles.textStyleTitle,
                    ),
                  ],
                ),
                titlePadding: const EdgeInsets.all(0),
                actions: [
                  TextButton(
                      onPressed: (() => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              LoginView.id, (Route<dynamic> route) => false)),
                      child: Text(
                        "OK",
                        style: Styles.textLabel.copyWith(color: Colors.blue),
                      ))
                ],
              ));
    }
  }

  Future<void> _navigateAndReturnDirecction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPlaces()),
    );

    if (!mounted) return;
    address.text = result;
  }
}
