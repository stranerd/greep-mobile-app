import 'package:greep/application/location/location.dart';

class WalletWithdrawRequest {
  final String pin;
  final num amount;
  final Location location;

  WalletWithdrawRequest({ required this.location,required this.pin, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'pin': "\"$pin\"",
      'amount': this.amount,
      'location': {
        'location': location.address,
        'coords': [location.latitude,location.longitude],
        'description': location.address
      }
    };
  }

  factory WalletWithdrawRequest.fromMap(Map<String, dynamic> map) {
    return WalletWithdrawRequest(
      pin: map['pin'] as String,
      amount: map['amount'] as num,
      location: map[''],
    );
  }

  @override
  String toString() {
    return 'WalletWithdrawRequest{pin: $pin, amount: $amount}';
  }
}
