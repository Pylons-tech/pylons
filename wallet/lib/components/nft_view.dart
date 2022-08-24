import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NFTViewWidget extends StatefulWidget {
  final String imageUrl;
  const NFTViewWidget({
    required this.imageUrl,
  }) : super();

  @override
  State<NFTViewWidget> createState() => _NFTViewWidgetState();
}

class _NFTViewWidgetState extends State<NFTViewWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Align(
            child: Image(
          image: CachedNetworkImageProvider(widget.imageUrl),
          width: double.infinity,
          fit: BoxFit.cover,
        )));
  }
}
