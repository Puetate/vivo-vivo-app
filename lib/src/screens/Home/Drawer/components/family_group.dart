import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/data/datasource/mongo/api_repository_family_group_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/family_group.dart';
import 'package:vivo_vivo_app/src/screens/Home/Drawer/components/card_person.dart';
import 'package:vivo_vivo_app/src/screens/Home/Drawer/components/dialog_add_family_member.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

class FamilyGroup extends StatefulWidget {
  final String userId;

  const FamilyGroup({super.key, required this.userId});

  @override
  State<FamilyGroup> createState() => _FamilyGroupState();
}

class _FamilyGroupState extends State<FamilyGroup> {
  ApiRepositoryFamilyGroupImpl familyGroupServices =
      ApiRepositoryFamilyGroupImpl();

  Future<List<FamilyGroupResponse>> getAllFamilyGroupByUserId(
      String userId) async {
    var res = await familyGroupServices.getAllFamilyGroupByUserId(userId);
    if (res.data == null || res.error as bool)
      return List<FamilyGroupResponse>.empty();
    List<FamilyGroupResponse> users = (res.data as List)
        .map(
          (p) => FamilyGroupResponse.fromJson(p),
        )
        .toList();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    const String textButtonAddFamilyMember = "Añadir nuevo familiar";
    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            title: const Text('Grupo Familiar')),
        body: SafeArea(
          bottom: false,
          child: FutureBuilder<List<FamilyGroupResponse>>(
            future: getAllFamilyGroupByUserId(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final user = snapshot.data![index];
                          return CardPerson(
                            user: user,
                          );
                        },
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "No tiene agregado ningún miembro",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Styles.primaryColor,
                  ),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            FormFamilyMember formFamilyMember = FormFamilyMember();
            formFamilyMember.dialogAddFamilyMember(context);
          },
          label: const Text(textButtonAddFamilyMember),
          icon: const Icon(Icons.person_add),
          backgroundColor: Styles.primaryColor,
        ),
      ),
    );
  }
}
