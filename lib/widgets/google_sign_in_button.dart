import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  GoogleSignInButton({this.onPressed});

  final Function onPressed;



  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      height: 40.0,
      onPressed: this.onPressed,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Container(
          alignment: FractionalOffset.center,
          height: 49.0,
          width: 500.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.0)],
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/img/google.png",
                height: 25.0,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 7.0)),
              Text(
                "Signin with Google",
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,)
              )
            ],
          ),
        ),
      )
    );
  }
}
