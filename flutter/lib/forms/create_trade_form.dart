import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';

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
  final nameController = TextEditingController();
  final PriceController = TextEditingController();
  final descController = TextEditingController();

  // final cvcController = TextEditingController();
  // final zipController = TextEditingController();

  String dropdownValue = 'USD';

  List<String> currencies = ['USD', 'Pylons'];

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
                  child: Text('create_trade'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                const VerticalSpace(24),
                Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('price'.tr()),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: PriceController,
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    suffix: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: kSelectedIcon),
                                      elevation: 16,
                                      underline: const SizedBox(),
                                      focusColor: const Color(0xFF1212C4),
                                      style: const TextStyle(color: Color(0xFF1212C4), fontSize: 14, fontWeight: FontWeight.w500),
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
                                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, -10),
                                    filled: true,
                                    hintText: 'expecting_price'.tr(),
                                    hintStyle: TextStyle(color: Colors.grey[800]),
                                    fillColor: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpace(20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('name'.tr()),
                        ),
                        const VerticalSpace(6),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.zero,
                              //   borderSide: BorderSide(color: Colors.transparent),
                              // ),

                              contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              filled: true,
                              hintText: 'title_of_artwork'.tr(),
                              hintStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
                              fillColor: const Color(0xffF1F1F2)),
                        ),
                        const VerticalSpace(20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('description'.tr()),
                        ),
                        const VerticalSpace(6),
                        TextFormField(
                          minLines: 4,
                          maxLines: 4,
                          controller: descController,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              filled: true,
                              hintText: 'artwork_description'.tr(),
                              hintStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
                              fillColor: const Color(0xffF1F1F2)),
                        ),
                        const VerticalSpace(20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('item_id'.tr()),
                        ),
                        const VerticalSpace(6),
                        TextFormField(
                          controller: descController,
                          minLines: 4,
                          maxLines: 4,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              filled: true,
                              hintText: 'cosmosxxx',
                              hintStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
                              fillColor: const Color(0xffF1F1F2)),
                        ),
                        const VerticalSpace(40),
                        PylonsBlueButton(
                          onTap: () {},
                          text: "resell".tr(),
                        ),
                        const VerticalSpace(20),
                      ],
                    )),
              ],
            )));
  }
}
