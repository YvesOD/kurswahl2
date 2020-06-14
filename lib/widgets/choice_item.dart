import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/choice.dart' as chc;

class ChoiceItem extends StatefulWidget {
  final chc.ChoiceItem choice;

  ChoiceItem(this.choice);

  @override
  _ChoiceItemState createState() => _ChoiceItemState();
}

class _ChoiceItemState extends State<ChoiceItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
      _expanded ? min(widget.choice.courses.length * 20.0 + 120, 420) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              //title: Text('€ ${widget.choice.sws.toString()}'),
              subtitle: Text(
                DateFormat('dd.MM.yyyy hh:mm').format(widget.choice.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
//            if (_expanded)
//              Container(
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//              height: min(widget.order.products.length * 20.0 + 10, 100),
              height: _expanded
                  ? min(widget.choice.courses.length * 20.0 + 20, 320)
                  : 0,
              child: ListView(
                children: widget.choice.courses
                    .map(
                      (course) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        course.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        //'Prio ${course.prio}',
                        '${course.category}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );  }
}
