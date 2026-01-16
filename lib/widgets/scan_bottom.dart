import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.filter_center_focus),
      onPressed: () async {
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);

        const String fakeGeo = 'geo:39.7259555,2.9110725';
        final ScanModel geoScan = await scanListProvider.nouScan(fakeGeo);
        launchURL(context, geoScan);

        const String fakeHttp = 'http://paucasesnovescifp.cat';
        final ScanModel httpScan = await scanListProvider.nouScan(fakeHttp);
        launchURL(context, httpScan);

        final String? realScan = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScannerScreen()),
        );

        if (realScan == null || realScan.isEmpty) return;

        final ScanModel realScanModel =
            await scanListProvider.nouScan(realScan);
        launchURL(context, realScanModel);
      },
    );
  }
}

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isPopped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, null),
          ),
        ],
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isPopped) return;

          final barcodes = capture.barcodes;
          if (barcodes.isEmpty) return;

          final value = barcodes.first.rawValue;
          if (value == null || value.isEmpty) return;

          _isPopped = true;
          Navigator.pop(context, value);
        },
      ),
    );
  }
}
