import 'package:salespro_saas_admin/model/seller_info_model.dart';
import 'package:salespro_saas_admin/model/user_role_model.dart';

class UserRoleUnderUser {
  late SellerInfoModel sellerInfoModel;
  late List<UserRoleModel> userRoles;
  bool isExpanded; // Add this line

  UserRoleUnderUser({required this.sellerInfoModel, required this.userRoles,this.isExpanded = false,});
}
