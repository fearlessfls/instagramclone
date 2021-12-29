import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instergram_flutter/models/post.dart';
import 'package:instergram_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //Upload Post
  Future<String> uploadPost(String caption, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some Error Occur";
    try {
      String photoUrl =
          await StorageMethod().uploadImagetoStorage('posts', file, true);
      String postID = Uuid().v1();
      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        postID: postID,
        datePublish: DateTime.now(),
        postURL: photoUrl,
        profImage: profImage,
        likes: [],
      );
      _firebaseFirestore.collection('posts').doc(postID).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
