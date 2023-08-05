import 'package:abroadlink/models/user_model/current_user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider<UserServices>((ref) => UserServices());

abstract class ICurrentUserAPIServices {
  Future<UserModel?> getCurrentUserData();

  Future<void> updateUserName(String name);
}

class UserServices implements ICurrentUserAPIServices {
  // Function to get the current logged-in user's data
  @override
  Future<UserModel?> getCurrentUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      final DocumentSnapshot snapshot =
          await usersCollection.doc(user.uid).get();
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
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      return usersCollection.doc(user.uid).update({'fullname': name});
    }

    return Future.value(); // User data not found or user is not logged in
  }
}
