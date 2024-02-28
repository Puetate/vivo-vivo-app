import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vivo_vivo_app/src/components/text_input.dart' as TX;
import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/global/global_variable.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class FormComponent {
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  String passwordConfirm = "";
  bool loading = false;
  String textButton = "Aceptar";

  Future openFormChangePassword(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          bool passwordVisible = false;
          final Size size = AppLayout.getSize(context);

          return StatefulBuilder(
            builder: (context, setState) {
              String buttonTextAceptar = "Aceptar";
              // var _loading = false;
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: (size.width * 0.15)),
                  decoration: BoxDecoration(
                      color: Styles.primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Center(
                    child: Text(
                      'Cambiar Contraseña',
                      style: Styles.textStyleBody,
                    ),
                  ),
                ),
                titlePadding: const EdgeInsets.all(0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TX.TextInput(
                            prefixIcon: Icons.lock_person,
                            hinText: "",
                            label: "Contraseña Anterior",
                            textIsEmpty: "Ingrese su contraseña",
                            keyboardType: TextInputType.text,
                            inputController: oldPassword,
                            obscureText: !passwordVisible,
                            lenLimitTextInpFmt: 15,
                            validation: Validations.exprWithoutWhitespace,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TX.TextInput(
                              prefixIcon: Icons.lock_person,
                              keyboardType: TextInputType.text,
                              hinText: "",
                              label: "Contraseña Nueva",
                              textIsEmpty: "Ingrese su contraseña",
                              inputController: password,
                              obscureText: !passwordVisible,
                              lenLimitTextInpFmt: 15,
                              validation: Validations.exprWithoutWhitespace,
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15),
                              FilteringTextInputFormatter.deny(
                                  Validations.expDenyWhitespace),
                            ],
                            textInputAction: TextInputAction.done,
                            obscureText: !passwordVisible,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock_person),
                              label: Text("Confirmar contraseña"),
                            ),
                            onSaved: (value) => {passwordConfirm = value!},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Ingrese su contraseña";
                              }
                              if (!(password.text == value)) {
                                return "Las contraseñas no coinciden";
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Mostrar Contraseña"),
                        Checkbox(
                            value: passwordVisible,
                            onChanged: (value) {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  setState(() {
                                    textButton = "Cambiando";
                                    loading = true;
                                  });

                                  await _changePassword(context, setState);
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(buttonTextAceptar),
                              if (loading)
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
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  Future<void> _changePassword(
      BuildContext context, StateSetter setState) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ApiRepositoryUserImpl apiRepositoryUserImpl = ApiRepositoryUserImpl();
      String id =
          context.read<UserProvider>().getUserPrefProvider!.getUser.userID.toString();

      Map<String, dynamic> changePasswordData = {
        "oldPassword": oldPassword.text,
        "newPassword": password.text,
        "confirmPassword": password.text,
      };

      var res = await apiRepositoryUserImpl.postChangePassword(
          id, changePasswordData);
      if (res.data == null || res.error as bool) {
        Navigator.of(context).pop();
        return;
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext!)
          .showSnackBar(MySnackBars.successSnackBar(
              "Contraseña cambiada con éxito.", "¡Excelentes noticias!"));
      setState(() {
        textButton = "Aceptar";
        loading = false;
      });
    }
  }
}
