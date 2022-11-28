import 'package:easel_flutter/models/nft.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class OwnerView extends StatefulWidget {
  final NFT nft;

  const OwnerView({required this.nft, Key? key}) : super(key: key);

  @override
  State<OwnerView> createState() => _OwnerViewState();
}

class _OwnerViewState extends State<OwnerView> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
