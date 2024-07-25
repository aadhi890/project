import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:helloworld/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('Conversion_History');
  runApp(unitconverter());
}

class unitconverter extends StatelessWidget {
  const unitconverter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      home: Homepage(),
    );
  }
}
