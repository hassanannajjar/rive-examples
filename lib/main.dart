import 'package:animated_bottom_bar/game_screen.dart';
import 'package:animated_bottom_bar/screen/demo_screen.dart';
import 'package:animated_bottom_bar/table_screen.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Montserrat",
        primarySwatch: Colors.blue,
      ),
      home: const TableScreen(),
      // home: const HomeScreen(),
      // home: const GameScreen(),
    );
  }
}
