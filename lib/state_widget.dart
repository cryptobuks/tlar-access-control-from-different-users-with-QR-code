import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/models/user.dart';
import 'package:tlar/ui/logger.dart';
import 'package:tlar/utils/auth.dart';
import 'package:tlar/utils/store.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
    as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseUser firebaseUser;
  User userSession;
  String devToken;

  // Defining variables
  static const String TAG = "AUTH";
//  //AuthStatus status = AuthStatus.SOCIAL_AUTH;
//  // Keys
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//  final GlobalKey<MaskedTextFieldState> _maskedPhoneKey =
//  GlobalKey<MaskedTextFieldState>();
//
//  // Controllers
//  TextEditingController smsCodeController = TextEditingController();
//  TextEditingController phoneNumberController = TextEditingController();
//  String _errorMessage;
//  String _verificationId;
//  Timer _codeTimer;
//  bool _isRefreshing = false;
//  bool _codeTimedOut = false;
//  bool _codeVerified = false;
//  Duration _timeOut = const Duration(minutes: 1);

  final FirebaseMessaging _messaging = FirebaseMessaging();


  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }

    _messaging.getToken().then((token){
      print(token);
      devToken = token;
    });

  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  /// Getting user favorites properties
  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('favorites') &&
        querySnapshot.data['favorites'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['favorites']);
    }
    return [];
  }

  /// Getting user favorites properties
  Future<List<String>> getParkings() async {

    List<String> parkings = [];

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('parkingassignations')
        .where("user", isEqualTo: state.user.uid)
        .getDocuments();
    if (querySnapshot.documents.length > 0) {
      // Create a new List<String> from List<dynamic>
      for (var property in querySnapshot.documents)
        {
          parkings.add(property.data['parking']);

        }
      return parkings;
    }
    return [];
  }

  /// Getting user properties from Cloud firebase
  Future<User> getUserCloudFirebase() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists) {
      // Create a new List<String> from List<dynamic>
      return User.fromMap(querySnapshot.data, state.user.uid);
    }
    return null;
  }

  /// Using Google signin connector
  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }

    firebaseUser = await signIntoFirebase(googleAccount);
    state.user  = firebaseUser;
    userSession = await getUserCloudFirebase();
    updateDevToken(firebaseUser.uid, devToken);

    List<String> parkings = await getParkings();
    setState(() {
      state.isLoading = false;
      //state.status = AuthStatus.PHONE_AUTH;
      state.googleUser = googleAccount;
      state.user = firebaseUser;
      state.userSession = userSession;
      state.parkings = parkings;
    });
  }

  /// Sign out actual user
  Future<Null> signOutOfGoogle() async {
    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // Clear variables
    googleAccount = null;
    state.user = null;
    setState(() {
      state = StateModel(user: null);
    });
  }

  Future<void> verifyPhone(String phoneNo) async {

    //String smsCode;
    String verificationId;

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      setState(() {
        state.isLoading = false;
        state.status = AuthStatus.SMS_AUTH;
        state.verID = verId;
        //state.user = firebaseUser;
        //state.favorites = favorites;
      });
      print('Enviado in');
      //smsCodeDialog(context).then((value) {
      //  print('Signed in');
      //});
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
      setState(() {
        state.codeTimeOut = true;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: veriFailed);
  }

  /// Completed SMS verification
  verificationCompleted(FirebaseUser user) async {
    Logger.log(TAG, message: "onVerificationCompleted, user: $user");
    if (await _onCodeVerified(user)) {
      //await _finishSignIn(user);
    } else {
      setState(() {
        state.status = AuthStatus.SMS_AUTH;
        Logger.log(TAG, message: "Changed status to");
      });
    }
  }

  /// verifyng code sent before
  Future<bool> _onCodeVerified(FirebaseUser user) async {
    final isUserValid = (user != null &&
        (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
    if (isUserValid) {
      setState(() {
        // Here we change the status once more to guarantee that the SMS's
        // text input isn't available while you do any other request
        // with the gathered data
        state.status = AuthStatus.PROFILE_AUTH;
        Logger.log(TAG, message: "Changed status to ");
      });
    } else {
      //_showErrorSnackbar("We couldn't verify your code, please try again!");
      Logger.log(TAG, message: "No pudimos verificar su código, intente de nuevo ");
    }
    return isUserValid;
  }

  /// Sending SMS Code from entry
  Future<Null> submitSmsCode(String text) async {
    final error = _smsInputValidator(text);
    if (error != null) {

      setState(() {
        state.status = AuthStatus.SMS_AUTH;
        Logger.log(TAG, message: "Changed status to");
      });

      return null;
    } else {
      Logger.log(TAG, message: "_signInWithPhoneNumber called");
      await _signInWithPhoneNumber(text);

      return null;
    }
  }

  Future<void> _signInWithPhoneNumber(String SMSCode) async {
    //final errorMessage = "No pudimos verificar tu código, intenta de nuevo!";

    firebaseUser = await signInWithPhoneNumber(state.verID, SMSCode);
    //state.user  = firebaseUser;
    //List<String> favorites = await getFavorites();
    setState(() {
      state.isLoading = false;
      state.status = AuthStatus.PHONE_AUTH;
      //state.user = firebaseUser;
      //state.favorites = favorites;
    });
    if (firebaseUser != null)
      _finishSignIn(firebaseUser);

  }

  /// Last process
  ///
  ///
  _finishSignIn(FirebaseUser user) async {
    await _onCodeVerified(user).then((result) {
      if (result) {
        // Here, instead of navigating to another screen, you should do whatever you want
        // as the user is already verified with Firebase from both
        // Google and phone number methods
        // Example: authenticate with your own API, use the data gathered
        // to post your profile/user, etc.
        state.user  = firebaseUser;
        setState(() {
          state.isLoading = false;
          state.user = firebaseUser;

        });

      } else {
        setState(() {
          state.status = AuthStatus.SMS_AUTH;
        });
        //Logger( "We couldn't create your profile for now, please try again later");
      }
    });
  }

  String _smsInputValidator(String text) {
    if (text.isEmpty) {
      return "Su código no puede ser vación!";
    } else if (text.length < 6) {
      return "Este código es demasiado peque;o!";
    }
    return null;
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter sms Code'),
            content: TextField(
              onChanged: (value) {
                //this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      Navigator.of(context).pop();
                      //signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}