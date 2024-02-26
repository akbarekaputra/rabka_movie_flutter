import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LikeMethods {
  Future<int> getLikeMovie(int idMovie, String idVideo) async {
    try {
      // Construct the reference to the specific video document
      DocumentReference movieDocRef = FirebaseFirestore.instance
          .collection('movies')
          .doc(idMovie.toString())
          .collection('videos')
          .doc(idVideo);

      // Retrieve the document snapshot
      DocumentSnapshot snapshot = await movieDocRef.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Retrieve the current number of likes from the document data
        int currentLikes =
            (snapshot.data() as Map<String, dynamic>)['liked'] ?? 0;

        return currentLikes;
      } else {
        // Document not found, create the document
        await movieDocRef.set({'liked': 0});

        // Return the updated like count after creating the document
        return 0;
      }
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      if (kDebugMode) {
        print("Error: $e");
      }
      return 0; // Return 0 likes if an error occurs
    }
  }

  Future<int> postLikeMovie(
      int idMovie, String idVideo, int currentLike) async {
    try {
      // Construct the reference to the specific video document
      DocumentReference movieDocRef = FirebaseFirestore.instance
          .collection('movies')
          .doc(idMovie.toString())
          .collection('videos')
          .doc(idVideo);

      // Retrieve the document snapshot to check if the document exists
      DocumentSnapshot snapshot = await movieDocRef.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Update the like count in the Firestore document
        await movieDocRef.update({'liked': currentLike + 1});

        // Fetch and return the updated like count after posting like
        return getLikeMovie(idMovie, idVideo);
      } else {
        // Document not found, create the document
        await movieDocRef.set({'liked': currentLike + 1});

        // Return the updated like count after creating the document
        return getLikeMovie(idMovie, idVideo);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error posting like: $e');
      }
      // Return the current like count if an error occurs
      return currentLike;
    }
  }
}
