import 'package:flutter/material.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/ui/screens/card_profile_menu.dart';
import 'package:tlar/ui/screens/invitations_menu.dart';
import 'package:tlar/ui/screens/login.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:tlar/ui/screens/myinvitations.dart';
import 'package:tlar/ui/screens/parkings.dart';
import 'package:tlar/ui/screens/phone_auth_body.dart';
import 'package:tlar/ui/screens/profile.dart';
import 'package:tlar/ui/screens/settings.dart';
import 'package:tlar/ui/screens/sms_verification_body.dart';


class Home extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<Home> with TickerProviderStateMixin {

  StateModel appState;
  int _currentIndex = 0;
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  /// Initialing content
  /// Routing every path
  ///
  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

  /// Route different states of widget
  /// depending of signin and signout process
  ///
  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
        return new LoginScreen();

    } else {
        return _buildTabView(
          body: _getPage(_currentIndex),
        );

    }
  }

  /// Indicator of waiting for data
  ///
  ///
  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  /// Generic body content method
  /// @body paramenter with different widget information, loading content, content, etc
  ///
  Scaffold _buildTabView({Widget body}) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(99, 138, 223, 1.0),
      //key: _scaffoldKey,
//      appBar: AppBar(
//        title:
//        Text('',
//            style: TextStyle(fontSize: 16.0, fontFamily: 'League Spartan')
//        ),
//        //backgroundColor: Colors.transparent,
//        elevation: Theme.of(context).platform == TargetPlatform.iOS
//            ? 0.0 : 4.0,
//        centerTitle: true,
//      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Inicio"),
          TabData(iconData: Icons.timer_off, title: "Mis citas"),
          TabData(iconData: Icons.time_to_leave, title: "Sitios"),
          TabData(iconData: Icons.account_circle, title: "Perfil")
        ],
        onTabChangedListener: (position) {
          setState(() {
            _currentIndex = position;
          });
        },
      ),
      //body: _children[_currentIndex],
      body: body,
      //drawer: Drawer(),
    );
  }

  /// Routing different screens
  _getPage(int page){
    switch (page) {
      case 0:
        return CardProfile(stateSession: appState);

      case 1:
        return MyInvitationsView(StateWidget.of(context).state);


      case 2:
        return ParkingsView();


      case 3:
        return ProfileView();
    }
  }
}
