// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/models/current_user.model.dart';
import 'package:abroadlink/notifiers/auth_notifier/auth.notifier.dart';
import 'package:abroadlink/views/app/auth_views/login.view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../const/colors.dart';
import 'package:country_picker/country_picker.dart';
import '../../../notifiers/location_notifier/location.notifier.dart';
import '../../../widgets/CustomTextField1.widget.dart';

class SetupProfileView extends ConsumerStatefulWidget {
  const SetupProfileView(
      {required this.email,
      required this.password,
      required this.username,
      super.key});

  final String email;
  final String password;
  final String username;

  @override
  ConsumerState<SetupProfileView> createState() => _SetupProfileViewState();

  static route(
          {required String email,
          required String password,
          required String username}) =>
      MaterialPageRoute(
        builder: (context) => SetupProfileView(
          email: email,
          password: password,
          username: username,
        ),
      );
}

class _SetupProfileViewState extends ConsumerState<SetupProfileView> {
  String destinationCountryCode = "";
  String homeCountryCode = "";
  String phoneNumberCode = "91";

  final TextEditingController _homeCountryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _preferedCountryController =
      TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _preferedCountryController.dispose();
    _homeCountryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationNotifier2 = ref.watch(locationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Setup Profile',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                    CustomTextFormField1(
                      controller: _nameController,
                      hintText: 'Full name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField1(
                            controller: _phoneNumberController,
                            hintText: 'Phone number',
                            keyboardType: TextInputType.phone,
                            prefixIcon: TextButton(
                              onPressed: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  onSelect: (Country country) {
                                    setState(() {
                                      phoneNumberCode = country.phoneCode;
                                    });
                                  },
                                );
                              },
                              child: Text(
                                "+$phoneNumberCode",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    CustomTextFormField1(
                      controller: _homeCountryController,
                      hintText: 'Home country',
                      readOnly: true,
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            _homeCountryController.text = country.name;
                            homeCountryCode = country.countryCode;
                            setState(() {
                              phoneNumberCode = country.phoneCode;
                            });
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your home country';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField1(
                      controller: _preferedCountryController,
                      hintText: 'Dream country',
                      readOnly: true,
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          exclude: [homeCountryCode],
                          onSelect: (Country country) {
                            _preferedCountryController.text = country.name;
                            destinationCountryCode = country.countryCode;
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your destination/dream country';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField1(
                      controller: _purposeController,
                      hintText: 'Purpose',
                      readOnly: true,
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your travel purpose';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField1(
                            readOnly: true,
                            hintText: "Location",
                            // decoration: InputDecoration(
                            //   hintText: 'Location',
                            //   fillColor: ConstColors.boxBgColor,
                            //   filled: true,
                            //   isDense: true,
                            //   hintStyle: GoogleFonts.poppins(
                            //       color: Colors.grey.shade400),
                            //   enabledBorder: const OutlineInputBorder(
                            //     borderSide:
                            //         BorderSide(color: ConstColors.boxBgColor),
                            //   ),
                            //   focusedBorder: const OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: ConstColors.buttonColor,
                            //     ),
                            //   ),
                            //   errorBorder: const OutlineInputBorder(
                            //     borderSide:
                            //         BorderSide(color: ConstColors.boxBgColor),
                            //   ),
                            //   focusedErrorBorder: const OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: ConstColors.buttonColor,
                            //     ),
                            //   ),
                            // ),
                            // onChanged: (value) {
                            //   // locationNotifier.location = value;
                            // },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your current location';
                              }
                              return null;
                            },
                            controller: TextEditingController(
                                text: locationNotifier2.isFetchingLocation
                                    ? "Fetching Your Location..."
                                    : locationNotifier2.place),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.location_pin,
                              color: Colors.white),
                          onPressed: () {
                            ref
                                .read(locationNotifierProvider.notifier)
                                .fetchLocation();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Consumer(builder: (context, ref, _) {
                      final authNotifier = ref.watch(authNotifierProvider);
                      Widget animatedWidget = authNotifier
                          ? const CustomCircularProgressIndicatior1()
                          : IconButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final authServiceProvider =
                                    ref.read(authNotifierProvider.notifier);

                                UserModel userModel = UserModel(
                                  fullname: _nameController.text,
                                  phoneNumber: _phoneNumberController.text,
                                  homeCountry: _homeCountryController.text,
                                  homeCountryCode: homeCountryCode,
                                  abroadDestination:
                                      _preferedCountryController.text,
                                  abroadDestinationCode: destinationCountryCode,
                                  travelPurpose: _purposeController.text,
                                  lat: locationNotifier2.lat,
                                  long: locationNotifier2.long,
                                  createdAt: DateTime.now(),
                                  followers: [],
                                  following: [],
                                  geopoint: GeoFirePoint(GeoPoint(
                                          locationNotifier2.lat,
                                          locationNotifier2.long))
                                      .data,
                                );
                                await authServiceProvider
                                    .registerWithEmailAndPassword(
                                        context,
                                        widget.username,
                                        widget.email,
                                        widget.password,
                                        userModel);
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
                            );
                      return AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: animatedWidget,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Education🎓'),
                onTap: () {
                  _purposeController.text = "Education";
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Employment👔'),
                onTap: () {
                  _purposeController.text = "Employment";
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Tour🏄'),
                onTap: () {
                  _purposeController.text = "Tour";
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
