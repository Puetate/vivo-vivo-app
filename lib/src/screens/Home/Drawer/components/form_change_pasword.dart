import 'package:flutter/services.dart';
import 'package:vivo_vivo_app/src/components/text_input.dart' as TX;
import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';

class FormComponent {
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  String passwordConfirm = "";
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
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TX.TextInput(                                 
                                prefixIcon: Icons.lock_person,
                                hinText: "XXXXXXX",
                                label: "Contraseña Nueva",
                                textIsEmpty: "Ingrese su contraseña",
                                inputController: password,
                                lenLimitTextInpFmt: 15,
                                validation: Validations.exprWithoutWhitespace,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.deny(
                                        Validations.exprWithoutWhitespace),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  obscureText: !passwordVisible,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.lock_person),
                                    label: Text("Confirmar contraseña"),
                                  ),
                                  onSaved: (value) =>
                                      {passwordConfirm = value!},
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
                              ),
                            ],
                          ),
                        ),
                      ],
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(buttonTextAceptar),
                              /*  
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
                                ) */
                            ],
                          ),
                          onPressed: () async {
                            setState(() {
                              textButton = "Cambiando";
                              // _loading = true;
                            });
                            /* bool isChangePassword =
                                await _changePassword(context);
                            if (isChangePassword) {
                              setState(() {
                                textButton = "Aceptar";
                                _loading = false;
                              });
                            } */
                          },
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
}
