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
  late Future<List<FamilyGroupResponse>>
      _familyGroupFuture; // Declara la variable para almacenar el Future

  ApiRepositoryFamilyGroupImpl familyGroupServices =
      ApiRepositoryFamilyGroupImpl();

  Future<List<FamilyGroupResponse>> getAllFamilyGroupByUserId(
      String userId) async {
    print("gdsfsgdfgfghfgh");
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _familyGroupFuture = getAllFamilyGroupByUserId(
        widget.userId); // Inicializa el Future en initState
  }

  Future<void> reloadData() async {
    setState(() {
      _familyGroupFuture = getAllFamilyGroupByUserId(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    const String textButtonAddFamilyMember = "Agregar";
    const String errorMessage =
        "No tiene ninguna persona de confianza registrada";

    String grupoFamiliar = 'Núcleo de Confianza';
    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            title: Text(grupoFamiliar)),
        body: SafeArea(
          bottom: false,
          child: FutureBuilder<List<FamilyGroupResponse>>(
            future: _familyGroupFuture,
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
                    : const MessageIsEmptyCoreTrust(errorMessage: errorMessage);
              } else if (snapshot.hasError) {
                return const MessageIsEmptyCoreTrust(
                    errorMessage: errorMessage);
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
            formFamilyMember.dialogAddFamilyMember(context, reloadData);
            setState(() {
              _familyGroupFuture = getAllFamilyGroupByUserId(widget
                  .userId); // Actualiza el Future después de cerrar el diálogo
            });
          },
          label: const Text(textButtonAddFamilyMember),
          icon: const Icon(Icons.person_add),
          backgroundColor: Styles.primaryColor,
        ),
      ),
    );
  }
}

class MessageIsEmptyCoreTrust extends StatelessWidget {
  const MessageIsEmptyCoreTrust({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          textAlign: TextAlign.center,
          errorMessage,
          style: Styles.textStyleTitle,
        ),
      ),
    );
  }
}
