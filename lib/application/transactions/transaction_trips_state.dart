part of 'transaction_trips_cubit.dart';

abstract class TransactionTripsState {}

class TransactionTripsStateInitial extends TransactionTripsState {}

class TransactionTripsStateAvailable extends TransactionTripsState {
  final TransactionTrip trip;

  TransactionTripsStateAvailable({required this.trip});

  @override
  String toString() {
    return 'TransactionTripsStateAvailable{trip: $trip}';
  }


}

class TransactionTripsStateUnAvailable extends TransactionTripsState {}
