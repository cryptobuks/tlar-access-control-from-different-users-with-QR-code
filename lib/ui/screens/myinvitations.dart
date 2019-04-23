import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/ui/screens/notifications_screen.dart';
import 'package:tlar/ui/screens/parking_detail.dart';
import 'package:tlar/widgets/invitation_card.dart';
import 'package:tlar/widgets/no_items_screen.dart';

class MyInvitationsView extends StatefulWidget {


  final StateModel stateSession;
  MyInvitationsView(@required this.stateSession);

  _MyInvitationsViewState createState() => _MyInvitationsViewState();

}

class _MyInvitationsViewState extends State<MyInvitationsView>{

  InputType inputType = InputType.date;
  bool editable = true;
  DateTime date = DateTime.now();
  Stream<QuerySnapshot> stream;
  String todayDate = formatDate(DateTime.now(), [dd, '-', MM, '-', yyyy]);
  DateTime _date;
  String _dateFormat;

  var _formatter = new DateFormat('dd-MM-yyyy');

  Future<Null> _selectDate(BuildContext context) async {

    print ("Okey");
    DateTime initialDate;

    if (widget.stateSession.filterActualDate == null)
      {
        initialDate = DateTime.now();
      }
    else
      {
        initialDate = widget.stateSession.filterActualDate;
      }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020));

    if (picked != null && picked != _date){

      setState(() {
        _date = picked;
        _dateFormat = _formatter.format(_date);

        //Saving temp date filter
        widget.stateSession.filterDate_MyInvitations = _dateFormat;
        widget.stateSession.filterActualDate = picked;

        CollectionReference collectionReference =
        Firestore.instance.collection('invitations');
        stream = collectionReference.
        where("guest.phonenumber", isEqualTo: widget.stateSession.userSession.phonenumber)
        .where("date", isEqualTo: widget.stateSession.filterDate_MyInvitations )
            .snapshots();

      });

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dateFormat = _formatter.format(DateTime.now());
    _date = widget.stateSession.filterActualDate;

    CollectionReference collectionReference =
    Firestore.instance.collection('invitations');
    stream = collectionReference.
    where("guest.phonenumber", isEqualTo: widget.stateSession.userSession.phonenumber)
    .where("date", isEqualTo: widget.stateSession.filterDate_MyInvitations )
        .snapshots();


  }

  @override
  Widget build(BuildContext context) {

    // Define query depeneding on passed args
    return Scaffold(

      body: Padding(
        // Padding before and after the list view:
        padding: const EdgeInsets.symmetric(vertical: 44.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: double.infinity,
                ),

                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15.0),
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {},
                        iconSize: 30.0,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 120.0),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationsView()));

                        },
                        iconSize: 30.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                )
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: buttonCustom(
                  color: Color(0xFF4458be),
                  txt: "Filtrar",
                  ontap: () {
                    _selectDate(context);
                  },
                ),
              ),
            ),

            Expanded(
              child: new StreamBuilder(
                stream: stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return _buildLoadingIndicator();
                  if (snapshot.data.documents.length>0)
                  {
                    return new ListView(
                      children: snapshot.data.documents
                      // Check if the argument ids contains document ID if ids has been passed:
                      //.where((d) => ids == null || ids.contains(d.documentID))
                          .map((document) {
                        return new InvitationCard(
                          invitation:
                          Invitation.fromMap(document.data, document.documentID),
                          //inFavorites:
                          //appState.favorites.contains(document.documentID),
                          //onFavoriteButtonPressed: _handleFavoritesListChanged,
                        );
                      }).toList(),
                    );
                  }
                  else
                  {
                    return NoItems("No hay invitaciones para el $_dateFormat", "assets/img/noInvitation.png");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );


  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }
}






