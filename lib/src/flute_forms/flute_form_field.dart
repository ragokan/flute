import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

abstract class FluteFormField extends StatefulWidget {
  final String name;

  void onCreate(BuildContext context) =>
      FluteFormProvider.of(context).add(this);

  void onDispose(BuildContext context) =>
      FluteFormProvider.of(context).remove(this);

  const FluteFormField({
    Key? key,
    required this.name,
  }) : super(key: key);
}
