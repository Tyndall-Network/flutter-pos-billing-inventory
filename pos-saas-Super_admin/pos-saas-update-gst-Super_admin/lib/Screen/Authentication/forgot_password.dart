import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import '../Widgets/Constant Data/button_global.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/static_string/static_string.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  static const String route = '/forgot_password';
  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = '';
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = rf.ResponsiveValue<bool>(context,
        defaultValue: false,
        conditionalValues: [
          rf.Condition.smallerThan(name: BreakpointName.SM.name, value: true)
        ]).value;
    bool isTab = rf.ResponsiveValue<bool>(context,
        defaultValue: false,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.XS.name, value: true)
        ]).value;
    bool isDesktop = rf.ResponsiveValue<bool>(context,
        defaultValue: false,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.MD.name, value: true)
        ]).value;
    return Scaffold(
      backgroundColor: kMainColor600,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding:  EdgeInsets.all(isMobile?16:20.0),
              child: Column(
                children: [
                  Container(
                    width: isDesktop? MediaQuery.of(context).size.width /1.7:isTab?MediaQuery.of(context).size.width/1.2:MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(isMobile?10:20.0),
                      child: Column(
                        children: [
                          Container(
                            height: isMobile?80:100,
                            width: isMobile?80: 100,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/logo.png'),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                            color: kGreyTextColor.withOpacity(0.1),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Reset Your Password',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,fontSize: isMobile?18:20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10.0),
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
                                    email = value;
                                  },
                                  showCursor: true,
                                  cursorColor: kTitleColor,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: 'Email',
                                    labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                    hintText: 'Enter your email address',
                                    hintStyle: kTextStyle.copyWith(color: kNutral600),
                                    contentPadding: const EdgeInsets.all(12.0),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide(color: kBorderColor, width: 1),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      borderSide: BorderSide(color: kBorderColor, width: 2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                ButtonGlobal(
                                    buttontext: 'Reset Password',
                                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor600, borderRadius: BorderRadius.circular(8.0)),
                                    onPressed: (() async {
                                      if (validateAndSave()) {
                                        try {
                                          EasyLoading.show(status: "Sending Reset Email");
                                          await FirebaseAuth.instance.sendPasswordResetEmail(
                                            email: email,
                                          );
                                          EasyLoading.showSuccess('Please Check Your Inbox');
                                          // ignore: use_build_context_synchronously
                                          context.go('/');
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'user-not-found') {
                                            EasyLoading.showError('No user found for that email.');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('No user found for that email.'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                          } else if (e.code == 'wrong-password') {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Wrong password provided for that user.'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          EasyLoading.showError(e.toString());
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                              duration: const Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      }
                                    })),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
