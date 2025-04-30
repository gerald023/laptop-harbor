import 'package:flutter/material.dart';

class SpecificationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  SpecificationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}