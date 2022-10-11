import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 47, 205, 226);
const darkBlue = Color(0xFF0A0C24);
const backgroundColor = Color(0xFFFAFAFA);
const whiteColor = Colors.white;
const darkGreyColor = Color(0xFF909090);
const greyColor = Color(0xFFECECEC);
const lightGrey = Color(0xFFF6F6F6);
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    elevation: (8),
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    textStyle: const TextStyle(color: Colors.white),
  );