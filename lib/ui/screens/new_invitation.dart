import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/ui/screens/parking_detail.dart';
import 'package:tlar/utils/store.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class InvitationForm extends StatefulWidget{

  final String parkingId;

  InvitationForm({this.parkingId});
  @override
  _InvitationFormState createState() => _InvitationFormState();

}

class _InvitationFormState extends State<InvitationForm> {

  final  GlobalKey<FormState> form = GlobalKey<FormState>();
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  InputType inputType = InputType.date;
  InputType inputTypeTime = InputType.time;
  bool editable = true;
  DateTime date;
  DateTime date2;
  List<String> _colors = <String>['', 'San Isidro', 'Valle Nuevo 2'];
  String _color = '';
  String _description = '';
  Invitation newInvitation = new Invitation();
  String descriptionTest;
  String phoneNumberForm;
  DateTime fechaHoraInvitacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
          _topContent(),
          Expanded(
            child: Container(
              child: Padding(
                // Padding before and after the list view:
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                child: Card(
                  elevation: 8.0,
                  child: Form(
                    key: form,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
                      children: <Widget>[
                        DateTimePickerFormField(
                          inputType: inputType,
                          format: DateFormat('yyyy-MM-dd'),
                          editable: editable,
                          decoration: InputDecoration(
                              labelText: 'Invitation Date',
                              hasFloatingPlaceholder: false,
                              icon: const Icon(
                                Icons.calendar_today,
                              )
                          ),
                          onChanged: (dt) => setState(() => date = dt),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),

                        DateTimePickerFormField(
                          inputType: inputTypeTime,
                          format: formats[inputTypeTime],
                          editable: editable,
                          decoration: InputDecoration(
                              labelText: 'Invitation Time',
                              hasFloatingPlaceholder: false,
                              icon: const Icon(
                                Icons.access_time,
                              )
                          ),
                          onChanged: (dt) => setState(() => date2 = dt),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),


//                        new FormField<String>(
//                          builder: (FormFieldState<String> state) {
//                            return InputDecorator(
//                              decoration: InputDecoration(
//                                icon: const Icon(Icons.home),
//                                labelText: 'Parqueo',
//                                errorText: state.hasError ? state.errorText : null,
//                              ),
//                              isEmpty: _color == '',
//                              child: new DropdownButtonHideUnderline(
//                                child: new DropdownButton<String>(
//                                  value: _color,
//                                  isDense: true,
//                                  onChanged: (String newValue) {
//                                    setState(() {
//                                      //newContact.favoriteColor = newValue;
//                                      _color = newValue;
//                                      state.didChange(newValue);
//                                    });
//                                  },
//                                  items: _colors.map((String value) {
//                                    return new DropdownMenuItem<String>(
//                                      value: value,
//                                      child: new Text(value),
//                                    );
//                                  }).toList(),
//                                ),
//                              ),
//                            );
//                          },
//                          validator: (val) {
//                            return val != '' ? null : 'Por favor seleccione un parqueo';
//                          },
//                        ),
//                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        TextFormField(
                          validator: (val) {
                            return val != '' ? null : 'Por favor ingrese un número';
                          },
                          decoration: InputDecoration(
                            isDense: false,
                            //enabled: this.status == AuthStatus.PHONE_AUTH,
                            counterText: "",
                            icon: const Icon(
                              Icons.phone_android,
                            ),
                            labelText: "Guest Phonenumber",
                            //labelStyle: decorationStyle,
                            hintText: "+50299999999",
                            //hintStyle: hintStyle,
                            //errorText: _errorMessage,
                          ),
                          onSaved: (val) => phoneNumberForm = val,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: false,
                            //enabled: this.status == AuthStatus.PHONE_AUTH,
                            counterText: "",
                            icon: const Icon(
                              Icons.description,
                            ),
                            labelText: "Description",
                            //labelStyle: decorationStyle,
                            //hintText: "+502 99999999",
                            //hintStyle: hintStyle,
                            //errorText: _errorMessage,
                          ),
                          onSaved: (val) => descriptionTest = val,
                        ),

                        Padding(padding: EdgeInsets.only(top: 40.0)),

                        buttonCustom(
                          color: Color(0xFF4458be),
                          txt: "Invitar",
                          ontap: () {
                            _submitForm();
                          },
                        ),
//                        new Container(
//                            padding: const EdgeInsets.only(left: 40.0, top: 20.0),
//                            child: new RaisedButton(
//                              //color: Color(0xFF4458be),
//                                child: Text(
//                                  "Invitar",
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                  ),
//                                ),
//                              onPressed: _submitForm,
//                            )),
                      ],

                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );

  }

  void _submitForm() {
    final FormState formLocal = form.currentState;

    if (!formLocal.validate()) {
      showDialog(
          child: Text("No es válido el formulario")
      );
    } else {
      print(date2);

      formLocal.save(); //This invokes each onSaved event
      fechaHoraInvitacion = date.add(date2.timeZoneOffset);

      print (date);
      Guest guestInvitation = new Guest(phonenumber: phoneNumberForm);
      Invitation invitationForm =
        new Invitation(usercreator: StateWidget.of(context).state.userSession.id,
          description: descriptionTest, date: fechaHoraInvitacion,
          guest: guestInvitation, parking: widget.parkingId);
      newInvitationStore(invitationForm).then((result) {
        if (result)
          {
            Navigator.pop(context);
          }
      }).catchError((error) {
        print('Error: $error');
        return false;
      });


    }
  }

  Widget _topContent() {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color(0xFF4458be)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8.0),
              Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 40.0,
              ),
              Container(
                width: 90.0,
                child: new Divider(color: Colors.white),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );


  }

}
