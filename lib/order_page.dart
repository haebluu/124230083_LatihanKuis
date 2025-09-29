import 'package:flutter/material.dart';
import 'package:latihankuis/data/food_data.dart';

class DetailPage extends StatefulWidget {
  final int index;
  const DetailPage({super.key, required this.index});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _qtyController = TextEditingController();
  int _total = 0;

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  int _parsePrice(String priceString) {
    final onlyDigits = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    if (onlyDigits.isEmpty) return 0;
    return int.tryParse(onlyDigits) ?? 0;
  }

  String _formatCurrency(int value) {
    String s = value.toString();
    String result = '';
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      result = s[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.' + result;
        count = 0;
      }
    }
    return 'Rp $result';
  }

  void _computeTotal() {
    final pricePerItem = _parsePrice(FoodList[widget.index].price);
    final qtyText = _qtyController.text.trim();
    final qty = int.tryParse(qtyText) ?? 0;
    setState(() {
      _total = pricePerItem * qty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final food = FoodList[widget.index];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), 
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD5E0), 
        title: const Text('Detail Order', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                food.imageUrl,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, err, st) => Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                  ),
                ),
                loadingBuilder: (context, child, loading) {
                  if (loading == null) return child;
                  return Container(
                    height: 220,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.price,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan Jumlah',
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onFieldSubmitted: (_) => _computeTotal(),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE0158), 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    _computeTotal();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Jumlah diperbarui')),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Total Harga: ${_formatCurrency(_total)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
