import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

class CounterController extends FluteController {
  int count = 0;

  void increment() => setState(() => count++);

  void decrement() {
    count--;
    update();
  }
}

void main() {
  Flute.inject(CounterController());
  runApp(CounterApp());
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Fluto<CounterController>(
            (controller) => Text('Current count is ${controller.count}'),
          ),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: Flute.use<CounterController>().increment,
                  child: const Text('Increment'),
                ),
                OtherWidget(),
                ElevatedButton(
                  onPressed: () => Flute.use<CounterController>()
                      .setState(() => Flute.use<CounterController>().count--),
                  child: const Text('Decrement'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtherWidget extends StatelessWidget {
  @override
  Widget build(_) => Fluto<CounterController>((c) => Text('${c.count}'));
}
