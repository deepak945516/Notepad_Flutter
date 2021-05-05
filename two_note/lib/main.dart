import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_note/ui/screens/notes.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: '2Note',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: Notes(),
    );
  }
}
