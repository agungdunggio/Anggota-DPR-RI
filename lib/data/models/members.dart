import 'package:individual_asessment/data/models/daftar_akd.dart';

class Members {
  final String noAnggota;
  final String id;
  final String nama;
  final String fraksi;
  final String dapil;
  final String foto;
  final DaftarAkd daftarAkd;

  Members({
    required this.noAnggota,
    required this.id,
    required this.nama,
    required this.fraksi,
    required this.dapil,
    required this.foto,
    required this.daftarAkd,
  });

  factory Members.fromJson(Map<String, dynamic> json) {
    return Members(
      noAnggota: json['no_anggota'],
      id: json['id'],
      nama: json['nama'],
      fraksi: json['fraksi'],
      dapil: json['dapil'],
      foto: json['foto'],
      daftarAkd: DaftarAkd.fromJson(json['daftar_akd']['akd']),
    );
  }
}