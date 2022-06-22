import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/transaction/transaction_details.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';

class CustomerRecordCard extends StatelessWidget {
  const CustomerRecordCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.titleStyle,
      required this.subtitleStyle,
      required this.subtextTitle,
        this.width,
        this.transaction,
      required this.subtextTitleStyle})
      : super(key: key);

  final String title;
  final String subtitle;
  final Transaction? transaction;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final String subtextTitle;
  final TextStyle subtextTitleStyle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    String text = title;
    String subText = subtitle;
    TextStyle textStyle = titleStyle;
    String subText2 = subtextTitle;

    if (transaction!=null) {
      TransactionType type = transaction!.data.transactionType;
      TransactionData data = transaction!.data;
      text = transaction!.amount.toString();

      subText = type == TransactionType.trip && transaction!.debt > 0 ? "to pay" :
      type == TransactionType.balance ? "balanced" : "balanced";

      textStyle =
      type == TransactionType.trip && transaction!.debt > 0 ? kDefaultTextStyle
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
          subText2 = "Customer";
        }
        var transaction = GetIt.I<CustomerStatisticsCubit>().getByParentBalance(data.parentId!);
        if (transaction == null || transaction.data.customerName == null) {
          subText2 = "Customer";
        }
        else {
          subText2 = transaction.data.customerName!;
        }
      }
      else {
        subText2 = data.customerName!;
      }
    }

    return SplashTap(
      onTap: () {
      if (transaction!=null){
        Get.to(() {
        return TransactionDetails(transaction: transaction!);
      });
      }
      },
      child: Container(
        width: width ?? Get.width * 0.31,
        height: 110,
        padding: EdgeInsets.all(kDefaultSpacing),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color.fromRGBO(221, 226, 224, 1),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: textStyle),
            const SizedBox(height: 8.0),
            Text(subText, style: kSubtitleTextStyle.copyWith(
              fontSize: 12
            )),
            const SizedBox(height: 8.0),
            Text(subText2,overflow: TextOverflow.ellipsis, style: kDefaultTextStyle.copyWith(
              fontSize: 12
            )),
          ],
        ),
      ),
    );
  }
}
