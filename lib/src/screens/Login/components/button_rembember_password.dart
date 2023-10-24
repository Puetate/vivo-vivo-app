import 'package:flutter/material.dart';

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
              textStyle: TextStyle(
                  color:
                      Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed("/rememberPassword");
            },
            child: const Text(
              "¿Olvidó su contraseña?",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
