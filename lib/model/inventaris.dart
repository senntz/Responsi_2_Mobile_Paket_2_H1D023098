class Inventaris {
  String? id;
  String? nama;
  var harga;
  var jumlah;
  String? tanggalMasuk;
  String? tanggalKedaluwarsa;
  Inventaris({this.id, this.nama, this.harga, this.jumlah, this.tanggalMasuk, this.tanggalKedaluwarsa});
  
  factory Inventaris.fromJson(Map<String, dynamic> obj) {
    return Inventaris(
    id: obj['id'],
    nama: obj['nama'],
    harga: obj['harga'],
    jumlah: obj['jumlah'],
    tanggalMasuk: obj['tanggal_masuk'],
    tanggalKedaluwarsa: obj['tanggal_kedaluwarsa']);
  }
}