class Validations {
  static RegExp exprOnlyLetter = RegExp(r'[ a-zA-ZñÑáéíóú]');
  static RegExp exprOnlyDigits = RegExp(r'[0-9]');
  static RegExp exprWithoutWhitespace = RegExp(r'[ ]');
  static RegExp exprWithLetterDigits = RegExp(r'[ A-Za-z0-9]');
}
