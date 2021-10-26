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
          child: FluteFormBuilder(
            builder: (context, provider, scope) => Column(
              children: [
                const FluteTextField('name'),
                FluteTextField<num>(
                  'age',
                  textInputAction: TextInputAction.done,
                  validators: [
                    NumberValidators.required('Error message of required'),
                    NumberValidators.min('Error message', min: 5),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (provider.validate()) {
                        print(provider.values);
                      }
                    },
                    child: const Text('Validate')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
