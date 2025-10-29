import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topnewsapp/provider/theme_provider.dart';
import 'package:topnewsapp/utilities/app_routes.dart';
import 'package:topnewsapp/view/main_screen.dart';
import 'package:topnewsapp/view/news_detail_screen.dart';
import 'package:topnewsapp/view/privacy_policy_screen.dart';
import 'package:topnewsapp/view/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Flutter Demo',
      initialRoute: splashScreenRoute,
      routes: {
        splashScreenRoute: (context) => const SplashScreen(), //
        homeScreenRoute: (context) => const MainScreen(),
        detailScreenRoute: (context) {
          var i = ModalRoute.of(context)?.settings.arguments;
          return NewsDetailScreen(article: i);
        },
        privacyPolicyScreenRoute: (context) => const PrivacyPolicyScreen(),
      },
    );
  }
}
