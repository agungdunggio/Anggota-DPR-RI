import 'package:flutter/material.dart';

class FilterChipItem extends StatefulWidget {
  final String label;
  const FilterChipItem({super.key, required this.label});

  @override
  _FilterChipItemState createState() => _FilterChipItemState();
}

class _FilterChipItemState extends State<FilterChipItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.label),
      selectedColor: Colors.grey[500],
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          isSelected = selected;
        });
      },
    );
  }
}
