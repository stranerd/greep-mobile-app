part of 'conversion_rate_cubit.dart';


@immutable
abstract class ConversionRateState {}

class ConversionRateStateInitial extends ConversionRateState {}


class ConversionRateStateFetched extends ConversionRateState {

  final num rate;

  ConversionRateStateFetched({required this.rate});

  Map<String, dynamic> toMap() {
    return {
      'wallet': this.rate,
    };
  }


}

class ConversionRateStateLoading extends ConversionRateState {}

class ConversionRateStateError extends ConversionRateState {

  final String? errorMessage;
  final bool isConnectionTimeout;
  final bool isSocket;
  final int statusCode;

  ConversionRateStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false, required this.statusCode});

}
