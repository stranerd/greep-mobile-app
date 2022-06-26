import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/customers/user_customers_cubit.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/commons/scaffold_messenger_service.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/customer/customer.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/submit_button.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';

class TransactionBalanceWidget extends StatefulWidget {
  const TransactionBalanceWidget({Key? key, this.withDetails = true, required this.transaction, required this.customerName})
      : super(key: key);
  final Transaction transaction;
  final bool withDetails;
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

  @override
  void initState() {
    _debtType = widget.transaction.credit > 0
        ? "Pay"
        : widget.transaction.debt > 0
            ? "Collect"
            : "Balance";
    _debtAmount = (widget.transaction.credit > 0
            ? widget.transaction.credit
            : widget.transaction.debt)
        .toString();

    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();
    _amountController = TextEditingController()..text = _debtAmount;
    customer = GetIt.I<UserCustomersCubit>().getCustomerByName(widget.customerName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (customer==null){
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
            }
          },
          builder: (context, state) {
            return LayoutBuilder(builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.withDetails)Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("${widget.transaction.data.customerName} ."),
                          kHorizontalSpaceTiny,
                          Text(DateFormat(
                                  "${DateFormat.ABBR_MONTH} ${DateFormat.DAY} . hh:${DateFormat.MINUTE} a")
                              .format(widget.transaction.timeAdded)),
                        ],
                      ),
                      kVerticalSpaceTiny,
                      Text("Trip Amount: ${widget.transaction.amount}"),
                      kVerticalSpaceTiny,
                      Text("Paid: ${widget.transaction.data.paidAmount}"),
                      kVerticalSpaceRegular,

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.5,
                        decoration: BoxDecoration(),
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
        amount: num.parse(_amountController.text),
        description: "",
        dateRecorded: DateTime.now());
  }
}
