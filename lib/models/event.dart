class Event {
  final String id;
  String date;
  String time;
  String invitation;
  String title;
  String message;

  Event({
    this.id,
    this.date,
    this.time,
    this.invitation,
    this.title,
    this.message
  });

  //set datetime(Timestamp datetime)=> this.datetime = datetime;
  /// Mapping from Query Snapshot Firebase
  /// Getting data
  /// Matching data
  Event.fromMap(Map<String, dynamic> data, String id)
      : this(
      id: id,
      date: data['date'] ,
      time: data['time'],
      invitation: data['invitation'],
      title: data['title'],
      message: data['message'],

  );

}