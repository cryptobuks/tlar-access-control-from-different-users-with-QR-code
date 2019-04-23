import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tlar/models/user.dart';
enum AuthStatus { SOCIAL_AUTH, PHONE_AUTH, SMS_AUTH, PROFILE_AUTH }

class StateModel {
  bool isLoading;
  FirebaseUser user;
  GoogleSignInAccount googleUser;
  List<String> favorites;
  AuthStatus status;
  String verID;
  bool codeTimeOut = false;
  User userSession;
  List<String> parkings;
  String filterDate_MyInvitations;
  DateTime filterActualDate;

  StateModel({
    this.isLoading = false,
    this.user,
    this.status = AuthStatus.SOCIAL_AUTH,
    this.verID
  });
}
