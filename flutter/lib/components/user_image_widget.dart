import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImageWidget extends StatelessWidget {
  final String imageUrl;
  final double radius;
  const UserImageWidget({Key? key, required this.imageUrl, this.radius = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(imageUrl),
      radius: radius,
    );
  }
}
