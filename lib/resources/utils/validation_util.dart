import 'dart:convert';

class ValidationUtil {
  static String? validatePassword(String password) {
    String errMessage = "";
    if (password.isEmpty) {
      errMessage = "${errMessage}Password is required. ";
    }
    if (!RegExp(r"[A-Z]").hasMatch(password)) {
      errMessage =
          "${errMessage}Password must contain at least an upper case alphabet. ";
    }
    if (!RegExp(r"[a-z]").hasMatch(password)) {
      errMessage =
          "${errMessage}Password must contain at least lower case alphabet. ";
    }
    if (!RegExp(r"[0-9]").hasMatch(password)) {
      errMessage = "${errMessage}Password must contain at least a digit. ";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      errMessage = "${errMessage}Password must contain a special character. ";
    }
    if (password.length < 8 || password.length > 30) {
      errMessage = "${errMessage}Password length must be between 8 and 30. ";
    }
    if (password.contains(" ")) {
      errMessage = "${errMessage}Passowrd cannot contain whitespace. ";
    }
    return errMessage.isEmpty ? null : errMessage;
  }

  static String? validateConfirmPassword(
      String confirmPassword, String password) {
    if (password != confirmPassword) {
      return "Password does not match password above";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static bool isValidPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Za-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static String? validateInput(String? value, String name) {
    return (value == null || value.isEmpty) ? "$name is required" : null;
  }

  static String? isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    if (emailRegex.hasMatch(email)) {
      return null;
    } else {
      return 'Invalid email address';
    }
  }

  static String? validateText(String text) {
    if (text.isEmpty) {
      return "Input cannot be empty";
    }
    return null;
  }
}
