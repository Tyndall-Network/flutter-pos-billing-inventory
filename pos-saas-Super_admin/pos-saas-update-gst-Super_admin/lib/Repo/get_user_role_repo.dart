import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../Screen/Widgets/Constant Data/constant.dart';
import '../model/user_role_model.dart';
import 'package:http/http.dart' as http;

class UserRoleRepo {
  Future<List<UserRoleModel>> getAllUserRole({required String userId}) async {
    List<UserRoleModel> allUser = [];

    await FirebaseDatabase.instance.ref(userId).child('User Role').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));
        data.userKey = element.key;
        allUser.add(data);
      }
    });
    return allUser;
  }

  Future<List<UserRoleModel>> getAllUserRoleFromAdmin() async {
    List<UserRoleModel> allUser = [];

    await FirebaseDatabase.instance.ref('Admin Panel').child('User Role').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));
        data.userKey = element.key;
        allUser.add(data);
      }
    });
    return allUser;
  }
}

class PurchaseModel {
  Future<bool> isActiveBuyer() async {
    final response =
        await http.get(Uri.parse('https://api.envato.com/v3/market/author/sale?code=$purchaseCode'), headers: {'Authorization': 'Bearer orZoxiU81Ok7kxsE0FvfraaO0vDW5tiz'});

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
