import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:salespro_saas_admin/model/terms&conditionModel.dart';

class TermsAndPrivacyRepo {
  Future<TermsAanPrivacyModel> getTerms() async {
    DatabaseReference bankRef = FirebaseDatabase.instance.ref('Admin Panel/Terms and Conditions');
    final bankData = await bankRef.get();
    TermsAanPrivacyModel bankInfoModel = TermsAanPrivacyModel.fromJson(jsonDecode(jsonEncode(bankData.value)));

    return bankInfoModel;
  }

  Future<TermsAanPrivacyModel> getPrivacy() async {
    DatabaseReference bankRef = FirebaseDatabase.instance.ref('Admin Panel/Privacy Policy');
    final bankData = await bankRef.get();
    TermsAanPrivacyModel bankInfoModel = TermsAanPrivacyModel.fromJson(jsonDecode(jsonEncode(bankData.value)));

    return bankInfoModel;
  }
}
