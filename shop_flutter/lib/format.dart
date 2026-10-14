import 'dart:ui' show FontFeature;

import 'package:flutter/painting.dart' show FontWeight, TextStyle;

/// Bold numbers with equal-width digits so amounts line up in columns.
const amountStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontFeatures: [FontFeature.tabularFigures()],
);

/// 1240 -> "KES 1,240", 19.99 -> "KES 19.99"
String formatKes(num value) {
  final isWhole = value == value.roundToDouble();
  final text = value.toStringAsFixed(isWhole ? 0 : 2);
  final parts = text.split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
  return parts.length > 1 ? 'KES $whole.${parts[1]}' : 'KES $whole';
}

/// "13 Oct 2026, 15:42" in the device's local time.
String formatDate(DateTime dateTime) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final d = dateTime.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d.day} ${months[d.month - 1]} ${d.year}, ${two(d.hour)}:${two(d.minute)}';
}
