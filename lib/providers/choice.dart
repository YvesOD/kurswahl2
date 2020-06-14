import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'selection.dart';

class ChoiceItem {
  final String id;
  final int sws;
  final List<SelectionItem> courses;
  final DateTime dateTime;

  ChoiceItem({
    @required this.id,
    @required this.sws,
    @required this.courses,
    @required this.dateTime,
  });
}

class Choice with ChangeNotifier {
  List<ChoiceItem> _choice = [];
  final String authToken;
  final String userId;

//  Choice({
//    @required this.authToken,
//    @required this.userId,
//    @required choice,
//  }) : _choice = choice;
  Choice(
    this.authToken,
    this.userId,
    _choice,
  );

  List<ChoiceItem> get choice {
    return [..._choice];
  }

  Future<void> fetchAndSetChoice() async {
    //ToDo: Adjust url (project of GCP)
    final url =
        'https://honolulu-2020.firebaseio.com/choices/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<ChoiceItem> loadedChoice = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((choiceId, choiceData) {
      loadedChoice.add(ChoiceItem(
        id: choiceId,
        sws: choiceData['sws'],
        dateTime: DateTime.parse(choiceData['dateTime']),
        courses: (choiceData['courses'] as List<dynamic>)
            .map((item) => SelectionItem(
                  id: item['id'],
                  sws: item['sws'],
                  title: item['title'],
                ))
            .toList(),
      ));
    });
    _choice = loadedChoice.reversed.toList();
    notifyListeners();
  }

  Future<void> addChoice(
      List<SelectionItem> selectionCourses, int totalSws) async {
    //ToDo: Adjust url (project of GCP)
    final url =
        'https://honolulu-2020.firebaseio.com/choices/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'sws': totalSws,
        'dateTime': timestamp.toIso8601String(),
        'courses': selectionCourses
            .map((selCourse) => {
                  'id': selCourse.id,
                  'title': selCourse.title,
                  'sws': selCourse.sws,
                })
            .toList(),
      }),
    );

    _choice.insert(
        0,
        ChoiceItem(
          //id: DateTime.now().toString(),
          id: json.decode(response.body)['name'],
          sws: totalSws,
          dateTime: timestamp,
          courses: selectionCourses,
        ));
    notifyListeners();
  }
}
