import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/filter_users.model.dart';

final filterUsersNotifierProvider =
    StateNotifierProvider<FilterUsersNotifierProvider, FilterUsersModel>((ref) {
  return FilterUsersNotifierProvider();
});

class FilterUsersNotifierProvider extends StateNotifier<FilterUsersModel> {
  FilterUsersNotifierProvider()
      : super(
          const FilterUsersModel(
              showLocalUsersOnly: false,
              radius: 50,
              sortByDistance: false,
              homeCountry: null,
              destinationCountry: null),
        ); // Set an initial value for max distance

  void updateMaxDistance(int newMaxDistance) {
    state = state.copyWith(radius: newMaxDistance);
  }

  void updateShowLocalUsersOnly(bool showLocalUsersOnly) {
    state = state.copyWith(
      showLocalUsersOnly: showLocalUsersOnly,
    );
  }

  void addHomeCountry(String homeCountry) {
    state = state.copyWith(homeCountry: homeCountry);
  }

  void removeHomeCountry() {
    state = state.copyWith(homeCountry: null);
  }

  void addDestinationCountry(String destinationCountry) {
    state = state.copyWith(destinationCountry: destinationCountry);
  }

  void removeDestinationCountry() {
    state = state.copyWith(destinationCountry: null);
  }

  void resetAllFilters() {
    state = const FilterUsersModel(
        showLocalUsersOnly: false,
        radius: 50,
        sortByDistance: false,
        homeCountry: null,
        destinationCountry: null);
  }
}
