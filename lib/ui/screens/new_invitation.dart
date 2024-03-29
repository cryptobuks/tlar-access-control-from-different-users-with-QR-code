
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:tlar/models/invitation.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/ui/screens/parking_detail.dart';
import 'package:tlar/utils/store.dart';
import 'package:country_code_picker/country_code_picker.dart';

class InvitationForm extends StatefulWidget{

  final String parkingId;

  InvitationForm({this.parkingId});
  @override
  _InvitationFormState createState() => _InvitationFormState();

}

class _InvitationFormState extends State<InvitationForm> {

  final  GlobalKey<FormState> form = GlobalKey<FormState>();

  TextEditingController phoneTextFieldController = TextEditingController();
  TextEditingController descriptionTextFieldController = TextEditingController();

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
  Invitation newInvitation = new Invitation();
  String descriptionTest = '';
  String phoneNumberForm = '';
  String codeArea = '+502';
  DateTime fechaHoraInvitacion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:

      Column(
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
                              labelText: 'Fecha',
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
                              labelText: 'Hora',
                              hasFloatingPlaceholder: false,
                              icon: const Icon(
                                Icons.access_time,
                              )
                          ),
                          onChanged: (dt) => setState(() => date2 = dt),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: CountryCodePicker(
                                onChanged: (value) {
                                  codeArea = value.toString();
                                  print(codeArea);
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'GT',
                                favorite: ['+502','GT'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,

                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*.5,
                              child: TextFormField(

                                controller: phoneTextFieldController,
                                validator: (val) {
                                  return val != '' ? null : 'Por favor ingrese un número';
                                },
                                decoration: InputDecoration(
                                  //isDense: false,
                                  //enabled: this.status == AuthStatus.PHONE_AUTH,
                                  counterText: "",
                                  labelText: "Número invitado",
                                  //labelStyle: decorationStyle,
                                  //hintText: "+50299999999",
                                  //hintStyle: hintStyle,
                                  //errorText: _errorMessage,
                                ),
                                onSaved: (value) {
                                  phoneNumberForm = value;
                                },
                              )
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        TextFormField(
                          controller: descriptionTextFieldController,
                          validator: (val) {
                            return val != '' ? null : 'Por favor ingrese una descripción';
                          },
                          decoration: InputDecoration(
                            isDense: false,
                            //enabled: this.status == AuthStatus.PHONE_AUTH,
                            counterText: "",
                            icon: const Icon(
                              Icons.description,
                            ),
                            labelText: "Descripción",
                            //labelStyle: decorationStyle,
                            //hintText: "+502 99999999",
                            //hintStyle: hintStyle,
                            //errorText: _errorMessage,
                          ),
                          onSaved: (value) {
                            descriptionTest = value;
                          },
                        ),

                        Padding(padding: EdgeInsets.only(top: 40.0)),

                        buttonCustom(
                          color: Color(0xFF4458be),
                          txt: "Invitar",
                          ontap: () {
                            _submitForm();
                          },
                        ),

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
     // Converting date and time to String
      var formatter = new DateFormat('dd-MM-yyyy');
      String dateFormat = formatter.format(date);

      var formatterTime = new DateFormat('hh:mm');
      String timeFormat = formatterTime.format(date2);

      // Storing invitation into Cloud Firestore
      Guest guestInvitation = new Guest(phonenumber: codeArea + phoneTextFieldController.text);
      Invitation invitationForm =
        new Invitation(usercreator: StateWidget.of(context).state.userSession.id,
          description: descriptionTextFieldController.text, date: dateFormat, time: timeFormat,
          guest: guestInvitation, parking: widget.parkingId);

      // ... Storing
      newInvitationStore(invitationForm).then((result) {
        if (result)
          {
            Navigator.pop(context);
          }
      }).catchError((error) {
        return false;
      });


    }
  }

  Widget _topContent() {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.all(35.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Color(0xFF4458be),
              boxShadow: <BoxShadow>[
                BoxShadow (
                  color: const Color(0xcc000000),
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0,
                ),
                BoxShadow (
                  color: const Color(0x80000000),
                  offset: Offset(0.0, 6.0),
                  blurRadius: 20.0,
              ),
            ],
          ),
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
              //SizedBox(height: 30.0),
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

