typedef String? Validator(String? value);

Validator requiredValidator = (String? value) {
  if (value != null && value.trim() == "") return "This field is required";
  return null;
};

Validator requiredLengthValidator({double min = 0, double max = 1 / 0}) {
  Validator validator = (String? value) {
    if (value != null && value.trim().length < min)
      return "This field should be at least ${min.toInt()} characters long";
    else if (value != null && value.length > max)
      return "This field should not exceed ${max.toInt()} characters";
    else
      return null;
  };
  return validator;
}

Validator emailValidator = (String? value) {
  if (value==null) {
    return "Please enter an email address";
  }
  RegExp regex = RegExp(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}");
  if (regex.hasMatch(value)) {
    return null;
  }
  return "Please enter a valid email address";
};

Validator usernameValidator = (String? value) {
  if (value != null && !RegExp(r"^[a-zA-Z0-9]{3,20}$").hasMatch(value.trim()))
    return "Invalid username";
  return null;
};
