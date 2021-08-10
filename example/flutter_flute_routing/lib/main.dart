import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FluteMaterialApp(
      title: 'Material App',
      routes: {
        '/': (_) => PageOne(),
        '/second': (_) => PageTwo(),
        '/third': (_) => PageThree(),
      },
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Page One'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Flute.pushNamed('/second', arguments: 'Anan');
            },
            child: Text('Go to page 2 - Width: ${Flute.width}'),
          ),
        ),
      );
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Two'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // navi.pushReplacementNamed('/third');
              Flute.pushEasy(PageThree());
            },
            child: const Text('Go to page 3'),
          ),
        ),
      );
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Page Three'),
        ),
      );
}
