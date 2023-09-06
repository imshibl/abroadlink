import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshNotifierProvider =
    StateNotifierProvider<RefreshNotifier, bool>((ref) {
  return RefreshNotifier();
});

class RefreshNotifier extends StateNotifier<bool> {
  RefreshNotifier() : super(false);

  void refresh() {
    Future.delayed(const Duration(seconds: 1), () {
      state = !state;
    });
  }
}
