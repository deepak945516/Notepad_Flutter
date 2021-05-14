import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_note/common/shared_pref.dart';
import 'package:two_note/ui/screens/lock_screen.dart';
import 'package:two_note/ui/screens/notes.dart';

String storedPassword = "";
bool isPasswordValidated = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  storedPassword = await PreferenceData.getStringData("password");
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
      home: isPasswordValidated ? Notes() : LockScreen(),
    );
  }
}
