import 'package:flutter/material.dart';
import 'package:kurswahl/providers/selection.dart';
import 'package:provider/provider.dart';

class SelectionItem extends StatefulWidget {
  final String id;
  final String selectionId;
  final int sws;
  final String title;
  final String category;
  final prio;
  final isTwoSemesters;

  SelectionItem({
    @required this.id,
    @required this.selectionId,
    @required this.sws,
    @required this.title,
    @required this.category,
    @required this.prio,
    @required this.isTwoSemesters,
    Key key,
  }) : super(key: key);

  @override
  _SelectionItemState createState() => _SelectionItemState();
}

class _SelectionItemState extends State<SelectionItem> {
  var _isChecked = false; //widget.isTwoSemesters;

  void setTwoSemesters(value) {
    setState(() {
      _isChecked = value;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
//      confirmDismiss: (direction) {
//        return showDialog(
//          context: context,
//          builder: (ctx) => AlertDialog(
//            title: Text('Bist Du sicher?'),
//            content: Text(
//              'Willst Du den Kurs aus der Auswahl entfernen?',
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Nein'),
//                onPressed: () {
//                  Navigator.of(ctx).pop(false);
//                },
//              ),
//              FlatButton(
//                child: Text('Ja'),
//                onPressed: () {
//                  Navigator.of(ctx).pop(true);
//                },
//              ),
//            ],
//          ),
//        );
//      },
      onDismissed: (direction) {
        Provider.of<Selection>(context, listen: false)
            .removeItem(widget.selectionId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              width: 60,
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Prio: ',
                        style: TextStyle(fontSize: 13),
                      ),
                      CircleAvatar(
//                      backgroundColor: Theme
//                          .of(context)
//                          .primaryColor,
                        backgroundColor: Theme.of(context).accentColor,
//                        backgroundColor: category == 'team'
//                            ? Color(0xDD8BC34A)
//                            : category == 'individual'
//                                ? Color(0x8A03A9F4)
//                                : Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: FittedBox(
                            child: Text('${widget.prio}'),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            title: Text(widget.title),
            subtitle:
//            Chip(
//              label: Text(
//                '$category',
//                style: TextStyle(
//                    color: Theme.of(context)
//                        .primaryTextTheme
//                        .headline1
//                        .color),
//              ),
//              backgroundColor: Color(0xDD8BC34A),
//            ),
                Text(
              '${widget.category}',
              style: TextStyle(
                color: widget.category == 'team'
                    ? Color(0xDD8BC34A)
                    : widget.category == 'individual'
                        ? Color(0x8A03A9F4)
                        : Colors.black54,
              ),
            ),
            //trailing: Text('$quantity x'),
            trailing: Column(
              children: <Widget>[
                //Text('2 Halbjahre', style: TextStyle(fontSize: 8),),
                Checkbox(
                  value: _isChecked,
                  onChanged: setTwoSemesters,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
