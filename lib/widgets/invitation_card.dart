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

    // Getting and casting dates
    var formatter = new DateFormat('dd-MM-yyyy');
    String dateFormat = formatter.format(invitation.date);

    var formatterTime = new DateFormat('hh:mm');
    String timeFormat = formatterTime.format(invitation.date);

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
              padding:
              const EdgeInsets.only(top: 20.0, left: 20.0, right: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "TLAR invitación",
                    style: _txtCustomHead.copyWith(
                        fontSize: 15.0, fontWeight: FontWeight.w600),
                  ),
                  Image.asset(
                    "assets/tlar-logo.png",
                    height: 30.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 5.0, left: 20.0, right: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        child: Text(dateFormat),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Hora",
                        style: _txtCustomSub,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(timeFormat),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "            ",
                        style: _txtCustomSub,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text("          "),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 30.0,
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
                        child: Text(invitation.guest.phonenumber),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Estado",
                        style: _txtCustomSub,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(invitation.status),
                      ),
                    ],
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
                  width: 1000.0,
                  color: Colors.blueGrey.withOpacity(0.1),
                  child: Center(
                      child: Text("Ver Detalles",
                          style: _txtCustomHead.copyWith(
                              fontSize: 15.0, color: Colors.blueGrey)))),
            )
          ],
        ),
      ),
    );
  }
}

