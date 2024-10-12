// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://www.dpr.go.id/rest/?method=getSemuaAnggota&tipe=json';

  // Fungsi untuk mengambil data tanpa Bearer Token dan mencetak hasilnya
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // Tidak menambahkan header Authorization
        },
      );

      if (response.statusCode == 200) {
        // Jika respons berhasil, parse JSON dan cetak
        final data = json.decode(response.body);
        print('Data fetched successfully: $data');
      } else {
        // Jika respons gagal, cetak status code
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani error lainnya dan cetak error
      print('Error fetching data: $e');
    }
  }
}
