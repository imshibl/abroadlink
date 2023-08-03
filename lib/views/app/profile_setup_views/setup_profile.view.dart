// ignore_for_file: prefer_const_constructors

import 'package:abroadlink/models/user_model/current_user.model.dart';
import 'package:abroadlink/notifiers/auth_notifier/auth.notifier.dart';
import 'package:abroadlink/widgets/CustomTextField1.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/colors.dart';
import 'package:country_picker/country_picker.dart';
import '../../../notifiers/location_notifier/loc.notifier.dart';

class SetupProfileView extends ConsumerStatefulWidget {
  const SetupProfileView({super.key});

  @override
  ConsumerState<SetupProfileView> createState() => _SetupProfileViewState();
}

class _SetupProfileViewState extends ConsumerState<SetupProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _preferedCountryController =
      TextEditingController();
  final TextEditingController _homeCountryController = TextEditingController();

  String phoneNumberCode = "91";
  String homeCountryCode = "";
  String destinationCountryCode = "";

  @override
  Widget build(BuildContext context) {
    // LocationNotifier locationNotifier = ref.watch(locationProvider);

    // final locationNotifier1 = ref.watch(locationStateNotifierProvider.notifier);

    final locationNotifier2 = ref.watch(locationStateNotifierProvider);

    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final String userName = data['username'];
    final String email = data['email'];
    final String password = data['password'];

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Setup Profile',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 50),
                  CustomTextFormField1(
                    controller: _nameController,
                    hintText: 'Full name',
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
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
                  ),
                  CustomTextFormField1(
                    controller: _preferedCountryController,
                    hintText: 'Country you want to study in',
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
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: GoogleFonts.poppins(color: Colors.white),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Location',
                            fillColor: boxBgColor,
                            filled: true,
                            isDense: true,
                            hintStyle: GoogleFonts.poppins(
                                color: Colors.grey.shade400),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: boxBgColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: buttonColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: boxBgColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: buttonColor,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            // locationNotifier.location = value;
                          },
                          controller: TextEditingController(
                              text: locationNotifier2.isFetchingLocation
                                  ? "Fetching Your Location..."
                                  : locationNotifier2.place),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.location_pin, color: Colors.white),
                        onPressed: () {
                          ref
                              .read(locationStateNotifierProvider.notifier)
                              .fetchLocation();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    onPressed: () async {
                      final authServiceProvider =
                          ref.read(authProvider.notifier);

                      UserModel userModel = UserModel(
                        fullname: _nameController.text,
                        phoneNumber: _phoneNumberController.text,
                        homeCountry: _homeCountryController.text,
                        homeCountryCode: homeCountryCode,
                        studyAbroadDestination: _preferedCountryController.text,
                        studyAbroadDestinationCode: destinationCountryCode,
                        lat: locationNotifier2.lat,
                        long: locationNotifier2.long,
                      );
                      await authServiceProvider.registerWithEmailAndPassword(
                          context, userName, email, password, userModel);
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
