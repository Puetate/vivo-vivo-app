import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_family_group_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/family_group.dart';
import 'package:vivo_vivo_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_app/src/screens/Home/Drawer/components/card_person.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_app/src/utils/snackbars.dart';

class DeleteFamilyMember {
  bool loading = false;
  bool loadingDelete = false;
  String buttonTextBuscar = "Buscar";
  ApiRepositoryFamilyGroupImpl familyGroupServices =
      ApiRepositoryFamilyGroupImpl();

  TextEditingController dni = TextEditingController();
  Future<void> dialogConfirmDeleteFamilyMember(BuildContext context,
      Function reloadFunction, FamilyGroupResponse userFamilyMember) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final Size size = AppLayout.getSize(context);

        return StatefulBuilder(
          builder: (context, setState) {
            String buttonTextAceptar = "Quitar";
            // var _loading = false;
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 11),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: (size.width * 0.15)),
                decoration: BoxDecoration(
                    color: Styles.redText,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Center(
                  child: Text('Quitar persona de confianza',
                      style: Styles.textStyleBody),
                ),
              ),
              titlePadding: const EdgeInsets.all(0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CardPerson(user: userFamilyMember),
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Styles.redText.withBlue(100)),
                        onPressed: loadingDelete
                            ? null
                            : () async {
                                handleDelete(
                                    context,
                                    reloadFunction,
                                    userFamilyMember.userID!.toString(),
                                    setState);
                              },
                        child: loadingDelete
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Styles.red,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(buttonTextAceptar),
                                  const Gap(5),
                                  const Icon(Icons.delete)
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

  Future<void> handleDelete(BuildContext context, Function reload,
      String userFamilyMemberID, StateSetter setState) async {
    String id = context
        .read<UserProvider>()
        .getUserPrefProvider!
        .getUser
        .userID
        .toString();
    setState(() {
      loadingDelete = true;
    });
    var res = await familyGroupServices.deleteFamilyGroupMember(
        id, userFamilyMemberID);
    if (!context.mounted) return;
    if (res.data == null || res.error as bool) {
      Navigator.of(context).pop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(MySnackBars.successSnackBar(
        "Persona de confianza eliminada con éxito.", "¡Excelentes noticias!"));
    setState(() {
      loadingDelete = false;
    });
    Navigator.of(context).pop();
    reload();
  }
}
