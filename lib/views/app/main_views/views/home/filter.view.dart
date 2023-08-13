import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../notifiers/home_notifier/filter_users.notifier.dart';

class FilterView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const FilterView());
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
        ),
        body: Column(
          children: [
            Consumer(builder: (context, ref, _) {
              final maxDistance = ref.watch(maxDistanceNotifierProvider);
              return Slider(
                value: maxDistance.toDouble(),
                onChanged: (newValue) {
                  ref
                      .read(maxDistanceNotifierProvider.notifier)
                      .updateMaxDistance(newValue.toInt());
                },
                min: 10,
                max: 150,
                divisions: 7,
                label: '$maxDistance km',
                activeColor: Colors.white,
              );
            }),
          ],
        ));
  }
}
