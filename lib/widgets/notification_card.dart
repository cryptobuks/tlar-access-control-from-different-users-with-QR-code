import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/ui/screens/invitation_detail.dart';

class NotificationCard extends StatelessWidget {
  final String user;
  final String body;
  final String datenotification;

  NotificationCard(
      {@required this.user,
        @required this.body,
      @required this.datenotification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _makeListTile(),
    );

  }

  Widget _makeListTile() {
    return Dismissible(
        key: Key(user+body),
        onDismissed: (direction) {

        },
        child: Container(
          height: 88.0,
          child: Column(
            children: <Widget>[
              Divider(height: 5.0),
              ListTile(
                title: Text(
                  'TLAR app',
                  style: TextStyle(
                      fontSize: 17.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top:6.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 440.0,
                        child: Text(
                          body,
                          style: new TextStyle(
                              fontSize: 15.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black38
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 440.0,
                        child: Text(
                          datenotification,
                          style: new TextStyle(
                              fontSize: 15.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black38
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                leading: Column(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          image: DecorationImage(image: AssetImage('assets/tlar-logo.png'),fit: BoxFit.cover)
                      ),
                    )
                  ],
                ),
              ),
              Divider(height: 5.0),
            ],
          ),
        ));

  }
}
