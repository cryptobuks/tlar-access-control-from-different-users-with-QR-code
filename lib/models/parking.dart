import 'package:cloud_firestore/cloud_firestore.dart';

class Parking {
  final String id;
  final GeoPoint localization;
  final String name;

  const Parking({
    this.id,
    this.localization,
    this.name,
  });

  /// Mapping from Query Snapshot Firebase
  /// Getting data
  /// Matching data
  Parking.fromMap(Map<String, dynamic> data, String id)
      : this(
      id: id,
      localization: data['localization'],
      name: data['name'],
  );
}
