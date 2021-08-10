import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FluteMaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flute Widgets'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => Flute.showModal(
                      child: Container(
                          height: 300,
                          child: const Center(child: Text('Flute Modal!')))),
                  child: const Text('Show Bottom Modal')),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () => Flute.showSnackBar(
                      snackBar:
                          const SnackBar(content: Text('Flute Snackbar'))),
                  child: const Text('Show Snackbar')),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () => Flute.showDialog(
                          child: Scaffold(
                        appBar: AppBar(title: const Text('Flute Dialog')),
                      )),
                  child: const Text('Show Dialog')),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Flute.showToast(text: 'Flute Toast'),
                child: const Text('Show Dialog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
