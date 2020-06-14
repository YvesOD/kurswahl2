import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/gender.dart';

class Sport {
  final String id;
  final String title;
  final String category;
  final GenderOptions gender;

  Sport({
    @required this.id,
    @required this.title,
    @required this.category,
    @required gender,
  }) : this.gender = gender == 'm'
      ? GenderOptions.Male
      : gender == 'f' ? GenderOptions.Female : null;
}

class Student {
  final String userId;

  //String schoolId;
  //String currentSchoolYear;
  //String currentGradeLevel;
  final String firstName;
  final String lastName;
  final GenderOptions gender;
  final bool isAbifach;

  List<Map<int, String>>
  _prioritizedSports; // [{1: Sport(...), 3: Sport(...}, 2: Sport(...)]

  Student({
    @required this.userId,
    @required this.firstName,
    @required this.lastName,
    @required this.gender,
    @required this.isAbifach,
  });

  List<Map<int, String>> get prioritizedSports {
    return _prioritizedSports;
  }

  set prioritizedSports(List<Map<int, String>> prioSport) {
    //ToDo: check if prio is unique
    _prioritizedSports = prioSport;
  }
}

class Course {
  final String id;
  final String title;
  final String category;
  final GenderOptions gender;
  int _minAttendance = 1;
  int _maxAttendance = 99;

  Course({
    @required this.id,
    @required this.title,
    @required this.category,
    @required gender,
  }) : this.gender = gender == 'm'
      ? GenderOptions.Male
      : gender == 'f' ? GenderOptions.Female : null;

  int get minAttendance => _minAttendance;

  int get maxAttendance => _maxAttendance;

  set minAttendance(int value) {
    if (value != null) {
      _minAttendance = min(max(1, value), _maxAttendance);
    }
  }

  set maxAttendance(int value) {
    if (value != null) {
      _maxAttendance = max(min(99, value), _minAttendance);
    }
  }
}

class BusinessLogic {

  BusinessLogic();

  List<Student> students = [
    Student(userId: 'a',
        firstName: 'Anton',
        lastName: 'Antonius',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'b',
        firstName: 'Bob',
        lastName: 'Bobby',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'c',
        firstName: 'Charlie',
        lastName: 'Charles',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'd',
        firstName: 'Diana',
        lastName: 'Delta',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'e',
        firstName: 'Eugen',
        lastName: 'Egenius',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'f',
        firstName: 'Frida',
        lastName: 'Fritzla',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'g',
        firstName: 'Gerhard',
        lastName: 'Gradnaus',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'h',
        firstName: 'Huhu',
        lastName: 'Hallo',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'i',
        firstName: 'Ida',
        lastName: 'Ignatzius',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'j',
        firstName: 'Jack',
        lastName: 'Jolo',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'k',
        firstName: 'Karl',
        lastName: 'Krumm',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'l',
        firstName: 'Lea',
        lastName: 'Laber',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'm',
        firstName: 'Max',
        lastName: 'Mann',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'n',
        firstName: 'Natalie',
        lastName: 'Nudel',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'o',
        firstName: 'Otto',
        lastName: 'Orkan',
        gender: GenderOptions.Male,
        isAbifach: true),
    Student(userId: 'p',
        firstName: 'Paula',
        lastName: 'Pistazie',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'q',
        firstName: 'Quentin',
        lastName: 'Qual',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'r',
        firstName: 'Rudi',
        lastName: 'Rüssel',
        gender: GenderOptions.Male,
        isAbifach: true),
    Student(userId: 's',
        firstName: 'Sara',
        lastName: 'Schön',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 't',
        firstName: 'Tom',
        lastName: 'Tetanus',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'u',
        firstName: 'Ulrike',
        lastName: 'Underberg',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'v',
        firstName: 'Valentin',
        lastName: 'Vogel',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'w',
        firstName: 'Wilma',
        lastName: 'Wurst',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'x',
        firstName: 'Xaver',
        lastName: 'Xylophon',
        gender: GenderOptions.Male,
        isAbifach: true),
    Student(userId: 'y',
        firstName: 'Yvonne',
        lastName: 'Yolo',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'z',
        firstName: 'Zorro',
        lastName: 'Zappenduster',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'a2',
        firstName: 'Axel',
        lastName: 'Aramis',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'b2',
        firstName: 'Bernd',
        lastName: 'Becker',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'c2',
        firstName: 'Corinna',
        lastName: 'Ceur',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'd2',
        firstName: 'Doris',
        lastName: 'Dobermann',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'e2',
        firstName: 'Emil',
        lastName: 'Efeu',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'f2',
        firstName: 'Fabienne',
        lastName: 'Fitzgerald',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'g2',
        firstName: 'Gustav',
        lastName: 'Gieger',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'h2',
        firstName: 'Hanna',
        lastName: 'Horn',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'i2',
        firstName: 'Iris',
        lastName: 'Iltis',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'j2',
        firstName: 'Jan',
        lastName: 'Jublak',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'k2',
        firstName: 'Konrad',
        lastName: 'Kasten',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'l2',
        firstName: 'Lona',
        lastName: 'Liefer',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'm2',
        firstName: 'Moritz',
        lastName: 'Mück',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'n2',
        firstName: 'Norma',
        lastName: 'Nil',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'o2',
        firstName: 'Oskar',
        lastName: 'Obermeyer',
        gender: GenderOptions.Male,
        isAbifach: true),
    Student(userId: 'p2',
        firstName: 'Pia',
        lastName: 'Panzer',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'q2',
        firstName: 'Quark',
        lastName: 'Quelle',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'r2',
        firstName: 'Roman',
        lastName: 'Rund',
        gender: GenderOptions.Male,
        isAbifach: true),
    Student(userId: 's2',
        firstName: 'Susi',
        lastName: 'Schröder',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 't2',
        firstName: 'Tim',
        lastName: 'Taler',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'u2',
        firstName: 'Ulla',
        lastName: 'Usedom',
        gender: GenderOptions.Female,
        isAbifach: true),
    Student(userId: 'v2',
        firstName: 'Vigo',
        lastName: 'Vvolt',
        gender: GenderOptions.Male,
        isAbifach: false),
    Student(userId: 'w2',
        firstName: 'Wanda',
        lastName: 'Wimmer',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'x2',
        firstName: 'Xanadoo',
        lastName: 'Xork',
        gender: GenderOptions.Male,
        isAbifach: true),
    Student(userId: 'y2',
        firstName: 'Yvette',
        lastName: 'Yang',
        gender: GenderOptions.Female,
        isAbifach: false),
    Student(userId: 'z2',
        firstName: 'Zabel',
        lastName: 'Zeblinho',
        gender: GenderOptions.Male,
        isAbifach: false),
  ];

  var sports = [
    Sport(id: 'asfeaasef',
        title: 'Fußball (männlich)',
        category: 'team',
        gender: GenderOptions.Male),
    Sport(id: 'aslaksdfl',
        title: 'Fußball (weiblich)',
        category: 'team',
        gender: GenderOptions.Female),
    Sport(id: 'bbbbbb', title: 'Badminton', category: 'extra', gender: null),
    Sport(id: 'ccccccccc',
        title: 'Gymnastik - Tanz',
        category: 'extra',
        gender: null),
    Sport(id: 'ddddddd',
        title: 'Schwimmen',
        category: 'individual',
        gender: null),
    Sport(id: 'eeeee',
        title: 'Geräteturnen',
        category: 'individual',
        gender: null),
    Sport(id: 'ffff',
        title: 'Leichtathletik',
        category: 'individual',
        gender: null),
    Sport(id: 'gggggg', title: 'Klettern', category: 'extra', gender: null),
    Sport(id: 'hhhhhh', title: 'Tennis', category: 'extra', gender: null),
    Sport(
        id: 'hubbabubba', title: 'Volleyball', category: 'team', gender: null),
    Sport(id: 'llaseflae', title: 'Basketball', category: 'team', gender: null),
    Sport(id: 'olapaloma', title: 'Bumerang', category: 'extra', gender: null),
    Sport(id: 'takatuka', title: 'Trampolin', category: 'extra', gender: null),
    Sport(id: 'zickezacke',
        title: 'Beachvolleyball',
        category: 'team',
        gender: null),
  ];

  void setStudents() {
    students[0].prioritizedSports = [
      {1: 'asfeaasef'},
    ];
  }


//var courses =
}
