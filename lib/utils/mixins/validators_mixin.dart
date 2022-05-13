import 'package:grip/utils/extensions/string_extension.dart';

mixin ValidatorMixin {
  static int inputLength = 6;

  String? validateNotEmptyField(String input, [String? label]) {
    if (input.isEmpty) {
      return label == null ? 'This field cannot be empty' : 'Enter a $label';
    } else {
      return null;
    }
  }

  String? validateEmail(String input) {
    if (input.validateEmail()) {
      return null;
    } else if (input.isEmpty) {
      return 'Enter your email';
    } else {
      return 'Enter a valid email address';
    }
  }

  String? validatePassword(input) {
    if (input.isNotEmpty) {
      return null;
    } else {
      return 'Enter your password';
    }
  }

  bool? isPasswordValid(String password) {
    if (password.length < inputLength) {
      return false;
    }
    if (password.isEmpty) {
      return false;
    }

    return true;
  }

  String? validateConfirmPasswordField(String input, String password) {
    if (input != password) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }
}
