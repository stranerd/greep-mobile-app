import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/money_value_widget.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';

class AmountSelectorWidget extends StatefulWidget {
  final Function(String) onValue;

  const AmountSelectorWidget({Key? key, required this.onValue})
      : super(key: key);

  @override
  _AmountSelectorWidgetState createState() => _AmountSelectorWidgetState();
}

class _AmountSelectorWidgetState extends State<AmountSelectorWidget> {
  num selectedNum = 0;

  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputTextField(
          suffixSize: 20.r,
          suffixIcon: "assets/icons/turkish2.svg",
          hintText: "100 - 1000",
          title: "Enter or select amount",
          customController: amountController,
          inputType: TextInputType.number,
          isMoney: true,
          validator: (_) {},
          onChanged: (s) {
            s = s.replaceAll(",", "");
            if (num.tryParse(s) != null) {
              setState(() {
                selectedNum = num.parse(s);
              });
              widget.onValue(
                s,
              );
            }
          },
        ),
        SizedBox(
          height: 16.h,
        ),
        LayoutBuilder(builder: (c, cs) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildItem(value: 100)),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(child: _buildItem(value: 200)),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(child: _buildItem(value: 300)),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(child: _buildItem(value: 400)),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildItem(value: 500)),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(child: _buildItem(value: 700)),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(child: _buildItem(value: 800)),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(child: _buildItem(value: 1000)),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildItem({
    required num value,
  }) {
    return MoneyValueWidget(
      onSelect: (n) {
        selectedNum = n;
        amountController.text = selectedNum.toString();

        setState(() {});
        widget.onValue(amountController.text);
      }, value: value, isSelected: selectedNum == value,
    );
  }
}
