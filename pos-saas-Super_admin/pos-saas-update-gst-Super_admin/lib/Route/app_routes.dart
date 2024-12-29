
import 'package:go_router/go_router.dart';
import 'package:salespro_saas_admin/Route/shell_route_warpper.dart';
import '../Homepage Advertising/homepage_advertising.dart';
import '../Screen/Add user/add_user.dart';
import '../Screen/Authentication/acnoo_login_screen.dart';
import '../Screen/Authentication/forgot_password.dart';
import '../Screen/Dashboard/dashboard.dart';
import '../Screen/NID Verification/nid_verification_screen.dart';
import '../Screen/Package/package.dart';
import '../Screen/Payment Settings/payment_settings_screen.dart';
import '../Screen/Payment Verification/payment_verification_screen.dart';
import '../Screen/Reports/reports.dart';
import '../Screen/SMS Package/sms_package_screen.dart';
import '../Screen/Shop Category/shop_category.dart';
import '../Screen/Shop Management/shop_management.dart';
import '../Screen/Subscription Plans/subscription_plans.dart';
import '../Screen/Terms and Policy/terms_and_policy_screen.dart';
import '../Screen/User Role/user_role_screen.dart';
import 'not_found.dart';


abstract class AcnooAppRoutes {
  static final routerConfig = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ShellRouteWrapper(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: MtDashboard.route,
            // builder: (context, state) => const MtDashboard(),
            pageBuilder: (context, state) => const NoTransitionPage(child: MtDashboard()),
          ),
          GoRoute(
            path: ShopManagement.route,
            // builder: (context, state) => const ShopManagement(),
            pageBuilder: (context, state) => const NoTransitionPage(child: ShopManagement()),
          ),
          GoRoute(
            path: ShopCategory.route,
            // builder: (context, state) => const ShopCategory(),
            pageBuilder: (context, state) => const NoTransitionPage(child: ShopCategory()),
          ),
          GoRoute(
            path: Package.route,
            // builder: (context, state) => const Package(),
            pageBuilder: (context, state) => const NoTransitionPage(child: Package()),
          ),
          GoRoute(
            path: Reports.route,
            // builder: (context, state) => const Reports(),
            pageBuilder: (context, state) => const NoTransitionPage(child: Reports()),
          ),

          GoRoute(
            path: PaymentSettings.route,
            // builder: (context, state) => const PaymentSettings(),
            pageBuilder: (context, state) => const NoTransitionPage(child: PaymentSettings()),
          ),
          GoRoute(
            path: TermsAndPolicyScreen.route,
            // builder: (context, state) => const TermsAndPolicyScreen(),
            pageBuilder: (context, state) => const NoTransitionPage(child: TermsAndPolicyScreen()),
          ),
          GoRoute(
            path: SubscriptionPlans.route,
            // builder: (context, state) => const SubscriptionPlans(),
            pageBuilder: (context, state) => const NoTransitionPage(child: SubscriptionPlans()),
          ),
          GoRoute(
            path: SMSPackage.route,
            // builder: (context, state) => const SMSPackage(),
            pageBuilder: (context, state) => const NoTransitionPage(child: SMSPackage()),
          ),
          GoRoute(
            path: HomepageAdvertising.route,
            // builder: (context, state) => const HomepageAdvertising(),
            pageBuilder: (context, state) => const NoTransitionPage(child: HomepageAdvertising()),
          ),
          GoRoute(
            path: NIDVerificationScreen.route,
            // builder: (context, state) => const NIDVerificationScreen(),
            pageBuilder: (context, state) => const NoTransitionPage(child: NIDVerificationScreen()),
          ),
          GoRoute(
            path: PaymentVerificationScreen.route,
            // builder: (context, state) => const PaymentVerificationScreen(),
            pageBuilder: (context, state) => const NoTransitionPage(child: PaymentVerificationScreen()),
          ),
          GoRoute(
            path: UserRoleScreen.route,
            // builder: (context, state) => const UserRoleScreen(),
            pageBuilder: (context, state) => const NoTransitionPage(child: UserRoleScreen()),
          ),
          GoRoute(
            path: AddUser.route,
            // builder: (context, state) => const AddUser(),
            pageBuilder: (context, state) => const NoTransitionPage(child: AddUser()),
          ),

        ],
      ),
      GoRoute(
        path: '/',
        // builder: (context, state) => const AcnooLoginScreen(),
        pageBuilder: (context, state) => const NoTransitionPage(child: AcnooLoginScreen()),
      ),
      GoRoute(
        path: ForgotPassword.route,
        // builder: (context, state) => const ForgotPassword(),
        pageBuilder: (context, state) => const NoTransitionPage(child: ForgotPassword()),
      ),

    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundView(),
    ),
  );
}