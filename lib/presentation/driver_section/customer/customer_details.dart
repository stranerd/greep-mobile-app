import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/response/customer_summary.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/money.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/record_card.dart';
import '../widgets/transaction_list_card.dart';

class CustomerDetails extends StatefulWidget {
  final String name;
  final String userId;
  const CustomerDetails({Key? key, required this.name, required this.userId}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late TransactionCrudCubit _transactionCrudCubit;

  List<String> paymentTypes = [];
  final formKey = GlobalKey<FormState>();
  late CustomerSummary _customerSummary;

  @override
  void initState() {
    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();
    _customerSummary = GetIt.I<CustomerStatisticsCubit>().getCustomerSummary(widget.name);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            color: AppColors.black),
        title: Text(
          'Customer Details',
          style: AppTextStyles.blackSizeBold16,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _customerSummary.name.capitalize??"",
                  style: AppTextStyles.blackSizeBold16,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Account",
                  style: AppTextStyles.blackSizeBold12,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RecordCard(
                            width: constraints.maxWidth * 0.31,
                            title: "N${_customerSummary.totalPaid.toMoney}",
                            subtitle: "Total paid",
                            titleStyle: AppTextStyles.greenSize16,
                            subtitleStyle: AppTextStyles.blackSize12),
                        RecordCard(
                            width: constraints.maxWidth * 0.31,
                            title: "N${_customerSummary.toCollect.toMoney}",
                            subtitle: "To collect",
                            titleStyle: AppTextStyles.blueSize16,
                            subtitleStyle: AppTextStyles.blackSize12),
                        RecordCard(
                            width: constraints.maxWidth * 0.31,
                            title: "N${_customerSummary.toPay.toMoney}",
                            subtitle: "To pay",
                            titleStyle: AppTextStyles.redSize16,
                            subtitleStyle: AppTextStyles.blackSize12),
                      ],
                    );
                  }
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Settle debt",
                  style: AppTextStyles.blackSizeBold12,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 180.w,
                      padding: const EdgeInsets.fromLTRB(16, 16, 64, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color.fromRGBO(243, 246, 248, 1),
                      ),
                      child: Text("\$8", style: AppTextStyles.blueSize14),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.black,
                      ),
                      child: Text("Balance", style: AppTextStyles.whiteSize14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Text("Transaction history",
                    style: AppTextStyles.blackSizeBold12),
                const SizedBox(
                  height: 8.0,
                ),
                Column(
                  children: _customerSummary.transactions.map((e) => TransactionListCard(
                    title: "Trip",
                    subtitle: "Mar 19 . 10:54 AM",
                    trailing: "+20\$",
                    transaction: e,
                    titleStyle: AppTextStyles.blackSize14,
                    subtitleStyle: AppTextStyles.blackSize12,
                    trailingStyle: AppTextStyles.greenSize14,
                  ),
                  ).toList()
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
