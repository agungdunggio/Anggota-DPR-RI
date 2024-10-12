class DaftarAkd {
  final List<String> akd;

  DaftarAkd({required this.akd});

  factory DaftarAkd.fromJson(dynamic json) {
    if (json is String) {
      return DaftarAkd(akd: [json]); // Jika hanya satu item, jadikan list
    } else if (json is List) {
      return DaftarAkd(akd: List<String>.from(json));
    } else {
      throw Exception('Invalid akd data');
    }
  }
}