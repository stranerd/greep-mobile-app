part of 'customer_statistics_cubit.dart';

@immutable
abstract class CustomerStatisticsState {}

class CustomerStatisticsInitial extends CustomerStatisticsState {}

class CustomerStatisticsStateDone extends CustomerStatisticsState {}

class CustomerStatisticsStateLoading extends CustomerStatisticsState {}
