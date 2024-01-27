import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/components/photo.dart';
import 'package:vivo_vivo_app/src/domain/models/family_group.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

/// Is a card component with view alerts for user
class CardPerson extends StatelessWidget {
  final FamilyGroupResponse user;

  const CardPerson({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [UIComponents.photo(size, user.avatar)],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            user.names,
                            style: Styles.textStyleTitle.copyWith(fontSize: 15),
                          ),
                          Text(
                            "Teléfono: ${user.phone}",
                            style: Styles.textLabel,
                          ),
                          Text("Cédula: ${user.dni}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
