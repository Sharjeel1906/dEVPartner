import 'package:flutter/material.dart';
import 'theme.dart';

Widget customDataContainer({
  required String data, // the text to display
  required String labelText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Label
      Text(
        labelText,
        style: TextStyle(
          color: C.textLabel,
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 6),
      // Container
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: C.border,
          ),
        ),
        child: Text(
          data,
          style: TextStyle(
            color: C.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}