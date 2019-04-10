import 'package:flutter/material.dart';
import 'package:tlar/models/state.dart';
import 'package:tlar/state_widget.dart';
import 'package:tlar/widgets/google_sign_in_button.dart';
import 'package:tlar/widgets/masked_text.dart';

class SMSVerificationScreen extends StatefulWidget {
  @override
  _SMSVerificationScreenScreenState createState() => _SMSVerificationScreenScreenState();
}

class _SMSVerificationScreenScreenState extends State<SMSVerificationScreen> {
  String SMSCode;

  @override
  Widget build(BuildContext context) {
    // Private methods within build method help us to
    // organize our code and recognize structure of widget
    // that we're building:

    return Scaffold(
        body: _buildSmsAuthBody()
    );
  }

  Widget _buildSmsAuthBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text(
            "Código de Verificación      ",
            //style: decorationStyle,
            //textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 64.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(flex: 5, child: _buildSmsCodeInput()),
              Flexible(flex: 1, child: _buildConfirmInputButton())
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildResendSmsWidget(),
        )
      ],
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
          : () => StateWidget.of(context).submitSmsCode(SMSCode),
    );
  }



  Widget _buildResendSmsWidget() {
    return InkWell(
      onTap: () async {
        if (StateWidget.of(context).state.codeTimeOut) {
          //await _verifyPhoneNumber();
        } else {
          _showErrorSnackbar("Tu no puedes intentarlo aún");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Si tu código no llega en un minuto, da click",
            style: new TextStyle(
              color: Colors.black87
            ),
            children: <TextSpan>[
              TextSpan(
                text: " aquí",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  verificationFailed(AuthException authException) {
//    _showErrorSnackbar(
//        "We couldn't verify your code for now, please try again!");
//  }

  // PhoneCodeSent
  _showErrorSnackbar(String message) {
    //_updateRefreshing(false);
      SnackBar(content: Text(message));
  }

  Widget _buildSmsCodeInput() {

    final enabled = StateWidget.of(context).state.status == AuthStatus.SMS_AUTH;
    return TextField(
      keyboardType: TextInputType.number,
      enabled: enabled,
      textAlign: TextAlign.center,
      //controller: smsCodeController,
      maxLength: 6,
      //onSubmitted: (text) => _updateRefreshing(true),
//      style: Theme.of(context).textTheme.subhead.copyWith(
//        fontSize: 32.0,
//        color: enabled ? Colors.white : Theme.of(context).buttonColor,
//      ),
      decoration: InputDecoration(
        counterText: "",
        enabled: enabled,
        hintText: "--- ---",
        //hintStyle: hintStyle.copyWith(fontSize: 42.0),
      ),
      onChanged: (value) {
        SMSCode = value;
      }
    );
  }

}



