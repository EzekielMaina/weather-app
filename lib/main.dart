import 'package:flutter/material.dart';
import 'features/splashscreen.dart';
import 'logic/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // Define named routes
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => const MyHomePage(title: 'Smart Weather'),
      },
    );
  }
}
