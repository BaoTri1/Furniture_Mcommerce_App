class CheckString{
  static bool containsDigit(String input) {
    // Biểu thức chính quy kiểm tra xem có số nào trong chuỗi hay không
    RegExp digit = RegExp(r'\d');

    return digit.hasMatch(input);
  }

  static bool containsSpecialCharacters(String input) {
    // Biểu thức chính quy kiểm tra xem có ký tự đặc biệt nào trong chuỗi hay không
    RegExp specialChars = RegExp(r'[!@#%^&*()?":{}|<>]');

    return specialChars.hasMatch(input);
  }

  static bool checkNumandSpecialCharacters(String text){
    if (!containsDigit(text) && !containsSpecialCharacters(text)) {
      return false;
    }
    return true;
  }

  static bool checkSpecialCharacters(String text){
    if (!containsSpecialCharacters(text)) {
      return false;
    }
    return true;
  }
}