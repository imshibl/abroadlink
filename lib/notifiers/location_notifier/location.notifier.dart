import 'dart:math';

import 'package:abroadlink/models/location.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../apis/location_api/location.api.dart';

final locationNotifierProvider =
    StateNotifierProvider<LocationNotifier, LocationModel>((ref) {
  return LocationNotifier(
    locationSerices: ref.watch(locationAPIServiceProvider),
  );
});

class LocationNotifier extends StateNotifier<LocationModel> {
  LocationAPIServices locationSerices;
  LocationNotifier({required this.locationSerices})
      : super(const LocationModel(
          isLocationFetched: false,
          lat: 0,
          long: 0,
          place: '',
          hasError: false,
          isFetchingLocation: false,
        ));

  late String? city;

  fetchLocation() async {
    // Check if we have location permission
    final permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      state = const LocationModel(
        isFetchingLocation: true,
        isLocationFetched: false,
        lat: 0,
        long: 0,
        place: '',
        hasError: false,
      );
      try {
        final position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        city = placemarks.first.locality;
        final district = placemarks.first.subLocality;
        final street = placemarks.first.street;
        final pincode = placemarks.first.postalCode;
        final administrativeArea = placemarks.first.administrativeArea;

        state = LocationModel(
          isFetchingLocation: false,
          isLocationFetched: true,
          lat: position.latitude,
          long: position.longitude,
          place: "$city,$district,$street,$administrativeArea,$pincode",
          hasError: false,
        );
      } catch (e) {
        state = const LocationModel(
          isFetchingLocation: false,
          isLocationFetched: false,
          lat: 0,
          long: 0,
          place: '',
          hasError: true,
        );
      }
    } else {
      state = const LocationModel(
        isFetchingLocation: false,
        isLocationFetched: false,
        lat: 0,
        long: 0,
        place: 'Location permission denied',
        hasError: true,
      );
    }
    return state;
  }

  updateLocation() async {
    try {
      await fetchLocation();
      await locationSerices.updateLocation(state.lat, state.long);
    } catch (e) {
      rethrow;
    }
  }

  Future getLocation() async {
    try {
      final locationData = await locationSerices.getLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData["lat"], locationData["long"]);
      city = placemarks.first.locality;
      final district = placemarks.first.subLocality;
      final street = placemarks.first.street;
      final pincode = placemarks.first.postalCode;
      final administrativeArea = placemarks.first.administrativeArea;

      state = LocationModel(
        isFetchingLocation: false,
        isLocationFetched: true,
        lat: locationData["lat"],
        long: locationData["long"],
        place: "$city,$district,$street,$administrativeArea,$pincode",
        hasError: false,
      );
      return state;
    } catch (e) {
      return Future.error(e);
    }
  }

  // Method to reset the state
  void resetState() {
    state = const LocationModel(
      isLocationFetched: false,
      lat: 0,
      long: 0,
      place: '',
      hasError: false,
      isFetchingLocation: false,
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int R = 6371; // Earth's radius in km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;
    // int distanceInKm = distance.round();
    // return distanceInKm;
    return distance;
  }

  bool shouldDisplayInKilometers(double distance) {
    const double kilometerTHRESHOLD = 1.0; // Display in km if distance >= 1 km
    return distance >= kilometerTHRESHOLD;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
