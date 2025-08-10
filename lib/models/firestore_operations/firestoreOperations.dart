import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOperations {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? streamListener;
  Future<void> deleteCurrentAccount(String uid) async {
    final collectionRef = FirebaseFirestore.instance.collection('Users');
    final querySnapshot =
        await collectionRef.where("UID", isEqualTo: uid).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      final firstID = querySnapshot.docs.first.id;
      await collectionRef.doc(firstID).delete();
    }
  }

  Future<void> startTransaction(
      Function(Transaction t)? transactionCallback) async {
    await firestore.runTransaction((transaction) async {
      if (transactionCallback != null) {
        await transactionCallback(transaction);
      }
    });
  }

  Future<void> addDataToDatabase(
      String collectionPath, Map<String, dynamic> data,
      {String? documentPath,
      String? subCollectionPath,
      String? subCollectionDocPath,
      Function(String id)? onCompleteAdd}) async {
    final collectionRef =
        getCollectionReference(collectionPath, documentPath, subCollectionPath);
    await collectionRef.add(data).then((data) {
      if (onCompleteAdd != null) {
        onCompleteAdd(data.id);
      }
    });
  }

  Future<void> updateDatabaseValues(
      String collectionPath, String? documentPath, Map<String, dynamic> data,
      {String? subCollectionPath,
      String? subDocumentPath,
      Transaction? transaction}) async {
    final documentRef = getDocumentReference(
        collectionPath, documentPath, subCollectionPath, subDocumentPath);
    if (transaction != null) {
      transaction.set(documentRef, data, SetOptions(merge: true));
    } else {
      await documentRef.set(data, SetOptions(merge: true));
    }
  }

  Future<Map<String, dynamic>> retrieveDatabaseValues(
      String collectionPath, String? documentPath,
      {String? subCollectionPath,
      String? subDocumentPath,
      Transaction? transaction}) async {
    DocumentSnapshot snapshot;
    final documentRef = getDocumentReference(
        collectionPath, documentPath, subCollectionPath, subDocumentPath);
    if (transaction != null) {
      snapshot = await transaction.get(documentRef);
    } else {
      snapshot = await documentRef.get();
    }
    return snapshot.data() as Map<String, dynamic>;
  }

  Future<QuerySnapshot<Object?>> retrieveCollectionSnapshots(
      String collectionPath,
      {String? documentPath,
      String? subCollectionPath,
      String? where,
      dynamic equalTo,
      int limit = 1,
      String orderBy = '',
      bool sort = false}) async {
    final collectionReference =
        getCollectionReference(collectionPath, documentPath, subCollectionPath);

    if (where != null && equalTo != null) {
      if (sort && orderBy.isNotEmpty) {
        return collectionReference
            .where(where, isEqualTo: equalTo)
            .orderBy(orderBy, descending: false)
            .limit(limit)
            .get();
      } else {
        return collectionReference
            .where(where, isEqualTo: equalTo)
            .limit(limit)
            .get();
      }
    }
    return await collectionReference.get();
  }

  void deleteDatabaseValues(String collectionPath, String? documentPath,
      {String? subCollectionPath,
      String? subDocumentPath,
      Transaction? transaction}) async {
    final documentRef = getDocumentReference(
        collectionPath, documentPath, subCollectionPath, subDocumentPath);

    if (transaction != null) {
      transaction.delete(documentRef);
    } else {
      await documentRef.delete();
    }
  }

  Future<void> listenToDatabaseValues(
    String collectionPath, {
    String? documentPath,
    String? subCollectionPath,
    String? subDocumentPath,
    bool listenToCollection = false,
    Function(dynamic snapshot)? listener,
  }) async {
    if (!listenToCollection) {
      print('listening on Doc');
      final documentRef = getDocumentReference(
          collectionPath, documentPath, subCollectionPath, subDocumentPath);
      streamListener = documentRef.snapshots().listen((snapshot) {
        if (listener != null) {
          listener(snapshot);
        }
      });
    } else {
      print('listening on Collection');
      final collectionRef = getCollectionReference(
          collectionPath, documentPath, subCollectionPath);
      streamListener = collectionRef.snapshots().listen((snapshot) {
        if (listener != null) {
          listener(snapshot);
        }
      });
    }
  }

  void stopListener() {
    streamListener!.cancel();
  }

  DocumentReference getDocumentReference(
      String collectionPath, String? documentPath,
      [String? subCollectionPath, String? subDocumentPath]) {
    if (subCollectionPath != null && subDocumentPath != null) {
      return firestore
          .collection(collectionPath)
          .doc(documentPath)
          .collection(subCollectionPath)
          .doc(subDocumentPath);
    } else {
      return firestore.collection(collectionPath).doc(documentPath);
    }
  }

  CollectionReference getCollectionReference(
    String collectionPath, [
    String? documentPath,
    String? subCollectionPath,
  ]) {
    if (documentPath != null && subCollectionPath != null) {
      return firestore
          .collection(collectionPath)
          .doc(documentPath)
          .collection(subCollectionPath);
    } else {
      return firestore.collection(collectionPath);
    }
  }
}
