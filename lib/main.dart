import 'package:flutter/material.dart';
import 'package:tlar/app.dart';
import 'package:tlar/state_widget.dart';


// - StateWidget incl. state data
//    - RecipesApp
//        - All other widgets which are able to access the data
void main() {
  StateWidget stateWidget = new StateWidget(child:new TLARApp());
  runApp(stateWidget);
}
