import 'package:flute/src/flute_forms/flute_form_model.dart';
import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

abstract class FluteFormField extends StatefulWidget {
  final FluteFormModel model;

  void onCreate(BuildContext context) =>
      FluteFormProvider.of(context).add(this);

  void onDispose(BuildContext context) =>
      FluteFormProvider.of(context).remove(this);

  FluteFormField({
    Key? key,
    required String name,
  })  : model = FluteFormModel(name: name),
        super(key: key);
}
