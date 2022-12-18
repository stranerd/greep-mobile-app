import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:greep/application/geocoder/geocoder_state.dart';
import 'package:greep/application/location/location.dart' as l;

class GeoCoderCubit extends Cubit<GeoCoderState> {
  GeoCoderCubit() : super(GeoCoderStateUninitialized());
  Map<l.Location, String> addresses = {};

  Future<String> fetchAddressFromLongAndLat(
      {required double longitude, required double latitude}) async {
    // print("Fetching address for $longitude $latitude");

    var location = l.Location(longitude: longitude, latitude: latitude);
    if (addresses.containsKey(location)) {
      emit(GeoCoderStateFetched(addresses[location]!));
      return addresses[location]??"";
    }
    emit(GeoCoderStateLoading());
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isEmpty) {
      emit(GeoCoderStateFetched(""));
      return "";
    }

    String address = "${placemarks[0].street}${placemarks[0].street!=null?",":""} ${placemarks[0].locality??""}${placemarks[0].locality!=null?",":""} ${placemarks[0].administrativeArea ??""}${placemarks[0].administrativeArea!=null?",":""} ${placemarks[0].country??""}";

    if (address.replaceAll(",", "").replaceAll(" ", "").isEmpty) {
      addresses.putIfAbsent(
        location,
        () => address,
      );
    }
    emit(GeoCoderStateFetched(address));
    return address;
  }

}
