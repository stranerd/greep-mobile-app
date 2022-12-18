import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double longitude;
  final String? address;
  final double latitude;

  Location({
    required this.longitude,
    this.address,
    required this.latitude,
  });

  factory Location.Zero() {
    return Location(longitude: 0, latitude: 0);
  }

  factory Location.fromServer(dynamic data) {
    return Location(
      longitude: double.parse(data["longitude"]),
      latitude: double.parse(data["latitude"]),
      address: data["address"] ?? ""
    );
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      longitude: map['longitude'] as double,
      latitude: map['latitude'] as double,
        address: map["address"] ?? ""

    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return 'Location{longitude: $longitude, address: ${address??""}, latitude: $latitude}';
  }

  @override

  List<Object?> get props => [longitude, latitude];
}

extension LocationToLatLgn on Location {
  String toDirectionsLatLng() {
    return '${latitude},${longitude}';
  }
}
