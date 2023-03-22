import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vintage_home/home_screen.dart';

Future<void> main() async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  catch (errorMsg) {
    print('Error!' + errorMsg.toString());
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vintage Home',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}