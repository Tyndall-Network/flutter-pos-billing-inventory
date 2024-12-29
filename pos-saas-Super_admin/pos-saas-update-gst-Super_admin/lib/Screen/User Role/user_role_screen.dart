import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Provider/seller_info_provider.dart';
import '../../Provider/user_role_provider.dart';
import '../../model/user_role_model.dart';
import '../../model/user_role_under_user_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/Topbar/topbar.dart';

class UserRoleScreen extends StatefulWidget {
  const UserRoleScreen({super.key});

  static const String route = '/user_role';

  @override
  State<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> {
  List<UserRoleUnderUser> mainShowList = [];
  int counter = 0;

  @override
  void initState() {
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  final _horizontalScroll = ScrollController();
  final _verticalScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      // drawer: const Drawer(
      //   child: SideBarWidget(
      //     index: 7,
      //     isTab: false,
      //   ),
      // ),
      // appBar: const GlobalAppbar(),
      body: Consumer(
        builder: (_, ref, watch) {
          final sellerInfo = ref.watch(sellerInfoProvider);
          final userRole = ref.watch(allAdminUserRoleProvider);
          final isCurrentSize = MediaQuery.of(context).size.width < 1200;
          final kTitleStyle = Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600);
          final kBodyTextStyle = Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kNutral800);
          return sellerInfo.when(
            data: (sellerInfo) {
              return userRole.when(
                data: (userRole) {
                  if (counter < 1) {
                    for (var singleSeller in sellerInfo) {
                      List<UserRoleModel> listData = [];
                      for (var singleUserRole in userRole) {
                        if (singleSeller.userID == singleUserRole.databaseId) {
                          listData.add(singleUserRole);
                        }
                      }
                      if (listData.isNotEmpty) {
                        mainShowList.add(UserRoleUnderUser(
                          sellerInfoModel: singleSeller,
                          userRoles: listData,
                        ));
                      }
                    }
                  }
                  counter++;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      // padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: kWhiteTextColor,
                      ),
                      child: RawScrollbar(
                        controller: _horizontalScroll,
                        thumbVisibility: true,
                        thickness: 8.0,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            final kWidth = constraints.maxWidth;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalScroll,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Title & buttons
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text('User Role',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600)),
                                    ),
                                    // const SizedBox(height: 16.0),
                                    SizedBox(
                                      // The width should be large enough to allow horizontal scrolling
                                      width: isCurrentSize
                                          ? MediaQuery.of(context).size.width +
                                              400
                                          : kWidth, // Adjust this value based on content width
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: kMainColor50,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 20.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text('S.L',
                                                          style: kTitleStyle)),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Text('Shop Name',
                                                          style: kTitleStyle)),
                                                  // Expanded(flex: 1,child: Text('')),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text('Category',
                                                          style: kTitleStyle)),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text('Phone',
                                                          style: kTitleStyle)),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Text('Email',
                                                          style: kTitleStyle)),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          'Number Of Role',
                                                          style: kTitleStyle)),
                                                  const SizedBox(
                                                    width: 50,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          ...List.generate(
                                            mainShowList.length,
                                            (index) => Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: kNutral300),
                                                ),
                                              ),
                                              child: Theme(
                                                data: Theme.of(context).copyWith(
                                                    dividerColor:
                                                        Colors.transparent),
                                                child: ExpansionTile(
                                                  title: Padding(
                                                    padding: const EdgeInsets.all(
                                                        10.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              (index + 1)
                                                                  .toString(),
                                                              style:
                                                                  kBodyTextStyle,
                                                            )),
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              mainShowList[index]
                                                                  .sellerInfoModel
                                                                  .companyName
                                                                  .toString(),
                                                              style:
                                                                  kBodyTextStyle,
                                                            )),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              mainShowList[index]
                                                                  .sellerInfoModel
                                                                  .businessCategory
                                                                  .toString(),
                                                              style:
                                                                  kBodyTextStyle,
                                                            )),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              mainShowList[index]
                                                                  .sellerInfoModel
                                                                  .phoneNumber
                                                                  .toString(),
                                                              style:
                                                                  kBodyTextStyle,
                                                            )),
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              mainShowList[index]
                                                                  .sellerInfoModel
                                                                  .email
                                                                  .toString(),
                                                              style:
                                                                  kBodyTextStyle,
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              mainShowList[index]
                                                                  .userRoles
                                                                  .length
                                                                  .toString(),
                                                              style:
                                                                  kBodyTextStyle,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  children: List.generate(
                                                    mainShowList[index]
                                                        .userRoles
                                                        .length,
                                                    (i) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              bottom: 15,
                                                              left: 27,
                                                              right: 60),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                (i + 1)
                                                                    .toString(),
                                                                style:
                                                                    kBodyTextStyle,
                                                              )),
                                                          Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                mainShowList[
                                                                        index]
                                                                    .userRoles[i]
                                                                    .userTitle
                                                                    .toString(),
                                                                style:
                                                                    kBodyTextStyle,
                                                              )),
                                                          Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                mainShowList[
                                                                        index]
                                                                    .sellerInfoModel
                                                                    .businessCategory
                                                                    .toString(),
                                                                style:
                                                                    kBodyTextStyle,
                                                              )),
                                                          Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                mainShowList[
                                                                        index]
                                                                    .sellerInfoModel
                                                                    .phoneNumber
                                                                    .toString(),
                                                                style:
                                                                    kBodyTextStyle,
                                                              )),
                                                          Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                mainShowList[
                                                                        index]
                                                                    .userRoles[i]
                                                                    .email
                                                                    .toString(),
                                                                style:
                                                                    kBodyTextStyle,
                                                              )),
                                                          const Expanded(
                                                              flex: 1,
                                                              child: SizedBox()),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                error: (e, stack) {
                  return Center(child: Text(e.toString()));
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
            error: (e, stack) {
              return Center(child: Text(e.toString()));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}

void signUp({
  required BuildContext context,
  required String email,
  required String password,
  required WidgetRef ref,
}) async {
  EasyLoading.show(status: 'Registering....');
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential != null) {
      EasyLoading.showSuccess('Successful');
    }
  } on FirebaseAuthException catch (e) {
    EasyLoading.showError('Failed with Error');
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The password provided is too weak.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The account already exists for that email.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  } catch (e) {
    EasyLoading.showError('Failed with Error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
