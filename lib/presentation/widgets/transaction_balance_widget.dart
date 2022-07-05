import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/customers/user_customers_cubit.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/commons/scaffold_messenger_service.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/customer/customer.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/submit_button.dart';
import 'package:grip/utils/constants/app_styles.dart';

class TransactionBalanceWidget extends StatefulWidget {
  const TransactionBalanceWidget({Key? key, required this.customerName})
      : super(key: key);
  final String customerName;

  @override
  State<TransactionBalanceWidget> createState() =>
      _TransactionBalanceWidgetState();
}

class _TransactionBalanceWidgetState extends State<TransactionBalanceWidget>
    with InputValidator, ScaffoldMessengerService {
  late TransactionCrudCubit _transactionCrudCubit;
  late TextEditingController _amountController;
  String _amount = "";
  late String _debtType;
  late String _debtAmount;
  Customer? customer;
  late bool isCredit;
  late num debt;

  @override
  void initState() {
    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();

    customer =
        GetIt.I<UserCustomersCubit>().getCustomerByName(widget.customerName);

    _amountController = TextEditingController();
    if (customer != null) {
      _amountController.text = customer!.debt.abs().toString();
      _debtType = "Balance";
      isCredit = customer!.debt > 0;
      debt = customer!.debt;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (customer == null || debt == 0) {
      return Container();
    }
    return BlocProvider.value(
      value: _transactionCrudCubit,
      child: Builder(builder: (context) {
        return BlocConsumer<TransactionCrudCubit, TransactionCrudState>(
          listener: (context, state) {
            if (state is TransactionCrudStateFailure) {
              error = state.errorMessage;
            }
            if (state is TransactionCrudStateSuccess) {

              success = "Balance recorded";
              setState(() {
                debt = debt - num.parse(_amountController.text);
                _amountController.text=debt.toString();
              });

            }
          },
          builder: (context, state) {
            return LayoutBuilder(builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settle customer transactions",
                    style: AppTextStyles.blackSizeBold12,
                  ),
                  kVerticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.5,
                        decoration: const BoxDecoration(),
                        child: LoginTextField(
                          customController: _amountController,
                          withTitle: false,
                          title: "Amount",
                          onChanged: (s) {
                            _amount = s;
                          },
                          validator: emptyFieldValidator,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 50,
                        child: SubmitButton(
                          text: _debtType,
                          isLoading: state is TransactionCrudStateLoading,
                          enabled: state is! TransactionCrudStateLoading,
                          onSubmit: transact,
                          padding: kDefaultSpacing * 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            });
          },
        );
      }),
    );
  }

  void transact() {

    _transactionCrudCubit.addBalance(
        customerId: customer!.id,
        amount: num.parse("${isCredit ? "" : "-"}${_amountController.text}"),
        description: "",
        dateRecorded: DateTime.now());
  }
}
