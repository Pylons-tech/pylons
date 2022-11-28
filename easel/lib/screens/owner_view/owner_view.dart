import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/owner_view/viewmodels/owner_view_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class OwnerView extends StatefulWidget {
  final NFT nft;

  const OwnerView({required this.nft, Key? key}) : super(key: key);

  @override
  State<OwnerView> createState() => _OwnerViewState();
}

class _OwnerViewState extends State<OwnerView> {
  OwnerViewViewModel ownerViewViewModel = GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
