import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sms/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(252, 252, 252, 255),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              iconSize: 24, backgroundColor: Color.fromRGBO(84, 201, 243, 1)),
          iconTheme: IconThemeData(color: Colors.grey.shade600),
          appBarTheme: const AppBarTheme()),
      home: const AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 242, 242, 242),
              statusBarIconBrightness: Brightness.dark),
          child: HomeScreen()),
    );
  }
}
