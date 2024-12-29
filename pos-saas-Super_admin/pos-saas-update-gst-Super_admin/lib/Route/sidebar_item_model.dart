import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../Homepage Advertising/homepage_advertising.dart';
import '../Screen/Add user/add_user.dart';
import '../Screen/Dashboard/dashboard.dart';
import '../Screen/Payment Settings/payment_settings_screen.dart';
import '../Screen/Reports/reports.dart';
import '../Screen/Shop Category/shop_category.dart';
import '../Screen/Shop Management/shop_management.dart';
import '../Screen/Subscription Plans/subscription_plans.dart';
import '../Screen/Terms and Policy/terms_and_policy_screen.dart';
import '../Screen/User Role/user_role_screen.dart';

// class SidebarItemModel {
//   final String name;
//   final IconData iconPath;
//   final SidebarItemType sidebarItemType;
//   final List<SidebarSubmenuModel>? submenus;
//   final String? navigationPath;
//   final bool isPage;
//
//   SidebarItemModel({
//     required this.name,
//     required this.iconPath,
//     this.sidebarItemType = SidebarItemType.tile,
//     this.submenus,
//     this.navigationPath,
//     this.isPage = false,
//   }) : assert(
//   sidebarItemType != SidebarItemType.submenu ||
//       (submenus != null && submenus.isNotEmpty),
//   'Sub menus cannot be null or empty if the item type is submenu',
//   );
// }
//
// class SidebarSubmenuModel {
//   final String name;
//   final String? navigationPath;
//   final bool isPage;
//
//   SidebarSubmenuModel({
//     required this.name,
//     this.navigationPath,
//     this.isPage = false,
//   });
// }
//
//
// enum SidebarItemType { tile, submenu }

class SidebarItemModel {
  final String name;
  final IconData icon; // Renamed for clarity
  final SidebarItemType sidebarItemType;
  final List<SidebarSubmenuModel>? submenus;
  final String? navigationPath;
  final bool isPage;

  SidebarItemModel({
    required this.name,
    required this.icon,
    this.sidebarItemType = SidebarItemType.tile,
    this.submenus,
    this.navigationPath,
    this.isPage = false,
  }) : assert(
  sidebarItemType != SidebarItemType.submenu ||
      (submenus != null && submenus.isNotEmpty),
  'Sub menus cannot be null or empty if the item type is submenu',
  );
}

class SidebarSubmenuModel {
  final String name;
  final String? navigationPath;
  final bool isPage;

  SidebarSubmenuModel({
    required this.name,
    this.navigationPath,
    this.isPage = false,
  });
}

enum SidebarItemType { tile, submenu }

final topMenus = <SidebarItemModel>[
  SidebarItemModel(
    name: 'Dashboard',
    icon: HugeIcons.strokeRoundedHome01,
    navigationPath: MtDashboard.route,
  ),
  SidebarItemModel(
    name: 'Shop List',
    icon: HugeIcons.strokeRoundedStore03,
    navigationPath: ShopManagement.route,
  ),
  SidebarItemModel(
    name: 'Shop Category',
    icon: HugeIcons.strokeRoundedLeftToRightListTriangle,
    navigationPath: ShopCategory.route,
  ),
  SidebarItemModel(
    name: 'Reports',
    icon: HugeIcons.strokeRoundedDocumentValidation,
    navigationPath: Reports.route,
  ),
  SidebarItemModel(
    name: 'Subscription Plans',
    icon: HugeIcons.strokeRoundedLoyaltyCard,
    navigationPath: SubscriptionPlans.route,
  ),
  SidebarItemModel(
    name: 'Payment Settings',
    icon: HugeIcons.strokeRoundedCreditCardValidation,
    navigationPath: PaymentSettings.route,
  ),
  SidebarItemModel(
    name: 'Homepage Advertising',
    icon: HugeIcons.strokeRoundedComputer,
    navigationPath: HomepageAdvertising.route,
  ),SidebarItemModel(
    name: 'User Roles',
    icon: HugeIcons.strokeRoundedHome01,
    navigationPath: UserRoleScreen.route,
  ),
  SidebarItemModel(
    name: 'Add User',
    icon: HugeIcons.strokeRoundedUserSettings01,
    navigationPath: AddUser.route,
  ),
  SidebarItemModel(
    name: 'Terms & Privacy',
    icon: HugeIcons.strokeRoundedAlert02,
    navigationPath: TermsAndPolicyScreen.route,
  ),


];

