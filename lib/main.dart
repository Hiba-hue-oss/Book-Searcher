//Hiba Shaito 42230627
import 'package:flutter/material.dart';
import 'home.dart';
import 'splash.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Books',
        home: SplashScreen()
    );
  }
}