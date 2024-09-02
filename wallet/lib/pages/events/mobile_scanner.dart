import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pylons_wallet/pages/events/stamping_screen.dart';
import '../../model/event.dart';
import '../detailed_asset_view/owner_view_view_model.dart';

class MobileQrScanner extends StatefulWidget {
  const MobileQrScanner({super.key});

  @override
  State<MobileQrScanner> createState() => _MobileQrScannerState();
}

class _MobileQrScannerState extends State<MobileQrScanner> {
  final OwnerViewViewModel ownerViewViewModel = GetIt.I.get<OwnerViewViewModel>();
  Barcode? _barcode;
  bool isScanning = true;

  Widget _buildBarcodeDisplay(Barcode? barcode) {
    if (barcode == null) {
      return const Text(
        'Scan Ticket!',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      );
    }
    return Text(
      barcode.displayValue ?? 'No display value.',
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    if (!isScanning) return;

    setState(() {
      if (barcodeCapture.barcodes.isNotEmpty) {
        _barcode = barcodeCapture.barcodes[0];
        final qrData = _barcode?.displayValue ?? '';
        final dataParts = qrData.split(',');

        if (dataParts.length >= 2) {
          final cookbookId = dataParts[0];
          final recipeId = dataParts[1];
          final challenge = dataParts.length > 2 ? dataParts[2] : '';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StampingScreen(
                cookbookId: cookbookId,
                recipeId: recipeId,
                challenge: challenge,
                ownerViewViewModel: ownerViewViewModel,
                event: Events(eventName: 'Event Name', thumbnail: 'Thumbnail URL', description: 'Description'),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid QR code data.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No barcodes detected.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Scanner'),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
            scanWindow: Rect.fromLTWH(
              0,
              0,
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              height: 100,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: _buildBarcodeDisplay(_barcode),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
