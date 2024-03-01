import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:vivo_vivo_app/src/components/photo.dart';
import 'package:vivo_vivo_app/src/domain/models/user_alert.dart';
import 'package:vivo_vivo_app/src/screens/MapLocation/map_location.dart';
import 'package:vivo_vivo_app/src/utils/app_layout.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

/// Is a card component with view alerts for user
class CardAlert extends StatelessWidget {
  const CardAlert({super.key, required this.userAlert});
  final UserAlert userAlert;
  final String DANGER = "DANGER";

  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);
    String state =
        (userAlert.status.toUpperCase() == DANGER) ? "En peligro" : "Seguro";
    Color colorState = (userAlert.status.toUpperCase() == DANGER)
        ? Styles.redText
        : Styles.green;

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
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
                      children: [UIComponents.photo(size, userAlert.avatar)],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(userAlert.names),
                          Text(
                            "Estado: $state",
                            style: Styles.textState.copyWith(color: colorState),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        (userAlert.status == "DANGER")
                            ? RippleAnimation(
                                repeat: true,
                                color: colorState,
                                minRadius: 40,
                                ripplesCount: 2,
                                child: ClipOval(
                                  child: Container(
                                    width: size.width * 0.12,
                                    height: size.width * 0.12,
                                    color: colorState,
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Container(
                                  width: size.width * 0.12,
                                  height: size.width * 0.12,
                                  color: colorState,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                Divider(
                  height: 2,
                  color: Styles.gray,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (userAlert.status == "DANGER")
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationMap(
                                        user: userAlert,
                                      )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Seguir Ubicación",
                              style: Styles.textButtonTrackLocation,
                            ),
                            const Gap(10),
                            RotatedBox(
                              //turns: AlwaysStoppedAnimation(45 / 360),
                              quarterTurns: 1,
                              child: Icon(
                                Icons.navigation_rounded,
                                color: colorState,
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
