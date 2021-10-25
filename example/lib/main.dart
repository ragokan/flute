import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

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
            builder: (context, provider, _) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  FluteTextField(
                    'name',
                    validateOnChange: true,
                    validators: [
                      StringValidators.required('Required'),
                      StringValidators.min('Min', minLength: 4),
                    ],
                  ),
                  FluteTextField<num>(
                    'age',
                    textInputAction: TextInputAction.done,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final _isValid = provider.validate();
                      print('Is valid: $_isValid');
                      print(provider.values);
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
