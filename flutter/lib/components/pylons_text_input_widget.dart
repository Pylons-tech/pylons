import 'package:flutter/material.dart';

class PylonsTextInput extends StatelessWidget {
  const PylonsTextInput({
    Key? key,
    required this.controller,
    required this.label,
    this.disabled = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
          enabled: !disabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),

          // filled: true,
          // labelText: "Username",
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white70),
    );
  }
}
