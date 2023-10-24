import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/utils/app_styles.dart';

class ButtonRegister extends StatelessWidget {
  const ButtonRegister({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Styles.blur),
                  onPressed:
                      () => /* _showRegisterPage(contextPushScreen) */ (),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "Regístrate!",
                      style: TextStyle(color: Styles.white, fontSize: 16),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}

