import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Nft3dWidget extends StatefulWidget {
  final String url;
  final bool cameraControls;
  final Color backgroundColor;

  const Nft3dWidget({Key? key, required this.backgroundColor, required this.url, required this.cameraControls}) : super(key: key);

  @override
  _Nft3dWidgetState createState() => _Nft3dWidgetState();
}

class _Nft3dWidgetState extends State<Nft3dWidget> {
  @override
  Widget build(BuildContext context) {
    return ModelViewer(

      backgroundColor: widget.backgroundColor,
      src: widget.url,
      ar: false,
      autoRotate: false,
      cameraControls: widget.cameraControls,
    );
  }
}
