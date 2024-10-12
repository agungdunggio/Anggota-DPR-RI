import 'dart:async';

import 'package:flutter/material.dart';
import 'package:individual_asessment/components/member_tile.dart';
import 'package:individual_asessment/data/models/members.dart';
import 'package:individual_asessment/components/filter_tile.dart';
import 'package:individual_asessment/data/service/service_json.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  late Future<List<Members>> futureListMembers;
  List<Members> allMemberList = [];
  List<Members> filteredMemberList = [];

  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  bool _isFilterVisible = false;

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        String searchText = searchController.text.toLowerCase();

        if (searchText.isEmpty) {
          filteredMemberList = allMemberList;
        } else {
          filteredMemberList = allMemberList.where((member) {
            return member.nama.toLowerCase().contains(searchText);
          }).toList();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    futureListMembers = ServiceJson().fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Members>>(
        future: futureListMembers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No data available',
                    style: TextStyle(fontSize: 18, color: Colors.grey)));
          } else {
            if (allMemberList.isEmpty) {
              allMemberList = snapshot.data!;
              filteredMemberList = allMemberList;
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daftar Anggota',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFilterVisible = !_isFilterVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _isFilterVisible ? 152 : 0,
                  child: _isFilterVisible
                      ? FilterTile(members: filteredMemberList)
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            _onSearchChanged();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMemberList.length,
                    itemBuilder: (context, index) {
                      return MemberTile(
                        member: filteredMemberList[index],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
