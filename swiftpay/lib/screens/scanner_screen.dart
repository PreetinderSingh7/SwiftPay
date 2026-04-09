// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:provider/provider.dart';
// import '../services/api_service.dart';
// import '../models/product_model.dart';
// import '../providers/cart_provider.dart';

// class ScannerScreen extends StatefulWidget {
//   const ScannerScreen({super.key});

//   @override
//   State<ScannerScreen> createState() => _ScannerScreenState();
// }

// class _ScannerScreenState extends State<ScannerScreen> {
//   bool _isScanning = false;
//   String? _lastBarcode;

//   Future<void> _scanBarcode() async {
//     try {
//       setState(() => _isScanning = true);

//       String barcode = await FlutterBarcodeScanner.scanBarcode(
//         '#1A73E8',
//         'Cancel',
//         true,
//         ScanMode.BARCODE,
//       );

//       if (barcode == '-1') {
//         setState(() => _isScanning = false);
//         return;
//       }

//       setState(() => _lastBarcode = barcode);

//       // Fetch product
//       final result = await ApiService.getProductByBarcode(barcode);

//       setState(() => _isScanning = false);

//       if (result['success'] == true) {
//         final product = Product.fromJson(result['data']);
//         _showProductDialog(product);
//       } else {
//         _showError(result['error'] ?? 'Product not found');
//       }
//     } catch (e) {
//       setState(() => _isScanning = false);
//       _showError('Scanner error: $e');
//     }
//   }

//   void _showProductDialog(Product product) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1A73E8).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.inventory_2_outlined,
//                       color: Color(0xFF1A73E8), size: 30),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(product.name,
//                           style: const TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                       Text(product.category,
//                           style: const TextStyle(
//                               color: Colors.grey, fontSize: 13)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Price:', style: TextStyle(color: Colors.grey)),
//                 Text('₹${product.price.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Tax (GST):',
//                     style: TextStyle(color: Colors.grey)),
//                 Text('${(product.taxRate * 100).toStringAsFixed(0)}%',
//                     style: const TextStyle(fontSize: 14)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Stock:', style: TextStyle(color: Colors.grey)),
//                 Text('${product.stockCount} available',
//                     style: const TextStyle(
//                         color: Colors.green, fontSize: 14)),
//               ],
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.add_shopping_cart),
//                 label: const Text('Add to Cart',
//                     style: TextStyle(fontSize: 16)),
//                 onPressed: () {
//                   Provider.of<CartProvider>(ctx, listen: false)
//                       .addProduct(product);
//                   Navigator.pop(ctx);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('${product.name} added to cart!'),
//                       backgroundColor: Colors.green,
//                       duration: const Duration(seconds: 2),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: const Text('Scan Product'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.grey.withOpacity(0.15),
//                         blurRadius: 20)
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.qr_code_scanner,
//                   size: 100,
//                   color: Color(0xFF1A73E8),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               const Text(
//                 'Point your camera at a\nproduct barcode to scan',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               if (_lastBarcode != null) ...[
//                 const SizedBox(height: 16),
//                 Text(
//                   'Last scanned: $_lastBarcode',
//                   style: const TextStyle(
//                       fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//               const SizedBox(height: 40),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   icon: _isScanning
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                               color: Colors.white, strokeWidth: 2))
//                       : const Icon(Icons.qr_code_scanner),
//                   label: Text(_isScanning ? 'Scanning...' : 'Start Scanner',
//                       style: const TextStyle(fontSize: 16)),
//                   onPressed: _isScanning ? null : _scanBarcode,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isProcessing = false;
  String? _lastBarcode;

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return; // prevent multiple triggers
    setState(() => _isProcessing = true);

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      setState(() => _isProcessing = false);
      return;
    }

    final barcode = barcodes.first.rawValue ?? '';
    setState(() => _lastBarcode = barcode);

    try {
      final result = await ApiService.getProductByBarcode(barcode);

      setState(() => _isProcessing = false);

      if (result['success'] == true) {
        final product = Product.fromJson(result['data']);
        _showProductDialog(product);
      } else {
        _showError(result['error'] ?? 'Product not found');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError('Scanner error: $e');
    }
  }

  void _showProductDialog(Product product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A73E8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.inventory_2_outlined,
                      color: Color(0xFF1A73E8), size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(product.category,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price:', style: TextStyle(color: Colors.grey)),
                Text('₹${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tax (GST):',
                    style: TextStyle(color: Colors.grey)),
                Text('${(product.taxRate * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Stock:', style: TextStyle(color: Colors.grey)),
                Text('${product.stockCount} available',
                    style: const TextStyle(
                        color: Colors.green, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart',
                    style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Provider.of<CartProvider>(ctx, listen: false)
                      .addProduct(product);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Scan Product'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: _onDetect,
              fit: BoxFit.cover,
            ),
          ),
          if (_lastBarcode != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Last scanned: $_lastBarcode',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
