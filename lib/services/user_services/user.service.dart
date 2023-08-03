import 'package:abroadlink/models/user_model/current_user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider<UserServices>((ref) => UserServices());

class UserServices {
  // Function to get the current logged-in user's data
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
}
