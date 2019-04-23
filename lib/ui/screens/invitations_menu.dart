import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/services/crud.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/widgets/invitation_card.dart';
import 'package:tlar/widgets/no_items_screen.dart';
import 'package:tlar/widgets/radiobutton_item.dart';

class InvitationsView extends StatefulWidget {

  final String parking;
  final StateModel stateSession;
  InvitationsView(this.parking, @required this.stateSession);


  @override
  _InvitationsViewState createState() => new _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView>{

  TextEditingController editingController = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];
  // Radio buttons for filter data from Firestore
  List<RadioModel> filterOption = new List<RadioModel>();
  Stream<QuerySnapshot> stream;
  String todayDate = formatDate(DateTime.now(), [dd, '-', MM, '-', yyyy]);
  String lastDayweek = formatDate(DateTime.now().add(new Duration(days: 7)), [dd, '-', MM, '-', yyyy]);


  @override
  void initState() {

    super.initState();
    filterOption.add(new RadioModel(true, 'Hoy', 'Hoy'));
    filterOption.add(new RadioModel(false, 'Esta semana', 'Esta Semana'));
    filterOption.add(new RadioModel(false, 'Todos', 'Todos'));

    //Getting first data from Firestore where date is today

    CollectionReference collectionReference =
    Firestore.instance.collection('invitations');
    stream = collectionReference.
    where("parking", isEqualTo: widget.parking).
    where("usercreator", isEqualTo: widget.stateSession.userSession.id).
    where("date", isEqualTo: todayDate )
        .snapshots();

  }

  @override
  Widget build(BuildContext context) {


    // Define query depending on passed args
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
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 30.0,
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 120.0),
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {},
                        iconSize: 30.0,
                      ),
                    ),
                    SizedBox(height: 15.0),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(5.0),
                child: TextField(
                  onChanged: (val) {
                    //initiateSearch(val);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon (
                      Icons.search,
                      size: 30.0,
                    ),
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    hintText: 'Buscar',
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: filterOption
                  .map((document) {
                return new InkWell(
                  //highlightColor: Colors.red,
                  splashColor:  Color(0xFF4458be),
                  onTap: () {
                    CollectionReference collectionReference =
                    Firestore.instance.collection('invitations');

                    setState(() {
                      filterOption.forEach((element) => element.isSelected = false);
                      document.isSelected = true;

                      // Implementing route cases for every filter
                      if (document.text == 'Hoy'){
                        stream = collectionReference.
                        where("parking", isEqualTo: widget.parking).
                        where("usercreator", isEqualTo: widget.stateSession.userSession.id).
                        where("date", isEqualTo: todayDate )
                            .snapshots();
                      }

                      else if(document.text == 'Esta Semana'){
                        stream = collectionReference.
                        where("parking", isEqualTo: widget.parking).
                        where("usercreator", isEqualTo: widget.stateSession.userSession.id).
                        where("date", isGreaterThanOrEqualTo: todayDate)
                            .where("date", isLessThanOrEqualTo: lastDayweek)
                            .snapshots();

                      }
                      else
                      {
                        stream = collectionReference.
                        where("parking", isEqualTo: widget.parking).
                        where("usercreator", isEqualTo: widget.stateSession.userSession.id)
                            .snapshots();
                      }

                    });
                  },
                  child: new RadioItem(document),
                );
              },).toList(),
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
                          .map((document) {
                        return new InvitationCard(
                          invitation:
                          Invitation.fromMap(document.data, document.documentID),
                        );
                      }).toList(),
                    );
                  }
                  else
                  {
                    return NoItems("Sin invitaciones", "assets/img/noNotification.png");

                  }

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//  initiateSearch(value) {
//    if (value.length == 0) {
//      setState(() {
//        queryResultSet = [];
//        tempSearchStore = [];
//      });
//    }
//
//    var capitalizedValue =
//        value.substring(0, 1).toUpperCase() + value.substring(1);
//
//    if (queryResultSet.length == 0 && value.length == 1) {
//      CrudMethods().searchByName("invitations", value).then((QuerySnapshot docs) {
//        for (int i = 0; i < docs.documents.length; ++i) {
//          queryResultSet.add(docs.documents[i].data);
//        }
//      });
//    } else {
//      tempSearchStore = [];
//      queryResultSet.forEach((element) {
//        if (element['description'].startsPPWith(capitalizedValue)) {
//          setState(() {
//            tempSearchStore.add(element);
//          });
//        }
//      });
//    }
//  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }


}

