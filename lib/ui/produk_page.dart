// ...existing code...
import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final List<Produk> _items = [
    Produk(id: "1", kodeProduk: 'A001', namaProduk: 'Kamera', hargaProduk: 5000000),
    Produk(id: "2", kodeProduk: 'A002', namaProduk: 'Kulkas', hargaProduk: 2500000),
    Produk(id: "3", kodeProduk: 'A003', namaProduk: 'Mesin Cuci', hargaProduk: 2000000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk Zaki'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                final result = await Navigator.push<Produk>(
                  context,
                  MaterialPageRoute(builder: (context) => const ProdukForm()),
                );
                if (result != null) {
                  setState(() {
                    _items.add(result);
                  });
                }
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                // TODO: implement logout
              },
            )
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final produk = _items[index];
          return ItemProduk(
            produk: produk,
            onDeleted: () {
              setState(() {
                _items.removeAt(index);
              });
            },
            onUpdated: (updated) {
              setState(() {
                _items[index] = updated;
              });
            },
          );
        },
      ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback? onDeleted;
  final ValueChanged<Produk>? onUpdated;

  const ItemProduk({
    Key? key,
    required this.produk,
    this.onDeleted,
    this.onUpdated,
  }) : super(key: key);

  String _formatHarga(num? harga) {
    final h = (harga ?? 0).toDouble();
    if (h % 1 == 0) {
      return 'Rp ${h.toStringAsFixed(0)}';
    }
    return 'Rp ${h.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final nama = produk.namaProduk ?? '';
    final hargaText = _formatHarga(produk.hargaProduk);

    return Card(
      child: ListTile(
        title: Text(nama),
        subtitle: Text(hargaText),
        onTap: () async {
          final result = await Navigator.push<dynamic>(
            context,
            MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
          );

          // ProdukDetail returns `true` when item was deleted.
          if (result == true) {
            if (onDeleted != null) onDeleted!();
          }

          // ProdukDetail currently updates its local copy when editing.
          // If you change ProdukDetail to return the updated Produk, handle it here:
          if (result is Produk && onUpdated != null) {
            onUpdated!(result);
          }
        },
      ),
    );
  }
}