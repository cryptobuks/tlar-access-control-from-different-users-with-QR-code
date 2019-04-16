import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/ui/screens/notifications_screen.dart';
import 'package:tlar/widgets/card_user.dart';

class CardProfile extends StatefulWidget {

  final StateModel stateSession;

  CardProfile({
    @required this.stateSession
  });

  _CardProfile_WidgetState createState() => _CardProfile_WidgetState();

}

// ignore: camel_case_types
class _CardProfile_WidgetState extends State<CardProfile> with TickerProviderStateMixin{
  var now = new DateTime.now();
  var cardIndex = 0;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {

    return ListView(

          children: <Widget>[
            Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
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
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                      width: 75.0,
                                      height: 75.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new AssetImage("assets/tlar-logo.png")
                                          )
                                      )),
                                ],
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,12.0),
                                  child: Text("Hola, "+ widget.stateSession.googleUser.displayName, style: TextStyle(fontSize: 25.0, fontFamily: 'League Spartan', fontWeight: FontWeight.w400),),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,12.0),
                                  child: Text("¡Bienvenido a la mejor app de Control de Acceso en Guatemala!", style: TextStyle(fontSize: 16.0),),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,12.0),
                                  child: Text("Hoy "+ formatDate(DateTime.now(), [dd, ' de ', M, ' de ', yyyy]), style: TextStyle(),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  CardUser(user: widget.stateSession.userSession.id)
                ]
            ),
        ]
        );

  }

}

class Record {
  final int listingtype;
  final int price;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['listingtype'] != null),
        assert(map['price'] != null),
        listingtype = map['listingtype'],
        price = map['price'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$listingtype:$price>";
}

