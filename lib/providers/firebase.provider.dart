import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseCollectionProvider =
    Provider<FirebaseCollections>((ref) => FirebaseCollections());

class FirebaseCollections {
  //collection reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference usersDataCollection =
      FirebaseFirestore.instance.collection('usersData');
}

// final authStateProvider = FutureProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges().first;
// });

final authStateStreamProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());
