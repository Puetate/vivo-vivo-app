import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vivo_vivo_app/src/domain/models/user_auth.dart';
import 'package:vivo_vivo_app/src/screens/Home/Drawer/components/family_group.dart';
import 'package:vivo_vivo_app/src/screens/Home/Drawer/components/form_change_pasword.dart';
import 'package:vivo_vivo_app/src/screens/Home/controllers/home_controller.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({super.key, required this.user});
  final UserAuth user;

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);
    return Drawer(
      width: 270,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.names),
            accountEmail: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.user.email),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.user.phone),
                    ],
                  ),
                ),
              ],
            ),
            currentAccountPicture: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClipOval(
                child: SizedBox(
                  child: CachedNetworkImage(
                    width: size.width * 0.9,
                    height: size.width * 0.07,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.avatar,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error_outline),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/image/back_user.jpg"),
                    fit: BoxFit.fill)),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    ListTile(
                        title: const Text("Núcleo de Confianza"),
                        trailing: const Icon(Icons.family_restroom),
                        onTap: () => showBarModalBottomSheet(
                              context: context,
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (context) => FamilyGroup(
                                userId: widget.user.userID.toString(),
                              ),
                            )),
                    const Divider(
                      height: 10,
                    ),
                    ListTile(
                        title: const Text("Cambiar Contraseña"),
                        trailing: const Icon(Icons.lock_rounded),
                        onTap: () {
                          FormComponent formComponent = FormComponent();
                          formComponent.openFormChangePassword(context);
                        }),
                  ],
                ),
                Column(
                  children: [
                    ListTile(
                      title: const Text("Cancel"),
                      trailing: const Icon(Icons.cancel),
                      onTap: () => Navigator.pop(context),
                    ),
                    const Divider(),
                    ListTile(
                        title: const Text("Cerrar Sesión"),
                        trailing: const Icon(Icons.exit_to_app_rounded),
                        onTap: () => _logOut(context)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logOut(context) async {
    HomeController homeController = HomeController(context);
    homeController.logOut();
  }
}
