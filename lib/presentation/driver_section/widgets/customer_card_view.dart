import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';

class CustomerCardView extends StatelessWidget {
  const CustomerCardView(
      {Key? key,
      required this.title,
      required this.subtitle,
        this.transaction,
        this.userId,
      required this.titleStyle,
      required this.subtitleStyle})
      : super(key: key);

  final String title;
  final String? userId;
  final String subtitle;
  final Transaction? transaction;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    String text = title;
    TextStyle subTextStyle = subtitleStyle;
    String subText = subtitle;

    if (transaction!=null) {
      TransactionType type = transaction!.data.transactionType;
      TransactionData data = transaction!.data;
      subText = "N${transaction!.amount.toMoney}";

      subTextStyle =
      type == TransactionType.trip && data.debt! > 0 ? kDefaultTextStyle
          .copyWith(
          color: kGreenColor,
          fontSize: 12
      ) :
      type == TransactionType.balance ? kDefaultTextStyle.copyWith(
          fontSize: 12
      ) : kDefaultTextStyle.copyWith(
          fontSize: 12
      );
      if (type == TransactionType.balance) {
        if (data.parentId == null || data.parentId!.isEmpty) {
          text = "Customer";
        }
        var transaction = GetIt.I<CustomerStatisticsCubit>().getByParentBalance(
            userId!, data.parentId!);
        if (transaction == null || transaction.data.customerName == null) {
          text = "Customer";
        }
        else {
          text = transaction.data.customerName!;
        }
      }
      else {
        text = data.customerName!;
      }
    }

    return Container(
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(221, 226, 224, 1),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Row(
          children: [
            Text(
              text,
              style: kDefaultTextStyle,
            ),
            const Spacer(),
            Text(
              "${subText}",
              style: subTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
