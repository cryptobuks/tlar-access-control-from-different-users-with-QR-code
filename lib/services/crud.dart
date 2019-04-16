import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {

  getData(String collectionName) async {
    return await Firestore.instance.collection(collectionName).snapshots();
  }

  searchByName(String collectionName, String searchField) async {
    return Firestore.instance
        .collection(collectionName)
        .where('description',
        isEqualTo: searchField)
        .getDocuments();
  }
}