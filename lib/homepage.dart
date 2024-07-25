import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:helloworld/History.dart';
import 'package:hive/hive.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> _units = [
    'Millimeters',
    'Centimeters',
    'Meters',
    'Kilometers',
    'Inches',
    'Feet'
  ];
  double _value = 0;
  String _from = 'Meters';
  String _to = 'Kilometers';
  String _result = "";
  final Box historyBox = Hive.box('conversion_history');

  final Map<String, int> _unitsMap = {
    'Millimeters': 0,
    'Centimeters': 1,
    'Meters': 2,
    'Kilometers': 3,
    'Inches': 4,
    'Feet': 5
  };

  final conversionTable = {
    0: {0: 1, 1: 0.1, 2: 0.001, 3: 0.000001, 4: 0.0393701, 5: 0.00328084},
    1: {0: 10, 1: 1, 2: 0.01, 3: 0.00001, 4: 0.393701, 5: 0.0328084},
    2: {0: 1000, 1: 100, 2: 1, 3: 0.001, 4: 39.3701, 5: 3.28084},
    3: {0: 1000000, 1: 100000, 2: 1000, 3: 1, 4: 39370.1, 5: 3280.84},
    4: {0: 25.4, 1: 2.54, 2: 0.0254, 3: 0.0000254, 4: 1, 5: 0.0833333},
    5: {0: 304.8, 1: 30.48, 2: 0.3048, 3: 0.0003048, 4: 12, 5: 1},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Unit Converter',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade800,
        actions: [
          IconButton(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => History()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the length',
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _value = double.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'From',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      DropdownButton<String>(
                          value: _from,
                          items: _units.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _from = value ?? 'Meters';
                            });
                          },
                          dropdownColor: Colors.grey.shade900),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'To',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      DropdownButton<String>(
                          value: _to,
                          items: _units.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _to = value ?? 'Kilometers';
                            });
                          },
                          dropdownColor: Colors.grey.shade900)
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: _convert,
                child: Text('Convert'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow, // Background color
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                _result,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _convert() {
    if (_value != 0 && _from.isNotEmpty && _to.isNotEmpty) {
      int from = _unitsMap[_from]!;
      int to = _unitsMap[_to]!;
      var multiplier = conversionTable[from]![to]!;
      setState(() {
        _result = '$_value $_from = ${_value * multiplier} $_to';
        historyBox.add(_result); // Store result in Hive
      });
    } else {
      setState(() {
        _result = 'Enter a non-zero value';
      });
    }
  }
}
