class ValidatorHelper {
  static String? validatePhone(String? value, String requiredMessage, String invalidMessage) {
    if (value == null || value.isEmpty) {
      return requiredMessage;
    }
    // Simple phone regex: at least 10 digits
    final phoneRegex = RegExp(r'^\d{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return invalidMessage;
    }
    return null;
  }

  static String? validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }
}
