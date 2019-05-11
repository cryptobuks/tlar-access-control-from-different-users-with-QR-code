import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlar/models/event.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/widgets/no_items_screen.dart';

class InvitationDetail extends StatefulWidget {

  final Invitation invitation;
  InvitationDetail(
  {
    this.invitation
  });

  @override
  _InvitationDetailState createState() => _InvitationDetailState();
}

class _InvitationDetailState extends State<InvitationDetail> {


  Stream<QuerySnapshot> stream;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    CollectionReference collectionReference =
    Firestore.instance.collection('events');
    stream = collectionReference.
    where("invitation", isEqualTo: widget.invitation.id)
        .snapshots();

  }

  @override
  Widget build(BuildContext context) {
    //Manage different dates

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
          style: TextStyle(
              //fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: Colors.white,
              //fontFamily: "Gotik"
          ),
        ),
        centerTitle: true,
        //iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        width: 800.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 45.0, right: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Fecha: "+widget.invitation.date,
                //style: _txtCustom,
              ),
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                "Hora: "+ widget.invitation.time,
                //style: _txtCustom,
              ),

              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                "Descripción: "+widget.invitation.description,
                //style: _txtCustom,
              ),
              Padding(padding: EdgeInsets.only(top: 30.0)),
              Text(
                "Tracking",

              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Expanded(
                child: StreamBuilder(
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
                          return new qeueuItem(
                            paddingValue: 55.0,
                            event:
                            Event.fromMap(document.data, document.documentID),
                            icon: "assets/img/bag.png",

                          );
                        }).toList(),
                      );
                    }
                    else
                    {
                      return NoItems("Sin eventos", "assets/img/noInvitation.png");

                    }

                  },
                ),
              ), /////
            ],
          ),
        ),
      ),
    );
  }
}

Center _buildLoadingIndicator() {
  return Center(
    child: new CircularProgressIndicator(),
  );
}

/// Constructor Data Orders
class qeueuItem extends StatelessWidget {
  @override
  static var _txtCustomOrder = TextStyle(
    color: Colors.black45,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  String icon;
  Event event;
  double paddingValue;

  qeueuItem(
      {this.icon, this.event, this.paddingValue});

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 13.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Image.asset(icon),
              _smallCircleTransparent,
              _bigCircle,
              _smallCircle,
              _smallCircle,
              _smallCircle,
              //_smallCircle,
             //_smallCircle,

            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0),
            width: 180.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.title, style: _txtCustomOrder),
                Text(
                  event.message,
                  style: _txtCustomOrder.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: Colors.black38),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Image.asset(icon),
              Text(
                event.time,
                style: _txtCustomOrder..copyWith(fontWeight: FontWeight.w400),
              )

            ],
          )
        ],
      ),
    );
  }

  /// Create Big Circle for Data Order Not Success
  var _bigCircleNotYet = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
    ),
  );

  /// Create Circle for Data Order Success
  var _bigCircle = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 20.0,
      width: 20.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 14.0,
        ),
      ),
    ),
  );

  /// Create Small Circle
  var _smallCircle = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 3.0,
      width: 3.0,
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        shape: BoxShape.circle,
      ),
    ),
  );

  var _smallCircleTransparent = Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      height: 3.0,
      width: 3.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
    ),
  );

}
