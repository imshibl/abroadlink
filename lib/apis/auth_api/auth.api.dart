import 'package:abroadlink/models/current_user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authAPIServiceProvider = Provider<AuthAPIServices>(
  (ref) => AuthAPIServices(),
);

abstract class IAuthAPIServices {
  Future<UserCredential> signUp(
      String username, String email, String password, UserModel usermodel);

  Future<UserCredential> signIn(String email, String password);

  Future<bool> isUsernameAvailable(String username);

  Future<bool> isEmailIsAvailable(String email);

  Future<void> removeUserData(String userId);

  Future<void> deleteAccount();

  Future<void> signOut();
}

class AuthAPIServices implements IAuthAPIServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserCredential> signUp(String username, String email, String password,
      UserModel usermodel) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);

      //add new user data to firestore database
      UserModel user = UserModel(
          username: username,
          uid: _firebaseAuth.currentUser!.uid,
          email: email,
          fullname: usermodel.fullname,
          phoneNumber: usermodel.phoneNumber,
          abroadDestination: usermodel.abroadDestination,
          abroadDestinationCode: usermodel.abroadDestinationCode,
          homeCountry: usermodel.homeCountry,
          homeCountryCode: usermodel.homeCountryCode,
          travelPurpose: usermodel.travelPurpose,
          followers: usermodel.followers,
          following: usermodel.following,
          lat: usermodel.lat,
          long: usermodel.long,
          geopoint: usermodel.geopoint,
          createdAt: usermodel.createdAt);

      final db = FirebaseFirestore.instance;
      await db.collection("users").doc(_firebaseAuth.currentUser!.uid).set(
            user.toMap(),
          );
      await db.collection("usersData").add(
        {
          "username": username,
          "email": email,
          "uid": _firebaseAuth.currentUser!.uid,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Future.error('The account already exists for that email.');
      } else {
        return Future.error('Could not sign up with those credentials.');
      }
    } catch (e) {
      return Future.error('Something went wrong.Try again');
    }
  }

  @override
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return Future.error('Wrong password provided for that user.');
      } else {
        return Future.error('Could not sign in with those credentials.');
      }
    } catch (e) {
      return Future.error('Something went wrong.Try again');
    }
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usersData')
        .where('username', isEqualTo: username)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  @override
  Future<bool> isEmailIsAvailable(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('usersData')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  @override
  Future<void> removeUserData(String userId) async {
    final db = FirebaseFirestore.instance;

    QuerySnapshot usersData1 =
        await db.collection("usersData").where('uid', isEqualTo: userId).get();

    if (usersData1.docs.isNotEmpty) {
      // Get the document reference for the matched document
      DocumentReference userDocRef = usersData1.docs[0].reference;
      // Delete the document
      await userDocRef.delete();
    }

    CollectionReference usersData2 = db.collection("users");
    DocumentReference userDocRef = usersData2.doc(userId);
    await userDocRef.delete();
  }

  @override
  Future<void> deleteAccount() async {
    User? currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      await removeUserData(currentUser.uid);
      return await currentUser.delete();
      // Additional actions after successful account deletion
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
