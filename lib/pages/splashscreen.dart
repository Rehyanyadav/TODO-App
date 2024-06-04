// ignore: file_names
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:todolist/pages/home.dart';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:splash_screen_view/splash_screen_view.dart';
import 'package:google_fonts/google_fonts.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenView(
        navigateRoute: const HomePage(),
        duration: 4000,
        imageSize: 100,
        imageSrc: "assets/todo.png",
        text: "TO DO -by Alpha Codes ",
        textStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.abyssinicaSil().fontFamily),
        textType: TextType.ColorizeAnimationText,
        colors: const [
          Colors.purple,
          Colors.blue,
          Color.fromARGB(255, 0, 204, 255),
          Color.fromARGB(255, 136, 54, 244),
        ],
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
