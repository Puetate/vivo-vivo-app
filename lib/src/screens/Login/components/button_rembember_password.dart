import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/screens/RemeberPassword/remember_password.dart';

class ButtonRememberPassword extends StatelessWidget {
  const ButtonRememberPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(RememberPassView.id);
            },
            child: const Text(
              "¿Olvidó su contraseña?",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
