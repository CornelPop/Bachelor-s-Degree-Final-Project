import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Rating.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Rating>> getRatings(String doctorId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .doc(doctorId)
          .collection('ratings')
          .get();

      return querySnapshot.docs
          .map((doc) => Rating.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error getting consultations: $e");
      return [];
    }
  }

  Future<void> addRating(String doctorId, Rating rating) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentReference docRef = await firestore
          .collection('users')
          .doc(doctorId)
          .collection('ratings')
          .add(rating.toMap());

      updateRatingField(doctorId, docRef.id, 'ratingId', docRef.id);
    } catch (e) {
      print("Error adding rating: $e");
    }
  }

  Future<void> deleteRating(String doctorId, String ratingId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(doctorId)
          .collection('ratings')
          .doc(ratingId)
          .delete();

      print("Rating with ID: $ratingId deleted successfully.");
    } catch (e) {
      print("Error deleting rating: $e");
    }
  }

  Future<void> updateRatingField(String doctorId, String ratingId, String field, String value) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(doctorId)
          .collection('ratings')
          .doc(ratingId)
          .update({field: value});
      print("Updated ratingId field successfully.");
    } catch (e) {
      print("Error updating rating: $e");
    }
  }

}