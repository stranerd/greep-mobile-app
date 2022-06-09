import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/customer_card_view.dart';
import 'customer_details.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({Key? key}) : super(key: key);

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerStatisticsCubit, CustomerStatisticsState>(
  listener: (context, state) {
    if (state is CustomerStatisticsStateDone) {
      print("Setting summary state");
      setState(() {

      });
    }
  },
  child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Customers',
          style: AppTextStyles.blackSizeBold16,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blue,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text("To collect", style: AppTextStyles.blackSize12),
                      ],
                    ),
                    const SizedBox(width: 48.0),
                    Row(
                      children: [
                        Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.red,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text("To pay", style: AppTextStyles.blackSize12),
                      ],
                    ),
                    const SizedBox(width: 48.0),
                    Row(
                      children: [
                        Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text("Balanced", style: AppTextStyles.blackSize12),
                      ],
                    ),
                  ],
                ),
                kVerticalSpaceMedium,
                Builder(builder: (c) {
                  String userId = GetIt.I<UserCubit>().userId!;
                  List<Transaction> transactions =
                      GetIt.I<CustomerStatisticsCubit>()
                          .getDebtTransactions(userId);
                  if (transactions.isEmpty) {
                    return SizedBox(
                      height: Get.height * 0.7,
                      child: const EmptyResultWidget(
                          text: "No customer transactions"),
                    );
                  }

                  return ListView.separated(
                      separatorBuilder: (c, i) => kVerticalSpaceSmall,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (c, i) {
                        return CustomerCardView(
                              title: "Kemi",
                              transaction: transactions[i],
                              userId: userId,
                              subtitle: "8\$",
                              titleStyle: AppTextStyles.blackSize16,
                              subtitleStyle: AppTextStyles.redSize16);
                      });
                }),
              ],
            ),
          ),
        ),
      ),
    ),
);
  }
}
