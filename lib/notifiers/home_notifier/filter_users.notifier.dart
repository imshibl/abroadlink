import 'package:flutter_riverpod/flutter_riverpod.dart';

final maxDistanceNotifierProvider =
    StateNotifierProvider<MaxDistanceNotifier, int>((ref) {
  return MaxDistanceNotifier();
});

class MaxDistanceNotifier extends StateNotifier<int> {
  MaxDistanceNotifier() : super(50); // Set an initial value for max distance

  void updateMaxDistance(int newMaxDistance) {
    state = newMaxDistance;
  }
}
