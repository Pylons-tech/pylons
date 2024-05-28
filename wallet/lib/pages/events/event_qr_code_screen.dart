import 'dart:convert';

import 'package:flutter/material.dart';

const jsonExecuteRecipe = '''
      {
        "creator": "",
        "cookbook_id": "",
        "recipe_id": "",
        "eventName": "",
        "eventPrice": "",
        "eventCurrency": "",
        "coinInputsIndex": 0
        }
        ''';
final jsonMap = jsonDecode(jsonExecuteRecipe) as Map;

class EventQrCodeScreen extends StatelessWidget {
  const EventQrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
