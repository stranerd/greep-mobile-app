import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/trip/trip.dart';
import 'package:greep/domain/user/model/manager_request.dart';
import 'package:greep/domain/user/model/manager_request.dart';

part 'transaction_trips_state.dart';

class TransactionTripsCubit extends Cubit<TransactionTripsState> {
  TransactionTripsCubit()
      : super(TransactionTripsStateInitial());

  StreamSubscription? _streamSubscription;

  void getTransactionTrips(String transactionId) {
    var statusStream = FirebaseApi.transactionTripStreams(transactionId);
    var status = statusStream.asyncMap((event) {
      var map = event.docs
        .map((e) => TransactionTrip.fromServer(e.data(), docId: e.id));
      if (map.isEmpty){
        return null;
      }
      return map
        .first;
    });
    _streamSubscription = status.listen((event) {
      if (event == null){
        emit(TransactionTripsStateUnAvailable());

      }
      else {
      emit(TransactionTripsStateAvailable(trip: event));
      }
    });
  }

  void makeUnavailable() {
    emit(TransactionTripsStateUnAvailable());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
