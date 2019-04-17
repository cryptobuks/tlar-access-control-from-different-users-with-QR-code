import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(10.0),
      child: new Container(
        height: 50.0,
        width: 110.0,
        child: new Center(
          child: new Text(_item.buttonText,
              style: new TextStyle(
                  color:
                  _item.isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0)),
        ),
        decoration: new BoxDecoration(
          color: _item.isSelected
              ? const Color(0xFF4458be)
              : Colors.transparent,
          border: new Border.all(
              width: 1.0,
              color: _item.isSelected
                  ? const Color(0xFF4458be)
                  : Colors.blueAccent),
          borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}