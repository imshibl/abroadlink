import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshHomeNotifierProvider =
    StateNotifierProvider<RefreshHome, bool>((ref) {
  return RefreshHome();
});

class RefreshHome extends StateNotifier<bool> {
  RefreshHome() : super(false);

  void refreshHome() {
    Future.delayed(const Duration(seconds: 1), () {
      state = !state;
    });
  }
}
