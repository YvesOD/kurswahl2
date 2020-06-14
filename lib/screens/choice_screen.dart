import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/choice.dart' show Choice;
import '../widgets/choice_item.dart';
import '../widgets/app_drawer.dart';

class ChoiceScreen extends StatelessWidget {
  static const routeName = '/choice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deine gesendeten Kurse'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Choice>(context, listen: false).fetchAndSetChoice(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              //ToDo: error handling
              return Center(
                child: Text('Es ist ein Fehler aufgetreten.'),
              );
            } else {
              return Consumer<Choice>(
                builder: (ct, choiceData, child) =>
                    choiceData.choice.length <= 0
                        ? Center(
                            child: Text('Du hast noch keine Kurse gesendet.'),
                          )
                        : ListView.builder(
                            itemCount: choiceData.choice.length,
                            itemBuilder: (ctx, idx) =>
                                ChoiceItem(choiceData.choice[idx]),
                          ),
              );
            }
          }
        },
      ),
    );
  }
}
