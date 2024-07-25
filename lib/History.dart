import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Box historyBox = Hive.box('conversion_history');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey.shade900,
      body: ValueListenableBuilder(
        valueListenable: historyBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'No history yet',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index);
              final value = box.get(key);

              return ListTile(
                title: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    box.delete(key);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
