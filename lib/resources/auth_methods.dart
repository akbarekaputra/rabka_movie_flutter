import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rabka_movie/resources/storage_methods.dart';
import 'package:rabka_movie/models/user.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnapshot(documentSnapshot);
  }

  // Sign Up User
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          file != null) {
        // Registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          photoUrl: photoUrl,
        );

        // Adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        return "success";
      } else {
        return "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
  }

  // Logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return "success";
      } else {
        return "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
