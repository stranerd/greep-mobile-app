import 'package:flutter/widgets.dart';

abstract class StatelessWidgetView<WidgetClass> extends StatelessWidget {
  final WidgetClass staticState;

  StatelessWidgetView(this.staticState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}
