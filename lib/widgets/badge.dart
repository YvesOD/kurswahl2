import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key key,
    @required this.child,
    @required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Stack(
        alignment: Alignment.center,
        children: [
          child,
/*
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2.0),
              // color: Theme.of(context).accentColor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color != null ? color : Theme.of(context).accentColor,
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          )
*/
        ],
      ),
      Container(
        margin: EdgeInsets.only(right: 10),
//        child: Text('$value SWS'),
        child: Text('$value Kurs${value == '1' ? '' : 'e'}'),
      ),
    ]);
  }
}
