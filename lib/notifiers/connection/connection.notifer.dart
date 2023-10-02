import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  final controller = StreamController<ConnectivityResult>();
  final connectivity = Connectivity();

  // Add an initial event to the stream to get the current connectivity status
  connectivity.checkConnectivity().then(controller.add);

  final subscription =
      connectivity.onConnectivityChanged.listen(controller.add);

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});
