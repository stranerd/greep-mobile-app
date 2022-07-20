import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/customers/user_customers_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/response/customer_summary.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/application/user/utils/get_current_user.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/customer/customer.dart';
import 'package:grip/presentation/widgets/transaction_balance_widget.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/record_card.dart';
import '../widgets/transaction_list_card.dart';

class CustomerDetails extends StatefulWidget {
  final String name;

  const CustomerDetails({Key? key, required this.name}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {

  List<String> paymentTypes = [];
  final formKey = GlobalKey<FormState>();
  late CustomerSummary _customerSummary;
  Customer? customer;

  @override
  void initState() {
    _customerSummary =
        GetIt.I<CustomerStatisticsCubit>().getCustomerSummary(widget.name);

    customer =
        GetIt.I<UserCustomersCubit>().getCustomerByName(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num debt = customer !=null ? customer!.debt : 0;

    return BlocListener<UserCustomersCubit, UserCustomersState>(
  listener: (context, state) {
    if (state is UserCustomersStateFetched){
      setState(() {
        customer = GetIt.I<UserCustomersCubit>().getCustomerByName(widget.name);
      });
    }
  },
  child: Scaffold(
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
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              Text(
                _customerSummary.name.capitalize ?? "",
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
              LayoutBuilder(builder: (context, constraints) {
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
                        title: "N${customer !=null ? debt > 0 ? debt.abs() : 0 : _customerSummary.toPay.toMoney}",
                        subtitle: "To collect",
                        titleStyle: AppTextStyles.blueSize16,
                        subtitleStyle: AppTextStyles.blackSize12),
                    RecordCard(
                        width: constraints.maxWidth * 0.31,
                        title: "N${customer !=null ? debt < 0 ? debt : 0  : _customerSummary.toCollect.toMoney}",
                        subtitle: "To pay",
                        titleStyle: AppTextStyles.redSize16,
                        subtitleStyle: AppTextStyles.blackSize12),
                  ],
                );
              }),

              kVerticalSpaceRegular,
              Text("Transaction history",
                  style: AppTextStyles.blackSizeBold12),
              const SizedBox(
                height: 8.0,
              ),
              Column(
                  children: _customerSummary.transactions
                      .map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TransactionListCard(
                              withColor: true,
                              padding: kDefaultSpacing * 0.5,
                              transaction: e,
                              withBorder: true,
                            ),
                            kVerticalSpaceSmall,
                          ],
                        ),
                      )
                      .toList()),
            ],
          ),
        ),
      ),
    ),
);
  }
}
