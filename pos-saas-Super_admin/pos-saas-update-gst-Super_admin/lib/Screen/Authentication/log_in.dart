// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:salespro_saas_admin/Screen/Authentication/acnoo_login_screen.dart';
// import 'package:salespro_saas_admin/Screen/Widgets/Sidebar/sidebar_widget.dart';
// import 'package:salespro_saas_admin/responsive.dart' as res;
// import '../../Repo/login_repo.dart';
// import '../Widgets/Constant Data/button_global.dart';
// import '../Widgets/Constant Data/constant.dart';
// import 'forgot_password.dart';
//
// class LogIn extends StatefulWidget {
//   const LogIn({Key? key}) : super(key: key);
//
//   static const String route = '/login';
//
//   @override
//   State<LogIn> createState() => _LogInState();
// }
//
// class _LogInState extends State<LogIn> {
//   late String email, password;
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//   String? user;
//
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   bool validateAndSave() {
//     final form = globalKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final mobileScreenSize = MediaQuery.of(context).size.width <= 576; // XS
//     final tabScreen = MediaQuery.of(context).size.width > 576 && MediaQuery.of(context).size.width <= 1239; // SM and MD
//     final desktopScreenSize = MediaQuery.of(context).size.width >= 1240; // LG and XL
//     return Scaffold(
//       backgroundColor: kDarkWhite,
//       body: Consumer(builder: (context, ref, watch) {
//           final loginProvider = ref.watch(logInProvider);
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Container(
//                         width: desktopScreenSize?
//                           MediaQuery.of(context).size.width * .50: tabScreen? MediaQuery.of(context).size.width * 0.80:null,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 10.0),
//                             Container(
//                               height: 80,
//                               width: 80,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage(appsLogo),
//                                 ),
//                               ),
//                             ),
//                             Divider(
//                               thickness: 1.0,
//                               color: kGreyTextColor.withOpacity(0.1),
//                             ),
//                             const SizedBox(height: 10.0),
//                             Text(
//                               '$appsName Login Panel',
//                               style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
//                               textAlign: TextAlign.center,
//                             ),
//                             ButtonGlobal(
//                                 buttontext: 'Acnoo Login Panel',
//                                 buttonDecoration: const BoxDecoration(color: Colors.red),
//                                 onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const AcnooLoginScreen())),),
//                             const SizedBox(height: 10.0),
//                             Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Form(
//                                 key: globalKey,
//                                 child: Column(
//                                   children: [
//                                     AppTextField(
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Email can\'n be empty';
//                                         } else if (!value.contains('@')) {
//                                           return 'Please enter a valid email';
//                                         }
//                                         return null;
//                                       },
//                                       onChanged: (value) {
//                                         loginProvider.email = value;
//                                       },
//                                       showCursor: true,
//                                       controller: emailController,
//                                       cursorColor: kTitleColor,
//                                       decoration: kInputDecoration.copyWith(
//                                         labelText: 'Email',
//                                         labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                         hintText: 'Enter your email address',
//                                         hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
//                                         contentPadding: const EdgeInsets.all(4.0),
//                                         enabledBorder: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(4.0),
//                                           ),
//                                           borderSide: BorderSide(color: kBorderColorTextField, width: 1),
//                                         ),
//                                         focusedBorder: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
//                                           borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                                         ),
//                                       ),
//                                       textFieldType: TextFieldType.EMAIL,
//                                     ),
//                                     const SizedBox(height: 20.0),
//                                     AppTextField(
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'Password can\'t be empty';
//                                         } else if (value.length < 4) {
//                                           return 'Please enter a bigger password';
//                                         }
//                                         return null;
//                                       },
//                                       onChanged: (value) {
//                                         loginProvider.password = value;
//                                       },
//                                       controller: passwordController,
//                                       showCursor: true,
//                                       cursorColor: kTitleColor,
//                                       decoration: kInputDecoration.copyWith(
//                                         labelText: 'Password',
//                                         floatingLabelAlignment: FloatingLabelAlignment.start,
//                                         labelStyle: kTextStyle.copyWith(color: kTitleColor),
//                                         hintText: 'Enter your password',
//                                         hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
//                                         contentPadding: const EdgeInsets.all(4.0),
//                                         enabledBorder: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(4.0),
//                                           ),
//                                           borderSide: BorderSide(color: kBorderColorTextField, width: 1),
//                                         ),
//                                         focusedBorder: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(Radius.circular(4.0)),
//                                           borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                                         ),
//                                       ),
//                                       textFieldType: TextFieldType.PASSWORD,
//                                     ),
//                                     const SizedBox(height: 20.0),
//                                     ButtonGlobal(
//                                       buttontext: 'Login',
//                                       buttonDecoration: kButtonDecoration.copyWith(color: kGreenTextColor, borderRadius: BorderRadius.circular(8.0)),
//                                       onPressed: (() {
//                                         if (validateAndSave() && emailController.text != kAdminEmail) {
//                                           EasyLoading.showError('Please enter a correct admin email');
//                                         } else if (validateAndSave() && emailController.text == kAdminEmail) {
//                                           loginProvider.signIn(context);
//                                         }
//                                       }),
//                                     ),
//                                     const SizedBox(height: 20.0),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: ListTile(
//                                             onTap: () => Navigator.pushNamed(context, ForgotPassword.route),
//                                             contentPadding: EdgeInsets.zero,
//                                             horizontalTitleGap: 0,
//                                             leading: Icon(
//                                               MdiIcons.lockAlertOutline,
//                                               color: kTitleColor,
//                                             ),
//                                             title: Text(
//                                               'Forgot password?',
//                                               style: kTextStyle.copyWith(color: kTitleColor),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           );
//         }),
//     );
//   }
// }
