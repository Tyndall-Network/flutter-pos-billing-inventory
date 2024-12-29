import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:restart_app/restart_app.dart';

const kAdminEmail = 'acnooteam@gmail.com';

///apps name
String appsName = 'Pos Saas';
String appsTitle = 'Poss Saas Super Admin';
String appsLogo = 'images/logo.png';
String sideBarLogo = 'images/pos.png';
String version = '4.4';

///__________Purchase_Code___________________________________________
String purchaseCode = 'Please enter your purchase code';

bool isDemo = false;
String demoText = 'You Can\'t change anything in demo mode';

Future<String> getSaleID({required String id}) async {
  String key = '';
  await FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').orderByKey().get().then((value) async {
    for (var element in value.children) {
      var data = jsonDecode(jsonEncode(element.value));
      if (data['userId'].toString() == id) {
        key = element.key.toString();
      }
    }
  });
  return key;
}

// const kMainColor = Color(0xFF3F8CFF);
const kMainColor = Color(0xff8424FF);
const kMainColor600 = Color(0xff7500FD);
const kMainColor50 = Color(0xffF8F1FF);
const kDarkGreyColor = Color(0xFF2E2E3E);
const kNutral500 = Color(0xff667085);
const kNutral900 = Color(0xff171717);
// const kNutral600 = Color(0xff475467);
const kNutral600 = Color(0xff475467);
const kNutral300 = Color(0xffDCDCDC);
const kBorderColor = Color(0xff98A2B3);
const kNutral700 = Color(0xff4D4D4D);
const kNutral800 = Color(0xff262626);
const kLitGreyColor = Color(0xFFD4D4D8);
const kGreyTextColor = Color(0xFF828282);
const kBorderColorTextField = Color(0xFFE8E7E5);
const kDarkWhite = Color(0xFFF5F5F5);
const kWhiteTextColor = Color(0xFFFFFFFF);
const kRedTextColor = Color(0xFFFE2525);
const kSuccessColor = Color(0xff00AB2B);
const kErrorColor = Color(0xffFF3B30);
const kBlueTextColor = Color(0xff8424FF);
const kYellowColor = Color(0xFFFF8C00);
const kGreenTextColor = Color(0xFF15CD75);
const kTitleColor = Color(0xFF2E2E3E);
final kTextStyle = GoogleFonts.manrope(
  color: Colors.white,
);
const kButtonDecoration = BoxDecoration(
  color: kMainColor,
  borderRadius: BorderRadius.all(
    Radius.circular(40.0),
  ),
);

const kInputDecoration = InputDecoration(
  // hintStyle: TextStyle(color: kBorderColorTextField),
  // filled: true,
  // fillColor: Colors.white70,
  floatingLabelBehavior: FloatingLabelBehavior.always,
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(color: kNutral300, width: 1)),

  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(color: kMainColor600, width: 1)),
);

const sInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kGreyTextColor),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

List<String> businessCategory = ['Fashion Store', 'Electronics Store', 'Computer Store', 'Vegetable Store', 'Sweet Store', 'Meat Store'];
List<String> language = ['English', 'Bengali', 'Hindi', 'Urdu', 'French', 'Spanish'];

List<String> productCategory = ['Fashion', 'Electronics', 'Computer', 'Gadgets', 'Watches', 'Cloths'];

List<String> userRole = [
  'Super Admin',
  'Admin',
  'User',
];

List<String> paymentType = [
  'Cheque',
  'Deposit',
  'Cash',
  'Transfer',
  'Sales',
];
List<String> posStats = [
  'Daily',
  'Monthly',
  'Yearly',
];
List<String> saleStats = [
  'Weekly',
  'Monthly',
  'Yearly',
];

Future<String> getUserID() async {
  final prefs = await SharedPreferences.getInstance();
  final String? uid = prefs.getString('userId');

  return uid ?? '';
}

DateFormat dateTypeFormat = DateFormat.yMMMd();
DateFormat timeFormat = DateFormat.jm();
DateTime now = DateTime.now();

final currentDate = DateTime.now();
final thirtyDaysAgo = currentDate.subtract(const Duration(days: 30));
final sevenDays = currentDate.subtract(const Duration(days: 7));

final firstDayOfCurrentMonth = DateTime(currentDate.year, currentDate.month, 1);
final firstDayOfCurrentYear = DateTime(currentDate.year, 1, 1);
final firstDayOfPreviousYear = firstDayOfCurrentYear.subtract(const Duration(days: 1));
final lastDayOfPreviousMonth = firstDayOfCurrentMonth.subtract(const Duration(days: 1));
final firstDayOfPreviousMonth = DateTime(lastDayOfPreviousMonth.year, lastDayOfPreviousMonth.month, 1);

void checkCurrentUserAndRestartApp() {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user?.uid == null) {
    Restart.restartApp();
  }
}

String mainLoginPassword = '';
String mainLoginEmail = '';
