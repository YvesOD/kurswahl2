import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gender.dart';
import '../providers/courses.dart';

class CourseDetailScreen extends StatelessWidget {
  static const routeName = '/course-detail';

  @override
  Widget build(BuildContext context) {
    final courseId = ModalRoute.of(context).settings.arguments as String;
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedCourse.title),
              background: Hero(
                tag: loadedCourse.id,
                child: Image.network(
                  loadedCourse.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Container(
                height: 50,
                color: loadedCourse.category == 'team'
                    ? Color(0xDD8BC34A)
                    : loadedCourse.category == 'individual'
                        ? Color(0x8A03A9F4)
                        : Colors.black54,
                alignment: Alignment.center,
                child: Text(
                  //'${loadedCourse.sws} SWS',
                  () {
                    switch (loadedCourse.category) {
                      case 'team':
                        {
                          return 'Mannschaft';
                        }
                        break;
                      case 'individual':
                        {
                          return 'Individual';
                        }
                        break;
                      default:
                        {
                          return 'Extra';
                        }
                    }
                  }(),
                  style: TextStyle(
                    color: loadedCourse.category == 'extra'
                        ? Colors.white
                        : Colors.black,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              if (loadedCourse.gender != null)
                Text(
                  'nur ${loadedCourse.gender == GenderOptions.Male ? 'männlich' : 'weiblich'}',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (loadedCourse.gender != null) SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('min. Teilnehmer: ${loadedCourse.minAttendance}'),
                  //Text('min: ${loadedCourse.minAttendance}'),
                  Text('max. Teilnehmer: ${loadedCourse.maxAttendance}'),
                ],
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedCourse.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 800,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
