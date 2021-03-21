import 'package:flutter/material.dart';

import './MainPage.dart';


class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blueGrey[800], //Changing this will change the color of the TabBar
          accentColor: Colors.yellow[700],
        ),
        home: MainPage());
  }
}
