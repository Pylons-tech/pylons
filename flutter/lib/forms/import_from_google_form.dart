import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_rounded_button.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

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
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 50,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  const Image(
                    image:  AssetImage('assets/images/pylons_logo.png'),
                    alignment: Alignment.bottomCenter,
                  ),
                 const  VerticalSpace(30),
                  PylonsRoundedButton(
                      glyph: const AssetImage('assets/images/gcloud.png'),
                      text: "Import from google cloud",
                      onTap: (){}
                  ),
                  const VerticalSpace(20),
                  PylonsTextInput(controller: TextEditingController(), label: "User Name"),
                  const VerticalSpace(20),
                  PylonsTextInput(controller: TextEditingController(), label: "User ID"),
                  const VerticalSpace(30),
                  PylonsBlueButton(onTap: (){}, text: "Start Pylons",),
                  const VerticalSpace(20),
                ],
              )
          )// Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}