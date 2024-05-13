import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/application/wallet/request/fund_wallet_request.dart';
import 'package:greep/application/wallet/request/wallet_withdraw_request.dart';
import 'package:greep/application/wallet/user_wallet_cubit.dart';
import 'package:greep/application/wallet/wallet_crud_cubit.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/driver_section/security/sheets/confirm_send_money_pin_sheet.dart';
import 'package:greep/presentation/driver_section/security/sheets/create_transaction_pin_sheet.dart';
import 'package:greep/presentation/wallet/views/wallet_withdrawal_success_screen.dart';
import 'package:greep/presentation/widgets/amount_selector_widget.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/custom_appbar.dart';
import 'package:greep/presentation/widgets/in_app_notification_widget.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class CashWithdrawalScreen extends StatefulWidget {
  const CashWithdrawalScreen({Key? key}) : super(key: key);

  @override
  _CashWithdrawalScreenState createState() => _CashWithdrawalScreenState();
}

class _CashWithdrawalScreenState extends State<CashWithdrawalScreen> {
  late WalletCrudCubit walletCrudCubit;

  String pin = "";
  num selectedNum = 0;

  @override
  void initState() {
    super.initState();
    walletCrudCubit = getIt();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: walletCrudCubit,
      child: BlocConsumer<WalletCrudCubit, WalletCrudState>(
        listener: (context, state) {
          if (state is WalletCrudStateError) {
            showInAppNotification(context,
                title: "Withdraw", body: state.errorMessage, isSuccess: false);
          }

          if (state is WalletCrudStateWithdrawSuccess) {
            print("Withdraw success ");
            Get.off(() => WalletWithdrawalSuccessScreen(
                  transaction: state.transaction,
                ));
            showInAppNotification(
              context,
              title: "Withdraw Success",
              body: "Your withdraw request was successfully sent",
            );
          }
        },
        builder: (context, crudState) {
          return BlocConsumer<UserWalletCubit, UserWalletState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, userWalletState) {
              return Scaffold(
                  bottomNavigationBar: SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                        bottom: 5.h,
                      ),
                      child: SubmitButton(
                        height: 50.h,
                        widthRatio: 0.98,
                        text: "Confirm",
                        isLoading: crudState is WalletCrudStateLoading,
                        enabled: selectedNum > 99 &&
                            crudState is! WalletCrudStateLoading,
                        onSubmit: () {
                          if (userWalletState is UserWalletStateFetched &&
                              userWalletState.wallet.hasPin) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return ConfirmSendMoneyPinSheet(
                                    amount: selectedNum,
                                    onFinish: (s) {
                                      setState(() {
                                        pin = s;
                                      });
                                      walletCrudCubit.withdrawWallet(
                                        WalletWithdrawRequest(
                                          amount: selectedNum,
                                          pin: pin,
                                          location: getIt<LocationCubit>().currLocation
                                        ),
                                      );
                                    },
                                  );
                                });
                          } else {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return CreateTransactionPinSheet(
                                    onFinished: (s) {
                                      setState(() {
                                        pin = s;
                                      });
                                    },
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ),
                  appBar: AppBar(
                    centerTitle: true,
                    title: TextWidget(
                      "Withdraw cash",
                      weight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    leading: const BackIcon(
                      isArrow: true,
                    ),
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                    child: Column(
                      children: [
                        AmountSelectorWidget(
                          onValue: (s) {
                            selectedNum = num.tryParse(s) ?? 0;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: 0.2.sh,
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
