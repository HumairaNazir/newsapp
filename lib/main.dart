import 'package:flutter/material.dart';
import 'package:topnewsapp/utilities/app_routes.dart';
import 'package:topnewsapp/view/home_screen.dart';
import 'package:topnewsapp/view/main_screen.dart';
import 'package:topnewsapp/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: splashScreenRoute,
      routes: {
        splashScreenRoute: (context) => const SplashScreen(), //
        homeScreenRoute: (context) => const MainScreen(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
