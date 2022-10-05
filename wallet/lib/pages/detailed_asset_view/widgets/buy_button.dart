import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/utils/constants.dart';

const fixedDecimal = 4;
const btcAsset = "assets/images/icons/ico_btc.png";

class BuyButton extends StatelessWidget {
  final NFT nft;
  final double usdAmount;
  const BuyButton({Key? key, required this.nft, required this.usdAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BuyButtonClipper(),
      child: Container(
        color: AppColors.kButtonColor.withOpacity(0.7),
        height: 65,
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.kButtonBuyNowColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          'Buy for ${double.parse(nft.price).toStringAsFixed(fixedDecimal)}',
                          maxLines: 2,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Image.asset(
                        btcAsset,
                        height: 25,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                  Text(
                    usdAmount.toStringAsFixed(fixedDecimal),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 30);
    path.lineTo(30, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 30);
    path.lineTo(size.width - 30, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
