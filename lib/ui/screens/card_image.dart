import 'package:flutter/material.dart';

class CardImage extends StatelessWidget {
  final String imageURL;

  CardImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 36.0 /25.0,
      child: Image.network(
        imageURL,
        fit: BoxFit.cover,
      ),
    );
  }
}