import 'package:abroadlink/models/current_user.model.dart';
import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userAPIServiceProvider = Provider<UserAPIServices>((ref) =>
    UserAPIServices(
        firebaseCollections: ref.watch(firebaseCollectionProvider)));

abstract class ICurrentUserAPIServices {
  Future<UserModel?> getCurrentUserData();

  Future<void> updateUserName(String name);

  Stream<DocumentSnapshot> updateUserCounts();
}

class UserAPIServices implements ICurrentUserAPIServices {
  FirebaseCollections firebaseCollections;
  UserAPIServices({
    required this.firebaseCollections,
  });
  // Function to get the current logged-in user's data
  @override
  Future<UserModel?> getCurrentUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      final DocumentSnapshot snapshot =
          await firebaseCollections.usersCollection.doc(user.uid).get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    }

    return null; // User data not found or user is not logged in
  }

  @override
  Future<void> updateUserName(String name) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      return firebaseCollections.usersCollection
          .doc(user.uid)
          .update({'fullname': name});
    }

    return Future.value(); // User data not found or user is not logged in
  }

  @override
  Stream<DocumentSnapshot> updateUserCounts() {
    final firestore = FirebaseFirestore.instance;
    final userDataStream = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return userDataStream;
  }
}
