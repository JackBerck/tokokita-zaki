class Produk {
  String? id;
  String? kodeProduk;
  String? namaProduk;
  double? hargaProduk;
  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});
  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'].toString(),
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: obj['harga'] != null
          ? double.tryParse(obj['harga'].toString()) ?? 0
          : 0,
    );
  }
}
