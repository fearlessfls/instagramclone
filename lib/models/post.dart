import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final String postID;
  final dynamic datePublish;
  final String postURL;
  final String profImage;
  final dynamic likes;
  Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.postID,
    required this.datePublish,
    required this.postURL,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "uid": uid,
        "username": username,
        "postID": postID,
        "datePublish": datePublish,
        "postURL": postURL,
        "profImage": profImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);

    return Post(
      caption: snapshot['caption'],
      uid: snapshot['uid'],
      username: snapshot['photoURL'],
      postID: snapshot['username'],
      datePublish: snapshot['bio'],
      postURL: snapshot['followers'],
      profImage: snapshot['following'],
      likes: snapshot['likes'],
    );
  }
}
