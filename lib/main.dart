import 'package:flutter/material.dart';
import 'package:varuna_new/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Initialises widgets, device databases, files, plugins before running app
  //Without this line, certain tasks that require a connection to the Flutter framework
  // might fail or cause errors during runtime
  await Firebase.initializeApp(); //returns a data type "future" which means
  // you need to wait for it to complete before executing rest of code
  //await: will not process further code unless Firebase services initialised
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // APPLIED ONCE IN main.dart
      title: 'Varuna',
      home: const SplashScreen(),
    );
  }
}
