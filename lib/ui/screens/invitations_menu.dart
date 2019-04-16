import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/services/crud.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/ui/screens/new_invitation.dart';
import 'package:tlar/widgets/invitation_card.dart';
import 'package:tlar/widgets/no_items_screen.dart';

class InvitationsView extends StatefulWidget {

  final String parking;
  InvitationsView(this.parking);


  @override
  _InvitationsViewState createState() => new _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView>{

  TextEditingController editingController = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];


  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference =
    Firestore.instance.collection('invitations');
    Stream<QuerySnapshot> stream;
    if (StateWidget.of(context).state.userSession != null) {
      stream = collectionReference.
      where("usercreator", isEqualTo: StateWidget.of(context).state.userSession.id)
          .where("parking", isEqualTo: widget.parking)
          //.where("date", isEqualTo:)
          .limit(5)
          .snapshots();
    } else {
      // Use snapshots of all recipes if recipeType has not been passed
      stream = collectionReference.
      where("usercreator", isEqualTo: "")
          .snapshots();
    }

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
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
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

//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Container(
//                decoration: BoxDecoration(
//                    border: Border(bottom: BorderSide(color: Colors.black54))
//                ),
//                child: new Row(
//                  children: <Widget>[
//
//                  ],
//                ),
//              ),
//            ),
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

