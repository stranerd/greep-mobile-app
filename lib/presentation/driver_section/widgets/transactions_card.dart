import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';
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
    String initial = "";

      var type = transaction.data.transactionType;
      text = (type == TransactionType.trip
          ? transaction.data.customerName : type == TransactionType.balance
          ? "balance": type == TransactionType.expense
          ? transaction.data.name! : "")!;

      subText = DateFormat("${DateFormat.ABBR_MONTH} ${DateFormat.DAY} . hh:${DateFormat.MINUTE} a").format(transaction.timeAdded);
      initial = type == TransactionType.trip ? "+":"-";
      trailText = transaction.amount.abs().toMoney;
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(initial, style: trailStyle.copyWith(
                      fontSize:withBigAmount ?  18 : 15,
                    ),
                    ),
                    TurkishSymbol(width:withBigAmount ?  13 : 11 ,height: withBigAmount ?  13 : 11,color: trailStyle.color,),
                    Text(
                      trailText,
                      style: trailStyle.copyWith(
                        fontSize:withBigAmount ?  18 : 15,

                      ),

                    ),
                  ],
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
