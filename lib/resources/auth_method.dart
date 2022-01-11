import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instergram_flutter/resources/storage_method.dart';
import 'package:instergram_flutter/models/user.dart' as model;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    late DocumentSnapshot snap;
    snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //signUp User
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (kDebugMode) {
          print(cred.user!.uid);
        }
        String photoURL = await StorageMethod()
            .uploadImagetoStorage("profilePic", file, false);
        //usermodel
        model.User user = model.User(
            username: username,
            email: email,
            bio: bio,
            photoURL: photoURL,
            followers: [],
            following: [],
            uid: cred.user!.uid);
        //add user to database
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //user Login
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some Error Occur";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = "Please Enter All The Field";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
