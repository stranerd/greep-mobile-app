import 'package:flutter/widgets.dart';

abstract class WidgetView<WidgetClass, ControllerStateClass>
    extends StatelessWidget {
  final ControllerStateClass state;

  WidgetClass get widget => (state as State).widget as WidgetClass;

  WidgetView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);


}
