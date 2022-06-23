import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

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
}
