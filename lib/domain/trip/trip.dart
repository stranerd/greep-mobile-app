import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';

class TransactionTrip {
  final String id;
  final DirectionProgress? gotDirection;
  final DirectionProgress? startDirection;
  final DirectionProgress? endDirection;

  TransactionTrip({required this.id, this.gotDirection, this.startDirection, this.endDirection});

  factory TransactionTrip.fromServer(Map<String,dynamic> data, {required String docId}) {
    return TransactionTrip(
      id: docId,

      gotDirection: data["trip"] == null
          ? null : data["trip"]["got"] == null ?  null
          : DirectionProgress.fromMap(data["trip"]["got"]),
      startDirection: data["trip"] == null
          ? null : data["trip"]["start"] == null ?  null
          : DirectionProgress.fromMap(data["trip"]["start"]),
      endDirection: data["trip"] == null
          ? null : data["trip"]["end"] == null ?  null
          : DirectionProgress.fromMap(data["trip"]["end"]),
    );
  }

  @override
  String toString() {
    return 'TransactionTrip{id: $id, gotDirection: $gotDirection, startDirection: $startDirection, endDirection: $endDirection}';
  }
}
