import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tlar/models/parking.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/ui/screens/notifications_screen.dart';
import 'package:tlar/ui/screens/parking_detail.dart';
import 'package:tlar/widgets/no_items_screen.dart';

class ParkingsView extends StatefulWidget {
  @override

  _ParkingsState createState() => _ParkingsState();
}

class _ParkingsState extends State<ParkingsView> {
  @override
  Widget build(BuildContext context) {
    // Component appbar
    var _appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 15.0),
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
                iconSize: 30.0,
                color: Color(0xFF4458be),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width - 120.0),
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsView()));

                },
                iconSize: 30.0,
                color: Color(0xFF4458be),
              ),
            ),
            SizedBox(height: 15.0),

          ],
        )
      ],
    );

    // Getting data from Cloud
    CollectionReference collectionReference = Firestore.instance.collection('parkings');
    Stream<QuerySnapshot> stream;
    stream = collectionReference
        .snapshots();



    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Scaffold(
        // Calling variable appbar
          appBar: _appbar,
          body: Container(
            color: Colors.white,
            child: new StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return _buildLoadingIndicator();
                if (StateWidget.of(context).state.parkings.length>0)
                {
                  return new ListView(
                    children: snapshot.data.documents
                    // Check if the argument ids contains document ID if ids has been passed:
                    .where((d) =>  StateWidget.of(context).state.parkings.contains(d.documentID))
                        .map((document) {
                      return new itemCard(
                        parking: Parking.fromMap(document.data, document.documentID),
                        flag: StateWidget.of(context).state.parkings.contains(document.documentID),
                      );
                    }).toList(),
                  );
                }
                else
                {
                  return NoItems("No tiene establecimientos asignados", "assets/img/noNotification.png");

                }

              },
            ),
          )),
    );
  }
}

/// Constructor for itemCard for List Menu
class itemCard extends StatelessWidget {
  // Declaration and Get data from BrandDataList.dart
  final Parking parking;
  final bool flag;
  itemCard({@required this.parking, @required this.flag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ParkingDetail(parking),
                transitionDuration: Duration(milliseconds: 600),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: child,
                  );
                }),
          );
        },
        child: Container(
          height: 130.0,
          //width: 400.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Hero(
            //tag: 'hero-tag-${brand.id}',
            tag: 'hero-tag-${parking.id}',
            child: Material(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  image: DecorationImage(
                      image: AssetImage('assets/parking-background.png'), fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFABABAB).withOpacity(0.3),
                      blurRadius: 1.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.black12.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      parking.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Center _buildLoadingIndicator() {
  return Center(
    child: new CircularProgressIndicator(),
  );
}