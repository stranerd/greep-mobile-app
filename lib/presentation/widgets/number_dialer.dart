import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class NumberDialer extends StatefulWidget {
  final Function onClear;
  final Function(String) onSelect;
  final Function(num) onValue;
  final int maxDigit;
  final Widget? dotWidget;
  final Widget? clearWidget;

  const NumberDialer({
    Key? key,
    required this.onClear,
    required this.onSelect,
    required this.onValue,
    this.clearWidget,
    this.dotWidget,
    this.maxDigit = 1000
  }) : super(key: key);

  @override
  State<NumberDialer> createState() => _NumberDialerState();
}

class _NumberDialerState extends State<NumberDialer> {
  String number = "0";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, cs) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildItem(value: "1",)
              ),
              Expanded(
                  child: _buildItem(value: "2",)

              ),
              Expanded(
                  child: _buildItem(value: "3",)

              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: _buildItem(value: "4",)

              ),
              Expanded(
                  child: _buildItem(value: "5",)

              ),
              Expanded(
                  child: _buildItem(value: "6",)

              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: _buildItem(value: "7",)

              ),
              Expanded(
                  child: _buildItem(value: "8",)

              ),
              Expanded(
                  child: _buildItem(value: "9",)

              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: _buildItem(value: ".",isNumber: false,customWidget: widget.dotWidget)

              ),
              Expanded(
                  child: _buildItem(value: "0",)

              ),
              Expanded(
                  child: _buildItem(value: "<",isClear: true,color: AppColors.red,customWidget: widget.clearWidget)

              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem({required String value,Color? color, bool isNumber = true, bool isClear = false,Widget? customWidget}){
    if (customWidget!=null){
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        alignment: Alignment.center,
        child: customWidget
      );
    }

    return SplashTap(
        onTap: () {
          print("Value ${value}");

          if (isClear){
            widget.onClear();
            if (number.length <= 1){
                number = "0";
            }
            else {
              number = number.substring(0, number.length -1);
            }


          }
          else  if (isNumber){
            widget.onSelect(value);
            if (num.tryParse(number) == 0) {
              number = "$value";
            } else {
              number = "$number$value".trim();
            }
          }
          widget.onValue(num.parse(number));


          setState(() {
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
          ),
          alignment: Alignment.center,
          child: TextWidget(
            value,
            color: color,
            weight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),);
  }
}
