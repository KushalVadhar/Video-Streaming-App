import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_streaming_app/model/live_stream.dart';
import 'package:video_streaming_app/providers/storage_methods.dart';
import 'package:video_streaming_app/providers/user_provider.dart';
import 'package:video_streaming_app/utils/utils.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storageMethods = StorageMethods();

  Future<String> startLiveStream(
      BuildContext context, String title, Uint8List? image) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String channelId = "${user.user.uid}${user.user.username}";
    try {
      if (title.isNotEmpty && image != null) {
        if (!((await _firestore.collection('livestream').doc(channelId).get())
            .exists)) {
          String thumbnailUrl = await _storageMethods.uploadImageToStorage(
            'livestream-thumbnails',
            image,
            user.user.uid,
          );
          channelId = '${user.user.uid}${user.user.username}';

          LiveStream liveStream = LiveStream(
            title: title,
            image: thumbnailUrl,
            uid: user.user.uid,
            username: user.user.username,
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          );

          _firestore
              .collection('livestream')
              .doc(channelId)
              .set(liveStream.toMap());
        } else {
          showSnackBar(
              context, 'Two Livestreams cannot start at the same time.');
        }
      } else {
        showSnackBar(context, 'Please enter all the fields');
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
    return channelId;
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore
          .collection('livestream')
          .doc(id)
          .update({'viewers': FieldValue.increment(isIncrease ? 1 : -1)});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> endLiveStream(String channelId) async {
  try {
    QuerySnapshot snap = await _firestore
        .collection('livestream')  
        .doc(channelId)
        .collection('comments')
        .get();

    for (int i = 0; i < snap.docs.length; i++) {
      await _firestore
          .collection('livestream')
          .doc(channelId)
          .collection('comments')
          .doc((snap.docs[i].data() as Map<String, dynamic>)['commentId'])
          .delete();
    }

    
    await _firestore.collection('livestream').doc(channelId).delete();
  } catch (e) {
    debugPrint(e.toString());
  }
}

  Future<void> chat(String text, String id, BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);

    try {
      String commentId = Uuid().v1();
      await _firestore
          .collection('livestream')
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set({
        'username': user.user.username,
        'text': text,
        'uid': user.user.uid,
        'createdAt': DateTime.now(),
        'commentId': commentId,
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
