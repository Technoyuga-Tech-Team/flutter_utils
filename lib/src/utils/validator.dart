class Validator {
  Validator._();

  static String? emailValidator(String? email) {
    if (email != null && email.isNotEmpty) {
      if (isEmailValid(email)) {
        return null;
      } else {
        return 'Enter valid email address';
      }
    } else {
      return 'Please enter email address';
    }
  }

  static String? fullNameValidator(String? fullName) {
    if (fullName != null && fullName.isNotEmpty) {
      return null;
    } else {
      return 'Please enter full name';
    }
  }

  static String? firstNameValidator(String? firstName) {
    if (firstName != null && firstName.isNotEmpty) {
      return null;
    } else {
      return 'Please enter first name';
    }
  }

  static String? lastNameValidator(String? lastName) {
    if (lastName != null && lastName.isNotEmpty) {
      return null;
    } else {
      return 'Please enter last name';
    }
  }

  static String? phoneNumberValidator(String? number) {
    if (number != null && number.isNotEmpty) {
      return null;
    } else {
      return 'Please enter phone number';
    }
  }


  static String? messageValidator(String? message) {
    if (message != null && message.trim().isNotEmpty) {
      return null;
    } else {
      return 'Please enter valid message';
    }
  }
  static String? passwordValidator(String? password, {bool isStrong = true}) {
    if (password != null && password.isNotEmpty) {
      if (isStrong) {
        if (isPasswordValid(password)) {
          return null;
        } else {
          return 'Password must be at least 8 characters, at least 1 upper case letter, at least 1 lower case letter, at least 1 number, at least 1 special character';
        }
      } else {
        return null;
      }
    } else {
      return 'Please enter password';
    }
  }

  static String? newPasswordValidator(String? value, String oldPassword) {
    if (value?.isNotEmpty ?? false) {
      if (oldPassword == value) {
        return 'This new password is already used';
      } else {
        if (isPasswordValid(value)) {
          return null;
        } else {
          return 'Password must be at least 8 characters, at least 1 upper case letter, at least 1 lower case letter, at least 1 number, at least 1 special character';
        }
      }
    } else {
      return 'Please new enter password';
    }
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value != null && value.isNotEmpty) {
      if (password == value) {
        return null;
      }
      return 'Password dose not match';
    } else {
      return 'Please re-enter your password';
    }
  }

  static String? genderValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    } else {
      return 'Select your gender';
    }
  }

  static String? dobValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      return null;
    } else {
      return 'Select your date of birth';
    }
  }

  static bool isPasswordValid(String? password) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern.toString());
    return password != null ? regExp.hasMatch(password) : false;
  }

  static bool isEmailValid(String? email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern.toString());
    return email != null ? regExp.hasMatch(email) : false;
  }
}
