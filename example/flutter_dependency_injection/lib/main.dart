import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

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
    final counterController = Flute.use<CounterController>();
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: FluteBuilder(
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
      controller: Flute.use<CounterController>(),
      builder: () =>
          Text('Second widget: ${Flute.use<CounterController>().count}'),
    );
  }
}
