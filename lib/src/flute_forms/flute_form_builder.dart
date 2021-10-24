import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

class FluteFormBuilder extends StatefulWidget {
  FluteFormBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final WidgetBuilder builder;

  @override
  _FluteFormBuilderState createState() => _FluteFormBuilderState();
}

class _FluteFormBuilderState extends State<FluteFormBuilder> {
  late final FluteFormProvider fluteFormProvider;
  @override
  void initState() {
    super.initState();
    fluteFormProvider = FluteFormProvider();
  }

  @override
  Widget build(BuildContext context) => FluteProviderWidget.value(
        value: fluteFormProvider,
        builder: (ctx, _) => widget.builder(ctx),
      );
}
