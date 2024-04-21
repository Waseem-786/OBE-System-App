class Course {
  static String? _code;
  static String? _title;
  static int? _theory_credits;
  static int _lab_credits = 0;
  static String? _course_type;
  static String? _required_elective;
  static String? _prerequisite;
  static String? _description;

  Course();

  //setter getter for course code
  static String? get code => _code;

  static set code(String? value) {
    _code = value;
  }

  //setter getter for course title
  static String? get title => _title;

  static set title(String? value) {
    _title = value;
  }

  //setter getter for course's theory credits
  static int? get theory_credits => _theory_credits;

  static set theory_credits(int? value) {
    _theory_credits = value;
  }

  //setter getter for course's lab credits
  static int get lab_credits => _lab_credits;

  static set lab_credits(int value) {
    _lab_credits = value;
  }

  //setter getter for course type
  static String? get course_type => _course_type;

  static set course_type(String? value) {
    _course_type = value;
  }

  //setter getter for course sense of being required or elective
  static String? get required_elective => _required_elective;

  static set required_elective(String? value) {
    _required_elective = value;
  }

  //setter getter for course's prerequisite
  static String? get prerequisite => _prerequisite;

  static set prerequisite(String? value) {
    _prerequisite = value;
  }

  //setter getter for course's description
  static String? get description => _description;

  static set description(String? value) {
    _description = value;
  }
}
