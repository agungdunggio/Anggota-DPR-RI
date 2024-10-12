import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:individual_asessment/data/models/detail_member.dart';
import 'package:individual_asessment/data/models/members.dart';

class MemberService {
  final String apiUrl =
      'https://www.dpr.go.id/rest/?method=getSemuaAnggota&tipe=json'; // Ganti dengan URL API Anda
  final String apiUrlDetail =
      'www.dpr.go.id/rest/?method=getDataAnggota&id='; // Ganti dengan URL API Anda

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept-Language': 'en-US,en;q=0.5'
    };
  }

  // Fungsi untuk mendapatkan semua members dari API
  Future<List<Members>> getMembers() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: _buildHeaders(),
      );

      // Mengecek apakah response sukses (kode status 200)
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        // Mengonversi setiap item dari JSON ke objek Member
        List<Members> members =
            body.map((dynamic item) => Members.fromJson(item)).toList();

        return members;
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  // Fungsi untuk mendapatkan satu member berdasarkan ID dari API
  Future<MemberDetail> getMemberById(String id) async {
    final response = await http.get(
      Uri.parse('$apiUrlDetail$id&tipe=json'),
      headers: _buildHeaders(),
    );

    if (response.statusCode == 200) {
      return MemberDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load member');
    }
  }

  // // Fungsi untuk menambah member baru ke API
  // Future<void> addMember(Members member) async {
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: membersToJson(member), // Mengonversi objek Member menjadi JSON
  //   );

  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to add member');
  //   }
  // }

  // // Fungsi untuk mengupdate member berdasarkan ID
  // Future<void> updateMember(String id, Members member) async {
  //   final response = await http.put(
  //     Uri.parse('$apiUrl/$id'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: membersToJson(member), // Mengonversi objek Member menjadi JSON
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to update member');
  //   }
  // }

  // // Fungsi untuk menghapus member berdasarkan ID
  // Future<void> deleteMember(String id) async {
  //   final response = await http.delete(
  //     Uri.parse('$apiUrl/$id'),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to delete member');
  //   }
  // }
}
