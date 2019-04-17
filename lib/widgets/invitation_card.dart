import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/ui/screens/invitation_detail.dart';

/// Custom Text Header
var _txtCustomHead = TextStyle(
  color: Colors.black54,
  fontSize: 17.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

/// Custom Text Detail
var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 13.5,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

/// Declare example Credit Card
String numberCC = "9867 - 2312 - 3212 - 4213";
String nameCC = "Alissa Hearth";
String cvvCC = "765";

class InvitationCard extends StatelessWidget {

  final Invitation invitation;
  final Function onFavoriteButtonPressed;

  InvitationCard(
      {@required this.invitation,
        @required this.onFavoriteButtonPressed});


  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.5,
                spreadRadius: 1.0,
              )
            ]),
        child: Column(
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
                        style: _txtCustomSub,
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
                        style: _txtCustomSub,
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
                        style: _txtCustomSub,
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
                          style: _txtCustomSub,
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
                  //width: 800.0,
                  color: const Color(0xFF4458be).withOpacity(0.1),
                  child: Center(
                      child: Text("Ver Detalles",
                          style: _txtCustomHead.copyWith(
                              fontSize: 15.0)))),
            )
          ],
        ),
      ),
    );
  }
}

