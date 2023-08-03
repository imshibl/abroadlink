// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:abroadlink/services/location_services/location.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

final locationProvider = ChangeNotifierProvider<LocationNotifier>(
  (ref) => LocationNotifier(
    locationSerices: ref.watch(locationServiceProvider),
  ),
);

class LocationNotifier extends ChangeNotifier {
  LocationServices locationSerices;
  LocationNotifier({
    required this.locationSerices,
  });

  String? location;

  late double lat;
  late double long;

  bool isLocationFetched = false;
  bool isFetchingLocation = false;

  Future fetchLocation() async {
    isFetchingLocation = true;
    notifyListeners();

    // Check if we have location permission
    final permissionStatus = await Permission.location.request();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        final position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        final city = placemarks.first.locality;
        final district = placemarks.first.subLocality;
        final street = placemarks.first.street;
        final pincode = placemarks.first.postalCode;
        final administrativeArea = placemarks.first.administrativeArea;

        location = "$city,$district,$street,$administrativeArea,$pincode";
        lat = position.latitude;
        long = position.longitude;
        isLocationFetched = true;
        isFetchingLocation = false;
      } catch (e) {
        log(e.toString());
      }

      notifyListeners();
      return location;
    } else {
      // Handle the case where the user denied location permission

      location = 'Location permission denied';
      isLocationFetched = false;
      isFetchingLocation = false;
      notifyListeners();
    }
  }

  // updateLocation() async {
  //   try {
  //     await fetchLocation();
  //     await locationSerices.updateLocation(lat, long);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future getLocation() async {
    try {
      final locationData = await locationSerices.getLocation();
      lat = locationData["lat"];
      long = locationData["long"];
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      final city = placemarks.first.locality;
      final district = placemarks.first.subLocality;
      final street = placemarks.first.street;
      final pincode = placemarks.first.postalCode;
      final administrativeArea = placemarks.first.administrativeArea;

      location = "$city,$district,$street,$administrativeArea,$pincode";
      notifyListeners();
      return locationData;
    } catch (e) {
      rethrow;
    }
  }
}
