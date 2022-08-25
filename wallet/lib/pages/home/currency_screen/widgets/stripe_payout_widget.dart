import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:simple_rich_text/simple_rich_text.dart';

class StripePayoutWidget {
  BuildContext context;
  String amount;
  Function? onCallback;

  StripePayoutWidget({required this.context, required this.amount, this.onCallback});

  Future show() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) => Wrap(children: [StripePayoutForm(maxAmount: amount, onCallback: onCallback)]));
  }
}

// Define a custom Form widget.
class StripePayoutForm extends StatefulWidget {
  final String maxAmount;
  final Function? onCallback;

  const StripePayoutForm({Key? key, required this.maxAmount, this.onCallback}) : super(key: key);

  @override
  StripePayoutFormState createState() => StripePayoutFormState();
}

class StripePayoutFormState extends State<StripePayoutForm> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

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
              padding: EdgeInsets.only(left: 16, right: 16, top: 50, bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  const VerticalSpace(30),
                  SimpleRichText("request_payout".tr(), style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const VerticalSpace(30),
                  Text("${"available_amount".tr()} ${widget.maxAmount.UvalToVal()} USD", textAlign: TextAlign.start),
                  const VerticalSpace(30),
                  PylonsTextInput(
                    controller: amountController,
                    label: "Amount",
                    inputType: TextInputType.number,
                    errorText: (textValue) {
                      if (textValue == null || textValue.isEmpty) {
                        return "empty_amount".tr();
                      } else {
                        if (Decimal.parse(textValue) > Decimal.parse(widget.maxAmount.UvalToVal())) {
                          return "exceed_amount".tr();
                        }
                      }
                      return null;
                    },
                  ),
                  const VerticalSpace(50),
                  PylonsBlueButton(onTap: onPayoutPressed, text: "payout".tr()),
                  const VerticalSpace(30)
                ],
              )) // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

  void onPayoutPressed() {
    if (_formKey.currentState!.validate()) {
      widget.onCallback?.call(amountController.text);
    }
  }
}
