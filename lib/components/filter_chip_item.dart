import 'package:flutter/material.dart';

class FilterChipItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  _FilterChipItemState createState() => _FilterChipItemState();
}

class _FilterChipItemState extends State<FilterChipItem> {
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.label),
      labelStyle: TextStyle(
        color: widget.isSelected ? Colors.white : Colors.brown[800],
      ),
      backgroundColor: const Color(0xFFD6C0B3),
      selectedColor: Colors.grey[500],
      selected: widget.isSelected,
      onSelected: (isSelected) {
        widget.onSelected(isSelected);
      },
    );
  }
}
