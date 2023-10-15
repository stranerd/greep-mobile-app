import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details_screen.dart';
import 'package:greep/presentation/widgets/custom_icons.dart';
import 'package:greep/presentation/widgets/edit_record_dialogue.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
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
    trailText = transaction.amount.abs().toString();
    trailStyle = type == TransactionType.trip
        ? kDefaultTextStyle.copyWith(
            color: kGreenColor,
          )
        : kErrorColorTextStyle.copyWith();
    return Slidable(
      closeOnScroll: false,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.18,

        children: [
          SlidableAction(
            icon: CustomIcons.edit_trip,
            autoClose: true,
            foregroundColor: Colors.white,
            // label: '${widget.chatList.viewersCount}',
            backgroundColor: AppColors.green,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.r),
                bottomRight: Radius.circular(
                  12.r,
                )),
            onPressed: (context) {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  builder: (context) {
                    return EditRecordDialogue(
                      transaction: transaction,
                    );
                  });
            },
          ),
        ],
      ),
      key: Key(transaction.id),
      child: SplashTap(
        onTap: shouldTap
            ? () => g.Get.to(
                  () => TransactionDetailsScreen(
                    transaction: transaction,
                  ),
                  transition: g.Transition.fadeIn,
                )
            : null,
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: withBorder
                ? BorderRadius.circular(
                    12.r,
                  )
                : null,
            border: Border.all(color: AppColors.lightGray, width: 2.w),
            color: AppColors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (withLeading)
                    Row(
                      children: [
                        Container(
                          width: 44.r,
                          height: 44.r,
                          padding: EdgeInsets.all(
                            10.r,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 2, color: transaction.data.transactionType == TransactionType.expense ? AppColors.red.withOpacity(0.25) : Color(0x3F0150C5)),
                            color: AppColors.white,
                          ),
                          child: transaction.data.transactionType ==
                                  TransactionType.expense
                              ? SvgPicture.asset(
                                  "assets/icons/expense2.svg",
                                  fit: BoxFit.cover,
                                )
                              : SvgPicture.asset(
                                  "assets/icons/car.svg",
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text,
                        fontSize: 14.sp,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TimeDotWidget(
                        date: transaction.timeAdded,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    initial,
                    style: trailStyle,
                  ),
                  MoneyWidget(
                    amount: num.tryParse(trailText) ?? 0,
                    color: trailStyle.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
