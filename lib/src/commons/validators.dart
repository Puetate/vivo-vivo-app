class Validators {
  /// The first two digits of the ID must be 04, the third digit must be less than 6, and the last digit
  /// must be the result of a calculation based on the other digits
  ///
  /// Args:
  ///   cedula (String): The ID number to be validated.
  ///
  /// Returns:
  ///   A bool value.
  static bool isValidateIdCard(String cedula) {
    bool cedulaCorrecta = false;

    try {
      /* if (cedula.substring(0, 2) != "04") {
        cedulaCorrecta = false;
      } else { */
      if (cedula.length == 10) // ConstantesApp.LongitudCedula
      {
        int tercerDigito = int.parse(cedula.substring(2, 3));
        if (tercerDigito < 6) {
// Coeficientes de validación cédula
// El decimo digito se lo considera dígito verificador
          List<int> coefValCedula = [2, 1, 2, 1, 2, 1, 2, 1, 2];
          int verificador = int.parse(cedula.substring(9, 10));
          int suma = 0;
          int digito = 0;
          for (int i = 0; i < (cedula.length - 1); i++) {
            digito = int.parse(cedula.substring(i, i + 1)) * coefValCedula[i];
            suma += ((digito % 10).toInt() + (digito ~/ 10));
          }

          if ((suma % 10 == 0) && (suma % 10 == verificador)) {
            cedulaCorrecta = true;
          } else if ((10 - (suma % 10)) == verificador) {
            cedulaCorrecta = true;
          } else {
            cedulaCorrecta = false;
          }
        } else {
          cedulaCorrecta = false;
        }
      } else {
        cedulaCorrecta = false;
      }
      /*   } */
    } on FormatException {
      cedulaCorrecta = false;
    } on Exception {
      cedulaCorrecta = false;
    }

    if (!cedulaCorrecta) {
      print("La Cédula ingresada es Incorrecta");
    }
    return cedulaCorrecta;
  }

  static bool validateEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
