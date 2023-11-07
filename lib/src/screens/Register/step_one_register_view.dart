import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vivo_vivo_app/src/components/text_input.dart' as TX;
import 'package:vivo_vivo_app/src/data/datasource/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/person_info.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/screens/Register/components/user_photo.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';

class StepOneRegisterView extends StatefulWidget {
  const StepOneRegisterView({super.key});
  static const String id = 'register_view';

  @override
  State<StepOneRegisterView> createState() => _StepOneRegisterViewState();
}

class _StepOneRegisterViewState extends State<StepOneRegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController idCard = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController ethnic = TextEditingController();
  DateTime? pickerDate;
  bool isDisability = false;
  XFile? imageFile;
  bool isPhoto = false;
  List<String> listMaritalStatus = [
    'Casado',
    'Soltero',
    'Divorciado',
    'Viudo',
    'Union libre'
  ];
  List<String> listEthnic = [
    'Mestizo',
    'Afroecuatoriano',
    'Indigena',
    'Blanca'
  ];
  List<String> listGender = ['Masculino', 'Femenino', 'No especificado'];

  @override
  void initState() {
    super.initState();
    birthDate.text;
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
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
        title: const Text("Información Personal"),
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
                    left: 15, right: 15, top: 80, bottom: 10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text("Añade una foto retrato"),
                        ),
                        UserPhoto(
                            imageFile: imageFile,
                            onImageSelected: ((file) {
                              setState(() {
                                imageFile = file;
                              });
                            })),
                        if (isPhoto)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "La imagen es obligatoria",
                                style: TextStyle(color: Colors.red[400]),
                              )
                            ],
                          ),
                        const Gap(10),
                        Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TX.TextInput(
                                        hinText: "Ej. Kevin",
                                        label: "Primer Nombre",
                                        textIsEmpty: "Ingrese su Nombre",
                                        inputController: firstName,
                                        keyboardType: TextInputType.name,
                                        lenLimitTextInpFmt: 15,
                                        prefixIcon: Icons.person_outline_rounded,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                    const Gap(15),
                                    Expanded(
                                      child: TX.TextInput(
                                        hinText: "Ej. Daniel",
                                        label: "Segundo Nombre",
                                        textIsEmpty: "Ingrese su Nombre",
                                        inputController: middleName,
                                        keyboardType: TextInputType.name,
                                        lenLimitTextInpFmt: 15,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TX.TextInput(
                                  hinText: "Ej. Chicaiza Suarez",
                                  label: "Apellidos",
                                  textIsEmpty: "Ingrese su Apellido",
                                  inputController: lastName,
                                  keyboardType: TextInputType.name,
                                  lenLimitTextInpFmt: 30,
                                  prefixIcon: Icons.person_outline_rounded,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TX.TextInput(
                                  hinText: "Ej. 1002677784",
                                  label: "Cédula",
                                  textIsEmpty: "Ingrese su Cédula",
                                  inputController: lastName,
                                  keyboardType: TextInputType.number,
                                  lenLimitTextInpFmt: 30,
                                  prefixIcon: Icons.calendar_view_week_outlined,
                                  textInputAction: TextInputAction.next,
                                  validation: Validations.exprOnlyDigits,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                TX.TextInput(
                                  hinText: "dd/MM/yyyy",
                                  label: "Fecha de nacimiento",
                                  textIsEmpty: "Ingrese su Fecha",
                                  inputController: birthDate,
                                  keyboardType: TextInputType.datetime,
                                  lenLimitTextInpFmt: 15,
                                  prefixIcon: Icons.calendar_today_outlined,
                                  textInputAction: TextInputAction.next,
                                  onTap: (() async {
                                    pickerDate = (await showDatePicker(
                                        locale: const Locale("es", "ES"),
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2101)))!;
                                    if (pickerDate != null) {
                                      final dateFormat =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickerDate!);
                                      setState(() {
                                        birthDate.text = dateFormat.toString();
                                      });
                                    }
                                  }),
                                ),                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Estado Civil",
                                              style: Styles.textLabel,
                                            ),
                                          ),
                                          items: listMaritalStatus.map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Estado Civil"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                maritalStatus.text = item!;
                                              })),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Género",
                                              style: Styles.textLabel,
                                            ),
                                          ),
                                          items: listGender.map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Genero"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                gender.text = item!;
                                              })),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            label: Text(
                                              "Etnia",
                                              style: Styles.textLabel,
                                            ),
                                          ),
                                          items: listEthnic.map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? "Elija su Etnia"
                                              : null,
                                          onChanged: (item) => setState(() {
                                                ethnic.text = item!;
                                              })),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "¿Sufre alguna\n discapacidad?",
                                          style: Styles.textLabel,
                                        ),
                                        Checkbox(
                                            activeColor: Styles.primaryColor,
                                            value: isDisability,
                                            onChanged: (value) {
                                              setState(() {
                                                isDisability = value!;
                                              });
                                            }),
                                      ],
                                    )),
                                  ],
                                ),
                              ]),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Continuar"),
                                    Icon(Icons.arrow_forward_rounded)
                                  ],
                                ),
                                onPressed: () {
                                  _showSecondPageRegister(context);
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

  /// records all user data to move to a second screen that records the remaining data
  /// Returns:
  ///   The person object is being returned.
  Future<void> _showSecondPageRegister(BuildContext context) async {
    String firstName = "John";
    String middleName = "Doe";
    String lastName = "Smith";
    String idCard = "0401111018";
    String bithDateCast = "1990-05-15";
    String maritalStatus = "6544319c1ec2bff196722f2f";
    String gender = "6543f6ec9c60565fc80d269d";
    String ethnic = "6543f5eda6822500c8cae61e";

    User user = User(
        username: "tuñaña", email: "pepgay1@gmail.com", password: "password");

    // Crear un objeto Person con información de prueba
    Person person = Person(
      firstName: firstName,
      middleName: middleName,
      lastNames: lastName,
      dni: idCard,
      avatar: imageFile!.path,
      personInfo: PersonInfo(
        birthDate: DateTime.parse(bithDateCast),
        maritalStatus: maritalStatus,
        gender: gender,
        ethnic: ethnic,
        address: "123 Main St",
        phone: "0961803004",
      ),
      /* personDisability: PersonDisability(
        disability: "None",
        percentage: 0,
      ), */
    );
    ApiRepositoryUserImpl serviceUser = ApiRepositoryUserImpl();
    await serviceUser.saveUser(
        user, person, person.personInfo!, person.personDisability);
    /* 
    try {
      if (checkImage()) return;
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        String bithDateCast = DateFormat('yyyy-MM-dd').format(pickerDate);
        Person person = Person(
          firstName: firstName.text,
          middleName: middleName.text,
          lastNames: lastName.text,
          dni: idCard.text,
          avatar: imageFile,
          personInfo: PersonInfo(
            birthDate: DateTime.parse(bithDateCast),
            maritalStatus: maritalStatus.text.toLowerCase(),
            gender: gender.text.toLowerCase(),
            ethnic: ethnic.text.toLowerCase(),
            address: "",
            phone: "",
          ),
          personDisability: PersonDisability(
            disability: "",
            percentage: 0,
          ),
        );

        Navigator.of(context)
            .pushNamed("/secondRegisterPage", arguments: person);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(MySnackBars.errorConnectionSnackBar());
    } */
  }

  bool checkImage() {
    // ignore: unnecessary_null_comparison
    if (imageFile == null) {
      setState(() {
        isPhoto = true;
      });
      return true;
    } else {
      setState(() {
        isPhoto = false;
      });
      return false;
    }
  }
}
