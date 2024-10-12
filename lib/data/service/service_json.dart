import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:individual_asessment/data/models/detail_member.dart';
import 'package:individual_asessment/data/models/members.dart';

class ServiceJson {
  // Fungsi untuk fetch list Anggota
  Future<List<Members>> fetchMembers() async {
    // Membaca file dari assets
    final String response =
        await rootBundle.loadString('asset/json/members.json');

    // Mengurai JSON menjadi objek Dart
    final jsonResponse = json.decode(response);
    List<dynamic> data = jsonResponse['anggota']['item'];

    return data.map((json) => Members.fromJson(json)).toList();
  }

  Future<MemberDetail> fetchMemberDetail() async {
    // Read the JSON file from assets
    final String response =
        await rootBundle.loadString('asset/json/member_detail.json');

    // Decode the JSON into a Dart object
    final jsonResponse = json.decode(response);

    // Create and return a MemberDetail object
    return MemberDetail.fromJson(jsonResponse);
  }
}
