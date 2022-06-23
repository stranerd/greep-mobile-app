import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  static Stream<QuerySnapshot<Map<String, dynamic>>> managerRequestsStream(
      String userId) {
    var data = FirebaseFirestore.instance
        .collection('ManagerRequests')
        .where('userid', isEqualTo: userId);
    return data.snapshots();
  }

  static clearManagerRequests(String userId) {
    print("clearing check chat for $userId");
    var documentReference = FirebaseFirestore.instance
        .collection('ManagerRequests')
        .where('userid', isEqualTo: userId);

    documentReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("deleting chat check ");
        doc.reference.delete();
      });
    });
  }

  static Future uploadCheckChat(
    String id,
  ) async {
    final refMessages = FirebaseFirestore.instance.collection('ManagerRequests');

    await refMessages.doc().set({
      'userid': id,
      'createdAt': DateTime.now(),
    });
  }
}
