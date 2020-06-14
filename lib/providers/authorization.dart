import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kurswahl/models/gender.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/authorization_exception.dart';
import 'selection.dart';
import 'user.dart';

import '../models/http_exception.dart';

class Authorization with ChangeNotifier {
  final String _authToken;
  final String _userId;
  final String _email;
  String _regStatus;

  String _selectionData;

  User user;

  Authorization(this._authToken, this._userId, this._email, [previousEmail]) {
    user = User(userId: _userId);

//    if (_email != null && previousEmail != null && previousEmail != _email) {
    if (previousEmail != null && previousEmail != _email) {
//      print('previousEmail: $previousEmail');
//      print('_email: $_email');
      clear();
    } else {}
  }

  bool get isAuthorized {
    return user.schoolId == null || user.schoolId == '' ? false : true;
  }

  String get email => _email;

  String get selectionData => _selectionData;


  void setAbifach(bool value) {
    user.isAbifach = value;
    notifyListeners();
  }

//  Authorization(
//    this._authToken,
//    this._email,
//  );

  Future<void> authorize(String accessCode) async {
    print('Autorisierung: authorize()');
    if (await authorizeRegisteredUser()) {
      //ToDO
      return;
    }

    print('accessCode: $accessCode');
    accessCode = Uri.encodeQueryComponent(accessCode);

    print('accessCode: $accessCode');
    final url =
        'https://honolulu-2020.firebaseio.com/elsa/users/students/$accessCode.json?auth=$_authToken';
//    print('Autorisierung: url = $url');
    try {
      const errorMessage = 'Autorisierungscode ungültig';
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        throw AuthorizationException(errorMessage);
      }
      if (responseData['error'] != null) {
        print(json.decode(response.body)['error']);
        //ToDo: check if response really (always) has ['message']
        throw HttpException(responseData['error']['message']);
      }
      print('Autorisierung: responseData = ${responseData.toString()}');

      final personData = responseData['person'] as Map<String, dynamic>;
      final email = personData['email'];
      if (personData == null || email == null || email != _email) {
        throw AuthorizationException(errorMessage);
      }

      final gender = personData['gender'] == 'm'
          ? GenderOptions.Male
          : personData['gender'] == 'w' ? GenderOptions.Female : null;
      await _setUserAndPreferences(
        firstName: personData['firstName'],
        lastName: personData['lastName'],
        gender: gender,
        schoolId: responseData['school'],
        currentSchoolYear: responseData['schoolYear'],
        currentGradeLevel: responseData['gradeLevel'],
      );
      print('Autorisierung: ${user.schoolId}');
      notifyListeners();
      //_regStatus;
    } catch (error) {
      print('Autorisierung: error');
      print('$error');
      throw (error);
    }
  }

  void _setUser({
    @required String firstName,
    @required String lastName,
    @required GenderOptions gender,
    @required String schoolId,
    @required String currentSchoolYear,
    @required String currentGradeLevel,
  }) {
    user.firstName = firstName;
    user.lastName = lastName;
    user.gender = gender;
    user.schoolId = schoolId;
    user.currentSchoolYear = currentSchoolYear;
    user.currentGradeLevel = currentGradeLevel;
  }

  Future<void> _setUserAndPreferences({
    @required String firstName,
    @required String lastName,
    @required GenderOptions gender,
    @required String schoolId,
    @required String currentSchoolYear,
    @required String currentGradeLevel,
  }) async {
    _setUser(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      schoolId: schoolId,
      currentSchoolYear: currentSchoolYear,
      currentGradeLevel: currentGradeLevel,
    );
    final prefs = await SharedPreferences.getInstance();
    print('_setUserAndPreferences...');
    final authorizationData = json.encode({
      'user': user.serialize(),
      'schoolId': schoolId,
    });
    print('..._setUserAndPreferences');
    prefs.setString('authorizationData', authorizationData);
  }

  Future<bool> authorizeRegisteredUser() async {
    print('Start of authorizeRegisteredUser');
    final url =
        'https://honolulu-2020.firebaseio.com/elsa/students/$_userId.json?auth=$_authToken';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        print('responseData == null');
        return false;
      }
      print('responseData != null');
      print(responseData);
      final firstName = responseData['person']['firstName'];
      final lastName = responseData['person']['lastName'];
      print('lastName: $lastName');
      final gender = responseData['person']['gender'] == 'm'
          ? GenderOptions.Male
          : responseData['person']['gender'] == 'w'
              ? GenderOptions.Female
              : null;
      print('gender finished');
      final schoolId = responseData['schools'].keys.toList().first;
      final schoolYear =
          responseData['schools'][schoolId]['schoolYears'].keys.toList().first;
      final gradeLevel = responseData['schools'][schoolId]['schoolYears']
          [schoolYear]['gradeLevel'];

      //if (schools == null || schools.isEmpty) {}
      await _setUserAndPreferences(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        schoolId: schoolId,
        currentSchoolYear: schoolYear,
        currentGradeLevel: gradeLevel,
      );
      print('finished _setPreferences');
      await fetchAndSetSelectionPreferences();
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  Future<bool> tryAutoAuthorize() async {
    print('Autorisierung: tryAutoAuthorize()');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authorizationData')) {
      print('tryAutoAuthorize: KEINE authorizationData');
      if (!await authorizeRegisteredUser()) {
        print('tryAutoAuthorize: und KEIN authorizeRegisteredUser');
        return false;
      }
      print('tryAutoAuthorize: aber authorizeRegisteredUser');
    }

    final extractedAuthorizationData = json
        .decode(prefs.getString('authorizationData')) as Map<String, Object>;
    print('tryAutoAuthorize: $extractedAuthorizationData');
    final schoolId = extractedAuthorizationData['schoolId'];
    if (schoolId == null || schoolId == '') {
      user.schoolId == null;
      return false;
    }
    user = User.deserialize(extractedAuthorizationData['user']);
//    _setUser(
//      firstName: extractedAuthorizationData['firstName'],
//      lastName: extractedAuthorizationData['lastName'],
//      gender: extractedAuthorizationData['gender'],
//      schoolId: schoolId,
//      currentSchoolYear: extractedAuthorizationData['schoolYear'],
//      currentGradeLevel: extractedAuthorizationData['gradeLevel'],
//    );
    fetchAndSetSelectionPreferences();

    notifyListeners();
    return true;
  }

  Future<void> clear() async {
    print('Autorisierung: clear()');
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authorizationData');
  }

  Future<void> fetchAndSetSelectionPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('selectionData_$_userId')) {
      print(
          'AUTHORIZATION: NOT restored Selection due to missing selectionData of User');
      _selectionData = null;
      return; //<String, SelectionItem>{};
    }
    _selectionData =
        //json.decode(prefs.getString('selectionData_$_userId')) as String;
        prefs.getString('selectionData_$_userId');
    print('AUTHORIZATION: restored Selection from SharedPreferences');
    //return;
  }
}
