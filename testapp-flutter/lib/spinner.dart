import 'package:flutter/material.dart';

class Spinner extends StatefulWidget {
  const Spinner({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<Spinner> createState() => _SpinnerState();

  static void enable (BuildContext context) {
    final state = context.findAncestorStateOfType<_SpinnerState>();
    state?.enabled.value = true;
  }

  static void disable (BuildContext context) {
    final state = context.findAncestorStateOfType<_SpinnerState>();
    state?.enabled.value = false;
  }
}

class _SpinnerState extends State<Spinner> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> enabled = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            widget.child,
            AnimatedBuilder(animation: enabled, builder: (BuildContext context, Widget? child) {
              return enabled.value ?
              Align(alignment: Alignment.bottomRight,
                  child: SizedBox(height: 100, width: 100,
                      child: Image.asset('assets/images/gifs/loading.gif'))
              ) : Container();
            })
          ],
        )
    );
  }
}