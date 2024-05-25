

import 'package:equatable/equatable.dart';
import 'package:greep/application/location/location.dart';

class PlaceSearchModel extends Equatable{
  final Location location;
  final String name;

  PlaceSearchModel({required this.location, required this.name});

  factory PlaceSearchModel.fromMap(Map<String, dynamic> map) {
    return new PlaceSearchModel(
      location: map['location'] as Location,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': this.location,
      'name': this.name,
    } as Map<String, dynamic>;
  }

  Map<String,dynamic> toServer() {

    return {
      "coords": [location.latitude, location.longitude,],
      "location": name,
      "description": "no description"
    };
  }

  @override
  String toString() {
    return 'PlaceSearchModel{location: $location, name: $name}';
  }

  factory PlaceSearchModel.fromServer(dynamic data) {
    return PlaceSearchModel(
        location: Location(
          address: data["formatted_address"],
          latitude: data["geometry"]["location"]["lat"],
          longitude: data["geometry"]["location"]["lng"],
        ),
        name: data["name"]);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [location];
}
