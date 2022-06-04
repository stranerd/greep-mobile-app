import 'package:flutter/material.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:intl/intl.dart';

class TransactionListCard extends StatelessWidget {
  const TransactionListCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.titleStyle,
        this.transaction,
      required this.subtitleStyle,
      required this.trailingStyle})
      : super(key: key);
  final String title;
  final String subtitle;
  final String trailing;
  final Transaction? transaction;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle trailingStyle;

  @override
  Widget build(BuildContext context) {
    String text = title;
    String subText = subtitle;
    String trailText = trailing;
    TextStyle subStyle = subtitleStyle;
    TextStyle trailStyle = trailingStyle;
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
    }
    return ListTile(
      title: Text(text, style: titleStyle),
      subtitle: Text(
        subText,
        style: kDefaultTextStyle.copyWith(
          fontSize: 13
        ),
      ),
      trailing: Text(
        trailText,
        style: trailStyle,
      ),
    );
  }
}
