import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlar/models/invitation.dart';

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

  static var _txtCustom = TextStyle(
    color: Colors.black54,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    //fontFamily: "Gotik",
  );

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

  @override
  Widget build(BuildContext context) {
    //Manage different dates
    var formatter = new DateFormat('dd-MM-yyyy');
    String dateFormat = formatter.format(widget.invitation.date);

    var formatterTime = new DateFormat('hh:mm');
    String timeFormat = formatterTime.format(widget.invitation.date);

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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 800.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 45.0, right: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Fecha: "+dateFormat,
                  style: _txtCustom,
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Text(
                  "Hora: "+ timeFormat,
                  style: _txtCustom,
                ),

                Padding(padding: EdgeInsets.only(top: 7.0)),
                Text(
                  "Descripción: "+widget.invitation.description,
                  style: _txtCustom,
                ),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Text(
                  "Tracking",
                  style: _txtCustom.copyWith(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        _bigCircleNotYet,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _bigCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _bigCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _smallCircle,
                        _bigCircle,
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        qeueuItem(
                          icon: "assets/img/bag.png",
                          txtHeader: "Checkout",
                          txtInfo: "Su invitado ha salido del parqueo",
                          time: "11:00",
                          paddingValue: 35.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/courier.png",
                          txtHeader: "Checkin",
                          txtInfo: "Su invitado ha ingresado al parqueo",
                          time: "09:50",
                          paddingValue: 18.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/payment.png",
                          txtHeader: "Invitación Aceptada",
                          txtInfo: "Invitado ha confirmado la visita",
                          time: "08:20",
                          paddingValue: 45.0,
                        ),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        qeueuItem(
                          icon: "assets/img/order.png",
                          txtHeader: "Invitación Enviada",
                          txtInfo: "Se ha enviado la invitación",
                          time: "08:00",
                          paddingValue: 69.0,
                        ),
                      ],
                    ),
                  ],
                ), /////
              ],
            ),
          ),
        ),
      ),
    );
  }
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

  String icon, txtHeader, txtInfo, time;
  double paddingValue;

  qeueuItem(
      {this.icon, this.txtHeader, this.txtInfo, this.time, this.paddingValue});

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 13.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Image.asset(icon),
              Padding(
                padding: EdgeInsets.only(
                    left: 8.0,
                    right: mediaQueryData.padding.right + paddingValue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(txtHeader, style: _txtCustomOrder),
                    Text(
                      txtInfo,
                      style: _txtCustomOrder.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Colors.black38),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: _txtCustomOrder..copyWith(fontWeight: FontWeight.w400),
              )
            ],
          ),
        ],
      ),
    );
  }
}
