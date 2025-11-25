import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;
  const ProdukDetail({Key? key, required this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  late Produk _produk;

  @override
  void initState() {
    super.initState();
    _produk = widget.produk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk Zaki')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Kode : ${_produk.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 8),
            Text(
              "Nama : ${_produk.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8),
            Text(
              "Harga : Rp. ${_produk.hargaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () async {
            final result = await Navigator.push<Produk>(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: _produk),
              ),
            );
            if (result != null) {
              setState(() {
                _produk = result;
              });
              // return updated product to previous screen
              Navigator.of(context).pop(result);
            }
          },
        ),
        const SizedBox(width: 8),
        OutlinedButton(child: const Text("DELETE"), onPressed: confirmHapus),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        //tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            ProdukBloc.deleteProduk(id: int.parse(widget.produk.id!)).then(
              (value) => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProdukPage()),
                ),
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),

          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
