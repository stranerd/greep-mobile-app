import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/customers/user_customers_cubit.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/widgets/customer_record_card.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/utils/constants/app_styles.dart';

class CustomerTransactionListWidget extends StatelessWidget {
  const CustomerTransactionListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCustomersCubit, UserCustomersState>(
      builder: (context, state) {
        return BlocBuilder<CustomerStatisticsCubit, CustomerStatisticsState>(
          builder: (context, state) {
            if (state is CustomerStatisticsStateDone) {
              List<Transaction> transactions = GetIt.I<
                  CustomerStatisticsCubit>()
                  .getCustomerTransactions()
                  .take(3)
                  .toList();
              if (transactions.isEmpty) {
                return const EmptyResultWidget(
                    text: "No Customer transactions");
              }

              return LayoutBuilder(builder: (c, cs) {
                return Row(
                  mainAxisAlignment: transactions.length > 1
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: transactions
                      .map(
                        (e) =>
                        CustomerRecordCard(
                          width: transactions.length == 2
                              ? cs.maxWidth * 0.48
                              : cs.maxWidth * 0.31,
                          transaction: e,
                          subtextTitleStyle: AppTextStyles.blackSize12,
                          subtitleStyle: AppTextStyles.blackSize12,
                          titleStyle: AppTextStyles.greenSize16,
                        ),
                  )
                      .toList(),
                );
              });
            }
            return Container();
          },
        );
      },
    );
  }
}
