import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
final theme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 180, 17, 50)), //ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 200, 050, 020))
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat\'in',
      theme: theme,
      home: ...,
    );
  }
}