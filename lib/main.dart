import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kurswahl/providers/authorization.dart';
import 'package:kurswahl/providers/user.dart';
import 'package:kurswahl/screens/authorization_screen.dart';
import 'package:kurswahl/screens/choice_screen.dart';
import 'package:kurswahl/screens/course_detail_screen.dart';
import 'package:kurswahl/screens/selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/custom_route.dart';

import 'providers/course.dart';
import 'screens/auth_screen.dart';
import 'screens/courses_overview_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/auth.dart';
import 'providers/choice.dart';
import 'providers/selection.dart';
import 'providers/courses.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Authorization>(
          update: (ctx, auth, previousAuthorization) => Authorization(
            auth.token,
            auth.userId,
            auth.email,
            previousAuthorization == null ? null : previousAuthorization.email,
          ),
        ),
        ChangeNotifierProxyProvider2<Auth, Authorization, Courses>(
          update: (ctx, auth, authorization, previousCourses) => Courses(
//            authToken: auth.token,
//            userId: auth.userId,
//            courses: previousCourses == null ? [] : previousCourses.items,
            auth.token,
            authorization.user,
            authorization,
            //previousCourses == null ? [] : previousCourses.items,
            previousCourses == null
                ? () {
                    print('MAIN: previousCourses is NULL');
                    return <Course>[];
                  }()
                : () {
                    print(
                        'MAIN: previousCourses is NOT NULL: ${previousCourses.items.length}');
                    return previousCourses.items;
                  }(),
          ),
        ),
//        ChangeNotifierProvider(
//          create: (ctx) => Selection(),
//        ),
        ChangeNotifierProxyProvider2<Auth, Authorization, Selection>(
          update: (ctx, auth, authorization, previousSelection) => Selection(
//            authToken: auth.token,
//            userId: auth.userId,
//            courses: previousCourses == null ? [] : previousCourses.items,
            auth.token,
            authorization.user,
            auth.token == null
                ? () {
                    print(
                        'MAIN - ChangeNotifierProxyProvider2 - SELECTION: auth.token == null');
                    return <String, SelectionItem>{};
                  }()
                : previousSelection == null ||
                        previousSelection.items.length == 0
                    ? auth.userId == null
                        ? () {
                            print('MAIN: previousSelection == null || empty');
                            return <String, SelectionItem>{};
                          }() //as Map<String, SelectionItem>
                        : authorization.selectionData == null
                            ? () {
                                print(
                                    'MAIN - ChangeNotifierProxyProvider2 - SELECTION: authorization.selectionData == null');
                                return <String, SelectionItem>{};
                              }()
                            : () {
                                print(
                                    'MAIN - ChangeNotifierProxyProvider2 - SELECTION: RESTORED selection from PREFS');
                                return Selection.deserialize(
                                        auth.token,
                                        authorization.user,
                                        authorization.selectionData)
                                    .items;
                              }()
                    : () {
                        print(
                            'MAIN - ChangeNotifierProxyProvider2 - SELECTION: previousSelection is NOT null: ${previousSelection.items.length}');
                        return previousSelection.items;
                      }(),
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Choice>(
          update: (ctx, auth, previousChoice) => Choice(
//            authToken: auth.token,
//            userId: auth.userId,
//            choice: previousChoice == null ? null : previousChoice.choice,
            auth.token,
            auth.userId,
            previousChoice == null ? null : previousChoice.choice,
          ),
        ),
      ],
      child: Consumer2<Auth, Authorization>(
        builder: (ctx, auth, authorization, _) {
          ifAuth(targetScreen) => auth.isAuth && authorization.isAuthorized
              ? targetScreen
              : auth.isAuth ? AuthorizationScreen() : AuthScreen();
          return MaterialApp(
            title: 'ELSA',
            theme: ThemeData(
              primarySwatch: Colors.green,
              accentColor: Colors.orangeAccent,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
              //visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth
                ? authorization.isAuthorized
                    ? CoursesOverviewScreen()
                    : FutureBuilder(
                        future: authorization.tryAutoAuthorize(),
                        builder: (ctx, authorizationResultSnapshot) =>
                            authorizationResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthorizationScreen(),
                      )
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              CourseDetailScreen.routeName: (ctx) =>
                  ifAuth(CourseDetailScreen()),
              SelectionScreen.routeName: (ctx) => ifAuth(SelectionScreen()),
              ChoiceScreen.routeName: (ctx) => ifAuth(ChoiceScreen()),
            },
          );
        },
      ),
    );
  }
}
