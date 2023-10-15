import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/dialog_header_widget.dart';

class AppDialog extends StatelessWidget {
  final Widget child;
  final double? height;
  final String title;

  const AppDialog({
    Key? key,
    required this.child,
    required this.title,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                20.r,
              ),
              topRight: Radius.circular(
                20.r,
              ),
            ),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeaderWidget(
              title: title,
            ),
            height != null
                ? Flexible(
                    child: Container(
                        padding: EdgeInsets.all(
                          kDefaultSpacing.r,
                        ),
                        child: child),
                  )
                : Container(
                    padding: EdgeInsets.all(
                      kDefaultSpacing.r,
                    ),
                    child: child)
          ],
        ),
      ),
    );
  }


}
