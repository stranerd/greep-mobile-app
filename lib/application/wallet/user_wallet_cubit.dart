import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/domain/wallet/wallet.dart';
import 'package:greep/domain/wallet/wallet_service.dart';

part 'user_wallet_state.dart';

class UserWalletCubit extends Cubit<UserWalletState> {
  final UserCubit userCubit;
  late StreamSubscription streamSubscription;
  final WalletService walletService;

  UserWalletCubit({
    required this.walletService,
    required this.userCubit,
  }) : super(UserWalletStateInitial()) {
    streamSubscription = userCubit.stream.listen((event) {
      if (event is UserStateFetched) {
        fetchUserWallet();
      }
    });
  }

  void fetchUserWallet({
    bool softUpdate = false,
  }) async {
    if (!softUpdate) {
      emit(UserWalletStateLoading());
    }

    var response = await walletService.getUserWallet(
    );
    if (response.isError) {
      emit(UserWalletStateError(
        response.errorMessage ?? "",
        isSocket: response.isSocket,
        isConnectionTimeout: response.isConnectionTimeout,
      ));
    }
    else {
      emit(UserWalletStateFetched(wallet: response.data!));
    }
  }
}
