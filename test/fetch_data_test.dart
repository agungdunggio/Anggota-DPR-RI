// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:individual_asessment/data/models/members.dart';

// void main() {
//   TestWidgetsFlutterBinding
//       .ensureInitialized(); // Inisialisasi binding test widget
//   // Data JSON yang akan diujikan
//   const mockJson = '''
//   {
//     "item": [
//       {
//         "no_anggota": "1",
//         "id": "1320",
//         "nama": "H. IRMAWAN, S.Sos., M.M.",
//         "fraksi": "Fraksi Partai Kebangkitan Bangsa",
//         "dapil": "ACEH I",
//         "foto": "/doksigota/photo/1320.jpg",
//         "daftar_akd": {
//           "akd": "Komisi V"
//         }
//       },
//       {
//         "no_anggota": "2",
//         "id": "1745",
//         "nama": "H. RUSLAN DAUD (HRD)",
//         "fraksi": "Fraksi Partai Kebangkitan Bangsa",
//         "dapil": "ACEH II",
//         "foto": "/doksigota/photo/1745.jpg",
//         "daftar_akd": {
//           "akd": "Komisi V"
//         }
//       }
//     ]
//   }
//   ''';

//   // Fungsi untuk mock data
//   void mockLoadString() {
//     // Setiap kali rootBundle.loadString dipanggil, kita akan return mockJson
//     rootBundle.loadString = (String key) async {
//       return mockJson;
//     };
//   }

//   group('MemberPage Test', () {
//     setUp(() {
//       mockLoadString(); // Menyiapkan mock data sebelum setiap test
//     });

//     test('Fetch members successfully and parse JSON correctly', () async {
//       List<Members> members = [];
//       Future<void> fetchMembers() async {
//         // Membaca file dari assets
//         final String response =
//             await rootBundle.loadString('assets/members.json');

//         // Mengurai JSON menjadi objek Dart
//         final data = json.decode(response);

//         setState(() {
//           members = (data['item'] as List)
//               .map((json) => Members.fromJson(json))
//               .toList();
//         });

//         // Memeriksa apakah jumlah member sesuai dengan data JSON
//         expect(members.length, 2);

//         // Memeriksa apakah data member pertama benar-benar sesuai
//         final firstMember = members[0];
//         expect(firstMember.nama, 'H. IRMAWAN, S.Sos., M.M.');
//         expect(firstMember.fraksi, 'Fraksi Partai Kebangkitan Bangsa');
//         expect(firstMember.dapil, 'ACEH I');
//       }
//     });
//   });
// }
