
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: (size.height * 0.09)),
          child: Image.asset(
            "assets/image/logo.png",
            height: (size.height * 0.2),
          ),
        ),
      ],
    );
  }
}
