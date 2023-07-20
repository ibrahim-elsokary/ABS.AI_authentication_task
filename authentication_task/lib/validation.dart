class Validation {
  Validation._();

  static bool email(String email) {
    String emailRegExp =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return RegExp(emailRegExp).hasMatch(email);
  }

  static bool userName(String userName) {
    String userNameRegExp = r'^[a-zA-Z0-9_]+$';
    return RegExp(userNameRegExp).hasMatch(userName);
  }

  static bool password(String password) {
    String passwordRegExp = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    return RegExp(passwordRegExp).hasMatch(password);
  }
}
