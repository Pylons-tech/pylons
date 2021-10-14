import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

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

  String dropdownValue = 'us'.tr();

  List<String> countries = [
    'us'.tr(),
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
            padding: EdgeInsets.only(left: 16, right: 16, top: 40, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('add_payment_info'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('card_info'.tr()),
                    ),
                    TextFormField(
                      controller: cardNumberController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          filled: true,
                          hintText: 'card_number'.tr(),
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70),
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'MM/YY',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70),
                        )),
                        Flexible(
                            child: TextFormField(
                          controller: cvcController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'CVC',
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70),
                        ))
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('country_or_region'.tr()),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const ImageIcon(AssetImage('assets/images/icon/chevron-down.png'), size: 24, color: kSelectedIcon),
                      elevation: 16,
                      underline: const SizedBox(),
                      focusColor: const Color(0xFF1212C4),
                      style: const TextStyle(color: kSelectedIcon, fontSize: 14),
                      onChanged: (String? data) {
                        setState(() {
                          dropdownValue = data!;
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
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          filled: true,
                          hintText: 'ZIP',
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70),
                    )
                  ],
                ),
              ],
            )));
  }
}
