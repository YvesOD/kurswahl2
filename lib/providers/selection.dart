import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user.dart';

class SelectionItem {
  final String id;
  final String title;
  final int sws;
  final String category;
  int prio;
  var isTwoSemesters = false;

  SelectionItem({
    @required this.id,
    @required this.title,
    @required this.sws,
    @required this.category,
    @required this.prio,
  });

  SelectionItem.deserialize(String serializedSelectionItemData)
      : id = json.decode(serializedSelectionItemData)['id'],
        title = json.decode(serializedSelectionItemData)['title'],
        sws = json.decode(serializedSelectionItemData)['sws'],
        category = json.decode(serializedSelectionItemData)['category'],
        prio = json.decode(serializedSelectionItemData)['prio'];

  void setPrio(int prio) {
    this.prio = prio;
  }

  String serialize() {
    return json.encode({
      'id': id,
      'title': title,
      'sws': sws,
      'category': category,
      'prio': prio,
    });
  }
}

class SelectionPrioItem {
  final String courseId;
  final SelectionItem item;

  SelectionPrioItem({
    @required this.courseId,
    @required this.item,
  });
}

class Selection with ChangeNotifier {
  Map<String, SelectionItem> _items = {};

  final String authToken;
  final User user;

  Selection(
    this.authToken,
    this.user,
    this._items,
  );

  Selection.deserialize(
      this.authToken, this.user, String serializedSelectionData) {
    _items = {};
    print('Selection.deserialize: $serializedSelectionData');
    if (serializedSelectionData != null) {
      var xxx = json.decode(serializedSelectionData);
      print('XXXX $xxx');
      var temp = json.decode(serializedSelectionData);
      temp.forEach((key, serializedSelectionItemData) {
        _addItem(
          courseId: key,
          selectionItem: SelectionItem.deserialize(serializedSelectionItemData),
        );
      });
    }
  }

  Map<String, SelectionItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get totalSws {
    var total = 0;
    _items.forEach((key, selectionItem) {
      total += selectionItem.sws;
    });
    return total;
  }

  _addItem({
    @required String courseId,
    @required SelectionItem selectionItem,
  }) {
    if (_items.containsKey(courseId)) {
      return;
    }
    _items.putIfAbsent(
      courseId,
      () => selectionItem,
    );
  }

  void addItem({
    @required String courseId,
    @required String title,
    @required int sws,
    @required String category,
  }) {
//    if (_addItem(
//        courseId: courseId, title: title, sws: sws, prio: _items.length + 1)) {
//      _updatePrefs();
//      notifyListeners();
//    }
    if (_items.containsKey(courseId)) {
      return;
    } else {
      _items.putIfAbsent(
        courseId,
        () => SelectionItem(
          id: DateTime.now().toString(),
          title: title,
          sws: sws,
          category: category,
          prio: _items.length + 1,
        ),
      );
      _updatePrefs();

      notifyListeners();
    }
  }

  void removeExtras() {
    // final Map<String, SelectionItem> extras = {..._items}....where((item) => false);
    final extraItems = Map.fromEntries(_items.entries
        .toList()
        .where((item) => item.value.category == 'extra'));
    extraItems.forEach((key, item) {
      removeItem(key);
    });
  }

  void removeItem(String courseId) {
    if (!isSelected(courseId)) {
      return;
    } else {
      final prio = _getPrio(courseId);
      //_items.map((key, item) => item.prio <= prio ? item : item..setPrio(item.prio - 1));
//      _items.entries.map((entry) => entry.item.prio <= prio ? item : item
//        ..setPrio(item.prio - 1));
      _items.forEach((key, item) {
        if (item.prio > prio) {
          item.prio = item.prio - 1;
        }
      });
      _items.remove(courseId);
      _updatePrefs();

      notifyListeners();
    }
  }

  void changePrio(courseId, int newPrio) {
    if (!isSelected(courseId)) {
      return;
    }
    final oldPrio = _getPrio(courseId);

    _items.forEach((key, item) {
      if (oldPrio < newPrio && item.prio > oldPrio && item.prio <= newPrio) {
        item.prio -= 1;
      } else if (newPrio < oldPrio &&
          item.prio >= newPrio &&
          item.prio < oldPrio) {
        item.prio += 1;
      }
    });
    _items[courseId].prio = newPrio;
    _updatePrefs();

    notifyListeners();
  }

  void clear() {
    _items = {};
    _updatePrefs();

    notifyListeners();
  }

  bool isSelected(String courseId) {
    return _items.containsKey(courseId);
  }

  int _getPrio(String courseId) {
    return !isSelected(courseId) ? -1 : _items[courseId].prio;
  }

  String getCourseIdByPrio(int prio) {
    return items.keys
        .firstWhere((key) => items[key].prio == prio, orElse: () => null);
  }

  void sortSelectionByPrio({desc = false}) {
    _items = Map.fromEntries(
      _items.entries.toList()
        ..sort((e1, e2) => !desc
            ? e1.value.prio.compareTo(e2.value.prio)
            : e2.value.prio.compareTo(e1.value.prio)),
    );
  }

  bool get isSubmitable {
    if (user.isAbifach) {
      return count() >= 4 && count('team') >= 2 && count('individual') >= 2;
    } else {
      return count() >= 4 && count('team') >= 1 && count('individual') >= 1;
    }
  }

  Future<void> _updatePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectionData_${user.userId}', serialize());
    print('updatePREFS: ${prefs.getString('selectionData_${user.userId}')}');
  }

  String serialize() {
    Map<String, String> tempMap = {};
    _items.forEach((key, item) {
      tempMap[key] = item.serialize();
    });
    print('SERIALIZE SELECTION: ${json.encode(tempMap)}');
    return json.encode(tempMap);
  }

  int count([String category]) {
    int count;
    switch (category) {
      case null:
        {
          count = itemCount;
        }
        break;
      default:
        {
          count =
              _items.values.where((item) => item.category == category).length;
        }
    }
    return count;
  }
}
