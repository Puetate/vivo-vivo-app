import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/commons/permissions.dart';

import '../../../utils/app_styles.dart';

class PermissionLocation extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  PermissionLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Uso de su Ubicación"),
                    const Image(image: AssetImage("assets/image/location.png")),
                    const Text(
                        textAlign: TextAlign.justify,
                        'Al presionar "SOS" esta aplicación recoge datos de tu ubicación para informar a tu grupo de confianza que estas en peligro y brinde apoyo en donde sea que te encuentres. Incluso cuando la aplicación está cerrada o no este en uso mientras estés en emergencia.'),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Styles.secondaryColor),
                            onPressed: (() {
                              Navigator.of(context).pop();
                            }),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            child: const Text("Aceptar"),
                            onPressed: () => _requestPermissions(context),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _requestPermissions(BuildContext context) {
    Permissions.handleLocationPermission(context);
    Navigator.of(context).pop();
  }
}
