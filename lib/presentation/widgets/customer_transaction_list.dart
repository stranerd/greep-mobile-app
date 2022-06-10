import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/customer_record_card.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/utils/constants/app_styles.dart';

class CustomerTransactionListWidget extends StatelessWidget {
  final String userId;
  const CustomerTransactionListWidget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 return BlocBuilder<CustomerStatisticsCubit, CustomerStatisticsState>(
  builder: (context, state) {
    if (state is CustomerStatisticsStateDone){
      List<Transaction> transactions  = GetIt.I<CustomerStatisticsCubit>().getDebtTransactions().take(3).toList();
      if (transactions.isEmpty) return const EmptyResultWidget(text: "No Customer transactions");

      return LayoutBuilder(builder: (c,cs){
      return Row(
        mainAxisAlignment: transactions.length > 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: transactions.map((e) => CustomerRecordCard(
          title: "\$8",
          subtitle: "To pay",
          width: transactions.length == 2 ? cs.maxWidth * 0.48 :  cs.maxWidth * 0.31,
          subtextTitle: "Kemi",
          transaction: e,
          subtextTitleStyle:
          AppTextStyles.blackSize12,
          subtitleStyle: AppTextStyles.blackSize12,
          titleStyle: AppTextStyles.greenSize16,
        ),).toList(),
      );
    }
    );
  }
    return Container();
    }

    ,
);
  }
}
