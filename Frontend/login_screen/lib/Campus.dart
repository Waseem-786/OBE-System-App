class Campus {
  static int _id = 0;
  static String _name = '';
  static String _vision = '';
  static String _mission = '';
  static int _university_id = 0;
  static String _university_name = '';


  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String get name => _name;

  static int get university_id => _university_id;

  static set university_id(int value) {
    _university_id = value;
  }

  static String get mission => _mission;

  static set mission(String value) {
    _mission = value;
  }

  static String get vision => _vision;

  static set vision(String value) {
    _vision = value;
  }

  static set name(String value) {
    _name = value;
  }

  static String get university_name => _university_name;

  static set university_name(String value) {
    _university_name = value;
  }

}