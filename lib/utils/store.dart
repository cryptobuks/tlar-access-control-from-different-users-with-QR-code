import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tlar/models/invitation.dart';
List<String> getFavoritesIDs() {
  return [
    '0',
    '2',
    '3',
  ];
}



/// Saving new devicetoken
/// [uid] user identification
/// [devtoken] it is a identifier of the device.
Future<bool> updateDevToken(String uid, String devtoken) {
  DocumentReference userReference =
  Firestore.instance.collection('users').document(uid);

  return Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(userReference);
    if (postSnapshot.exists) {
      // Extend 'favorites' if the list does not contain the property ID:
      await tx.update(userReference, <String, dynamic>{
        'devtoken': devtoken});


    } else {
      // Create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document:
      await tx.set(userReference, {
        'devtoken': devtoken
      });
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('---------Error here...: $error');
    return false;
  });
}

Future<bool> newInvitationStore(Invitation invitation) {
  return Firestore.instance
      .collection('invitations')
      .add({
    "description": invitation.description,
    "usercreator": invitation.usercreator,
    "date" : invitation.date.toString(),
    "parking" : invitation.parking,
    "status" : "iniciada",
    //"datetime": invitation.datetime,
    "guest" : {
      "dpi" : invitation.guest.dpi,
      "phonenumber" : invitation.guest.phonenumber
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('---------Error here...: $error');
    return false;
  });
}