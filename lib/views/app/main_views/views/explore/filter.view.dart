// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/notifiers/location_notifier/location.notifier.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../notifiers/explore_notifier/filter_users.notifier.dart';

class FilterView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const FilterView());
  const FilterView({super.key});

  @override
  ConsumerState<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends ConsumerState<FilterView> {
  @override
  Widget build(BuildContext context) {
    final locationNotifier = ref.read(locationNotifierProvider.notifier);
    final locationData = ref.watch(locationNotifierProvider);
    final filterNotifier = ref.watch(filterUsersNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
              child: Text(
                "Show me people from",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
            Row(
              children: [
                FilterButton1(
                  text: "Global",
                  isSelected: filterNotifier.showLocalUsersOnly ? false : true,
                  onTap: () {
                    ref
                        .read(filterUsersNotifierProvider.notifier)
                        .updateShowLocalUsersOnly(false);
                  },
                ),
                FilterButton1(
                  text: "Local",
                  isSelected: filterNotifier.showLocalUsersOnly ? true : false,
                  onTap: () {
                    ref
                        .read(filterUsersNotifierProvider.notifier)
                        .updateShowLocalUsersOnly(true);
                  },
                ),
              ],
            ),
            //filter for local users only
            Visibility(
              visible: filterNotifier.showLocalUsersOnly,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            style: GoogleFonts.poppins(color: Colors.white),
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Location',
                              fillColor: ConstColors.boxBgColor,
                              filled: true,
                              isDense: true,
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey.shade400),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ConstColors.boxBgColor),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ConstColors.buttonColor,
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ConstColors.boxBgColor),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ConstColors.buttonColor,
                                ),
                              ),
                            ),
                            controller: TextEditingController(
                                text: locationData.isFetchingLocation
                                    ? "Updating current location..."
                                    : locationData.place),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ConstColors.boxBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(left: 10, right: 5),
                        child: IconButton(
                          icon: Icon(Icons.location_searching,
                              color: Colors.white),
                          onPressed: () {
                            locationNotifier.updateLocation();
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                            "Max distance (${filterNotifier.radius} km)",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16)),
                      ),
                      Slider(
                        value: filterNotifier.radius.toDouble(),
                        onChanged: (newValue) {
                          ref
                              .read(filterUsersNotifierProvider.notifier)
                              .updateMaxDistance(newValue.toInt());
                        },
                        min: 10,
                        max: 150,
                        divisions: 7,
                        label: '${filterNotifier.radius} km',
                        activeColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !filterNotifier.showLocalUsersOnly,
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Home Country:",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            final String countryName = country.name;

                            ref
                                .read(filterUsersNotifierProvider.notifier)
                                .addHomeCountry(countryName);
                          },
                        );
                      },
                      child: Text(
                        filterNotifier.homeCountry != null
                            ? filterNotifier.homeCountry.toString()
                            : "Not selected",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined,
                        color: Colors.white),
                    Spacer(),
                    Visibility(
                      visible:
                          filterNotifier.homeCountry != null ? true : false,
                      child: GestureDetector(
                        onTap: () {
                          ref
                              .read(filterUsersNotifierProvider.notifier)
                              .removeHomeCountry();
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Destination Country:",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: false,
                        onSelect: (Country country) {
                          final String countryName = country.name;

                          ref
                              .read(filterUsersNotifierProvider.notifier)
                              .addDestinationCountry(countryName);
                        },
                      );
                    },
                    child: Text(
                      filterNotifier.destinationCountry != null
                          ? filterNotifier.destinationCountry.toString()
                          : "Not selected",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
                  Spacer(),
                  Visibility(
                    visible: filterNotifier.destinationCountry != null
                        ? true
                        : false,
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(filterUsersNotifierProvider.notifier)
                            .resetAllFilters();
                      },
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class FilterButton1 extends StatelessWidget {
  const FilterButton1({
    super.key,
    required this.text,
    this.onTap,
    required this.isSelected,
  });

  final String text;
  final Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: isSelected ? Colors.black : Colors.white)),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
