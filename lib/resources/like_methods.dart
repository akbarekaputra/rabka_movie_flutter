import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LikeMethods {
  Future<int> getLikeMovie(int idMovie) async {
    try {
      DocumentReference movieDocRef = FirebaseFirestore.instance
          .collection('movies')
          .doc(idMovie.toString());

      DocumentSnapshot snapshot = await movieDocRef.get();

      if (snapshot.exists) {
        int currentLikes =
            (snapshot.data() as Map<String, dynamic>)['like'] ?? 0;

        return currentLikes;
      } else {
        if (kDebugMode) {
          print('Dokumen tidak ditemukan!');
        }
        return 0;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      return 0;
    }
  }

  Future<int> updateLikeMovie(int idMovie, int likeMovie) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      DocumentReference movieRef =
          _firestore.collection("movies").doc(idMovie.toString());

      DocumentSnapshot snapshot = await movieRef.get();

      if (snapshot.exists) {
        await movieRef.set({'like': likeMovie + 1});
      } else {
        await movieRef.set({'like': 1});
      }
      return await getLikeMovie(idMovie);
    } catch (e) {
      print('Terjadi kesalahan saat menyimpan data like: $e');
      return 0; // Atau nilai default jika terjadi kesalahan
    }
  }
}
