import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String dpi;
  String phonenumber;

  User({
    this.id,
    this.dpi,
    this.phonenumber,
  });

  //set datetime(Timestamp datetime)=> this.datetime = datetime;
  /// Mapping from Query Snapshot Firebase
  /// Getting data
  /// Matching data
  User.fromMap(Map<String, dynamic> data, String id)
      : this(
      id: id,
      dpi: data['dpi'],
      phonenumber: data['phonenumber'],
  );

  Map<String, dynamic> toMap(User userConvert)
  {

    var mapData = new Map();
    mapData["id"] = userConvert.id;
    mapData["dpi"] = userConvert.dpi;
    mapData["phonenumber"] = userConvert.phonenumber;
    return mapData;

  }
}
