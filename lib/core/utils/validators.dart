import '../constants/app_strings.dart';

class Validators {
  Validators._();

   static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    final email = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9]+([._%+\-][a-zA-Z0-9]+)*@([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$',
    );
    if (email.length > 254 || !emailRegex.hasMatch(email)) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    return null;
  }

   static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }
    // Egyptian mobile: 01XXXXXXXXX, +201XXXXXXXXX or 201XXXXXXXXX
    final phoneRegex = RegExp(r'^(?:\+?20|0)1[0125][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return AppStrings.phoneInvalid;
    }
    return null;
  }
}
