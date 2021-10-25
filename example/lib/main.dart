import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
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
                  const FluteTextField<num>(
                    'age',
                    textInputAction: TextInputAction.done,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final _isValid = provider.validate();
                      debugPrint('Is valid: $_isValid');
                      debugPrint(provider.values.toString());
                    },
                    child: const Text('Submit'),
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
