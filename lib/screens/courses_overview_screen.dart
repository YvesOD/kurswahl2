import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'selection_screen.dart';
import '../providers/selection.dart';
import '../providers/courses.dart';
import '../widgets/app_drawer.dart';
import '../widgets/courses_grid.dart';
import '../widgets/badge.dart';
import '../models/gender.dart';

// enum FilterOptions { Favorites, All }
/*enum GenderOptions {
  Male,
  Female,
}*/

class CoursesOverviewScreen extends StatefulWidget {
  static const routeName = '/courses-overview';

  @override
  _CoursesOverviewScreenState createState() => _CoursesOverviewScreenState();
}

class _CoursesOverviewScreenState extends State<CoursesOverviewScreen> {
  GenderOptions _showOnlyGender;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Courses>(context).fetchAndSetCourses().then((_) {
        setState(() {
          _isLoading = false;
        });
//      }).catchError((response) {
//        _isLoading = false;
//        //print(response.statusCode);
//        //print(json.decode(response.body));
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return //true ? Center(child: Text('Hallo')) :
        Scaffold(
      appBar: AppBar(
        title: Text('Kursliste'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (GenderOptions selectedValue) {
                setState(() {
                  _showOnlyGender = selectedValue;
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('männlich'), value: GenderOptions.Male),
                    PopupMenuItem(
                        child: Text('weiblich'), value: GenderOptions.Female),
                  ]),
          Consumer<Selection>(
            builder: (_, selection, ch) =>
                //Badge(child: ch, value: selection.totalSws.toString()),
                Badge(child: ch, value: selection.items.length.toString()),
            child: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.of(context).pushNamed(SelectionScreen.routeName);
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          //: CoursesGrid(_showOnlyFavorites),
          : CoursesGrid(_showOnlyGender),
    );
  }
}
