import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class CollectionViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tileWidth = (MediaQuery.of(context).size.width - 30) / 3;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      mainAxisSpacing: 7.0,
      crossAxisSpacing: 7.0,
      children: List<Widget>.generate(16, (index) {
        return GridTile(
          child: Card(
            color: const Color(0xFFDFDFDF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image(image: const CachedNetworkImageProvider(kImage2), width: tileWidth * 2, height: tileWidth * 2 + 2, fit: BoxFit.cover),
            ),
          ),
        );
      }),
    );
  }
}
