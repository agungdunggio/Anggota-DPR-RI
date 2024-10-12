import 'package:flutter/material.dart';
import 'package:individual_asessment/components/filter_chip_item.dart';
import 'package:individual_asessment/data/models/members.dart';

class FilterTile extends StatefulWidget {
  final List<Members> members; // Menambahkan parameter untuk anggota

  const FilterTile(
      {super.key,
      required this.members}); // Mengharuskan daftar anggota di passing

  @override
  _FilterTileState createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  List<String> dapils = [];
  List<String> fraksis = [];

  @override
  void initState() {
    super.initState();

    // Mengambil data unik dari anggota
    dapils = widget.members.map((member) => member.dapil).toSet().toList();
    fraksis = widget.members.map((member) => member.fraksi).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 25.0), // Margin kiri dan kanan yang sesuai
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dapil Filter
          const Text('Dapil:', style: TextStyle(fontWeight: FontWeight.bold)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dapils
                  .map((dapil) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: FilterChipItem(label: dapil),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Fraksi Filter
          const Text('Fraksi:', style: TextStyle(fontWeight: FontWeight.bold)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: fraksis
                  .map((fraksi) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: FilterChipItem(label: fraksi),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

















/* import 'package:flutter/material.dart';
import 'package:individual_asessment/data/models/members.dart';

class FilterTile extends StatefulWidget {
  final List<Members> members; // Menambahkan parameter untuk anggota

  const FilterTile(
      {super.key,
      required this.members}); // Mengharuskan daftar anggota di passing

  @override
  _FilterTileState createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  List<bool> selectedDapils = [];
  List<bool> selectedFraksis = [];
  // List<bool> selectedAKDs = [];

  late List<String> dapils;
  late List<String> fraksis;
  // late List<String> akds;

  @override
  void initState() {
    super.initState();

    // Mengambil data unik dari anggota
    dapils = widget.members.map((member) => member.dapil).toSet().toList();
    fraksis = widget.members.map((member) => member.fraksi).toSet().toList();
    // akds = widget.members
    //     .expand((member) {
    //       if (member.daftarAkd is String) {
    //         return [member.daftarAkd as String];
    //       } else if (member.daftarAkd is List) {
    //         return member.daftarAkd as List<String>;
    //       }
    //       return [];
    //     })
    //     .toSet()
    //     .toList();

    // Menginisialisasi status terpilih
    selectedDapils = List.generate(dapils.length, (index) => false);
    selectedFraksis = List.generate(fraksis.length, (index) => false);
    // selectedAKDs = List.generate(akds.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 25.0), // Margin kiri dan kanan yang sesuai
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dapil Filter
          const Text('Dapil:', style: TextStyle(fontWeight: FontWeight.bold)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                dapils.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0), // Spasi antar kartu
                    child: ChoiceChip(
                      label: Text(dapils[index]),
                      selected: selectedDapils[index],
                      onSelected: (bool selected) {
                        setState(() {
                          selectedDapils[index] = selected;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Fraksi Filter
          const Text('Fraksi:', style: TextStyle(fontWeight: FontWeight.bold)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                fraksis.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0), // Spasi antar kartu
                    child: ChoiceChip(
                      label: Text(fraksis[index]),
                      selected: selectedFraksis[index],
                      onSelected: (bool selected) {
                        setState(() {
                          selectedFraksis[index] = selected;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // // AKD Filter
          // const Text('AKD:', style: TextStyle(fontWeight: FontWeight.bold)),
          // Wrap(
          //   spacing: 10.0,
          //   children: List.generate(akds.length, (index) {
          //     return ChoiceChip(
          //       label: Text(akds[index]),
          //       selected: selectedAKDs[index],
          //       onSelected: (bool selected) {
          //         setState(() {
          //           selectedAKDs[index] = selected;
          //         });
          //       },
          //     );
          //   }),
          // ),
        ],
      ),
    );
  }
}
*/
