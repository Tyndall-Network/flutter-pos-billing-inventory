class PersonalInformationModel {
  PersonalInformationModel({
    this.phoneNumber,
    this.companyName,
    this.pictureUrl,
    this.businessCategory,
    this.language,
    this.countryName,
    this.saleInvoiceCounter,
    this.purchaseInvoiceCounter,
    this.dueInvoiceCounter,
    this.smsBalance,
    this.verificationStatus,
    this.shopOpeningBalance,
    this.remainingShopBalance,
    required this.currency,
    required this.currentLocale,
  });

  PersonalInformationModel.fromJson(dynamic json) {
    phoneNumber = json['phoneNumber'];
    companyName = json['companyName'];
    pictureUrl = json['pictureUrl'];
    businessCategory = json['businessCategory'];
    language = json['language'];
    countryName = json['countryName'];
    saleInvoiceCounter = json['saleInvoiceCounter'];
    purchaseInvoiceCounter = json['purchaseInvoiceCounter'];
    dueInvoiceCounter = json['dueInvoiceCounter'];
    smsBalance = json['smsBalance'] ?? 50;
    verificationStatus = json['verificationStatus'] ?? 'pending';
    shopOpeningBalance = json['shopOpeningBalance'];
    remainingShopBalance = json['remainingShopBalance'];
    currency = json['currency'] ?? '\$';
    currentLocale = json['currentLocale'] ?? 'en';
  }

  dynamic phoneNumber;
  String? companyName;
  String? pictureUrl;
  String? businessCategory;
  String? language;
  String? countryName;
  int? saleInvoiceCounter;
  int? purchaseInvoiceCounter;
  int? dueInvoiceCounter;
  int? smsBalance;
  String? verificationStatus;
  num? shopOpeningBalance;
  num? remainingShopBalance;
  late String currency;
  late String currentLocale;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['companyName'] = companyName;
    map['pictureUrl'] = pictureUrl;
    map['businessCategory'] = businessCategory;
    map['language'] = language;
    map['countryName'] = countryName;
    map['saleInvoiceCounter'] = saleInvoiceCounter;
    map['purchaseInvoiceCounter'] = purchaseInvoiceCounter;
    map['dueInvoiceCounter'] = dueInvoiceCounter;
    map['smsBalance'] = smsBalance;
    map['verificationStatus'] = verificationStatus ?? 'pending';
    map['shopOpeningBalance'] = shopOpeningBalance;
    map['remainingShopBalance'] = remainingShopBalance;
    map['currency'] = currency;
    map['currentLocale'] = currentLocale;
    return map;
  }
}
