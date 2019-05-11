import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tlar/models/event.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/ui/screens/invitation_detail.dart';
import 'package:tlar/utils/store.dart';



class InvitationCard extends StatelessWidget {

  final Invitation invitation;
  final Function onFavoriteButtonPressed;
  final DocumentSnapshot snapshot;
  final bool myInvitation;

  InvitationCard(
      {@required this.invitation,
        @required this.onFavoriteButtonPressed,
        @required this.myInvitation,
        @required this.snapshot
      });



  @override
  Widget build(BuildContext context) {

    var _formatterDate = new DateFormat('dd-MM-yyyy');
    var _formatterTime = new DateFormat('HH:mm');

    RawMaterialButton _buildAcceptButton(IconData iconButton, Color colorButton) {
      return RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        onPressed:  () => Firestore.instance.runTransaction((transaction) async {
          final freshSnapshot = await transaction.get(snapshot.reference);

          await transaction.update(freshSnapshot.reference, {
            'status': 'aceptada'
          });
          // Adding new event and new notification
          Event newEvent =
          new Event(date: _formatterDate.format(DateTime.now()),
                    time: _formatterTime.format(DateTime.now()),
                    invitation: invitation.id,
                    title: 'Invitación Aceptada',
                    message: 'El invitado ha aceptado la invitación'

          );

          // ... Storing
          newEventStore(newEvent).then((result) {
            if (result)
            {
              print("Event added");
            }
          }).catchError((error) {
            return false;
          });

        }),
        child: Icon(
          // Conditional expression:
          // show "favorite" icon or "favorite border" icon depending on widget.inFavorites:
          iconButton,
          color: Colors.white,
        ),
        elevation: 5.0,
        fillColor: colorButton,
        shape: CircleBorder(),
      );
    }

    RawMaterialButton _buildAddCalendarButton(IconData iconButton, Color colorButton) {
      return RawMaterialButton(
        constraints: const BoxConstraints(
            minWidth: 40.0, minHeight: 40.0
        ),
        onPressed:
          () => print("hola"),
        child: Icon(
          // Conditional expression:
          // show "favorite" icon or "favorite border" icon depending on widget.inFavorites:
          iconButton,
          color: Colors.white,
        ),
        elevation: 5.0,
        fillColor: colorButton,
        shape: CircleBorder(),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
      child: Container(

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.5,
                spreadRadius: 1.0,
              )
            ]),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  top: 2.0,
                  right: 10.0,

                  child: invitation.status == 'iniciada' && myInvitation ?

                    Tooltip(
                      message: 'Acepte la invitación',
                        child: _buildAcceptButton(
                          Icons.check,
                          Colors.green,
                        )
                    )
                    :
                      Center(
                        child: Text(""),
                      )
                ),
                Positioned(
                  top: 2.0,
                  right: 55.0,
                  child: Tooltip(
                    message: 'Guarde invitación a su calendario',
                    child: myInvitation ?
                      _buildAddCalendarButton(Icons.calendar_today, Color(0xFF7a84f1)):
                    Center(
                      child: Text(""),
                    ),
                  )
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 5.0, left: 20.0, right: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Fecha",
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(const IconData(59701, fontFamily: 'MaterialIcons')),
                                    ),
                                    SizedBox(width: 5.0,),
                                    Text(invitation.date),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Hora",
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(const IconData(57745, fontFamily: 'MaterialIcons')),
                                    ),
                                    SizedBox(width: 5.0,),
                                    Text(invitation.time),
                                  ],
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        bottom: 0.0,
                        left: 20.0,
                        right: 30.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Invitado",
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Icon(const IconData(58705, fontFamily: 'MaterialIcons')),
                                    ),
                                    SizedBox(width: 5.0,),
                                    Text(invitation.guest.phonenumber),
                                  ],
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        bottom: 15.0,
                        left: 20.0,
                        right: 30.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Descripción",
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(invitation.description),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvitationDetail(invitation: invitation,)));

                      },
                      child: Container(

                          height: 40.0,
//                          decoration: BoxDecoration(
//                            color: Theme.of(context).primaryColorLight,
//                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                          ),
                          //width: 800.0,
                          //color: const Color(0xFF4458be).withOpacity(0.1),
                          child: Center(
                              child: Text(
                                "Ver Detalles >",
                                style: Theme.of(context).textTheme.title

                                // style: _txtCustomHead.copyWith(
                                //     fontSize: 15.0)
                              )
                          )
                      ),
                    )
                  ],
                ),
                Positioned(
                    bottom: 10.0,
                    right: 15.0,

                  child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(
                            color: Colors.green,
                            width: 1.0,
                            style: BorderStyle.solid
                        ),
                        borderRadius: new BorderRadius.all(
                          new Radius.circular(20.0),
                        ),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey,
                            offset: new Offset(2.0, 2.0),
                          )
                        ],
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(invitation.status.toUpperCase(), style: Theme.of(context).textTheme.caption,),
                    ),
                    ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}

