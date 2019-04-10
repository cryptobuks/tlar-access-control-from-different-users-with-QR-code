import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/ui/screens/new_invitation.dart';
import 'package:tlar/widgets/invitation_card.dart';
import 'package:tlar/widgets/no_items_screen.dart';
import 'package:tlar/widgets/notification_card.dart';

class NotificationsView extends StatelessWidget {

  NotificationsView();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    CollectionReference collectionReference =
    Firestore.instance.collection('notifications');
    Stream<QuerySnapshot> stream;
    if (StateWidget.of(context).state.userSession != null) {
      stream = collectionReference.
      where("user", isEqualTo: StateWidget.of(context).state.userSession.id)
      .orderBy("datenotification", descending: true)
          .snapshots();
    } else {
      // Use snapshots of all recipes if recipeType has not been passed
      stream = collectionReference.
      where("user", isEqualTo: "")
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

                  ],
                )
              ],
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
                          return new NotificationCard(
                              body: document.data['body'],
                              user: document.data['user'],
                              datenotification : document.data['datenotification'],
                            //inFavorites:
                            //appState.favorites.contains(document.documentID),
                            //onFavoriteButtonPressed: _handleFavoritesListChanged,
                          );
                        }).toList(),
                      );
                    }
                  else
                    {
                      return NoItems("No hay notificaciones recientes", "assets/img/noNotification.png");
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