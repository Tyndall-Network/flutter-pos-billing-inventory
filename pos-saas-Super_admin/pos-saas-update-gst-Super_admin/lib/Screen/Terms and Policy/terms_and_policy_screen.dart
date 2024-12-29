// ignore_for_file: unused_result

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/terms&Privacy_provider.dart';
import '../../model/terms&conditionModel.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/Topbar/topbar.dart';

class TermsAndPolicyScreen extends StatefulWidget {
  const TermsAndPolicyScreen({super.key});

  static const String route = '/terms_and_policy';

  @override
  State<TermsAndPolicyScreen> createState() => _TermsAndPolicyScreenState();
}

class _TermsAndPolicyScreenState extends State<TermsAndPolicyScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController termsTitleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  TextEditingController termsDiscriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  void postDataIfNoDataInTerms({required WidgetRef ref}) async {
    TermsAanPrivacyModel paypalInfoModel = TermsAanPrivacyModel(title: '', description: '', isActive: true);
    final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Terms and Conditions');
    adRef.set(paypalInfoModel.toJson());

    ///____provider_refresh____________________________________________
    ref.refresh(termsProvider);
  }

  void postDataIfNoDataInPrivacy({required WidgetRef ref}) async {
    TermsAanPrivacyModel paypalInfoModel = TermsAanPrivacyModel(title: '', description: '', isActive: true);
    final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Privacy Policy');
    adRef.set(paypalInfoModel.toJson());

    ///____provider_refresh____________________________________________
    ref.refresh(privacyProvider);
  }

  bool isTermsLive = false;
  bool isPrivacyLive = false;

  int i = 0;
  int j = 0;

  @override
  Widget build(BuildContext context) {
    final isMobileScreen=MediaQuery.of(context).size.width <576;
    return Scaffold(
      backgroundColor: kDarkWhite,
      // drawer: const Drawer(
      //   child: SideBarWidget(
      //     index: 9,
      //     isTab: false,
      //   ),
      // ),
      // appBar: const GlobalAppbar(),
      body: Consumer(
        builder: (_, ref, watch) {
          final privacy = ref.watch(privacyProvider);
          final terms = ref.watch(termsProvider);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Terms And Policy',
                  //   style: kTextStyle.copyWith(color: kTitleColor, fontSize: 22, fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 10.0),
                  // const Divider(
                  //   height: 1,
                  //   color: Colors.black12,
                  // ),
                  // const SizedBox(height: 10.0),

                  ///_______Terms & Conditions_________________________
                  terms.when(
                    data: (bankData) {
                      termsTitleController.text = bankData.title;
                      termsDiscriptionController.text = bankData.description;
                      i == 0 ? isTermsLive = bankData.isActive : null;
                      i++;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 20),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text('Terms & Conditions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,fontSize: isMobileScreen?16:20)),
                                   Transform.scale(
                                     scale: 0.7,
                                     child: SizedBox(
                                       height: 20,
                                       width: 36,
                                       child: CupertinoSwitch(
                                         trackColor: Colors.red,
                                         activeColor: kMainColor600,
                                         value: isTermsLive,
                                         onChanged: (value) {
                                           setState(() {
                                             isTermsLive = value;
                                           });
                                         },
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                              const SizedBox(height: 20),
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     Container(
                              //       width: 130,
                              //       height: 50,
                              //       alignment: Alignment.centerLeft,
                              //       child: const Text('Is Live'),
                              //     ),
                              //     const SizedBox(width: 20),
                              //     CupertinoSwitch(
                              //       trackColor: Colors.red,
                              //       value: isTermsLive,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           isTermsLive = value;
                              //         });
                              //       },
                              //     ),
                              //   ],
                              // ),

                              ///________bank_Name____________________________
                              TextFormField(
                                decoration:  kInputDecoration.copyWith(
                                  labelText: 'Title',
                                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kNutral700,fontWeight: FontWeight.w500),
                                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                                  hintText: 'Enter Title',
                                ),
                                controller: termsTitleController,
                              ),
                              const SizedBox(height: 20),

                              ///________Description____________________________
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                minLines: 3,
                                decoration: kInputDecoration.copyWith(
                                  hintText: 'Enter Description',
                                  labelText: 'Description',
                                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kNutral700,fontWeight: FontWeight.w500),
                                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                maxLines: 3,
                                controller: termsDiscriptionController,
                              ),
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Container(
                              //       width: 130,
                              //       height: 50,
                              //       alignment: Alignment.centerLeft,
                              //       child: const Text('Description'),
                              //     ),
                              //     const SizedBox(width: 20),
                              //     ResizableTextField(
                              //       levelText: 'Enter Description',
                              //       controller: termsDiscriptionController,
                              //     ),
                              //
                              //   ],
                              // ),
                              const SizedBox(height: 20),

                              ///_________Buttons_____________________________________
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (() {
                                      // Navigator.pop(context);
                                      // const TermsAndPolicyScreen().launch(context);
                                      context.go('/terms_and_policy');
                                    }),
                                    child: Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.red)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Cancel',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () async {
                                      EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                      TermsAanPrivacyModel bankInfo = TermsAanPrivacyModel(
                                        title: termsTitleController.text,
                                        description: termsDiscriptionController.text,
                                        isActive: isTermsLive,
                                      );
                                      final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Terms and Conditions');
                                      await adRef.set(bankInfo.toJson());
                                      EasyLoading.showSuccess('Added Successfully');

                                      ///____provider_refresh____________________________________________
                                      ref.refresh(termsProvider);
                                    },
                                    child: Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Save',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                    error: (e, stack) {
                      if (e.toString().contains("TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                        postDataIfNoDataInTerms(ref: ref);
                      }
                      return Center(
                        child: Text(e.toString()),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),

                  ///________Privacy___________________________
                  privacy.when(
                    data: (bankData) {
                      titleController.text = bankData.title;
                      discriptionController.text = bankData.description;
                      j == 0 ? isPrivacyLive = bankData.isActive : null;
                      j++;
                      return Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Privacy Policy', style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,fontSize: isMobileScreen?16:20),),
                                Transform.scale(
                                  scale: 0.8,
                                  child: SizedBox(
                                    height: 20,
                                    width: 36,
                                    child: CupertinoSwitch(
                                      trackColor: Colors.red,
                                      activeColor: kMainColor600,
                                      value: isPrivacyLive,
                                      onChanged: (value) {
                                        setState(() {
                                          isPrivacyLive = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Container(
                            //       width: 130,
                            //       height: 50,
                            //       alignment: Alignment.centerLeft,
                            //       child: const Text('Is Live'),
                            //     ),
                            //     const SizedBox(width: 20),
                            //     CupertinoSwitch(
                            //       trackColor: Colors.red,
                            //       value: isPrivacyLive,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           isPrivacyLive = value;
                            //         });
                            //       },
                            //     ),
                            //   ],
                            // ),

                            ///________bank_Name____________________________
                            TextFormField(
                              decoration: kInputDecoration.copyWith(
                                labelText: 'Title',
                                hintText: 'Enter Title',
                                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kNutral700,fontWeight: FontWeight.w500),
                                hintStyle: Theme.of(context).textTheme.bodyLarge,
                              ),
                              controller: titleController,
                            ),
                            // Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Container(
                            //       width: 130,
                            //       height: 50,
                            //       alignment: Alignment.centerLeft,
                            //       child: const Text('Title'),
                            //     ),
                            //     const SizedBox(width: 20),
                            //     SizedBox(
                            //       width: 500,
                            //       child: TextFormField(
                            //         decoration: const InputDecoration(
                            //           border: OutlineInputBorder(),
                            //           hintText: 'Enter Title',
                            //         ),
                            //         controller: titleController,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 20),

                            ///________Description____________________________
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              decoration: kInputDecoration.copyWith(
                                hintText: 'Enter Description',
                                labelText: 'Description',
                                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kNutral700,fontWeight: FontWeight.w500),
                                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              maxLines: 3,
                              controller: discriptionController,
                            ),
                            // Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       width: 130,
                            //       height: 50,
                            //       alignment: Alignment.centerLeft,
                            //       child: const Text('Description'),
                            //     ),
                            //     const SizedBox(width: 20),
                            //     ResizableTextField(
                            //       levelText: 'Enter Description',
                            //       controller: discriptionController,
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 20),

                            ///_________Buttons_____________________________________
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (() {
                                    // Navigator.pop(context);
                                    // const TermsAndPolicyScreen().launch(context);
                                    context.go('/terms_and_policy');
                                  }),
                                  child: Container(
                                    width: 100,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: Colors.red)),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Cancel',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () async {
                                    EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                    TermsAanPrivacyModel bankInfo = TermsAanPrivacyModel(
                                      title: titleController.text,
                                      description: discriptionController.text,
                                      isActive: isPrivacyLive,
                                    );
                                    final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Privacy Policy');
                                    await adRef.set(bankInfo.toJson());
                                    EasyLoading.showSuccess('Added Successfully');

                                    ///____provider_refresh____________________________________________
                                    ref.refresh(privacyProvider);
                                  },
                                  child: Container(
                                    width: 100,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Save',
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600,color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                    error: (e, stack) {
                      if (e.toString().contains("TypeError: null: type 'Null' is not a subtype of type 'Map<dynamic, dynamic>'")) {
                        postDataIfNoDataInPrivacy(ref: ref);
                      }
                      return Center(
                        child: Text(e.toString()),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ResizableTextField extends StatefulWidget {
  const ResizableTextField({super.key, required this.levelText, required this.controller});

  final String levelText;
  final TextEditingController controller;

  @override
  _ResizableTextFieldState createState() => _ResizableTextFieldState();
}

class _ResizableTextFieldState extends State<ResizableTextField> {
  double _height = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 500,
          height: _height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: TextFormField(
            maxLines: null,
            expands: true,
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              border: InputBorder.none,
              hintText: widget.levelText,
            ),
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) {
            if (_height > 99) {
              setState(() {
                _height += details.delta.dy;
              });
            } else {
              setState(() {
                _height = 100;
              });
            }
          },
          child: Container(
            width: 500,
            height: 10,
            color: Colors.grey,
            alignment: Alignment.center,
            child: const Icon(
              Icons.drag_handle,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
