import 'package:chat_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //add this line if the app get stuck at launch screen
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final theme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      //brightness: Brightness.dark,
      seedColor: const Color.fromARGB(255, 180, 50, 50)
  ), //ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 200, 050, 020))
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat\'in',
      theme: theme,
      home: const AuthScreen(),
    );
  }
}