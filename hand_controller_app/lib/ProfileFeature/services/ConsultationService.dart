import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/MedicalHistory.dart';

class ConsultationService {

  Future<List<Consultation>> getConsultations(String patientId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .doc(patientId)
          .collection('consultations')
          .get();

      return querySnapshot.docs
          .map(
              (doc) => Consultation.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error getting consultations: $e");
      return [];
    }
  }

  Future<void> addConsultation(Consultation consultation) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentReference docRef = await firestore
          .collection('users')
          .doc(consultation.patientId)
          .collection('consultations')
          .add(consultation.toMap());

      updateConsultationField(consultation.patientId, docRef.id, 'consultationId', docRef.id);
    } catch (e) {
      print("Error adding rating: $e");
    }
  }

  Future<void> updateConsultationField(String patientId, String consultationId, String field, String value) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(patientId)
          .collection('consultations')
          .doc(consultationId)
          .update({field: value});
    } catch (e) {
      print("Error updating rating: $e");
    }
  }
}