import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/domain/user/model/auth_user.dart' as u;
import 'package:greep/domain/user/model/ride_status.dart';

class FirebaseApi {
  static Future<bool> saveDeviceToken({
    required String deviceToken,
    required String customerId,
  }) async {
    final CollectionReference _userDeviceTokensCollection =
    FirebaseFirestore.instance.collection('UserDeviceTokens');
    print("Saving device Token ");
    try {
      // Check if the customerId already exists in the collection
      final existingDoc =
      await _userDeviceTokensCollection.doc(customerId).get();

      if (existingDoc.exists) {
        // Update the existing document with the new device token
        await _userDeviceTokensCollection.doc(customerId).update({
          'deviceToken': deviceToken,
        });
      } else {
        // Create a new document if the customerId doesn't exist
        await _userDeviceTokensCollection.doc(customerId).set({
          'deviceToken': deviceToken,
        });
      }
      print("Saved Device Token");
      return true;
    } catch (e) {
      print('Error mapping device token to customer ID: $e');
      print("Saved Device Token Failed");

      return false;
      // Handle error as needed
    }
  }
  static Future<String?> fetchUserDeviceToken(String customerId) async {
    print("Fetching user device token ${customerId}");
    final CollectionReference _userDeviceTokensCollection =
    FirebaseFirestore.instance.collection('UserDeviceTokens');
    try {
      // Retrieve the document by customerId
      final doc = await _userDeviceTokensCollection.doc(customerId).get();

      if (doc.exists) {
        // Return the device token if the document exists
        return doc['deviceToken'];
      } else {
        // Return null if the document doesn't exist
        return null;
      }
    } catch (e) {
      print('Error fetching device token by customer ID: $e');
      // Handle error as needed
      return null;
    }
  }

  static void signInWithFirebase() async {
    print("Signing in with Firebase");
    FirebaseAuth auth = FirebaseAuth.instance;
    var deviceToken = await FirebaseMessaging.instance.getToken();

    if (auth.currentUser == null) {
      u.AuthUser user = getAuthUser();

      var customerID = user.id;
      print("device Token: $deviceToken , customerId: $customerID");
      try {
        await auth.createUserWithEmailAndPassword(
            email: user.email, password: user.id);
        await auth.signInWithEmailAndPassword(
            email: user.email, password: user.id);
        if (deviceToken != null && customerID.isNotEmpty) {
          await saveDeviceToken(
              deviceToken: deviceToken, customerId: customerID);
          print("Set device token on login");
        }

        print("Successfully signed into Firebase with new account");
      } catch (e) {
        try {
          var userCredential = await auth.signInWithEmailAndPassword(
              email: user.email, password: user.id);
          if (deviceToken != null && customerID.isNotEmpty) {
            await saveDeviceToken(
                deviceToken: deviceToken, customerId: customerID);
            print("Set device token on login");
          }
          print("Successfully signed into Firebase with existing");
        } catch (e) {
          print("Firebase auth error ${e.toString()}");
        }
      }
    }
    else {
      print("Firebase already signed in ");
      var customerId2 = getUser().id;
      if (deviceToken != null && customerId2.isNotEmpty) {
        await saveDeviceToken(
            deviceToken: deviceToken, customerId: customerId2);
        print("Set device token on login");
      }

    }
  }

  static Future<bool> signOutFirebase({required String customerId}) async {
    print("Trying to sign out of firebase");
    try {
      if (customerId.isNotEmpty) {
        await saveDeviceToken(deviceToken: "", customerId: customerId);
        print("Remove device token on logout");
      }
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.signOut();
      print("Signed out with Firebase");
      return true;
    } catch (e) {
      print("Sign out with Firebase error ${e.toString()}");
      return false;
    }
  }

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

  static Future sendManagerRequest(
      {required String driverId,
      required String managerId,
      required String managerName,
      required String commission}) async {
    final refMessages =
        FirebaseFirestore.instance.collection('ManagerRequests');

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
  }) async {
    final refMessages = FirebaseFirestore.instance.collection('ManagerAccepts');

    await refMessages.doc().set({
      'managerId': managerId,
      'createdAt': DateTime.now(),
    });
  }

  static Future updateDriverLocation(
      {required String driverId,
      required Location location,
      RideStatus rideStatus = RideStatus.ended,
      Map<String, DirectionProgress?> directions = const {},
  bool softUpdate = false}
  ) async {
    final collection = FirebaseFirestore.instance.collection('DriverLocation');
    var future = collection.where("driverId", isEqualTo: driverId).get();
    future.then((value) async {
      if (value.docs.isEmpty) {
        await collection.doc().set({
          'driverId': driverId,
          'rideStatus': rideStatus.name,
          'latitude': location.latitude.toString(),
          'longitude': location.longitude.toString(),
          'address': location.address.toString(),
          'updatedAt': DateTime.now(),
          'directions': directions.map(
            (key, value) => MapEntry(
              key,
              value?.toMap(),
            ),
          )
        });
      } else {
        value.docs.forEach((element) {
          Map<String, dynamic> fullUpdate = {};
          if (!softUpdate){
            fullUpdate = {
              'rideStatus': rideStatus.name,
              'directions': directions.map(
                    (key, value) => MapEntry(
                  key,
                  value?.toMap(),
                ),
              )
            };
          }
          element.reference.update({
            'latitude': location.latitude.toString(),
            'longitude': location.longitude.toString(),
            'updatedAt': DateTime.now(),
            'address': location.address.toString(),
            ...fullUpdate
          });
        });
      }
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getDriverLocation(
      String userId) {
    var data = FirebaseFirestore.instance
        .collection('DriverLocation')
        .where('driverId', isEqualTo: userId);
    return data.snapshots();
  }

  static void addTransactionTrip({required Map<String, Map> trip, required String transactionId})async  {
    final refMessages =
    FirebaseFirestore.instance.collection('TransactionTrips');

    await refMessages.doc().set({
      'transactionId': transactionId,
      'trip': trip,
      'createdAt': DateTime.now(),
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> transactionTripStreams(
      String transactionId) {
    var data = FirebaseFirestore.instance
        .collection('TransactionTrips')
        .where('transactionId', isEqualTo: transactionId);
    return data.snapshots();
  }
}
