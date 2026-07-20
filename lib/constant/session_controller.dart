class SessionController {
  static final SessionController _instance = SessionController._internal();

  String? test = "";
  int? _selectedLang = 1;

  factory SessionController() {
    return _instance;
  }

  SessionController._internal();

  void setLanguage(int? id) {
    _selectedLang = id;
  }

  int? getLanguage() {
    return _selectedLang;
  }

  void resetSession() {}
}
