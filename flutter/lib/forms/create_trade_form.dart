import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/pages/payment/payment_result_screen.dart';

// Define a custom Form widget.
class CreateTradeForm extends StatefulWidget {
  const CreateTradeForm({
    Key? key,
  }) : super(key: key);

  @override
  CreateTradeFormState createState() => CreateTradeFormState();

}

class CreateTradeFormState extends State<CreateTradeForm> {

  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final PriceController = TextEditingController();
  final descController = TextEditingController();
  final cvcController = TextEditingController();
  final zipController = TextEditingController();

  String dropdownValue = 'USD';

  List <String> currencies = [
    'USD',
    'Pylons'
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
                  alignment: Alignment.center,
                  child: Text('Create Trade', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 24),
                Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Price'),
                        ),
                        Row(
                          children: [
                            Expanded(child:TextFormField(
                              controller: PriceController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),

                                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  filled: true,
                                  hintText: 'Expecting Price',
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  fillColor: Colors.white70
                              ),
                            ),
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
                                  dropdownValue = data!;
                                });
                              },
                              items: currencies.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),

                          ],),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Name'),
                        ),
                        TextFormField(
                          controller: descController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),

                              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'Title of Artwork',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Description'),
                        ),
                        TextFormField(
                          minLines: 4,
                          maxLines: 4,
                          controller: descController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),

                              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'Description about the artwork',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Item ID'),
                        ),
                        TextFormField(
                          controller: descController,
                          minLines: 4,
                          maxLines: 4,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),

                              contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'cosmosxxx',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                            alignment: Alignment.center,
                            height: 60,
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: (){

                                },
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFF1212C4),
                                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                  minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                                ),
                                child: Text('Resell', style: TextStyle(color: Colors.white))
                            )
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