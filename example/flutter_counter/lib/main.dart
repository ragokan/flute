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

CounterController counterController = CounterController();

void main() {
  runApp(CounterApp());
  // You can change state from anywhere
  Future.delayed(const Duration(seconds: 3), () {
    counterController.increment();
  });
}

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: FluteBuilder<CounterController>(
            filter: (c) => c.count,
            controller: counterController,
            builder: () => Text('Current count is ${counterController.count}'),
          ),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: counterController.increment,
                  child: const Text('Increment'),
                ),
                const OtherWidget(),
                ElevatedButton(
                  onPressed: () => counterController
                      .setState(() => counterController.count--),
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
  const OtherWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluteBuilder(
      controller: counterController,
      builder: () => Text('Second widget: ${counterController.count}'),
    );
  }
}
