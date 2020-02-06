import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tictactoe_vicenzotto/HomePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TicTacToeVicenzotto',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

void main() => runApp(MyApp());
