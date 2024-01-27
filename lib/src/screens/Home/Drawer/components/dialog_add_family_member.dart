import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:vivo_vivo_app/src/components/text_input.dart' as TX;
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_family_group_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/family_group.dart';
import 'package:vivo_vivo_app/src/screens/Home/Drawer/components/card_person.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';

class FormFamilyMember {
  String textButton = "Buscar";
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  FamilyGroupResponse? user;
  
  TextEditingController dni = TextEditingController();
    Key key = Key('input_dni');
  Future<void> dialogAddFamilyMember(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Center(
                  child:
                      Text('Añadir un Familiar', style: Styles.textStyleBody),
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
                            TextFormField(
                              controller: dni,
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15),
                                    FilteringTextInputFormatter.deny(
                                        Validations.exprWithoutWhitespace),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.lock_person),                                    
                                  ),
                                  /* onSaved: (value) =>
                                      {dni.text = value!}, */
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese su contraseña";
                                    }                                   
                                    return null;
                                  },
                                ),
                            if (user != null) CardPerson(user: user!),
                          ],
                        ),
                      ),
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
                          ],
                        ),
                        onPressed: () async {
                          handleSubmit(setState);
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  ApiRepositoryFamilyGroupImpl familyGroupServices =
      ApiRepositoryFamilyGroupImpl();

  Future<FamilyGroupResponse?> getUserByDni(String dni) async {
    //1805283452
    var res = await familyGroupServices.getUserByDni(dni);
    if (res.data == null || res.error as bool) return null;
    FamilyGroupResponse user = FamilyGroupResponse.fromJson(res.data);
    return user;
  }

  Future<void> handleSubmit(StateSetter setState) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        textButton = "Buscando";
        loading = true;
      });

      var foundedUser = await getUserByDni(dni.text);
      if (foundedUser == null) {
        setState(() {
          textButton = "Buscar";
          loading = false;
        });
        return;
      }
      setState(() {
        user = foundedUser;
      });
    }
  }
}
