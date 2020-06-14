import 'package:flutter/material.dart';
import 'package:kurswahl/screens/course_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/course.dart';
import '../providers/selection.dart';

class CourseItem extends StatelessWidget {
//  final String id;
//  final title;
//  final imageUrl;
//
//  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context, listen: false);
    final selection = Provider.of<Selection>(context);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              CourseDetailScreen.routeName,
              arguments: course.id,
            );
          },
          child: Hero(
            tag: course.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/course-placeholder.png'),
              image: NetworkImage(course.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: course.category == 'team'
              ? Color(0xDD8BC34A)
              : course.category == 'individual'
                  ? Color(0x8A03A9F4)
                  : Colors.black54,
//          leading: Consumer<Course>(
//              builder: (ctx, prod, _) => IconButton(
//                  icon: Icon(
//                      prod.isFavorite ? Icons.favorite : Icons.favorite_border),
//                  onPressed: () {
//                    prod.toggleFavoriteStatus(authData.token, authData.userId);
//                  },
//                  color: Theme.of(context).accentColor)),
          title: Text(
            course.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Course>(
            builder: (ctx, crs, _) => IconButton(
                icon: Icon(selection.isSelected(crs.id)
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: selection.isSelected(crs.id)
                    ? () {
                        selection.removeItem(course.id);
                      }
                    : () {
                        selection.addItem(
                          courseId: course.id,
                          title: course.title,
                          sws: course.sws,
                          category: course.category,
                          //crs.toggleFavoriteStatus(authData.token, authData.userId
                        );
//                        Scaffold.of(context).hideCurrentSnackBar();
//                        Scaffold.of(context).showSnackBar(
//                          SnackBar(
//                            content: Text(
//                              'Kurs zur Auswahl hinzugefügt.',
//                              textAlign: TextAlign.center,
//                            ),
//                            duration: Duration(seconds: 5),
//                            action: SnackBarAction(
//                              label: 'Rückgängig machen',
//                              onPressed: () {
//                                //selection.removeSingleItem(course.id);
//                                selection.removeItem(course.id);
//                              },
//                            ),
//                          ),
//                        );
                      },
                color: Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }
}
