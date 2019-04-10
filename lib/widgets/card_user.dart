import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardUser extends StatelessWidget {
  final String user;
  final Function onFavoriteButtonPressed;

  CardUser(
      {@required this.user,
        @required this.onFavoriteButtonPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
        child: Card(
          child: Center(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // We overlap the image and the button by
                  // creating a Stack object:
                  new QrImage(
                    data: user,
                    //size: 300.0,
                  )
                  //AgentTitle(agent, 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
