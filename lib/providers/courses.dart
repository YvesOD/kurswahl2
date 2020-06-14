import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kurswahl/providers/user.dart';

import '../models/http_exception.dart';
import 'authorization.dart';
import 'course.dart';
import '../models/gender.dart';

class Courses with ChangeNotifier {
  List<Course> _items = [];

  final String authToken;

  //final String userId;
  final User user;
  final Authorization authorization;

//  Courses({
//    @required this.authToken,
//    @required this.userId,
//    @required courses,
//  }) : _items = courses;
  Courses(
    this.authToken,
    this.user,
    this.authorization,
    this._items,
  );



  List<Course> get items {
    //return [..._items];
    print('COURSES: get items - ${authorization.user.isAbifach}');
    print('COURSES: get items - ${user.isAbifach}');

    return [..._items]
      ..sort((one, two) {
        if (one.category == two.category) {
          return one.title.compareTo(two.title); // ascending
        } else {
          return two.category
              .compareTo(one.category); // descending (team|individual|extra)
        }
      });
  }

  List<Course> get filteredItems {
    return items.where((item) {
      if (authorization.user.isAbifach && item.category == 'extra') {
        print('COURSES: user.isAbifach && item.category == extra');
        return false;
      } else {
        return true;
      }
    }).toList();
  }

//  List<Course> get favoriteItems {
//    return _items.where((crsItem) => crsItem.isFavorite).toList();
//  }

  List<Course> genderItems(GenderOptions gender) {
    if (gender == null) {
      return filteredItems;
    }
    return filteredItems
        .where((crsItem) => crsItem.gender == gender || crsItem.gender == null)
        .toList();
  }

  Course findById(String id) {
    return _items.firstWhere((crs) => crs.id == id);
  }

  Future<void> fetchAndSetCourses({filterByUser = false}) async {
    //final filterString = filterByUser ? '&orderBy="merchantId"&equalTo="$userId"' : '';
    final filterString = '';
    //ToDo: url
    final userId = user.userId; //'hipphipphurra'; //userId
    final schoolId = user.schoolId; // 'saf%20lajs%C3%B6faew%C3%B6nae';
    final schoolYear = user.currentSchoolYear; // '2019_2020';
    final gradeLevel = user.currentGradeLevel; // '11';

    print('fetchAndSetCourses - userId: $userId');
    print('fetchAndSetCourses - schoolId: $schoolId');
    print('fetchAndSetCourses - schoolYear: $schoolYear');
    print('fetchAndSetCourses - gradeLevel: $gradeLevel');

    var url =
//        'https://honolulu-2020.firebaseio.com/products.json?auth=$authToken$filterString';
        'https://honolulu-2020.firebaseio.com/elsa/courses/schools/$schoolId/schoolYears/$schoolYear/gradeLevels/$gradeLevel.json?auth=$authToken$filterString';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Course> loadedCourses = [];
      //ToDo: url
      url =
//          'https://honolulu-2020.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
          'https://honolulu-2020.firebaseio.com/elsa/students/$userId/schools/$schoolId/schoolYears/$schoolYear/selectedCourses.json?auth=$authToken';
      final selectedResponse = await http.get(url);
      final selectedData = json.decode(selectedResponse.body);
      extractedData.forEach((crsId, crsData) {
//        selectedData == null || selectedData[crsId] == null
//            ? () {}
//            : print(
//                'fetchAndSetCourses: $crsId is stored in firebase as selected');
        final course = Course(
          id: crsId,
          title: crsData['title'],
          category: crsData['category'],
          gender: crsData['gender'],
          minAttendance: crsData['minAttendance'],
          maxAttendance: crsData['maxAttendance'],
          description: crsData['description'],
          sws: crsData['sws'],
          imageUrl: crsData['imageUrl'],
//            isFavorite: false,
          isSelected:
              selectedData == null ? false : selectedData[crsId] ?? false,
        );
        if (user.gender == null ||
            course.gender == null ||
            user.gender == course.gender) {
          loadedCourses.add(
            course,
          );
        }
      });
      _items = loadedCourses;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

/*
  Future<void> addCourse(Course course) async {
    //TodO: url
    final url =
        'https://honolulu-2020.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': course.title,
          'description': course.description,
          'imageUrl': course.imageUrl,
          'sws': course.sws,
          //'merchantId': userId,
        }),
      );
      final newCourse = Course(
        id: json.decode(response.body)['name'],
        title: course.title,
        description: course.description,
        sws: course.sws,
        imageUrl: course.imageUrl,
      );
      _items.add(newCourse);
      //_items.insert(0, newProduct); //at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCourse(String id, Course newCourse) async {
    final crsIndex = _items.indexWhere((crs) => crs.id == id);
    if (crsIndex >= 0) {
      //ToDo: url
      final url =
          'https://honolulu-2020.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': newCourse.title,
          'description': newCourse.description,
          'sws': newCourse.sws,
          'imageUrl': newCourse.imageUrl,
        }),
      );
      _items[crsIndex] = newCourse;
      notifyListeners();
    } else {
      print('no course id to update course');
    }
  }

  Future<void> deleteCourse(String id) async {
    //ToDo: url
    final url =
        'https://honolulu-2020.firebaseio.com/products/$id.json?auth=$authToken';
    final existingCourseIndex = _items.indexWhere((crs) => crs.id == id);
    var existingCourse = _items[existingCourseIndex];

    //_items.removeWhere((prod) => prod.id == id);
    _items.removeAt(existingCourseIndex);
    notifyListeners(); // Optimistic Updating

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      // re-add, if optimistic updating failed
      _items.insert(existingCourseIndex, existingCourse);
      notifyListeners();
      throw HttpException('Could not delete course.');
    }
    existingCourse = null;
  }
*/
}
