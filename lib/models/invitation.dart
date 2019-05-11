import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Guest
{


  final String dpi;
  final String phonenumber;

  Guest({
    this.dpi,
    this.phonenumber,
  });
  /// Mapping from Query Snapshot Firebase
  /// Getting data
  /// Matching data
  Guest.fromMap(Map<String, dynamic> data)
      : this(
      dpi: data['dpi'],
      phonenumber : data['phonenumber']
  );

  Map<String, dynamic> toMap()
  {

    var mapData = new Map();
    mapData["dpi"] = this.dpi;
    mapData["phonenumber"] = this.phonenumber;
    return mapData;

  }

}



class Invitation {
  final String id;
  String date;
  String time;
  String parking;
  String usercreator;
  String description;
  String status;
  Guest guest;


  Invitation({
    this.id,
    this.date,
    this.time,
    this.parking,
    this.usercreator,
    this.description,
    this.status,
    this.guest
  });

  //set datetime(Timestamp datetime)=> this.datetime = datetime;
  /// Mapping from Query Snapshot Firebase
  /// Getting data
  /// Matching data
  Invitation.fromMap(Map<String, dynamic> data, String id)
      : this(
    id: id,
    date: data['date'] ,
    time: data['time'],
    parking: data['parking'],
    usercreator: data['usercreator'],
    description: data['description'],
    status: data['status'],
    guest: Guest.fromMap(Map<String, dynamic>.from(data['guest']))

  );

  Map<String, dynamic> toMap(Invitation invitationConvert)
  {

    var mapData = new Map();
    mapData["date"] = invitationConvert.date  ;
    mapData["usercreator"] = invitationConvert.usercreator;
    mapData["email"] = invitationConvert.description;
    return mapData;

  }


}
