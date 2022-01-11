import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
      String postID = const Uuid().v1();
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

  Future<void> likePost(String postID, String uid, List like) async {
    try {
      if (like.contains(uid)) {
        _firebaseFirestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firebaseFirestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      if (kDebugMode) {
        print(
          err.toString(),
        );
      }
    }
  }

  Future<void> postComment(
      {required String postID,
      required String text,
      required String uid,
      required String name,
      required String profilePic}) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();
        _firebaseFirestore
            .collection('posts')
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .set({
          'profImage': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentID': commentID,
          'datePublished': DateTime.now(),
        });
      }
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      FirebaseFirestore.instance.collection('posts').doc(postID).delete();
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }
}
