import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/records/view_records.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:get/get.dart' as g;
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding:
          const EdgeInsets.fromLTRB(0, 0, 0, 0),
          title: TextWidget("Transaction history",
              weight: FontWeight.bold,
            fontSize: 16,
          ),
          trailing: SplashTap(
            onTap: () {
              g.Get.to(
                      () => const ViewAllRecords(),
                  arguments: {"showAppBar": true},
                  transition: g.Transition.fadeIn);
            },
            child: TextWidget("view all",
                style: AppTextStyles.blackSize14),
          ),
        ),
        Builder(builder: (context) {
          List<Transaction> transactions =
          GetIt.I<UserTransactionsCubit>()
              .getLastUserTransactions();
          if (transactions.isEmpty) {
            return const EmptyResultWidget(
                text: "No recent transactions");
          }
          return ListView.separated(
            separatorBuilder: (_, __) => Row(
              children: [
                SizedBox(
                  width: 70.w,
                ),
                Expanded(
                  child: Container(
                    width: Get.width * 0.7,
                    height: 4.h,
                    decoration: const BoxDecoration(
                        color: AppColors.lightGray),
                  ),
                ),
              ],
            ),
            itemCount: transactions.length,
            physics:
            const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (c, i) {
              return TransactionListCard(
                transaction: transactions[i],
                withLeading: true,
              );
            },
          );
        }),
      ],
    );
  }
}
