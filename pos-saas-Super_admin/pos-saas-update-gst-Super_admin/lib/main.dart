import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_saas_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'Route/app_routes.dart';
import 'Screen/Widgets/static_string/static_string.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  setPathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return rf.ResponsiveBreakpoints.builder(
      breakpoints: [
        rf.Breakpoint(
          start: BreakpointName.XS.start,
          end: BreakpointName.XS.end,
          name: BreakpointName.XS.name,
        ),
        rf.Breakpoint(
          start: BreakpointName.SM.start,
          end: BreakpointName.SM.end,
          name: BreakpointName.SM.name,
        ),
        rf.Breakpoint(
          start: BreakpointName.MD.start,
          end: BreakpointName.MD.end,
          name: BreakpointName.MD.name,
        ),
        rf.Breakpoint(
          start: BreakpointName.LG.start,
          end: BreakpointName.LG.end,
          name: BreakpointName.LG.name,
        ),
        rf.Breakpoint(
          start: BreakpointName.XL.start,
          end: BreakpointName.XL.end,
          name: BreakpointName.XL.name,
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: appsTitle,
        // initialRoute: '/',
        routerConfig: AcnooAppRoutes.routerConfig,
        builder: EasyLoading.init(),
        // routes: {
        //   '/': (context) => const AcnooLoginScreen(),
        //   MtDashboard.route: (context) => const MtDashboard(),
        //   ShopManagement.route: (context) => const ShopManagement(),
        //   ShopCategory.route: (context) => const ShopCategory(),
        //   Package.route: (context) => const Package(),
        //   Reports.route: (context) => const Reports(),
        //   ForgotPassword.route: (context) => const ForgotPassword(),
        //   PaymentSettings.route: (context) => const PaymentSettings(),
        //   TermsAndPolicyScreen.route: (context) => const TermsAndPolicyScreen(),
        //   SubscriptionPlans.route: (context) => const SubscriptionPlans(),
        //   SMSPackage.route: (context) => const SMSPackage(),
        //   HomepageAdvertising.route: (context) => const HomepageAdvertising(),
        //   NIDVerificationScreen.route: (context) =>
        //       const NIDVerificationScreen(),
        //   PaymentVerificationScreen.route: (context) =>
        //       const PaymentVerificationScreen(),
        //   UserRoleScreen.route: (context) => const UserRoleScreen(),
        //   AddUser.route: (context) => const AddUser(),
        // },
      ),
    );
  }
}
