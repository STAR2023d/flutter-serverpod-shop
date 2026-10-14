/// Normalizes Kenyan numbers (0712..., 0112..., +254712..., 712...) to
/// 2547XXXXXXXX / 2541XXXXXXXX. Returns null if invalid.
String? normalizeKenyanPhone(String input) {
  var p = input.replaceAll(RegExp(r'[\s\-+]'), '');
  if (p.startsWith('0')) {
    p = '254${p.substring(1)}';
  } else if (p.startsWith('7') || p.startsWith('1')) {
    p = '254$p';
  }
  return RegExp(r'^254[17]\d{8}$').hasMatch(p) ? p : null;
}
