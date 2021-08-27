import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/components/pylons_rounded_button.dart';

// Define a custom Form widget.
class ImportFromGoogleForm extends StatefulWidget {
  const ImportFromGoogleForm({Key? key}) : super(key: key);

  @override
  ImportFromGoogleFormState createState() {
    return ImportFromGoogleFormState();
  }
}

class ImportFromGoogleFormState extends State<ImportFromGoogleForm> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Image(
                    image: const AssetImage('assets/images/pylons_logo.png'),
                    alignment: Alignment.bottomCenter,
                  ),
                  Container(
                    height: 20,
                  ),
                  PylonsRoundedButton(
                      glyph: const AssetImage('assets/images/gcloud.png'),
                      text: "Import from google cloud",
                      onTap: (){}
                  ),
                  Container(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                    ),
                    filled: true,
                    labelText: "User Name",
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    fillColor: Colors.white70)),
                  Container(
                    height: 20,
                  ),
                  TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          filled: true,
                          labelText: "Code Number",
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70)),
                ],
              )
          )// Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}