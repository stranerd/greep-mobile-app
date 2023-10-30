import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/transaction_crud_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_styles.dart';

class TransactionBalanceWidget extends StatefulWidget {
  const TransactionBalanceWidget({Key? key, required this.transaction, this.isColumn = false})
      : super(key: key);
  final Transaction transaction;
  final bool isColumn;

  @override
  State<TransactionBalanceWidget> createState() =>
      _TransactionBalanceWidgetState();
}

class _TransactionBalanceWidgetState extends State<TransactionBalanceWidget>
    with InputValidator, ScaffoldMessengerService {
  late TransactionCrudCubit _transactionCrudCubit;
  late TextEditingController _amountController;
  late String _debtType;
  late num debt;

  @override
  void initState() {
    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();

    _amountController = TextEditingController();
      _amountController.text = widget.transaction.debt.abs().toString();
      _debtType = "Balance";
      debt = widget.transaction.debt;
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (debt == 0) {
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
                debt = debt.abs() - num.parse(_amountController.text);
                _amountController.text=debt.toString();
              });

            }
          },
          builder: (context, state) {
           return Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Expanded(
                 child: Container(
                   decoration: const BoxDecoration(),
                   child: InputTextField(
                     customController: _amountController,
                     withTitle: false,
                     textStyle: widget.transaction.debt < 0 ? AppTextStyles.redSize14 : AppTextStyles.blueSize14,
                     inputType: TextInputType.number,
                     title: "Amount",
                     onChanged: (s) {
                     },
                     validator: emptyFieldValidator,
                   ),
                 ),
               ),
               kHorizontalSpaceSmall,
               SizedBox(
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
           );
          },
        );
      }),
    );
  }

  void transact() {
    _transactionCrudCubit.addBalance(
        parentId: widget.transaction.id,
        amount: num.parse("${widget.transaction.debt>0 ? "" : "-"}${_amountController.text}"),
        description: "",
        dateRecorded: DateTime.now());
  }
}
