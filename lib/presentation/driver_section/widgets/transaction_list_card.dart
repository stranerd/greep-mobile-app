import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/transaction/transaction_details.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';
import 'package:grip/utils/constants/svg_icon.dart';
import 'package:intl/intl.dart';

class TransactionListCard extends StatelessWidget {
  const TransactionListCard(
      {Key? key,
        this.shouldTap = true,
        this.withBorder = false,
        this.withLeading = false,
        this.padding,
      required this.transaction,
        this.withColor = false,})
      : super(key: key);
  final Transaction transaction;
  final bool withBorder;
  final bool shouldTap;
  final bool withColor;
  final bool withLeading;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    String text = "";
    String subText = "";
    String trailText = "";

    TextStyle? trailStyle;
      var type = transaction.data.transactionType;
      text = (type == TransactionType.trip
          ? transaction.data.customerName
          : type == TransactionType.balance
              ? "balance"
              : type == TransactionType.expense
                  ? transaction.data.name!
                  : "")!;

      subText = DateFormat(
              "${DateFormat.ABBR_MONTH} ${DateFormat.DAY} . hh:${DateFormat.MINUTE} a")
          .format(transaction.timeAdded);

      trailText =
          "${type == TransactionType.trip ? "+" : "-"}N${transaction.amount.toMoney}";
      trailStyle = type == TransactionType.trip
          ? kDefaultTextStyle.copyWith(color: kGreenColor,)
          : kErrorColorTextStyle.copyWith();

    return Container(
      decoration: BoxDecoration(
        border: withBorder ?Border.all(color: Colors.grey.shade200,
        ): null,

        color: withColor ? AppColors.lightGray: null,
        borderRadius: withBorder ?BorderRadius.circular(kDefaultSpacing * 0.5) : null

      ),
      child: ListTile(
        contentPadding: padding == null ?EdgeInsets.zero : EdgeInsets.symmetric(horizontal: padding!),
        leading: withLeading ? Container(
          width: 60,
          padding: const EdgeInsets.all(kDefaultSpacing,),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightGray,
            ),
          child: SvgPicture.asset(transaction.data.transactionType == TransactionType.expense ?"assets/icons/expense.svg": "assets/icons/local_taxi.svg"),
          ) : null,
        onTap: shouldTap ? () => g.Get.to(() => TransactionDetails(transaction: transaction),transition: g.Transition.fadeIn): null,
        title: Text(text, style: AppTextStyles.blackSize14),
        subtitle: Text(
          subText,
          style: kDefaultTextStyle.copyWith(fontSize: 12),
        ),
        trailing: Text(
          trailText,
          style: trailStyle,
        ),
      ),
    );
  }

}
