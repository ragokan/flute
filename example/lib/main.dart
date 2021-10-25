import 'dart:convert';
import 'dart:io';

import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final response =
                  await FluteApiProvider('jsonplaceholder.typicode.com')
                      .post<Map>('/todos', body: {'title': 'hele hele'});
              print(response);
            },
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
