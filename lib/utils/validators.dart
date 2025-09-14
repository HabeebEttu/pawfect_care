bool isValidName(String name) {
  final trimmed = name.trim();
  final nameRegex = RegExp(r"^[a-zA-Z\s]{3,}$");
  return nameRegex.hasMatch(trimmed);
}

bool isValidEmail(String email) {
  final trimmed = email.trim();
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(trimmed);
}

bool isValidPassword(String password) {
  final trimmed = password.trim();
  return trimmed.length >= 6;
}
