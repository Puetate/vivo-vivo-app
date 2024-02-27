import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vivo_vivo_app/src/screens/Login/components/button_register.dart';
import 'package:vivo_vivo_app/src/screens/Login/components/button_rembember_password.dart';
import 'package:vivo_vivo_app/src/screens/Login/components/logo.dart';
import 'package:vivo_vivo_app/src/screens/Login/controllers/login_controller.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';
// import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static const String id = "login_view";

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginController loginController;
  bool _loading = false;
  bool isSwitched = false;
  bool _passwordVisible = false;
  // final bool _isNotConnect = false;

  final email = TextEditingController();
  final password = TextEditingController();

  String userNameValue = "";
  String passwordValue = "";
  String textButtonSesion = "Iniciar Sesión";
  String saveSesionText = "Guardar Sesión";
  final formKey = GlobalKey<FormState>();
  // UserProvider userProvider;

  @override
  void initState() {
    //openUserPreferences(context);
    super.initState();
    loginController = LoginController(context);
    loginController.onStateConnect =
        (state) => setLoading(state, textButtonSesion);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);

    return Scaffold(
      body: Stack(children: [
        Container(
          width: double.infinity,
          //padding: const EdgeInsets.symmetric(vertical: 60),
          padding: const EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Styles.primaryColorGradient,
              Styles.secondaryColorGradient,
            ]),
          ),
        ),
        Logo(size: size),
        Container(
          margin: EdgeInsets.only(bottom: (size.height * 0.05)),
          child: const ButtonRegister(),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: (size.height * 0.18),
                      bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Text("Bienvenido",
                              style: Styles.textStyleWelcomeTitle),
                        ),
                        Form(
                          key: formKey,
                          child: Column(children: [
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                                FilteringTextInputFormatter.deny(
                                    Validations.expDenyWhitespace),
                              ],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              controller: email,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                label: Text("Correo Electrónico"),
                              ),
                              onSaved: (value) => {userNameValue = value!},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingrese su Correo";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(15),
                              ],
                              textInputAction: TextInputAction.done,
                              obscureText: !_passwordVisible,
                              controller: password,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    (_passwordVisible)
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Styles.secondaryColor,
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.lock_person),
                                label: const Text("Contraseña"),
                              ),
                              onSaved: (value) => {passwordValue = value!},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingrese su contraseña";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  userNameValue = email.text;
                                  passwordValue = password.text;

                                  showHomePage(
                                      context, userNameValue, passwordValue);
                                }),
                            /*  const SizedBox(
                              height: 15,
                            ),
                            const ButtonRememberPassword() */
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /* if (_isNotConnect)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(56, 56, 76, 1)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
              ],
            ),
          ), */
      ]),
    );
  }

  void showHomePage(
      BuildContext context, String userName, String password) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      if (!_loading) {
        setState(() => initLoading());
        await loginController.showHomePage(userName, password);
      }
    }
  }

  void finalLoading() {
    setState(() {
      _loading = false;
      textButtonSesion = "Iniciar Sesión";
    });
  }

  void setLoading(bool state, String textSesion) {
    setState(() {
      _loading = state;
      textButtonSesion = textSesion;
    });
  }

  void initLoading() {
    _loading = true;
    textButtonSesion = "Iniciando";
  }

/*   Future<void> openUserPreferences(context) async {
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      loginController.openPreferences(context);
    });
  } */
}
