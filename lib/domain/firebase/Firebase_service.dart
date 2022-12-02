import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/domain/user/model/ride_status.dart';

class FirebaseApi {
  static Stream<QuerySnapshot<Map<String, dynamic>>> managerRequestsStream(
      String driverId) {
    var data = FirebaseFirestore.instance
        .collection('ManagerRequests')
        .where('driverId', isEqualTo: driverId);
    return data.snapshots();
  }

  static clearManagerRequests(String driverId) {
    print("clearing manager requests for $driverId");
    var documentReference = FirebaseFirestore.instance
        .collection('ManagerRequests')
        .where('driverId', isEqualTo: driverId);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("deleting manager request ");
        doc.reference.delete();
      });
    });
  }

  static Future sendManagerRequest({
    required String driverId,
      required String managerId, required String managerName, required String commission}
  ) async {
    final refMessages = FirebaseFirestore.instance.collection('ManagerRequests');

    await refMessages.doc().set({
      'driverId': driverId,
      'managerId': managerId,
      'managerName': managerName,
      'commission': commission,
      'createdAt': DateTime.now(),
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> managerAcceptsStream(
      String managerId) {
    var data = FirebaseFirestore.instance
        .collection('ManagerAccepts')
        .where('managerId', isEqualTo: managerId);
    return data.snapshots();
  }

  static clearManagerAccepts(String managerId) {
    print("clearing manager requests for $managerId");
    var documentReference = FirebaseFirestore.instance
        .collection('ManagerAccepts')
        .where('managerId', isEqualTo: managerId);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("deleting manager request ");
        doc.reference.delete();
      });
    });
  }

  static Future sendManagerAccept({
    required String managerId,
  }
      ) async {
    final refMessages = FirebaseFirestore.instance.collection('ManagerAccepts');

    await refMessages.doc().set({
      'managerId': managerId,
      'createdAt': DateTime.now(),
    });
  }


  static Future updateDriverLocation({
    required String driverId,
    required Location location,

  }
      ) async {
    final collection = FirebaseFirestore.instance.collection('DriverLocation');
    var future = collection.where("driverId", isEqualTo: driverId).get();
    future.then((value) async {
      if (value.docs.isEmpty) {
        await collection.doc().set({
          'driverId': driverId,
          'rideStatus': RideStatus.ended.name,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'updatedAt': DateTime.now(),
        });
      } else {
        value.docs.forEach((element) {
          element.reference.update({
            'latitude': location.latitude,
            'longitude': location.longitude,
            'updatedAt': DateTime.now(),
          });
        });
      }
    });
  }


}
