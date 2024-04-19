class University {
  static int _id = 0;
  static String _name = '';
  static String? _vision; // Updated to nullable String
  static String? _mission; // Updated to nullable String

  University();

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String get name => _name;

  static set name(String value) {
    _name = value;
  }

  static String? get vision => _vision; // Updated getter to return nullable String

  static set vision(String? value) { // Updated setter to accept nullable String
    _vision = value;
  }

  static String? get mission => _mission; // Updated getter to return nullable String

  static set mission(String? value) { // Updated setter to accept nullable String
    _mission = value;
  }
}
