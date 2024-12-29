// class UserRoleModel {
//   late String email, userTitle, databaseId;
//   late bool salePermission,
//       partiesPermission,
//       purchasePermission,
//       productPermission,
//       profileEditPermission,
//       addExpensePermission,
//       lossProfitPermission,
//       dueListPermission,
//       stockPermission,
//       reportsPermission,
//       salesListPermission,
//       purchaseListPermission;
//
//   String? userKey;
//
//   UserRoleModel({
//     required this.email,
//     required this.userTitle,
//     required this.databaseId,
//     required this.salePermission,
//     required this.partiesPermission,
//     required this.purchasePermission,
//     required this.productPermission,
//     required this.profileEditPermission,
//     required this.addExpensePermission,
//     required this.lossProfitPermission,
//     required this.dueListPermission,
//     required this.stockPermission,
//     required this.reportsPermission,
//     required this.salesListPermission,
//     required this.purchaseListPermission,
//     this.userKey,
//   });
//
//   UserRoleModel.fromJson(Map<dynamic, dynamic> json)
//       : email = json['email'],
//         userTitle = json['userTitle'],
//         databaseId = json['databaseId'],
//         salePermission = json['salePermission'],
//         partiesPermission = json['partiesPermission'],
//         purchasePermission = json['purchasePermission'],
//         productPermission = json['productPermission'],
//         profileEditPermission = json['profileEditPermission'],
//         addExpensePermission = json['addExpensePermission'],
//         lossProfitPermission = json['lossProfitPermission'],
//         dueListPermission = json['dueListPermission'],
//         stockPermission = json['stockPermission'],
//         reportsPermission = json['reportsPermission'],
//         salesListPermission = json['salesListPermission'],
//         purchaseListPermission = json['purchaseListPermission'];
//
//   Map<dynamic, dynamic> toJson() => <String, dynamic>{
//         'email': email,
//         'userTitle': userTitle,
//         'databaseId': databaseId,
//         'salePermission': salePermission,
//         'partiesPermission': partiesPermission,
//         'purchasePermission': purchasePermission,
//         'productPermission': productPermission,
//         'profileEditPermission': profileEditPermission,
//         'addExpensePermission': addExpensePermission,
//         'lossProfitPermission': lossProfitPermission,
//         'dueListPermission': dueListPermission,
//         'stockPermission': stockPermission,
//         'reportsPermission': reportsPermission,
//         'salesListPermission': salesListPermission,
//         'purchaseListPermission': purchaseListPermission,
//       };
// }

/*class UserRoleModel {
  late String email, userTitle, databaseId;
  late bool salePermission,
      partiesPermission,
      purchasePermission,
      productPermission,
      profileEditPermission,
      addExpensePermission,
      lossProfitPermission,
      dueListPermission,
      stockPermission,
      reportsPermission,
      salesListPermission,
      purchaseListPermission;

  String? userKey;

  UserRoleModel({
    required this.email,
    required this.userTitle,
    required this.databaseId,
    required this.salePermission,
    required this.partiesPermission,
    required this.purchasePermission,
    required this.productPermission,
    required this.profileEditPermission,
    required this.addExpensePermission,
    required this.lossProfitPermission,
    required this.dueListPermission,
    required this.stockPermission,
    required this.reportsPermission,
    required this.salesListPermission,
    required this.purchaseListPermission,
    this.userKey,
  });

  UserRoleModel.fromJson(Map<dynamic, dynamic> json)
      : email = json['email'] as String,
        userTitle = json['userTitle'] as String,
        databaseId = json['databaseId'] as String,
        salePermission = (json['salePermission'] as bool?) ?? false,  // Handle null values
        partiesPermission = (json['partiesPermission'] as bool?) ?? false,
        purchasePermission = (json['purchasePermission'] as bool?) ?? false,
        productPermission = (json['productPermission'] as bool?) ?? false,
        profileEditPermission = (json['profileEditPermission'] as bool?) ?? false,
        addExpensePermission = (json['addExpensePermission'] as bool?) ?? false,
        lossProfitPermission = (json['lossProfitPermission'] as bool?) ?? false,
        dueListPermission = (json['dueListPermission'] as bool?) ?? false,
        stockPermission = (json['stockPermission'] as bool?) ?? false,
        reportsPermission = (json['reportsPermission'] as bool?) ?? false,
        salesListPermission = (json['salesListPermission'] as bool?) ?? false,
        purchaseListPermission = (json['purchaseListPermission'] as bool?) ?? false;

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'userTitle': userTitle,
    'databaseId': databaseId,
    'salePermission': salePermission,
    'partiesPermission': partiesPermission,
    'purchasePermission': purchasePermission,
    'productPermission': productPermission,
    'profileEditPermission': profileEditPermission,
    'addExpensePermission': addExpensePermission,
    'lossProfitPermission': lossProfitPermission,
    'dueListPermission': dueListPermission,
    'stockPermission': stockPermission,
    'reportsPermission': reportsPermission,
    'salesListPermission': salesListPermission,
    'purchaseListPermission': purchaseListPermission,
  };
}*/

class UserRoleModel {
  String email;
  String userTitle;
  String databaseId;
  bool salePermission;
  bool partiesPermission;
  bool purchasePermission;
  bool productPermission;
  bool profileEditPermission;
  bool addExpensePermission;
  bool lossProfitPermission;
  bool dueListPermission;
  bool stockPermission;
  bool reportsPermission;
  bool salesListPermission;
  bool purchaseListPermission;

  String? userKey;

  UserRoleModel({
    required this.email,
    required this.userTitle,
    required this.databaseId,
    required this.salePermission,
    required this.partiesPermission,
    required this.purchasePermission,
    required this.productPermission,
    required this.profileEditPermission,
    required this.addExpensePermission,
    required this.lossProfitPermission,
    required this.dueListPermission,
    required this.stockPermission,
    required this.reportsPermission,
    required this.salesListPermission,
    required this.purchaseListPermission,
    this.userKey,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => UserRoleModel(
        email: json["email"] ?? '',
        userTitle: json["userTitle"] ?? '',
        databaseId: json["databaseId"] ?? '',
        salePermission: json["salePermission"] ?? false,
        partiesPermission: json["partiesPermission"] ?? false,
        purchasePermission: json["purchasePermission"] ?? false,
        productPermission: json["productPermission"] ?? false,
        profileEditPermission: json["profileEditPermission"] ?? false,
        addExpensePermission: json["addExpensePermission"] ?? false,
        lossProfitPermission: json["lossProfitPermission"] ?? false,
        dueListPermission: json["dueListPermission"] ?? false,
        stockPermission: json["stockPermission"] ?? false,
        reportsPermission: json["reportsPermission"] ?? false,
        salesListPermission: json["salesListPermission"] ?? false,
        purchaseListPermission: json["purchaseListPermission"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "userTitle": userTitle,
        "databaseId": databaseId,
        "salePermission": salePermission,
        "partiesPermission": partiesPermission,
        "purchasePermission": purchasePermission,
        "productPermission": productPermission,
        "profileEditPermission": profileEditPermission,
        "addExpensePermission": addExpensePermission,
        "lossProfitPermission": lossProfitPermission,
        "dueListPermission": dueListPermission,
        "stockPermission": stockPermission,
        "reportsPermission": reportsPermission,
        "salesListPermission": salesListPermission,
        "purchaseListPermission": purchaseListPermission,
      };
}
