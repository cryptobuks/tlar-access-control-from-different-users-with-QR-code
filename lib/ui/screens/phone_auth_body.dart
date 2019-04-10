import 'package:flutter/material.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/widgets/google_sign_in_button.dart';
import 'package:tlar/widgets/masked_text.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  String phoneNo;

  @override
  Widget build(BuildContext context) {
    // Private methods within build method help us to
    // organize our code and recognize structure of widget
    // that we're building:

    return Scaffold(
      body: _buildPhoneAuthBody()
    );
  }

  Widget _buildPhoneAuthBody() {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Text(
            "Te enviaremos un SMS para verificar tu identidad, por favor ingresa tu número de teléfono!",
            //style: decorationStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(flex: 5, child: _buildPhoneNumberInput()),
              Flexible(flex: 1, child: _buildConfirmInputButton())
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberInput() {
    return TextField(
      decoration: InputDecoration(
        isDense: false,
        //enabled: this.status == AuthStatus.PHONE_AUTH,
        counterText: "",
        icon: const Icon(
          Icons.phone,
        ),
        labelText: "Teléfono",
        //labelStyle: decorationStyle,
        hintText: "+502 99999999",
        //hintStyle: hintStyle,
        //errorText: _errorMessage,
      ),
      onChanged: (value) {
        phoneNo = value;
      },
    );
  }

  Widget _buildConfirmInputButton() {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(Icons.check),
      color: theme.accentColor,
      disabledColor: theme.buttonColor,
      onPressed: (StateWidget.of(context).state.status == AuthStatus.PROFILE_AUTH)
          ? null
          : () => StateWidget.of(context).verifyPhone(phoneNo),
    );
  }
}



