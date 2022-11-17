import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:greep/utils/constants/svg_icon.dart';
import 'package:intl/intl.dart';

class TransactionListCard extends StatelessWidget {
  const TransactionListCard({
    Key? key,
    this.shouldTap = true,
    this.withBorder = false,
    this.withLeading = false,
    this.padding,
    required this.transaction,
    this.withColor = false,
  }) : super(key: key);
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
    String initial = "";

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

    initial = type == TransactionType.trip ? "+" : "-";
    trailText = transaction.amount.abs().toMoney;
    trailStyle = type == TransactionType.trip
        ? kDefaultTextStyle.copyWith(color: kGreenColor,)
        : kErrorColorTextStyle.copyWith();
    return Container(
      decoration: BoxDecoration(
          border: withBorder
              ? Border.all(
                  color: Colors.grey.shade200,
                )
              : null,
          color: withColor ? AppColors.lightGray : null,
          borderRadius:
              withBorder ? BorderRadius.circular((kDefaultSpacing * 0.5).r) : null),
      child: ListTile(
        contentPadding: padding == null
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: padding!.w),
        leading: withLeading
            ? Container(
                width: 60,
                padding: const EdgeInsets.all(
                  kDefaultSpacing,
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGray,
                ),
                child:
                    transaction.data.transactionType == TransactionType.expense
                        ? Image.asset("assets/icons/expense.png",
                            width: 25.w, height: 25.h)
                        : SvgPicture.asset("assets/icons/local_taxi.svg"),
              )
            : null,
        onTap: shouldTap
            ? () => g.Get.to(() => TransactionDetails(transaction: transaction),
                transition: g.Transition.fadeIn)
            : null,
        title: TextWidget(text, style: AppTextStyles.blackSize14),
        subtitle: TextWidget(
          subText,
          style: kDefaultTextStyle.copyWith(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              initial,
              style: trailStyle,
            ),
            TurkishSymbol(
              width: (14.w),
              height: (14.h),
              color: trailStyle.color,
            ),
            TextWidget(
              trailText,
              style: trailStyle,
            ),
          ],
        ),
      ),
    );
  }
}
