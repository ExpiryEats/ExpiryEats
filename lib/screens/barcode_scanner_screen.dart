import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late MobileScannerController cameraController;
  String? _scannedBarcode;
  bool _torchEnabled = false;
  bool _isScanComplete = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      torchEnabled: _torchEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: _torchEnabled
                ? const Icon(Icons.flash_on, color: Colors.yellow)
                : const Icon(Icons.flash_off, color: Colors.grey),
            onPressed: () {
              setState(() {
                _torchEnabled = !_torchEnabled;
              });
              cameraController.toggleTorch();
            },
          ),
          if (_scannedBarcode != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed:() {
                Navigator.pop(context, _scannedBarcode);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture capture) {
                if (_isScanComplete) return;

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? barcode = barcodes.first.rawValue;
                  if (barcode != null && mounted) {
                    setState(() {
                      _isScanComplete = true;
                      _scannedBarcode = barcode;
                    });
                    HapticFeedback.vibrate();
                  }
                }
              },
            ),
          ),
          if (_scannedBarcode != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
              children: [
                Text(
                'Scanned Code: $_scannedBarcode',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _scannedBarcode);
                },
                child: const Text('Use this Barcode'),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () {
                setState(() {
                  _scannedBarcode = null;
                  _isScanComplete = false;
                });
              },
              child: const Text('Scan Again'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
