import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';

// Define a custom Form widget.
class NewUserForm extends StatefulWidget {

  final Function(String) onValidate;

  const NewUserForm({
    Key? key,
    required this.onValidate
  }) : super(key: key);

  @override
  NewUserFormState createState() => NewUserFormState(onValidate: this.onValidate);

}

class NewUserFormState extends State<NewUserForm> {

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final Function(String) onValidate;

  NewUserFormState({required this.onValidate});


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
              child:
                Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/pylons_logo.png'),
                    alignment: Alignment.bottomCenter,
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                    ),
                    filled: true,
                    labelText: "Username",
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70),
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                  ),
                  PylonsBlueButton(
                    onTap : () => onValidate(usernameController.value.text)
                    ,text: "Start Pylons")
                ],
              )
          )// Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

}