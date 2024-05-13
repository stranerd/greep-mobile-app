import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/application/wallet/conversion_rate_cubit.dart';
import 'package:greep/application/wallet/user_wallet_cubit.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/wallet/sheets/wallet_withdraw_options_sheet.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/custom_appbar.dart';
import 'package:greep/presentation/widgets/key_value_widget.dart';
import 'package:greep/presentation/widgets/loading_widget.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          "Wallet",
          weight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        leading: const BackIcon(
          isArrow: true,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(
          16.r,
        ),
        child: Column(
          children: [
           BlocConsumer<UserWalletCubit, UserWalletState>(
        listener: (newContext, state) {
          if (state is UserWalletStateError && state.statusCode == 461) {

          }
        },
        builder: (context, walletState) {
          return Stack(
            children: [
              Container(
                height: 172.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(colors: [
                     Color(0xff10BB76),
                    Color(0xff086D50),
                    Color(0xff001726).withOpacity(1),
                  ], stops: [
                    -0.3,
                    0.4,
                    1.2
                  ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child:
                      TextWidget(
                        getUser().fullName,
                        fontSize: 16.sp,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),

                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          "Total Balance",
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            walletState is UserWalletStateFetched
                                ? MoneyWidget(
                              amount: walletState.wallet.amount,
                              flipped: true,
                              color: Colors.white,
                              size: 22,
                              weight: FontWeight.bold,
                            )
                                :walletState is UserWalletStateLoading ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: LoadingWidget(
                                color: Colors.white,
                                size: 15,
                              ),
                            ): MoneyWidget(
                              amount: 0,
                              flipped: true,
                              color: Colors.white,
                              size: 22,
                              weight: FontWeight.bold,
                            ),

                            // TextWidget("**********",fontSize: 22.sp,color: Colors.white,),
                            SizedBox(
                              width: 10.w,
                            ),
                          ],
                        ),

                      ],
                    ),

                  ],
                ),
              ),
              // Positioned(
              //   right: 10.w,
              //   top: 21.h,
              //   child: IgnorePointer(
              //     child: Image.asset(
              //       "assets/images/wallet_board.png",
              //     ),
              //   ),
              // )
            ],
          );
        },
        ),
            SizedBox(height: 20.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SplashTap(
                    onTap: () {
                      showModalBottomSheet(context: context, builder: (context){
                        return WalletWithdrawOptionsSheet();
                      });
                      // Get.to(() => const SendMoneyScreen());
                    },
                    child: Container(
                      height: 45.h,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(kDefaultSpacing * 0.6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.black,),
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            "Withdraw ",
                            color:AppColors.black,
                            fontSize: 14.sp,
                            weight: FontWeight.w600,
                          ),
                          TextWidget(
                            "(",
                            color: AppColors.black,
                            fontSize: 14.sp,
                            weight: FontWeight.w600,
                          ),
                          TurkishSymbol(
                            color: AppColors.black,
                            width: 15.w,
                            height: 15.h,
                          ),
                          TextWidget(
                            ")",
                            color: AppColors.black,
                            fontSize: 14.sp,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: SplashTap(
                    onTap: () {
                      // Get.to(() => const WithdrawMoneyScreen());
                    },
                    child: Container(
                      height: 45.h,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(kDefaultSpacing * 0.6),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.red,),
                          borderRadius: BorderRadius.circular(12.r,),),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            "Balance ",
                            color: AppColors.red,
                            fontSize: 14.sp,
                            weight: FontWeight.bold,
                          ),
                          TextWidget(
                            "(",
                            color: AppColors.red,
                            fontSize: 14.sp,
                            weight: FontWeight.bold,
                          ),
                          TurkishSymbol(
                            color: AppColors.red,
                            width: 15.w,
                            height: 15.h,
                          ),
                          TextWidget(
                            ")",
                            color: AppColors.red,
                            fontSize: 14.sp,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24.h,
            ),
            BoxShadowContainer(
              child: Column(
                children: [
                  KeyValueWidget(
                    title: "Greep%",
                    value: "15%",
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  KeyValueWidget(
                    title: "Total Trips",
                    value: "0",
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  KeyValueWidget(
                    title: "Total Exchange",
                    value: "",
                    widgetValue: MoneyWidget(
                      amount: 0,
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  KeyValueWidget(
                    title: "Total Balance",
                    value: "",
                    widgetValue: MoneyWidget(
                      amount: 0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            BoxShadowContainer(
              child: KeyValueWidget(
                title: "Available Balance",
                value: "",
                widgetValue: MoneyWidget(
                  amount: 0,
                  color: kGreenColor,
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SvgPicture.asset(
                  "assets/icons/info.svg",
                  width: 10.sp,
                  height: 10.sp,
                ),
                SizedBox(
                  width: 3.w,
                ),
                TextWidget(
                  "This is your current balance available for withdrawal",
                  fontSize: 10.sp,
                  fontStyle: FontStyle.italic,
                  color: AppColors.lightBlack,
                )
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            BoxShadowContainer(
              child: KeyValueWidget(
                title: "Greep's Balance",
                value: "",
                widgetValue: MoneyWidget(
                  amount: 0,
                  color: AppColors.red,
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SvgPicture.asset(
                  "assets/icons/info.svg",
                  width: 10.sp,
                  height: 10.sp,
                ),
                SizedBox(
                  width: 3.w,
                ),
                TextWidget(
                  "Greep’s weekly percentage fee that needs to be paid",
                  fontSize: 10.sp,
                  color: AppColors.lightBlack,
                  fontStyle: FontStyle.italic,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
