import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:salespro_saas_admin/Screen/Widgets/Constant%20Data/constant.dart';
import '../../Repo/get_user_role_repo.dart';
import '../../Repo/login_repo.dart';
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/static_string/static_string.dart';
import 'dart:html' as html;

class AcnooLoginScreen extends StatefulWidget {
  const AcnooLoginScreen({super.key});
  static const String route = '/';

  @override
  State<AcnooLoginScreen> createState() => _AcnooLoginScreenState();
}

class _AcnooLoginScreenState extends State<AcnooLoginScreen> {
  late String email, password;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? user;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _setupHistory();
  }

  void _setupHistory() {
    // Replace the current state to avoid default back navigation
    html.window.history.replaceState(null, '', html.window.location.href);

    // Push a new state to ensure we are not navigating back
    html.window.history.pushState(null, '', html.window.location.href);

    // Handle the back button event
    html.window.onPopState.listen((event) {
      // Redirect to the dashboard page to prevent navigating back
      html.window.history.pushState(null, '', html.window.location.href);
      // Optionally, use GoRouter to navigate to a specific route
      // For example, redirect to the login screen if desired
      GoRouter.of(context).go('/');
    });
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Future<bool> checkUser() async {
  //   await PurchaseModel().isActiveBuyer().then((value) {
  //     if (value) {
  //       return true;
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text("Not Active User"),
  //           content: const Text("Please use the valid purchase code to use the app."),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 //Exit app
  //                 if (Platform.isAndroid) {
  //                   SystemNavigator.pop();
  //                 } else {
  //                   exit(0);
  //                 }
  //               },
  //               child: Text("OK"),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   });
  //   return false;
  // }

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    // final isTabAndPhone=MediaQuery.of(context).size.width<577;
    bool isTabAndPhone = rf.ResponsiveValue<bool>(context, defaultValue: false, conditionalValues: [rf.Condition.smallerThan(name: BreakpointName.MD.name, value: true)]).value;
    bool isMobile = rf.ResponsiveValue<bool>(context, defaultValue: false, conditionalValues: [rf.Condition.smallerThan(name: BreakpointName.LG.name, value: true)]).value;
    return Scaffold(
      backgroundColor: kMainColor600,
      body: PopScope(
        canPop: true,
        child: Consumer(
          builder: (context, ref, watch) {
            final loginProvider = ref.watch(logInProvider);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/nameLogo.png', height: 50),
                      ResponsiveGridRow(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        ResponsiveGridCol(
                            lg: 6,
                            md: 6,
                            child: Center(
                              child: Container(
                                height: isTabAndPhone ? MediaQuery.of(context).size.width / 1.1 : MediaQuery.of(context).size.height / 1.2,
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(isTabAndPhone ? 'images/loginLogo2.png' : 'images/login logo.png'))),
                              ),
                            )),
                        ResponsiveGridCol(
                            lg: 6,
                            md: 6,
                            child: Padding(
                              padding: EdgeInsets.only(right: isTabAndPhone ? 10 : 50, left: isTabAndPhone ? 10 : 20),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(isMobile ? 20 : 44.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                text: 'Welcome to ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(fontSize: isMobile ? 24 : 40, color: kTitleColor, fontWeight: isMobile ? FontWeight.w700 : FontWeight.bold),
                                                children: [
                                              TextSpan(
                                                text: 'PosSaas',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(fontSize: isMobile ? 24 : 40, color: kMainColor600, fontWeight: isMobile ? FontWeight.w700 : FontWeight.bold),
                                              )
                                            ])),
                                        Text(
                                          'Welcome back, Please login in to your account',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kNutral500, fontSize: isMobile ? 14 : 20),
                                        ),
                                        SizedBox(
                                          height: isMobile ? 15 : 25,
                                        ),
                                        Form(
                                          key: globalKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Email can\'n be empty';
                                                  } else if (!value.contains('@')) {
                                                    return 'Please enter a valid email';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  loginProvider.email = value;
                                                },
                                                showCursor: true,
                                                controller: emailController,
                                                cursorColor: kTitleColor,
                                                decoration: kInputDecoration.copyWith(
                                                  prefixIcon: Padding(
                                                    padding: const EdgeInsets.only(right: 8),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      width: 48,
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(color: kBorderColor)),
                                                        // color: Color(0xff98A2B3),
                                                      ),
                                                      child: const HugeIcon(
                                                        icon: HugeIcons.strokeRoundedMail01,
                                                        color: kNutral600,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                  hintText: 'Enter your email address',
                                                  hintStyle: kTextStyle.copyWith(color: kNutral700),
                                                  contentPadding: const EdgeInsets.all(10.0),
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0),
                                                    ),
                                                    borderSide: BorderSide(color: kBorderColor, width: 1),
                                                  ),
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                    borderSide: BorderSide(color: kMainColor600, width: 1),
                                                  ),
                                                ),
                                                keyboardType: TextInputType.emailAddress,
                                              ),
                                              const SizedBox(height: 20.0),
                                              TextFormField(
                                                obscureText: _hidePassword,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Password can\'t be empty';
                                                  } else if (value.length < 4) {
                                                    return 'Please enter a bigger password';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  loginProvider.password = value;
                                                },
                                                controller: passwordController,
                                                showCursor: true,
                                                cursorColor: kTitleColor,
                                                decoration: kInputDecoration.copyWith(
                                                  prefixIcon: Padding(
                                                    padding: const EdgeInsets.only(right: 8),
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      width: 48,
                                                      decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(color: kBorderColor)),
                                                        // color: Color(0xff98A2B3),
                                                      ),
                                                      child: const HugeIcon(
                                                        icon: HugeIcons.strokeRoundedSquareLock02,
                                                        color: kNutral600,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                  suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _hidePassword = !_hidePassword;
                                                        });
                                                      },
                                                      icon: _hidePassword
                                                          ? const Icon(
                                                              Icons.visibility_off_outlined,
                                                              color: kNutral600,
                                                            )
                                                          : const HugeIcon(
                                                              icon: HugeIcons.strokeRoundedView,
                                                              color: Colors.black,
                                                              size: 24.0,
                                                            )),
                                                  // labelText: 'Password',
                                                  floatingLabelAlignment: FloatingLabelAlignment.start,
                                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                  hintText: 'Enter your password',
                                                  hintStyle: kTextStyle.copyWith(color: kNutral700),
                                                  contentPadding: const EdgeInsets.all(10.0),
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0),
                                                    ),
                                                    borderSide: BorderSide(color: kBorderColor, width: 1),
                                                  ),
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                    borderSide: BorderSide(color: kMainColor600, width: 2),
                                                  ),
                                                ),
                                                keyboardType: TextInputType.visiblePassword,
                                              ),
                                              const SizedBox(height: 10.0),
                                              ListTile(
                                                onTap: () => context.go('/forgot_password'),
                                                contentPadding: EdgeInsets.zero,
                                                horizontalTitleGap: 5,
                                                leading: const HugeIcon(
                                                  icon: HugeIcons.strokeRoundedSquareLock02,
                                                  color: kNutral600,
                                                  size: 24.0,
                                                ),
                                                title: Text(
                                                  'Forgot password?',
                                                  style: kTextStyle.copyWith(color: kTitleColor),
                                                ),
                                              ),
                                              SizedBox(height: isMobile ? 10 : 20.0),
                                              ButtonGlobal(
                                                buttontext: 'Login',
                                                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor600, borderRadius: BorderRadius.circular(8.0)),
                                                onPressed: () async {
                                                  if (await PurchaseModel().isActiveBuyer()) {
                                                    if (emailController.text != kAdminEmail) {
                                                      EasyLoading.showError('Please enter a correct admin email');
                                                    } else if (validateAndSave() && emailController.text == kAdminEmail) {
                                                      loginProvider.signIn(context);
                                                    }
                                                  } else {
                                                    EasyLoading.showError('Your purchase code is invalid');
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                      ]),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
