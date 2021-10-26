import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

typedef _FormBuilder = Widget Function(
    BuildContext context, FluteFormProvider provider, FocusScopeNode node);

class FluteFormBuilder extends StatefulWidget {
  const FluteFormBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final _FormBuilder builder;

  @override
  FluteFormBuilderState createState() => FluteFormBuilderState();
}

class FluteFormBuilderState extends State<FluteFormBuilder> {
  late final FluteFormProvider fluteFormProvider;
  @override
  void initState() {
    super.initState();
    fluteFormProvider = FluteFormProvider();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        fluteFormProvider,
        FocusScope.of(context),
      );
}
