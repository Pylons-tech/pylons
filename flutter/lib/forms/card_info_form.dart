import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/payment/payment_result_screen.dart';

// Define a custom Form widget.
class CardInfoForm extends StatefulWidget {
  const CardInfoForm({
    Key? key,
  }) : super(key: key);

  @override
  CardInfoFormState createState() => CardInfoFormState();

}

class CardInfoFormState extends State<CardInfoForm> {

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final dateController = TextEditingController();
  final cvcController = TextEditingController();
  final zipController = TextEditingController();

  String dropdownValue = 'United States';

  List <String> countries = [
    'United States',
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 40,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child:Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('Add your payment Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.only(

              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Card Information'),
                  ),
                  TextFormField(
                    controller: cardNumberController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),

                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        filled: true,
                        hintText: 'Card Number',
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        fillColor: Colors.white70
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),

                              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'MM/YY',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70
                          ),
                        )
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: cvcController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'CVC',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70
                          ),
                        )
                      )
                    ],
                  )
                ],
              )
            ),
            SizedBox(height: 24),
            Padding(
                padding: EdgeInsets.only(

                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Country or region'),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: ImageIcon(
                          AssetImage('assets/images/icon/chevron-down.png'),
                          size: 24,
                          color: kIconBGColor
                      ),
                      iconSize: 24,
                      elevation: 16,
                      underline: SizedBox(),
                      focusColor: Color(0xFF1212C4),
                      style: TextStyle(color: kIconBGColor, fontSize: 14),
                      onChanged: (String? data) {
                        setState(() {
                          dropdownValue = data!!;
                        });
                      },
                      items: countries.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: zipController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          filled: true,
                          hintText: 'ZIP',
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70
                      ),
                    )
                  ],
                )
            ),
          ],
        )
      )
    );
  }

}