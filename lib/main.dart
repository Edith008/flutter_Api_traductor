import 'package:flutter/material.dart';
import 'traductor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Traductor(),
      theme: ThemeData(
        appBarTheme: AppBarTheme( 
          backgroundColor: Color.fromARGB(255, 214, 149, 220), 
        ),  
      ),
    );
  }
}
