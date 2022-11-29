import 'package:flutter/material.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextWidget("Map Screen"),
    );
  }
}
