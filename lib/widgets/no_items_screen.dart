import 'package:flutter/material.dart';

class NoItems extends StatelessWidget {
  @override
  final String message;
  final String urlImage;

  NoItems(
      this.message,
      this.urlImage
      );


  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return  Container(
      width: 500.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.only(top: mediaQueryData.padding.top + 100.0)),
            Image.asset(
              urlImage,
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0)),
            Text(
              message,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.5,
                  //color: Colors.black54,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}


