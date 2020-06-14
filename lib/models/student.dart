import 'package:flutter/foundation.dart';

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String schoolId;
  final String classLevel;

  Student({
  @required this.id,
  @required this.firstName,
  @required this.lastName,
  @required this.email,
  @required this.classLevel,
  @required this.schoolId,
});

}