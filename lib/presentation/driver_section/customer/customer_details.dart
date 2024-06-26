import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/customers/user_customers_cubit.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/application/transactions/response/customer_summary.dart';
import 'package:greep/application/transactions/transaction_crud_cubit.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/customer/customer.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/transaction_balance_widget.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/record_card.dart';
import '../widgets/transaction_list_card.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String name;

  const CustomerDetailsScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  List<String> paymentTypes = [];
  final formKey = GlobalKey<FormState>();
  late CustomerSummary _customerSummary;
  Customer? customer;

  String filter = "";

  @override
  void initState() {
    _customerSummary =
        GetIt.I<CustomerStatisticsCubit>().getCustomerSummary(widget.name);


    customer = GetIt.I<UserCustomersCubit>().getCustomerByName(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    num debt = customer != null ? customer!.debt : 0;

    return MultiBlocListener(
  listeners: [
    BlocListener<UserCustomersCubit, UserCustomersState>(
      listener: (context, state) {
        if (state is UserCustomersStateFetched) {
          setState(() {
            customer =
                GetIt.I<UserCustomersCubit>().getCustomerByName(widget.name);
            _customerSummary =
                GetIt.I<CustomerStatisticsCubit>().getCustomerSummary(widget.name);

          });
        }
      },
),
    BlocListener<UserTransactionsCubit, UserTransactionsState>(
      listener: (context, state) {
        setState(() {
          _customerSummary = GetIt.I<CustomerStatisticsCubit>().getCustomerSummary(widget.name);
        });
      },
    ),
  ],
  child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(

          backgroundColor: Colors.white,
          leading: BackIcon(isArrow: true,),
          title: TextWidget(
            widget.name,
            fontSize: 18.sp,
            weight: FontWeight.w600,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16.0.r, 16.0.r, 16.0.r, 0.0),
          child: SafeArea(
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                // TextWidget(
                //   _customerSummary.name.capitalize ?? "",
                //   style: AppTextStyles.blackSizeBold16,
                // ),
                // SizedBox(
                //   height: 16.0.h,
                // ),
                TextWidget(
                  "Account",
                  fontSize: 16.sp,weight: FontWeight.w600,
                ),
                SizedBox(
                  height: 8.0.h,
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RecordCard(
                          initial: "",
                          width: constraints.maxWidth * 0.31,
                          title: _customerSummary.totalPaid.abs().toMoney,
                          subtitle: "Total paid",
                          withSymbol: true,
                          onTap: () => _setFilter("total"),
                          isSelected: filter == "total",
                          titleStyle: AppTextStyles.greenSize16,
                          subtitleStyle: AppTextStyles.blackSize12),
                      RecordCard(
                          initial: "",
                          withSymbol: true,
                          onTap: () => _setFilter("collect"),
                          isSelected: filter == "collect",
                          width: constraints.maxWidth * 0.31,
                          title:
                              _customerSummary.toCollect.abs().toMoney,
                          subtitle: "To collect",
                          titleStyle: AppTextStyles.blueSize16,
                          subtitleStyle: AppTextStyles.blackSize12),
                      RecordCard(
                          initial: "",
                          withSymbol: true,
                          onTap: () => _setFilter("pay"),
                          isSelected: filter == "pay",
                          width: constraints.maxWidth * 0.31,
                          title:
                              _customerSummary.toPay.abs().toMoney,
                          subtitle: "To pay",
                          titleStyle: AppTextStyles.redSize16,
                          subtitleStyle: AppTextStyles.blackSize12),
                    ],
                  );
                }),
                kVerticalSpaceRegular,
                TextWidget("Transaction history",
                    weight: FontWeight.bold,
                fontSize: 16.sp,
                ),
                 SizedBox(
                  height: 8.0.h,
                ),
                Column(
                    children: _customerSummary.transactions.where((element) {
                      if (filter.isEmpty || filter == "total"){
                        return true;
                      }

                      else if (filter == "pay"){
                        return element.debt < 0;
                      }

                      else if (filter == "collect"){
                        return element.debt > 0;
                      }

                      return true;
                    })
                        .map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TransactionListCard(
                                withColor: true,
                                padding: kDefaultSpacing * 0.5,
                                transaction: e,
                                withBorder: true,
                                withLeading: true,
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

  _setFilter(String filter) {
    if (filter == this.filter) {
      setState(() {
        this.filter = "";
      });
    } else {
      setState(() {
        this.filter = filter;
      });
    }
  }
}
