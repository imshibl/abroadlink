import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseProvider =
    Provider<FirebaseServices>((ref) => FirebaseServices());

class FirebaseServices {
  //collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference usersDataCollection =
      FirebaseFirestore.instance.collection('usersData');
}
