import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/gender.dart';

class Course with ChangeNotifier {
  final String id;
  final String title;
  final String category;
  final GenderOptions gender;
  final int minAttendance;
  final int maxAttendance;
  final String description;
  final int sws;
  final String imageUrl;

//  bool isFavorite;
  bool isSelected;

  Course({
    @required this.id,
    @required this.title,
    @required this.category,
    @required gender,
    @required this.minAttendance,
    @required this.maxAttendance,
    @required this.description,
    @required this.sws,
    @required this.imageUrl,
//    this.isFavorite = false,
    this.isSelected = false,
  }) : this.gender = gender == 'm'
            ? GenderOptions.Male
            : gender == 'f' ? GenderOptions.Female : null;

//  void _setFavValue(bool newValue) {
//    isFavorite = newValue;
//    notifyListeners();
//  }
//
//  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
//    final oldStatus = isFavorite;
//    _setFavValue(!isFavorite);
//    //ToDo: url (adjust to project in GCP)
//    final url =
//        'https://honolulu-2020.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
//    try {
////      final response = await http.patch(
//      final response = await http.put(
//        url,
//        body: json.encode(
////          {
////            'isFavorite': isFavorite,
////          },
//          isFavorite,
//        ),
//      );
//      if (response.statusCode >= 400) {
//        _setFavValue(oldStatus); // rollback (if optimistic update failed)
//      }
//    } catch (error) {
//      _setFavValue(oldStatus); // rollback (if optimistic update failed)
//    }
//  }

  void _setSelValue(bool newValue) {
    isSelected = newValue;
    notifyListeners();
  }

  Future<void> toggleSelectedStatus(String authToken, String userId) async {
    final oldStatus = isSelected;
    _setSelValue(!isSelected);
    //ToDo: url (adjust to project in GCP)
    final foobar = 'hipphipphurra'; //userId
    final schoolId = 'saf%20lajs%C3%B6faew%C3%B6nae';
    final schoolYear = '2019_2020';
    final url =
        'https://honolulu-2020.firebaseio.com/elsa/students/$foobar/schools/$schoolId/schoolYears/$schoolYear/slectedCourses.json?auth=$authToken';
    try {
//      final response = await http.patch(
      final response = await http.put(
        url,
        body: json.encode(
          isSelected,
        ),
      );
      if (response.statusCode >= 400) {
        _setSelValue(oldStatus); // rollback (if optimistic update failed)
      }
    } catch (error) {
      _setSelValue(oldStatus); // rollback (if optimistic update failed)
    }
  }
}
