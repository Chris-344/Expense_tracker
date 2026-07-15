import 'package:expense_tracker/pages/filter.dart';
import 'package:expense_tracker/pages/home.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('TransactionData');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        '/home': (context) => const Home(),
        '/filter': (context) => const Filter(),
      },
    );
  }
}
