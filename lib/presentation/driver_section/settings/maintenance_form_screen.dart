import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class MaintenanceFormScreen extends StatefulWidget {
  const MaintenanceFormScreen({Key? key}) : super(key: key);

  @override
  _MaintenanceFormScreenState createState() => _MaintenanceFormScreenState();
}

class _MaintenanceFormScreenState extends State<MaintenanceFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget("Maintenance Form",weight: FontWeight.bold,fontSize: 18.sp,),
      ),
      body: Container(
        padding: EdgeInsets.all(16.r,),
        child: Column(
          children: [
            TextWidget("Vehicle",),
            SizedBox(height: 10.h,),


          ],
        ),
      ),
    );
  }
}
