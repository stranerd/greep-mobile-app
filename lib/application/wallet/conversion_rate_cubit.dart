import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/domain/wallet/wallet.dart';
import 'package:greep/domain/wallet/wallet_service.dart';

part 'conversion_rate_state.dart';

class ConversionRateCubit extends Cubit<ConversionRateState> {
  final UserCubit userCubit;
  late StreamSubscription streamSubscription;
  final WalletService walletService;

  num conversationRate = 0;

  ConversionRateCubit({
    required this.walletService,
    required this.userCubit,
  }) : super(ConversionRateStateInitial()) {
    streamSubscription = userCubit.stream.listen((event) {
      if (event is UserStateFetched) {
        getConversionRate();
      }
    });
  }

  void getConversionRate({
    bool softUpdate = false,
  }) async {
    if (!softUpdate) {
      emit(ConversionRateStateLoading());
    }
    var response = await walletService.getConversionRate();
    if (response.isError) {
      emit(ConversionRateStateError(
        response.errorMessage ?? "",
        statusCode: response.statusCode,
        isSocket: response.isSocket,
        isConnectionTimeout: response.isConnectionTimeout,
      ));
    } else {
      num rate = 1/response.data!;
      conversationRate = rate;
      print("conversion rate ${rate}");


      emit(ConversionRateStateFetched(rate: rate));
    }
  }
}
