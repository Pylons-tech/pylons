import 'package:flutter/material.dart';

class PylonsBlueButtonLoading extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final ValueNotifier<bool> loader;
  final bool enabled;

  const PylonsBlueButtonLoading(
      {Key? key,
      required this.onTap,
      this.text = "",
      required this.loader,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: loader,
        builder: (context, loading, child) {
          return ElevatedButton(
            onPressed: isUserAllowedToTap(loading: loading) ? onTap : null,
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (loading)
                    const SizedBox(
                        width: 40,
                        height: 30,
                        child: CircularProgressIndicator.adaptive()),
                  if (!loading)
                    Expanded(
                      child: Text(text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                ],
              ),
            ),
          );
        });
  }

  bool isUserAllowedToTap({required bool loading}) => enabled && !loading;
}
