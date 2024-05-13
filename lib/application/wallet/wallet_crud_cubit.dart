import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/wallet/request/fund_wallet_request.dart';
import 'package:greep/application/wallet/request/transfer_money_request.dart';
import 'package:greep/application/wallet/request/wallet_withdraw_request.dart';
import 'package:greep/application/wallet/user_wallet_cubit.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/domain/transaction/wallet_transaction.dart';
import 'package:greep/domain/wallet/wallet_service.dart';
import 'package:greep/ioc.dart';

part 'wallet_crud_state.dart';

class WalletCrudCubit extends Cubit<WalletCrudState> {

  final WalletService walletService;
  WalletCrudCubit({required this.walletService,}) : super(WalletCrudStateInitial());


  void withdrawWallet(WalletWithdrawRequest request) async {
    emit(WalletCrudStateLoading());
    var response = await walletService.withdrawWallet(request);
    if (response.isError){
      emit(WalletCrudStateError(response.errorMessage ?? ""));
    }
    else {
      emit(WalletCrudStateWithdrawSuccess(transaction: response.data!,),);
    }


    getIt<UserWalletCubit>().fetchUserWallet(softUpdate: true);
    getIt<UserCubit>().fetchUser(softUpdate: true,);
  }



  void fullfillTransaction(String transactionId) async {
    print("Completing transaction ${transactionId}");
    emit(WalletCrudStateLoading());
    var response = await walletService.fulfillTransaction(transactionId);
    if (response.isError){
      emit(WalletCrudStateError(response.errorMessage ?? ""));
    }
    else {
      emit(WalletCrudStateSuccess());
    }


    getIt<UserWalletCubit>().fetchUserWallet(softUpdate: true);
    getIt<UserCubit>().fetchUser(softUpdate: true,);

  }
}
