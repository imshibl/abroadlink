// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:abroadlink/config/colors.dart';

class ForgotPasswordView extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ForgotPasswordView());
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Reset Password",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter your registered email",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: boxBgColor,
                  filled: true,
                  isDense: true,
                  hintText: 'Email',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@gmail.com')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (_emailController.text.isNotEmpty) {
                        try {
                          //reset password
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _emailController.text)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Password reset link is sent to your email")));
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(context,
                                message: "No user found for provided email.");
                          }
                        } catch (_) {
                          showSnackBar(context,
                              message: "Something went wrong.Try again.");
                        }
                      }
                    }
                  },
                  elevation: 0,
                  color: buttonColor,
                  child: Text(
                    'Send Reset Link',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
