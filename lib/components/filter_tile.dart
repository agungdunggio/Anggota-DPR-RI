import 'package:flutter/material.dart';
import 'package:individual_asessment/components/filter_chip_item.dart';
import 'package:individual_asessment/data/models/members.dart';

class FilterTile extends StatefulWidget {
  final List<Members> members;
  final List<String> selectedDapil;
  final List<String> selectedFraksi;
  final Function(List<String>, List<String>) onFilterSelected;

  const FilterTile({
    super.key,
    required this.members,
    required this.selectedDapil,
    required this.selectedFraksi,
    required this.onFilterSelected,
  });

  @override
  _FilterTileState createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  List<String> dapils = [];
  List<String> fraksis = [];
  late List<String> selectedDapil;
  late List<String> selectedFraksi;

  @override
  void initState() {
    super.initState();

    // Mengambil data unik dari anggota
    dapils = widget.members.map((member) => member.dapil).toSet().toList();
    fraksis = widget.members.map((member) => member.fraksi).toSet().toList();

    // Menginisialisasi state dari parameter yang diterima
    selectedDapil = List.from(widget.selectedDapil);
    selectedFraksi = List.from(widget.selectedFraksi);
  }

  void _onFilterChanged(String filter, bool isDapil) {
    setState(() {
      if (isDapil) {
        if (selectedDapil.contains(filter)) {
          selectedDapil.remove(filter);
        } else {
          selectedDapil.add(filter);
        }
      } else {
        if (selectedFraksi.contains(filter)) {
          selectedFraksi.remove(filter);
        } else {
          selectedFraksi.add(filter);
        }
      }

      // Kirim pilihan filter dapil dan fraksi ke parent
      widget.onFilterSelected(selectedDapil, selectedFraksi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                        child: FilterChipItem(
                          label: dapil,
                          isSelected: selectedDapil.contains(dapil),
                          onSelected: (selected) =>
                              _onFilterChanged(dapil, true),
                        ),
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
                        child: FilterChipItem(
                          label: fraksi,
                          isSelected: selectedFraksi.contains(fraksi),
                          onSelected: (selected) =>
                              _onFilterChanged(fraksi, false),
                        ),
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
