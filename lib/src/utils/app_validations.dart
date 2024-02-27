class Validations {
  static RegExp exprOnlyLetter = RegExp(r'[ a-zA-ZñÑáéíóú]');
  static RegExp exprOnlyDigits = RegExp(r'[0-9]');
  static RegExp expDenyWhitespace = RegExp(r'[ ]');
  static RegExp exprWithoutWhitespace = RegExp(r'^\S+$');
  static RegExp exprWithLetterDigits = RegExp(r'[ A-Za-z0-9]');
}
