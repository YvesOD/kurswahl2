import 'package:flutter/material.dart';
import 'package:kurswahl/providers/choice.dart';
import 'package:kurswahl/providers/course.dart';
import 'package:provider/provider.dart';

import '../widgets/selection_item.dart';
import '../providers/selection.dart' show Selection;
import '../providers/selection.dart' show SelectionPrioItem;
import '../providers/user.dart';
import '../providers/authorization.dart';

//enum AbifachOptions {
//  IsAbifach,
//  IsNotAbifach,
//}

class SelectionScreen extends StatefulWidget {
  static const routeName = '/selection';

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  //AbifachOptions _isAbifach;

  List<SelectionItem> getListItems(Selection selection) {
    final List<SelectionPrioItem> prioList = selection.items.entries
        .map((entry) => SelectionPrioItem(
              courseId: entry.key,
              item: entry.value,
            ))
        .toList();

    return prioList
        .asMap()
        .map((idx, item) => MapEntry(idx, buildTenableListTile(item, idx)))
        .values
        .toList();
  }

  SelectionItem buildTenableListTile(SelectionPrioItem pItem, int index) {
//    return Dismissible(
//        key: ValueKey(pItem.courseId),
//        child: ListTile(
//          // key: ValueKey(pItem.courseId),
//          title: Text(pItem.item.title),
//          leading: Text('${index + 1}.'),
//          trailing: Text('${pItem.item.prio}'),
//        ));
    return SelectionItem(
      id: pItem.item.id,
      selectionId: pItem.courseId,
      sws: pItem.item.sws,
      title: pItem.item.title,
      category: pItem.item.category,
      prio: pItem.item.prio,
      isTwoSemesters: pItem.item.isTwoSemesters,
      key: ValueKey(pItem.item.id),
    );
  }

  void onReorder(int oldIdx, int newIdx, Selection selection) {
    if (newIdx > oldIdx) {
      newIdx -= 1; // because old position in front is now empty
    }
    final newPrio = newIdx + 1;
    final oldPrio = oldIdx + 1;
    final courseId = selection.getCourseIdByPrio(oldPrio);
    setState(() {
      selection.changePrio(courseId, newPrio);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selection = Provider.of<Selection>(context);
    //final user = Provider.of<Authorization>(context).user;
    final authorization = Provider.of<Authorization>(context);
    //final user = Provider.of<Authorization>(context).user;
    final user = authorization.user;

    selection.sortSelectionByPrio();

    return Scaffold(
      appBar: AppBar(
        title: Text('Deine Auswahl'),
        actions: <Widget>[
          PopupMenuButton(
              //onSelected: (AbifachOptions selectedValue) {
              onSelected: (bool selectedValue) {
                if (selectedValue) {
                  selection.removeExtras();
                }
                setState(() {
                  //_isAbifach = selectedValue;
                  //authorization.user.isAbifach = selectedValue;
                  authorization.setAbifach(selectedValue);
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text(
                            '${user.isAbifach ? 'Checked: ' : ''}Sport als Abiturfach'),
                        value: true), //AbifachOptions.IsAbifach),
                    PopupMenuItem(
                        child: Text(
                            '${!user.isAbifach ? 'Checked: ' : ''}Sport kein Abiturfach'),
                        value: false), //AbifachOptions.IsNotAbifach),
                  ]),
        ],
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //Text('min. 4 Kurse', style: TextStyle(fontSize: 16)),
                  //Spacer(),
                  Column(
                    children: <Widget>[
                      Text('Mannschaft'),
                      Chip(
                        label: Text(
                          '${selection.count('team').toString()}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline1
                                  .color),
                        ),

//                    backgroundColor: !selection.isSubmitable
//                        ? Colors.red
//                        : Theme.of(context).primaryColor,
                        backgroundColor: Color(0xDD8BC34A),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Individual'),
                      Chip(
                        label: Text(
                          '${selection.count('individual').toString()}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline1
                                  .color),
                        ),
                        backgroundColor: Color(0x8A03A9F4),
                      ),
                    ],
                  ),
                  if (!user.isAbifach)
                    Column(
                      children: <Widget>[
                        Text('Extra'),
                        Chip(
                          label: Text(
                            '${selection.count('extra').toString()}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headline1
                                    .color),
                          ),
                          backgroundColor: Colors.black54,
                        ),
                      ],
                    ),
                  ChoiceButton(selection: selection)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (int oldIdx, int newIdx) =>
                  onReorder(oldIdx, newIdx, selection),
              children: getListItems(selection),
            ),
//            child: ListView.builder(
//              itemCount: selection.items.length,
//              itemBuilder: (ctx, idx) => SelectionItem(
//                id: selection.items.values.toList()[idx].id,
//                selectionId: selection.items.keys.toList()[idx],
//                sws: selection.items.values.toList()[idx].sws,
//                title: selection.items.values.toList()[idx].title,
//              ),
//            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatefulWidget {
  const ChoiceButton({
    Key key,
    @required this.selection,
  }) : super(key: key);

  final Selection selection;

  @override
  _ChoiceButtonState createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Kurse senden'),
      onPressed: (!widget.selection.isSubmitable || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Choice>(context, listen: false).addChoice(
                widget.selection.items.values.toList(),
                widget.selection.totalSws,
              );
              setState(() {
                _isLoading = false;
              });
              widget.selection.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
