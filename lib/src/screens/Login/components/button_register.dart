import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/data/datasource/api_repository_user_impl.dart';
import 'package:vivo_vivo_app/src/domain/models/person.dart';
import 'package:vivo_vivo_app/src/domain/models/person_disability.dart';
import 'package:vivo_vivo_app/src/domain/models/person_info.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/screens/Register/step_one_register_view.dart';
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
                  style: TextButton.styleFrom(backgroundColor: Styles.blur),
                  onPressed: () => _showRegisterPage(context),
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

  Future<void> _showRegisterPage(BuildContext context) async {
    Navigator.of(context).pushNamed(StepOneRegisterView.id);
  }
}
