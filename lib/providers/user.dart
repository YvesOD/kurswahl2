import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/gender.dart';

class User with ChangeNotifier {
  final String userId;

  String schoolId;
  String currentSchoolYear;
  String currentGradeLevel;
  String firstName;
  String lastName;
  GenderOptions gender;
  var _isAbifach = false;

  User({this.userId});

  bool get isAbifach => _isAbifach;

  set isAbifach(bool value) {
    if (value != _isAbifach) {
      _isAbifach = value;
      notifyListeners();
    }
  }

  void setAbifach(value) {}

  User.deserialize(String serializedUserData)
      : userId = json.decode(serializedUserData)['userId'],
        schoolId = json.decode(serializedUserData)['schoolId'],
        currentSchoolYear =
            json.decode(serializedUserData)['currentSchoolYear'],
        currentGradeLevel =
            json.decode(serializedUserData)['currentGradeLevel'],
        firstName = json.decode(serializedUserData)['firstName'],
        lastName = json.decode(serializedUserData)['lastName'],
        gender = getGenderOptionsFromString(
            json.decode(serializedUserData)['gender']),
        _isAbifach = json.decode(serializedUserData)['isAbifach'];

  String serialize() {
    print('gender: $gender');
    //print('gender in json: ${json.encode(gender)}');
    return json.encode({
      'userId': userId,
      'schoolId': schoolId,
      'currentSchoolYear': currentSchoolYear,
      'currentGradeLevel': currentGradeLevel,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.toString(),
      'isAbifach': isAbifach,
    });
  }
}
