import 'package:cosmos_utils/cosmos_utils.dart';
import 'package:flutter/material.dart';

void notImplemented(BuildContext context) {
  logError(UnimplementedError('not implemented'), StackTrace.current);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: const Text('Not implemented'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        )
      ],
    ),
  );
}
