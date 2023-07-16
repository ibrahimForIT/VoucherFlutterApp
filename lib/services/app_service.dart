import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/labels.dart';

abstract class AppModel {
  Map<String, dynamic> toMap();
}

class AppService {
  final FirebaseFirestore _firestore;
  AppService(this._firestore);

  Future<void> addDocument(
      String userId, String collectionName, AppModel serviceType) async {
    try {
      // print('Attempting to add document to Firestore...');
      // print('Collection name: $collectionName');
      // print('User ID: $userId');
      // print('Voucher data: ${serviceType.toMap()}');
      await _firestore
          .collection(Labels.users)
          .doc(userId)
          .collection(collectionName)
          .add(serviceType.toMap());
      // print('Voucher successfully added to Firestore!');
    } catch (e) {
      // print('Failed to add voucher: $e');
    }
  }

  //delete voucher
  Future<void> deleteDocument(
      String userId, String collectionName, String documentId) async {
    try {
      // print('Attempting to delete document from Firestore...');
      // print('Collection name: $collectionName');
      // print('Document ID: $documentId');
      await _firestore
          .collection(Labels.users)
          .doc(userId)
          .collection(collectionName)
          .doc(documentId)
          .delete();
      // print('Document successfully deleted from Firestore!');
    } catch (e) {
      // print('Failed to delete document: $e');
    }
  }

  //update voucher
  Future<void> updateDocument(String userId, String collectionName,
      String documentId, AppModel serviceType) async {
    try {
      // print('Attempting to update document in Firestore...');
      // print('Collection name: $collectionName');
      // print('Document ID: $documentId');
      // print('Document data: ${serviceType.toMap()}');
      await _firestore
          .collection(Labels.users)
          .doc(userId)
          .collection(collectionName)
          .doc(documentId)
          .update(serviceType.toMap());
      // print('Document successfully updated in Firestore!');
    } catch (e) {
      // print('Failed to update voucher: $e');
    }
  }

  void updatebank(String userId, String collectionName, String documentId,
      bool? bankValueUpdate) async {
    await _firestore
        .collection(Labels.users)
        .doc(userId)
        .collection(collectionName)
        .doc(documentId)
        .update({'isBank': bankValueUpdate});
  }
}
