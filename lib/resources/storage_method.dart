import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Upload image to firebase Storage
  Future<String> uploadImagetoStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    if (kDebugMode) {
      print(downloadURL);
    }
    return downloadURL;
  }
}
