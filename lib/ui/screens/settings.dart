import 'package:flutter/material.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/widgets/settings_button.dart';
class Settings extends StatelessWidget {


  Settings();

  @override
  Widget build(BuildContext context) {

    StateModel appState = StateWidget.of(context).state;
    return Column(

      children: <Widget>[
        SizedBox(height: 44.0),
        Stack(
          children: <Widget>[
            Container(
              height: 50.0,
              width: double.infinity,
            ),


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
                    onPressed: () {},
                    iconSize: 30.0,
                  ),
                ),
                SizedBox(height: 15.0),
              ],
            )
          ],
        ),

        Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsButton(
              Icons.exit_to_app,
              "Cerrar sesión",
              appState.googleUser.displayName,
                  () async {
                await StateWidget.of(context).signOutOfGoogle();
              },
            ),

          ],
        ),
      )
    ],
    );

  }
}