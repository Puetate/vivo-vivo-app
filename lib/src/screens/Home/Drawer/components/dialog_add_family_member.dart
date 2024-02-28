import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:vivo_vivo_app/src/components/text_input.dart' as TX;
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_family_group_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/family_group.dart';
import 'package:vivo_vivo_app/src/domain/models/family_group_request.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/Home/Drawer/components/card_person.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/app_validations.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class FormFamilyMember {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  FamilyGroupResponse? user;
  String buttonTextBuscar = "Buscar";
  ApiRepositoryFamilyGroupImpl familyGroupServices =
      ApiRepositoryFamilyGroupImpl();

  TextEditingController dni = TextEditingController();
  Future<void> dialogAddFamilyMember(
      BuildContext context, Function reloadFunction) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final Size size = AppLayout.getSize(context);

        return StatefulBuilder(
          builder: (context, setState) {
            String buttonTextAceptar = "Añadir";
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
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TX.TextInput(
                            prefixIcon: Icons.calendar_view_week_outlined,
                            hinText: "",
                            label: "Cédula",
                            textIsEmpty: "Ingrese una cédula",
                            inputController: dni,
                            lenLimitTextInpFmt: 15,
                            validation: Validations.exprOnlyDigits,
                          ),
                        ),
                        Gap(8),
                        TextButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  handleSearchUser(setState);
                                },
                          child: Text(buttonTextBuscar),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  if (user != null) CardPerson(user: user!),
                  if (loading && (user == null))
                    const CircularProgressIndicator.adaptive()
                ],
              ),
              actions: [
                if (user != null)
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
                          onPressed: () async {
                            handleSubmit(context, reloadFunction);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(buttonTextAceptar),
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
      },
    );
  }

  Future<FamilyGroupResponse?> getUserByDni(String dni) async {
    //1805283452
    var res = await familyGroupServices.getUserByDni(dni);
    if (res.data == null || res.error as bool) return null;
    FamilyGroupResponse user = FamilyGroupResponse.fromJson(res.data);
    return user;
  }

  Future<void> handleSubmit(BuildContext context, Function reload) async {
    String id = context
        .read<UserProvider>()
        .getUserPrefProvider!
        .getUser
        .userID
        .toString();
    FamilyGroupRequest familyGroupRequest =
        FamilyGroupRequest(user: id, userFamilyMember: user!.userID.toString());
    var res = await familyGroupServices.postFamilyGroup(familyGroupRequest);
    if (res.data == null || res.error as bool) {
      Navigator.of(context).pop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar(
        "Familiar añadido con éxito.", "¡Excelentes noticias!"));
    Navigator.of(context).pop();
    reload();
  }

  Future<void> handleSearchUser(StateSetter setState) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        loading = true;
      });

      var foundedUser = await getUserByDni(dni.text);
      if (foundedUser == null) {
        setState(() {
          loading = false;
        });
        return;
      }
      setState(() {
        loading = false;
        user = foundedUser;
      });
    }
  }
}
