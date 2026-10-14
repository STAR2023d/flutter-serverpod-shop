import 'package:flutter/foundation.dart';

/// Indexes of the bottom navigation tabs.
abstract final class Tabs {
  static const shop = 0;
  static const cart = 1;
  static const orders = 2;
  static const account = 3;
}

/// The selected tab. Any screen can switch tabs by setting `tabIndex.value`.
final ValueNotifier<int> tabIndex = ValueNotifier<int>(Tabs.shop);

/// Bump this to make the Shop tab reload (e.g. after stock changed).
final ValueNotifier<int> shopRefreshTick = ValueNotifier<int>(0);
