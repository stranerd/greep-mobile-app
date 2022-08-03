import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/transaction/transaction_details.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {Key? key,
      required this.titleStyle,
      required this.subtitleStyle,
      required this.trailingStyle,
        required this.transaction,
        this.shouldTap = true,
        this.withBigAmount = true,
      required this.subTrailingStyle})
      : super(key: key);
  final Transaction transaction;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle trailingStyle;
  final TextStyle subTrailingStyle;
  final bool shouldTap;
  final bool withBigAmount;


  @override
  Widget build(BuildContext context) {
    String text = "";
    String subText = "";
    String trailText = "";
    TextStyle subStyle = subtitleStyle;
    TextStyle trailStyle = trailingStyle;
    String subTrailText = "";

      var type = transaction.data.transactionType;
      text = (type == TransactionType.trip
          ? transaction.data.customerName : type == TransactionType.balance
          ? "balance": type == TransactionType.expense
          ? transaction.data.name! : "")!;

      subText = DateFormat("${DateFormat.ABBR_MONTH} ${DateFormat.DAY} . hh:${DateFormat.MINUTE} a").format(transaction.timeAdded);

      trailText = "${type == TransactionType.trip ? "+":"-"}N${transaction.amount.abs().toMoney}";
      trailStyle = type == TransactionType.trip ? kDefaultTextStyle.copyWith(
          color: kGreenColor,
          fontSize: 12
      ): kErrorColorTextStyle.copyWith(
          fontSize: 12
      );

      subTrailText = transaction.data.transactionType.name;
    return SplashTap(
      onTap: !shouldTap ? null : (){
        g.Get.to(() => TransactionDetails(transaction: transaction,),transition: g.Transition.fadeIn);
      },
      child: Container(
        padding: const EdgeInsets.all(kDefaultSpacing * 0.5),
        margin: const EdgeInsets.only(
            bottom: kDefaultSpacing * 0.5
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.lightGray,
          border: Border.all(
              width: 0.5,
              color: const Color.fromRGBO(
                  221, 226, 224, 1)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: kDefaultTextStyle.copyWith(
                  fontSize: 15
                )),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  subText,
                  style: subStyle,
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trailText,
                  style: trailStyle.copyWith(
                    fontSize:withBigAmount ?  18 : 15,

                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  subTrailText,
                  style: kDefaultTextStyle.copyWith(
                    fontSize: 14
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
