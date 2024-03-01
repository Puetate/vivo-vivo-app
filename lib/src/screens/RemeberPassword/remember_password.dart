import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/components/text_input.dart' as TX;
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/screens/Login/login_view.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class RememberPassView extends StatefulWidget {
  const RememberPassView({super.key});
  static const String id = 'remember_password_view';

  @override
  State<RememberPassView> createState() => _RememberPassViewState();
}

class _RememberPassViewState extends State<RememberPassView> {
  final formKey = GlobalKey<FormState>();
  bool _loading = false;
  TextEditingController email = TextEditingController();
  String textButtonSesion = "Recuperar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        //padding: const EdgeInsets.symmetric(vertical: 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(0, 150, 136, 1),
            Color.fromRGBO(56, 56, 76, 1),
          ]),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 27),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, right: 30),
                      child: Text(
                        "Recuperar contraseña",
                        style: Styles.textStyleBody.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 60, bottom: 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            "¿Ha olvidado su contraseña?",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 5),
                          child: Text(
                            "Se enviará una contraseña temporal a su correo electrónico.",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Column(children: [
                            TX.TextInput(
                              prefixIcon: Icons.lock_person,
                              hinText: "",
                              label: "Correo Electrónico",
                              textIsEmpty: "Ingrese su correo electrónico",
                              keyboardType: TextInputType.emailAddress,
                              inputController: email,
                              lenLimitTextInpFmt: 30,
                              validation: Validations.exprWithoutWhitespace,
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                onPressed: _loading
                                    ? null
                                    : () {
                                        rememberPass(context);
                                      },
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
                                )),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void rememberPass(context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Map<String, dynamic> changePasswordData = {
        "email": email.text,
      };

      if (!_loading) {
        setState(() {
          _loading = true;
          textButtonSesion = "Enviando";
        });
        ApiRepositoryUserImpl apiRepositoryUserImpl = ApiRepositoryUserImpl();
        var res = await apiRepositoryUserImpl
            .postSendEmailChangePassword(changePasswordData);

        if (res == null || res.error) {
          setState(() {
            _loading = false;
            textButtonSesion = "Enviar";
          });
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
            MySnackBars.successSnackBar(res.data["message"], "¡Excelente!"));
        Navigator.of(context).pushReplacementNamed(LoginView.id);
      }
    }
  }
}
