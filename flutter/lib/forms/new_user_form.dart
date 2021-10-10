import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

// Define a custom Form widget.
class NewUserForm extends StatefulWidget {

  final Function(String) onValidate;

  const   NewUserForm({
    Key? key,
    required this.onValidate
  }) : super(key: key);

  @override
  NewUserFormState createState() => NewUserFormState();

}

class NewUserFormState extends State<NewUserForm> {

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  // final Function(String) onValidate;

  // NewUserFormState({required this.onValidate});


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 50,
                bottom: MediaQuery.of(context).viewInsets.bottom),
              child:
              Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/pylons_logo.png'),
                    alignment: Alignment.bottomCenter,
                  ),
                  Container(
                    height: 100,
                  ),
                  PylonsTextInput(controller: usernameController, label: "user_name".tr()),
                 const VerticalSpace(50),
                  PylonsBlueButton(
                      onTap : onStartPylonsPressed,
                      text: "start_pylons".tr()),
                  const VerticalSpace(30)
                ],
              )
          )// Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

  void onStartPylonsPressed(){

    if(usernameController.text.isEmpty){


      ScaffoldMessenger.of(context)..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('User name is Empty'),));
      Navigator.of(context).pop();
      return;
    }

    widget.onValidate(usernameController.value.text);

  }

}