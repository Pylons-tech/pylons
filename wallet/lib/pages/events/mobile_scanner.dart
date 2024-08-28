import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../utils/string_utils.dart';
import '../detailed_asset_view/owner_view_view_model.dart';

class MobileQrScanner extends StatefulWidget {
  const MobileQrScanner({super.key});

  @override
  State<MobileQrScanner> createState() => _MobileQrScannerState();
}

class _MobileQrScannerState extends State<MobileQrScanner> {
  OwnerViewViewModel ownerViewViewModel = GetIt.I.get();
  Barcode? _barcode;


  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan Ticket!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }
    print('QR Code Data: ${value.displayValue}');

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;

        if (_barcode != null) {
          final qrData = _barcode!.displayValue ?? '';
          final dataParts = qrData.split(',');

          if (dataParts.length >= 2) {
            final cookbookId = dataParts[0];
            final recipeId = dataParts[1];


            final challenge = StringUtils.generateRandomString(16);


            stampTicket(cookbookId, recipeId, challenge);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid QR code data.')),
            );
          }
        }
      });
    }
  }

  Future<void> stampTicket(String cookbookId, String recipeId, String challenge) async {
    try {
      await ownerViewViewModel.stampTicket(
        enabled: true,
        cookbookId: cookbookId,
        recipeId: recipeId,
        challenge: challenge,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket with challenge $challenge stamped successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stamp ticket: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
