import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class NFTViewWidget extends StatefulWidget {
  const NFTViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NFTViewWidget> createState() => _NFTViewWidgetState();
}

class _NFTViewWidgetState extends State<NFTViewWidget> with SingleTickerProviderStateMixin {

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
            onPressed: (){
              Navigator.pop(context);
            },
          )
      ),
      body: const Align(
        child: Image(
          image: CachedNetworkImageProvider(kImage),
          width: double.infinity,
          fit: BoxFit.cover,
        )
      )
    );
  }
}
