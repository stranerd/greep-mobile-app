import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/transaction/transaction_details.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.titleStyle,
      required this.subtitleStyle,
      required this.trailingStyle,
        this.transaction,
        this.shouldTap = true,
      required this.subTrailing,
      required this.subTrailingStyle})
      : super(key: key);
  final String title;
  final String subtitle;
  final String trailing;
  final String subTrailing;
  final Transaction? transaction;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle trailingStyle;
  final TextStyle subTrailingStyle;
  final bool shouldTap;


  @override
  Widget build(BuildContext context) {
    String text = title;
    String subText = subtitle;
    String trailText = trailing;
    TextStyle subStyle = subtitleStyle;
    TextStyle trailStyle = trailingStyle;
    String subTrailText = subTrailing;

    if (transaction!=null){
      var type = transaction!.data.transactionType;
      text = (type == TransactionType.trip
          ? transaction!.data.customerName : type == TransactionType.balance
          ? "balance": type == TransactionType.expense
          ? transaction!.data.name! : title)!;

      subText = DateFormat("${DateFormat.ABBR_MONTH} ${DateFormat.DAY} . hh:${DateFormat.MINUTE} a").format(transaction!.timeCreated);

      trailText = "${type == TransactionType.trip ? "+":"-"}${transaction!.amount}";
      trailStyle = type == TransactionType.trip ? kDefaultTextStyle.copyWith(
          color: kGreenColor,
          fontSize: 12
      ): kErrorColorTextStyle.copyWith(
          fontSize: 12
      );

      subTrailText = transaction!.data.transactionType.name;
    }
    return GestureDetector(
      onTap: transaction == null ? null : !shouldTap ? null : (){
        Get.to(() => TransactionDetails(transaction: transaction!,));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(
            16, 16, 16, 16),
        margin: const EdgeInsets.only(
            bottom: kDefaultSpacing * 0.5
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
              width: 1,
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
              children: [
                Text(
                  trailText,
                  style: trailStyle,
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
