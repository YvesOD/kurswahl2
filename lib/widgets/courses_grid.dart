import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';
import 'course_item.dart';
import '../models/gender.dart';

class CoursesGrid extends StatelessWidget {
  final GenderOptions showOnlyGender;

  CoursesGrid(this.showOnlyGender);

//  CoursesGrid();

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);
//    final courses = showFavs ? coursesData.favoriteItems : coursesData.items;
//    final courses = coursesData.items;
    final courses = coursesData.genderItems(showOnlyGender);

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: courses.length,
//      itemBuilder: (ctx, idx) => ChangeNotifierProvider(
//        create: (cx) => products[idx],
      // 'create' may cause bugs in ListViews & Grids due to recycling Widgets beyond view-port
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
        value: courses[idx],
        child: CourseItem(
//          products[idx].id,
//          products[idx].title,
//          products[idx].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
