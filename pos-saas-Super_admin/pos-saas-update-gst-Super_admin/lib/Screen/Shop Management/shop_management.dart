// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_saas_admin/Provider/seller_info_provider.dart';
import 'package:salespro_saas_admin/Screen/Widgets/Pop%20Up/Shop%20Management/view_shop.dart';
import 'package:salespro_saas_admin/model/seller_info_model.dart';
import 'package:salespro_saas_admin/model/subscription_request_model.dart';
import '../../Provider/get_subscription_request_privider.dart';
import '../../Provider/subacription_plan_provider.dart';
import '../../model/subscription_data_post_model.dart';
import '../../model/subscription_model.dart';
import '../../model/subscription_plan_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/Pop Up/Shop Management/edit_shop.dart';
import '../Widgets/Pop Up/view_request.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/Topbar/topbar.dart';

class ShopManagement extends StatefulWidget {
  const ShopManagement({Key? key}) : super(key: key);

  static const String route = '/shop_management';

  @override
  State<ShopManagement> createState() => _ShopManagementState();
}

class _ShopManagementState extends State<ShopManagement>
    with TickerProviderStateMixin {
  //View Shop PopUp
  void showViewShopPopUp(SellerInfoModel info) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ViewShop(
            infoModel: info,
          ),
        );
      },
    );
  }

  late AnimationController _controller;
  bool _isRefreshing = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 1),
  //   );
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    _controller.repeat();

    // Simulate a refresh process (you should replace this with your actual refresh logic)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
    _controller.reset();
  }

  void showViewRequestPopUp(
      {required SubscriptionRequestModel info, required WidgetRef ref}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ViewRequest(
            infoModel: info,
            ref: ref,
          ),
        );
      },
    );
  }

  //Edit Shop PopUp
  void showEditShopPopUp(SellerInfoModel shopInfo) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: EditShop(shopInformation: shopInfo),
        );
      },
    );
  }

  late TabController controller;
  int activeIndex = 0;

  void deleteShop(
      {required String phoneNumber,
      required WidgetRef updateProduct,
      required BuildContext context}) async {
    if (!isDemo) {
      EasyLoading.show(status: 'Deleting..');
      String customerKey = '';

      await FirebaseDatabase.instance
          .ref('Admin Panel')
          .child('Seller List')
          .orderByKey()
          .get()
          .then((value) {
        for (var element in value.children) {
          var data = jsonDecode(jsonEncode(element.value));
          if (data['phoneNumber'].toString() == phoneNumber) {
            customerKey = element.key.toString();
          }
        }
      });

      DatabaseReference ref = FirebaseDatabase.instance.ref(
          'Admin Panel/Seller List/$customerKey'); // Remove single quotes here

      await ref.remove();
      updateProduct.refresh(sellerInfoProvider);
      Navigator.pop(context);
      EasyLoading.showSuccess('Done');
    } else {
      EasyLoading.showInfo(demoText);
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller =
        TabController(length: 3, vsync: this, initialIndex: activeIndex);
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  int selectedIndex = 0;
  ScrollController mainScroll = ScrollController();
  List<String> packageNameList = [];
  List<String> packagePriceList = [];
  String selectedPackage = 'Free';

  List<String> paymentTypeList = ['Bank', 'Card', 'Others'];
  String selectedType = 'Bank';
  // List<String> _paths = [];

  /* Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      List<String> paths = result.paths.map((path) => path!).toList();
      setState(() {
        _paths = paths;
      });
    }
  }
  */

  //______subscription___________________________________________________________________
  SubscriptionPlanModel?
      selectedCategories; // Change to nullable as it starts as null
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  DropdownButton<SubscriptionPlanModel> getPlan(
      {required List<SubscriptionPlanModel> list}) {
    List<DropdownMenuItem<SubscriptionPlanModel>> dropDownItems = [];
    for (var element in list) {
      dropDownItems.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            element.subscriptionName.toString(),
            style: kTextStyle.copyWith(color: kTitleColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return DropdownButton(
      items: dropDownItems,
      hint: Text(
        'Select Plan',
        style: kTextStyle.copyWith(color: kGreyTextColor),
      ),
      value: selectedCategories,
      onChanged: (value) {
        setState(() {
          selectedCategories = value;
        });
      },
    );
  }
  final _horizontalScroll = ScrollController();
  final _verticalScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const Drawer(
      //   child: SideBarWidget(
      //     index: 1,
      //     isTab: false,
      //   ),
      // ),
      // appBar: const GlobalAppbar(),
      backgroundColor: kDarkWhite,
      body: Consumer(
        builder: (_, ref, watch) {
          final sellerInfoData = ref.watch(sellerInfoProvider);
          final subscriptionRequest = ref.watch(subscriptionRequestProvider);
          final reports = ref.watch(subscriptionPlanProvider);
          return selectedIndex == 0
              ? sellerInfoData.when(data: (sellerInfo) {
                  return Container(
                    // width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kWhiteTextColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'SHOP LIST',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    _refreshData();
                                    ref.refresh(sellerInfoProvider);
                                    ref.refresh(
                                        subscriptionRequestProvider);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(6),
                                      border: Border.all(color: kMainColor),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _isRefreshing
                                            ? const SpinKitCircle(
                                                // Using a spinner from the flutter_spinkit package
                                                color: kMainColor,
                                                size: 24.0,
                                              )
                                            : RotationTransition(
                                                turns: _controller,
                                                child: Icon(
                                                  MdiIcons.refresh,
                                                  color: kMainColor,
                                                ),
                                              ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Refresh',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: kMainColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       ref.refresh(sellerInfoProvider);
                                //       ref.refresh(
                                //           subscriptionRequestProvider);
                                //     });
                                //   },
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //         borderRadius:
                                //             BorderRadius.circular(6),
                                //         border:
                                //             Border.all(color: kMainColor)),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Row(
                                //         children: [
                                //           Icon(
                                //             MdiIcons.refresh,
                                //             color: kMainColor,
                                //           ),
                                //           const SizedBox(
                                //             width: 5,
                                //           ),
                                //           Text(
                                //             'Refresh',
                                //             style: Theme.of(context)
                                //                 .textTheme
                                //                 .bodyLarge
                                //                 ?.copyWith(
                                //                     color: kMainColor,
                                //                     fontWeight:
                                //                         FontWeight.w500),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                const ExportButton().visible(false)
                              ],
                            ),
                            const SizedBox(height: 10),
                            ///__________Tab_bar_________________________________________________________-
                            LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                double kConstrainWidth =
                                    constraints.maxWidth;
                                List<String> tabLabels = [
                                  'All Shop list',
                                  'Request for subscription',
                                  'Accepted Subscription Request',
                                  'Rejected Request'
                                ];

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minWidth: kConstrainWidth),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border:
                                          Border.all(color: kGreyTextColor),
                                    ),
                                    child: Row(
                                      children: List.generate(
                                          tabLabels.length, (index) {
                                        bool isSelected =
                                            selectedIndex == index;
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: index == 0 ? 5 : 40),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: isSelected
                                                        ? kMainColor
                                                        : Colors
                                                            .transparent,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        16.0),
                                                child: Text(
                                                  tabLabels[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: isSelected
                                                            ? kMainColor
                                                            : kGreyTextColor,
                                                        fontWeight:
                                                            isSelected
                                                                ? FontWeight
                                                                    .w600
                                                                : FontWeight
                                                                    .w400,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20.0),
                            Expanded(
                              child: RawScrollbar(
                                controller: _horizontalScroll,
                                thickness: 8.0,
                                thumbVisibility: true,
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    double tableWidth = constraints.maxWidth;
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      controller: _horizontalScroll,
                                      child: SingleChildScrollView(
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minWidth: tableWidth),
                                            child: DataTable(
                                              border: TableBorder.all(
                                                color: kBorderColorTextField,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              dividerThickness: 1.0,
                                              headingRowColor:
                                                  WidgetStateProperty.all(
                                                      kMainColor50),
                                              showBottomBorder: true,
                                              headingTextStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                              dataTextStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(color: kNutral800),
                                              columns: const [
                                                DataColumn(
                                                  label: Text('SL.'),
                                                ),
                                                DataColumn(
                                                  label: Text('Logo'),
                                                ),
                                                DataColumn(
                                                  label: Text('Shop Name'),
                                                ),
                                                DataColumn(
                                                  label: Text('Category'),
                                                ),
                                                DataColumn(
                                                  label: Text('Phone'),
                                                ),
                                                DataColumn(
                                                  label: Text('Email'),
                                                ),
                                                DataColumn(
                                                  label: Text('Package'),
                                                ),
                                                DataColumn(
                                                  label: Text('Method'),
                                                ),
                                                // DataColumn(
                                                //   label: Text('DURATION'),
                                                // ),
                                                DataColumn(
                                                  label: Text('Status'),
                                                ),
                                                DataColumn(
                                                  label: Text('Action'),
                                                ),
                                              ],
                                              rows: List.generate(
                                                sellerInfo.length,
                                                (index) => DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Text(
                                                          (index + 1).toString()),
                                                    ),
                                                    DataCell(
                                                      CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundImage:
                                                            NetworkImage(sellerInfo[
                                                                        index]
                                                                    .pictureUrl ??
                                                                ''),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(sellerInfo[index]
                                                              .companyName ??
                                                          ''),
                                                    ),
                                                    DataCell(
                                                      Text(sellerInfo[index]
                                                              .businessCategory ??
                                                          ''),
                                                    ),
                                                    DataCell(
                                                      Text(sellerInfo[index]
                                                              .phoneNumber ??
                                                          ''),
                                                    ),
                                                    DataCell(
                                                      Text(sellerInfo[index]
                                                              .email ??
                                                          ''),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        sellerInfo[index]
                                                                .subscriptionName ??
                                                            '',
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(sellerInfo[index]
                                                              .subscriptionMethod ??
                                                          ''),
                                                    ),
                                                    // const DataCell(
                                                    //   Text('Free 30 days'),
                                                    // ),
                                                    DataCell(
                                                      Text(
                                                        'Active',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.green),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      PopupMenuButton(
                                                        color: Colors.white,
                                                        padding: EdgeInsets.zero,
                                                        itemBuilder:
                                                            (BuildContext bc) => [
                                                          PopupMenuItem(
                                                            child:
                                                                GestureDetector(
                                                              onTap: (() =>
                                                                  showViewShopPopUp(
                                                                      sellerInfo[
                                                                          index])),
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                      FeatherIcons
                                                                          .eye,
                                                                      size: 18.0,
                                                                      color:
                                                                          kTitleColor),
                                                                  const SizedBox(
                                                                      width: 4.0),
                                                                  Text(
                                                                    'View',
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kTitleColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          PopupMenuItem(
                                                              child:
                                                                  GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          dialogContext) {
                                                                    final kMoiblePopUp=MediaQuery.of(context).size.width<365;
                                                                    return Center(
                                                                      child:
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(16.0),
                                                                            child: Container(
                                                                                                                                                  decoration:
                                                                              const BoxDecoration(
                                                                            color: Colors
                                                                                .white,
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(
                                                                                  15),
                                                                            ),
                                                                                                                                                  ),
                                                                                                                                                  child:
                                                                              Padding(
                                                                            padding: const EdgeInsets
                                                                                .all(
                                                                                20.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize:
                                                                                  MainAxisSize.min,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.center,
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              children: [
                                                                                const Text(
                                                                                  'Are you want to delete this Shop',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 22),
                                                                                ),
                                                                                const SizedBox(height: 30),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      child: Container(
                                                                                        height: 50,
                                                                                        width: kMoiblePopUp?100: 130,
                                                                                        decoration: const BoxDecoration(
                                                                                          color: Colors.green,
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(15),
                                                                                          ),
                                                                                        ),
                                                                                        child: const Center(
                                                                                          child: Text(
                                                                                            'Cancel',
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        Navigator.pop(dialogContext);
                                                                                        Navigator.pop(bc);
                                                                                      },
                                                                                    ),
                                                                                    const SizedBox(width: 30),
                                                                                    GestureDetector(
                                                                                      child: Container(
                                                                                        width: kMoiblePopUp?100:130,
                                                                                        height: 50,
                                                                                        decoration: const BoxDecoration(
                                                                                          color: Colors.red,
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(15),
                                                                                          ),
                                                                                        ),
                                                                                        child: const Center(
                                                                                          child: Text(
                                                                                            'Delete',
                                                                                            style: TextStyle(color: Colors.white),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        deleteShop(phoneNumber: sellerInfo[index].phoneNumber, updateProduct: ref, context: bc);
                                                                                        Navigator.pop(dialogContext);
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                                                                                                  ),
                                                                                                                                                ),
                                                                          ),
                                                                    );
                                                                  });
                                                            },
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.delete,
                                                                  size: 18,
                                                                  color:
                                                                      kTitleColor,
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  'Delete',
                                                                  style: kTextStyle
                                                                      .copyWith(
                                                                          color:
                                                                              kTitleColor),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                          //__________________________________________________________________________Subscription_req_popup
                                                          PopupMenuItem(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      SubscriptionPostRequestModel
                                                                          data =
                                                                          SubscriptionPostRequestModel(
                                                                        subscriptionPlanModel: SubscriptionPlanModel(
                                                                            dueNumber:
                                                                                0,
                                                                            duration:
                                                                                0,
                                                                            offerPrice:
                                                                                0,
                                                                            partiesNumber:
                                                                                0,
                                                                            products:
                                                                                0,
                                                                            purchaseNumber:
                                                                                0,
                                                                            saleNumber:
                                                                                0,
                                                                            subscriptionName:
                                                                                '',
                                                                            subscriptionPrice:
                                                                                00),
                                                                        transactionNumber:
                                                                            '',
                                                                        note: '',
                                                                        attachment:
                                                                            '',
                                                                        userId:
                                                                            sellerInfo[index].userID ??
                                                                                '',
                                                                        businessCategory:
                                                                            sellerInfo[index].businessCategory ??
                                                                                '',
                                                                        companyName:
                                                                            sellerInfo[index].companyName ??
                                                                                '',
                                                                        countryName:
                                                                            sellerInfo[index].countryName ??
                                                                                '',
                                                                        language:
                                                                            sellerInfo[index].language ??
                                                                                '',
                                                                        phoneNumber:
                                                                            sellerInfo[index].phoneNumber ??
                                                                                '',
                                                                        pictureUrl:
                                                                            sellerInfo[index].pictureUrl ??
                                                                                '',
                                                                      );
                                                                      // Future<void> uploadFile(String filePath) async {
                                                                      //   File file = File(filePath);
                                                                      //   try {
                                                                      //     EasyLoading.show(
                                                                      //       status: 'Uploading... ',
                                                                      //       dismissOnTap: false,
                                                                      //     );
                                                                      //     var snapshot = await FirebaseStorage.instance
                                                                      //         .ref('Subscription Attachment/${DateTime.now().millisecondsSinceEpoch}')
                                                                      //         .putFile(file);
                                                                      //     var url = await snapshot.ref.getDownloadURL();
                                                                      //
                                                                      //     data.attachment = url.toString();
                                                                      //   } catch (e) {
                                                                      //     EasyLoading.dismiss();
                                                                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                                                      //   }
                                                                      // }
                                                                    
                                                                      return Dialog(
                                                                        backgroundColor: Colors.white,
                                                                        child:
                                                                            StatefulBuilder(
                                                                          builder: (BuildContext
                                                                                  context,
                                                                              void Function(void Function())
                                                                                  newState) {
                                                                            String
                                                                                attachmentUrl =
                                                                                '';
                                                                            Future<void>
                                                                                uploadFile() async {
                                                                              if (kIsWeb) {
                                                                                try {
                                                                                  Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
                                                                                  if (bytesFromPicker!.isNotEmpty) {
                                                                                    EasyLoading.show(
                                                                                      status: 'Uploading..',
                                                                                      dismissOnTap: false,
                                                                                    );
                                                                                  }
                                                                    
                                                                                  var snapshot = await FirebaseStorage.instance.ref('Homepage Advertising Storage/${DateTime.now().millisecondsSinceEpoch}').putData(bytesFromPicker);
                                                                                  var url = await snapshot.ref.getDownloadURL();
                                                                                  EasyLoading.showSuccess('Upload Successful!');
                                                                    
                                                                                  attachmentUrl = url.toString();
                                                                                } on FirebaseException catch (e) {
                                                                                  EasyLoading.dismiss();
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
                                                                                }
                                                                              }
                                                                            }
                                                                    
                                                                            return SizedBox(
                                                                              width:
                                                                                  500,
                                                                              child:
                                                                                  SingleChildScrollView(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(10.0),
                                                                                  child: reports.when(data: (snapShot) {
                                                                                    return subscriptionRequest.when(data: (sellerSnap) {
                                                                                      return Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              const Text(
                                                                                                'Package Information',
                                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                              const Spacer(),
                                                                                              Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  border: Border.all(color: Colors.redAccent),
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                                  child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          finish(context);
                                                                                                        });
                                                                                                      },
                                                                                                      child: const Icon(
                                                                                                        Icons.close,
                                                                                                        size: 20,
                                                                                                      )),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          Container(
                                                                                            height: 1,
                                                                                            width: double.infinity,
                                                                                            color: kBorderColorTextField,
                                                                                          ),
                                                                                          const SizedBox(height: 15),
                                                                                          Column(
                                                                                            children: [
                                                                                              SizedBox(
                                                                                                height: 58,
                                                                                                child: FormField(
                                                                                                  builder: (FormFieldState<dynamic> field) {
                                                                                                    return InputDecorator(
                                                                                                      decoration: kInputDecoration.copyWith(contentPadding: const EdgeInsets.all(5), labelText: 'Package Name'),
                                                                                                      child: DropdownButtonHideUnderline(
                                                                                                          child: DropdownButton<SubscriptionPlanModel>(
                                                                                                        // Initial Value
                                                                                                        value: selectedCategories,
                                                                    
                                                                                                        // Down Arrow Icon
                                                                                                        icon: const Icon(Icons.keyboard_arrow_down),
                                                                    
                                                                                                        // Array list of items
                                                                                                        items: snapShot.map((var items) {
                                                                                                          return DropdownMenuItem(
                                                                                                            value: items,
                                                                                                            child: Text(items.subscriptionName),
                                                                                                          );
                                                                                                        }).toList(),
                                                                                                        // After selecting the desired option,it will
                                                                                                        // change button value to selected value
                                                                                                        onChanged: (var newValue) {
                                                                                                          newState(() {
                                                                                                            selectedCategories = newValue;
                                                                                                            durationController.text = newValue?.duration.toString() ?? "0";
                                                                                                            priceController.text = newValue?.offerPrice.toString() ?? "0";
                                                                                                          });
                                                                                                        },
                                                                                                      )),
                                                                                                    );
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              const SizedBox(height: 10),
                                                                                              TextFormField(
                                                                                                readOnly: true,
                                                                                                controller: durationController,
                                                                                                decoration: sInputDecoration.copyWith(floatingLabelBehavior: FloatingLabelBehavior.always, labelText: 'Duration', hintText: 'Enter Duration in Days'),
                                                                                              ),
                                                                                              const SizedBox(height: 15),
                                                                                              TextFormField(
                                                                                                readOnly: true,
                                                                                                controller: priceController,
                                                                                                decoration: sInputDecoration.copyWith(
                                                                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                                  labelText: 'Plan Price',
                                                                                                  hintText: 'Enter price',
                                                                                                ),
                                                                                              ),
                                                                                              const SizedBox(height: 15),
                                                                                              TextFormField(
                                                                                                onChanged: (value) {
                                                                                                  data.transactionNumber = value;
                                                                                                },
                                                                                                decoration: kInputDecoration.copyWith(floatingLabelBehavior: FloatingLabelBehavior.always, labelText: 'Transaction ID', hintStyle: kTextStyle.copyWith(color: kGreyTextColor), labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor), hintText: 'Enter transaction  id'),
                                                                                                // initialValue: selectedCategories..toString(),
                                                                                              ),
                                                                                              const SizedBox(height: 15),
                                                                                              TextFormField(
                                                                                                onTap: () async {
                                                                                                  await uploadFile();
                                                                                                },
                                                                                                readOnly: true,
                                                                                                decoration: kInputDecoration.copyWith(
                                                                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                                                    labelText: 'Upload Document',
                                                                                                    labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                                                                                                    hintText: "Upload File",
                                                                                                    hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                                                                    suffixIcon: const Icon(
                                                                                                      FeatherIcons.upload,
                                                                                                      color: kGreyTextColor,
                                                                                                    )),
                                                                                                initialValue: attachmentUrl,
                                                                                              ),
                                                                                              const SizedBox(height: 15),
                                                                                              TextFormField(
                                                                                                maxLines: 3,
                                                                                                onChanged: (value) {
                                                                                                  data.note = value;
                                                                                                },
                                                                                                keyboardType: TextInputType.multiline,
                                                                                                decoration: kInputDecoration.copyWith(floatingLabelBehavior: FloatingLabelBehavior.always, hintStyle: kTextStyle.copyWith(color: kGreyTextColor), labelText: 'Note', labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor), hintText: 'Enter Note'),
                                                                                              ),
                                                                                              const SizedBox(height: 20),
                                                                                              GestureDetector(
                                                                                                onTap: () async {
                                                                                                  SubscriptionModel selectedSubscription = SubscriptionModel(
                                                                                                    subscriptionName: selectedCategories?.subscriptionName.toString() ?? '',
                                                                                                    subscriptionDate: DateTime.now().toString(),
                                                                                                    saleNumber: selectedCategories?.saleNumber ?? 0,
                                                                                                    purchaseNumber: selectedCategories?.purchaseNumber ?? 0,
                                                                                                    partiesNumber: selectedCategories?.partiesNumber ?? 0,
                                                                                                    dueNumber: selectedCategories?.dueNumber ?? 0,
                                                                                                    duration: selectedCategories?.duration ?? 0,
                                                                                                    products: selectedCategories?.products ?? 0,
                                                                                                  );
                                                                    
                                                                                                  if (selectedCategories == null) {
                                                                                                    EasyLoading.showError('Please select a plan');
                                                                                                  } else {
                                                                                                    EasyLoading.show(status: 'Loading...');
                                                                                                    data.subscriptionPlanModel = selectedCategories!;
                                                                                                    data.attachment = attachmentUrl;
                                                                                                    // data.attachment == '' ? null : await uploadFile(data.attachment);
                                                                                                    final DatabaseReference ref1 = FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Update Request');
                                                                    
                                                                                                    ref1.push().set(data.toJson());
                                                                    
                                                                                                    final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(data.userId).child('Subscription');
                                                                    
                                                                                                    await subscriptionRef.set(selectedSubscription.toJson());
                                                                    
                                                                                                    ///___________Smaller_info_Update______________________________________________________
                                                                    
                                                                                                    String imageKey = '';
                                                                                                    await FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').orderByKey().get().then((value) async {
                                                                                                      for (var element in value.children) {
                                                                                                        var data1 = jsonDecode(jsonEncode(element.value));
                                                                                                        if (data1['userId'].toString() == sellerInfo[index].userID) {
                                                                                                          imageKey = element.key.toString();
                                                                                                        }
                                                                                                      }
                                                                                                    });
                                                                                                    DatabaseReference ref2 = FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').child(imageKey);
                                                                                                    await ref2.update({
                                                                                                      'subscriptionDate': DateTime.now().toString(),
                                                                                                      'subscriptionName': data.subscriptionPlanModel.subscriptionName,
                                                                                                    });
                                                                    
                                                                                                    ///____provider_refresh____________________________________________
                                                                                                    ref.refresh(subscriptionRequestProvider);
                                                                                                    ref.refresh(sellerInfoProvider);
                                                                    
                                                                                                    EasyLoading.showSuccess('Done');
                                                                    
                                                                                                    Future.delayed(const Duration(milliseconds: 100), () {
                                                                                                      Navigator.pop(context);
                                                                                                    });
                                                                                                  }
                                                                                                },
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  height: 50,
                                                                                                  width: double.infinity,
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                    color: kMainColor,
                                                                                                  ),
                                                                                                  child: Text(
                                                                                                    'Submit',
                                                                                                    style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      );
                                                                                    }, error: (e, stock) {
                                                                                      return Center(
                                                                                        child: Text(e.toString()),
                                                                                      );
                                                                                    }, loading: () {
                                                                                      return const Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      );
                                                                                    });
                                                                                  }, error: (e, stock) {
                                                                                    return Center(
                                                                                      child: Text(e.toString()),
                                                                                    );
                                                                                  }, loading: () {
                                                                                    return const Center(
                                                                                      child: CircularProgressIndicator(),
                                                                                    );
                                                                                  }),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons.add,
                                                                      size: 18.0,
                                                                      color:
                                                                          kTitleColor),
                                                                  const SizedBox(
                                                                      width: 4.0),
                                                                  Text(
                                                                    'Upgrade',
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kTitleColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                        onSelected: (value) {
                                                          Navigator.pushNamed(
                                                              context, '$value');
                                                        },
                                                        icon: const Icon(
                                                            FeatherIcons
                                                                .moreVertical,
                                                            size: 18.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }, error: (e, stack) {
                  return Center(
                    child: Text(e.toString()),
                  );
                }, loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })
              : subscriptionRequest.when(data: (requests) {
                  List<SubscriptionRequestModel> pendingList = [];
                  List<SubscriptionRequestModel> approvedList = [];
                  List<SubscriptionRequestModel> rejectedList = [];

                  for (var element in requests) {
                    if (element.status == 'pending') {
                      pendingList.add(element);
                    } else if (element.status == 'approved') {
                      approvedList.add(element);
                    } else {
                      rejectedList.add(element);
                    }
                  }
                 // return Container(
                 //   decoration: const BoxDecoration(color: kDarkWhite),
                 //   child: Padding(
                 //     padding: const EdgeInsets.all(20.0),
                 //     child: Container(
                 //       padding: const EdgeInsets.all(10.0),
                 //       decoration: BoxDecoration(
                 //         borderRadius: BorderRadius.circular(10.0),
                 //         color: kWhiteTextColor,
                 //       ),
                 //       child: Scrollbar(
                 //         thumbVisibility: true,
                 //         controller: mainScroll,
                 //         child: SingleChildScrollView(
                 //           controller: mainScroll,
                 //           child: Column(
                 //             crossAxisAlignment: CrossAxisAlignment.start,
                 //             children: [
                 //               Row(
                 //                 children: [
                 //                   Text(
                 //                     'Shop List',
                 //                     style: Theme.of(context)
                 //                         .textTheme
                 //                         .titleLarge
                 //                         ?.copyWith(fontWeight: FontWeight.w600),
                 //                   ),
                 //                   const Spacer(),
                 //                   GestureDetector(
                 //                     onTap: () {
                 //                       _refreshData();
                 //                       ref.refresh(sellerInfoProvider);
                 //                       ref.refresh(subscriptionRequestProvider);
                 //                     },
                 //                     child: Container(
                 //                       decoration: BoxDecoration(
                 //                         borderRadius: BorderRadius.circular(6),
                 //                         border: Border.all(color: kMainColor),
                 //                       ),
                 //                       padding: const EdgeInsets.all(8.0),
                 //                       child: Row(
                 //                         mainAxisSize: MainAxisSize.min,
                 //                         children: [
                 //                           _isRefreshing
                 //                               ? const SpinKitCircle(
                 //                             color: kMainColor,
                 //                             size: 24.0,
                 //                           )
                 //                               : RotationTransition(
                 //                             turns: _controller,
                 //                             child: Icon(
                 //                               MdiIcons.refresh,
                 //                               color: kMainColor,
                 //                             ),
                 //                           ),
                 //                           const SizedBox(width: 5),
                 //                           Text(
                 //                             'Refresh',
                 //                             style: Theme.of(context)
                 //                                 .textTheme
                 //                                 .bodyLarge
                 //                                 ?.copyWith(
                 //                               color: kMainColor,
                 //                               fontWeight: FontWeight.w500,
                 //                             ),
                 //                           ),
                 //                         ],
                 //                       ),
                 //                     ),
                 //                   ),
                 //                   const ExportButton().visible(false),
                 //                 ],
                 //               ),
                 //               const SizedBox(height: 10),
                 //               LayoutBuilder(
                 //                 builder: (BuildContext context, BoxConstraints constraints) {
                 //                   double kWidth = constraints.maxWidth;
                 //                   return SingleChildScrollView(
                 //                     scrollDirection: Axis.horizontal,
                 //                     controller: mainScroll,
                 //                     child: ConstrainedBox(
                 //                       constraints: BoxConstraints(minWidth: kWidth),
                 //                       child: DataTable(
                 //                         border: TableBorder.all(
                 //                           color: kBorderColorTextField,
                 //                           borderRadius: BorderRadius.circular(5.0),
                 //                         ),
                 //                         dividerThickness: 1.0,
                 //                         headingRowColor:
                 //                         MaterialStateProperty.all(kMainColor50),
                 //                         showBottomBorder: true,
                 //                         headingTextStyle: Theme.of(context)
                 //                             .textTheme
                 //                             .titleSmall
                 //                             ?.copyWith(
                 //                           fontWeight: FontWeight.w600,
                 //                         ),
                 //                         dataTextStyle: Theme.of(context)
                 //                             .textTheme
                 //                             .bodyMedium
                 //                             ?.copyWith(color: kNutral800),
                 //                         horizontalMargin: 20.0,
                 //                         columns: const [
                 //                           DataColumn(label: Text('SL.')),
                 //                           DataColumn(label: Text('Logo')),
                 //                           DataColumn(label: Text('Shop Name')),
                 //                           DataColumn(label: Text('Category')),
                 //                           DataColumn(label: Text('Phone')),
                 //                           DataColumn(label: Text('Package')),
                 //                           DataColumn(label: Text('Amount')),
                 //                           DataColumn(label: Text('Transaction No.')),
                 //                           DataColumn(label: Text('Duration')),
                 //                           DataColumn(label: Text('Status')),
                 //                           DataColumn(label: Text('Action')),
                 //                         ],
                 //                         rows: List.generate(
                 //                           pendingList.length,
                 //                               (index) => DataRow(
                 //                             cells: [
                 //                               DataCell(Text((index + 1).toString())),
                 //                               DataCell(
                 //                                 CircleAvatar(
                 //                                   radius: 20.0,
                 //                                   backgroundImage: NetworkImage(
                 //                                     pendingList[index].pictureUrl ?? '',
                 //                                   ),
                 //                                 ),
                 //                               ),
                 //                               DataCell(Text(pendingList[index].companyName ?? '')),
                 //                               DataCell(
                 //                                   Text(pendingList[index].businessCategory ?? '')),
                 //                               DataCell(
                 //                                   Text(pendingList[index].phoneNumber ?? '')),
                 //                               DataCell(
                 //                                   Text(pendingList[index].subscriptionName)),
                 //                               DataCell(Text(pendingList[index].amount.toString())),
                 //                               DataCell(
                 //                                   Text(pendingList[index].transactionNumber)),
                 //                               DataCell(Text('${pendingList[index].duration} days')),
                 //                               DataCell(
                 //                                 Text(
                 //                                   'Pending',
                 //                                   style: Theme.of(context)
                 //                                       .textTheme
                 //                                       .titleSmall
                 //                                       ?.copyWith(
                 //                                     color: const Color(0xffFF8C00),
                 //                                     fontWeight: FontWeight.w500,
                 //                                   ),
                 //                                 ),
                 //                               ),
                 //                               DataCell(
                 //                                 onTap: () {
                 //                                   showViewRequestPopUp(
                 //                                       info: pendingList[index], ref: ref);
                 //                                 },
                 //                                 Text(
                 //                                   'Approve >',
                 //                                   style: Theme.of(context)
                 //                                       .textTheme
                 //                                       .titleSmall
                 //                                       ?.copyWith(
                 //                                     color: const Color(0xff2DB0F6),
                 //                                     fontWeight: FontWeight.w500,
                 //                                   ),
                 //                                 ),
                 //                               ),
                 //                             ],
                 //                           ),
                 //                         ),
                 //                       ),
                 //                     ),
                 //                   );
                 //                 },
                 //               ),
                 //             ],
                 //           ),
                 //         ),
                 //       ),
                 //     ),
                 //   ),
                 // );

            return Container(
                    // height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(color: kDarkWhite),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: kWhiteTextColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Shop List',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    _refreshData();
                                    ref.refresh(sellerInfoProvider);
                                    ref.refresh(
                                        subscriptionRequestProvider);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(6),
                                      border: Border.all(color: kMainColor),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _isRefreshing
                                            ? const SpinKitCircle(
                                                // Using a spinner from the flutter_spinkit package
                                                color: kMainColor,
                                                size: 24.0,
                                              )
                                            : RotationTransition(
                                                turns: _controller,
                                                child: Icon(
                                                  MdiIcons.refresh,
                                                  color: kMainColor,
                                                ),
                                              ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Refresh',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: kMainColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const ExportButton().visible(false)
                              ],
                            ),
                            const SizedBox(height: 10),
                                                
                            ///__________Tab_bar_________________________________________________________-
                            LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                double kWidth=constraints.maxWidth;
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth: kWidth
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                        Border.all(color: kGreyTextColor)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = 0;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: selectedIndex ==
                                                                0
                                                                ? kMainColor
                                                                : Colors
                                                                .transparent,
                                                            width: 2))),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(16.0),
                                                  child: Text(
                                                    'All Shop list',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                        color: selectedIndex ==
                                                            0
                                                            ? kMainColor
                                                            : kGreyTextColor,
                                                        fontWeight:
                                                        selectedIndex == 0
                                                            ? FontWeight
                                                            .w600
                                                            : FontWeight
                                                            .w400),
                                                  ),
                                                ),
                                              )),
                                        ),
                                        const SizedBox(width: 40),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = 1;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: selectedIndex == 1
                                                            ? kMainColor
                                                            : Colors.transparent,
                                                        width: 2))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Request for subscription',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                        color: selectedIndex ==
                                                            1
                                                            ? kMainColor
                                                            : kGreyTextColor,
                                                        fontWeight:
                                                        selectedIndex == 1
                                                            ? FontWeight
                                                            .w600
                                                            : FontWeight
                                                            .w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = 2;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: selectedIndex == 2
                                                            ? kMainColor
                                                            : Colors.transparent,
                                                        width: 2.0))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Accepted Subscription Request',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                        color: selectedIndex ==
                                                            2
                                                            ? kMainColor
                                                            : kGreyTextColor,
                                                        fontWeight:
                                                        selectedIndex == 2
                                                            ? FontWeight
                                                            .w600
                                                            : FontWeight
                                                            .w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = 3;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: selectedIndex == 3
                                                            ? kMainColor
                                                            : Colors
                                                            .transparent))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Rejected Request',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                        color: selectedIndex ==
                                                            3
                                                            ? kMainColor
                                                            : kGreyTextColor,
                                                        fontWeight:
                                                        selectedIndex == 3
                                                            ? FontWeight
                                                            .w600
                                                            : FontWeight
                                                            .w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // const Spacer(),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       ref.refresh(sellerInfoProvider);
                                        //       ref.refresh(subscriptionRequestProvider);
                                        //     });
                                        //   },
                                        //   child: Container(
                                        //     alignment: Alignment.center,
                                        //     height: 35,
                                        //     width: 100,
                                        //     decoration: const BoxDecoration(color: Colors.red),
                                        //     child: Text(
                                        //       'Refresh',
                                        //       style: kTextStyle,
                                        //     ),
                                        //   ),
                                        // ),
                                        // const SizedBox(width: 20)
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20.0),
                            Expanded(
                              child: RawScrollbar(
                                thumbVisibility: true,
                                controller: _horizontalScroll,
                                thickness: 8.0,
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    double kWidth = constraints.maxWidth;
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      controller: _horizontalScroll,
                                      child: SingleChildScrollView(
                                        controller: _verticalScroll,
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(minWidth: kWidth),
                                          child: selectedIndex == 1
                                              ? DataTable(
                                                  border: TableBorder.all(
                                                    color: kBorderColorTextField,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  dividerThickness: 1.0,
                                                  headingRowColor:
                                                      WidgetStateProperty.all(
                                                          kMainColor50),
                                                  showBottomBorder: true,
                                                  headingTextStyle:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                  dataTextStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: kNutral800),
                                                  horizontalMargin: 20.0,
                                                  columns: const [
                                                    DataColumn(
                                                      label: Text('SL.'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Logo'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Shop Name'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Category'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Phone'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Package'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Amount'),
                                                    ),
                                                    DataColumn(
                                                      label:
                                                          Text('Transaction No.'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Duration'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Status'),
                                                    ),
                                                    DataColumn(
                                                      label: Text('Action'),
                                                    ),
                                                  ],
                                                  rows: List.generate(
                                                    pendingList.length,
                                                    (index) => DataRow(
                                                      cells: [
                                                        DataCell(
                                                          Text((index + 1)
                                                              .toString()),
                                                        ),
                                                        DataCell(
                                                          CircleAvatar(
                                                            radius: 20.0,
                                                            backgroundImage:
                                                                NetworkImage(pendingList[
                                                                            index]
                                                                        .pictureUrl ??
                                                                    ''),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(pendingList[index]
                                                                  .companyName ??
                                                              ''),
                                                        ),
                                                        DataCell(
                                                          Text(pendingList[index]
                                                                  .businessCategory ??
                                                              ''),
                                                        ),
                                                        DataCell(
                                                          Text(pendingList[index]
                                                                  .phoneNumber ??
                                                              ''),
                                                        ),
                                                        DataCell(
                                                          Text(pendingList[index]
                                                              .subscriptionName),
                                                        ),
                                                        DataCell(
                                                          Text(pendingList[index]
                                                              .amount
                                                              .toString()),
                                                        ),
                                                        DataCell(
                                                          Text(pendingList[index]
                                                              .transactionNumber),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                              '${pendingList[index].duration} days'),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            'Pending',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                    color: const Color(
                                                                        0xffFF8C00),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          onTap: () {
                                                            showViewRequestPopUp(
                                                                info: pendingList[
                                                                    index],
                                                                ref: ref);
                                                          },
                                                          Text(
                                                            'Approve >',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                    color: const Color(
                                                                        0xff2DB0F6),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : selectedIndex == 2
                                                  ? DataTable(
                                                      border: TableBorder.all(
                                                        color:
                                                            kBorderColorTextField,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5.0),
                                                      ),
                                                      dividerThickness: 1.0,
                                                      headingRowColor:
                                                          WidgetStateProperty.all(
                                                              kMainColor50),
                                                      showBottomBorder: true,
                                                      headingTextStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                      dataTextStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color:
                                                                      kNutral800),
                                                      horizontalMargin: 20.0,
                                                      columns: const [
                                                        DataColumn(
                                                          label: Text('S.L'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Logo'),
                                                        ),
                                                        DataColumn(
                                                          label:
                                                              Text('Shop Name'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Category'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Phone'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Package'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Amount'),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                              'Transaction No.'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Duration'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Status'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Action'),
                                                        ),
                                                      ],
                                                      rows: List.generate(
                                                        approvedList.length,
                                                        (index) => DataRow(
                                                          cells: [
                                                            DataCell(
                                                              Text((index + 1)
                                                                  .toString()),
                                                            ),
                                                            DataCell(
                                                              CircleAvatar(
                                                                radius: 20.0,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        approvedList[index]
                                                                                .pictureUrl ??
                                                                            ''),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(approvedList[
                                                                          index]
                                                                      .companyName ??
                                                                  ''),
                                                            ),
                                                            DataCell(
                                                              Text(approvedList[
                                                                          index]
                                                                      .businessCategory ??
                                                                  ''),
                                                            ),
                                                            DataCell(
                                                              Text(approvedList[
                                                                          index]
                                                                      .phoneNumber ??
                                                                  ''),
                                                            ),
                                                            DataCell(
                                                              Text(approvedList[
                                                                      index]
                                                                  .subscriptionName),
                                                            ),
                                                            DataCell(
                                                              Text(approvedList[
                                                                      index]
                                                                  .amount
                                                                  .toString()),
                                                            ),
                                                            DataCell(
                                                              Text(approvedList[
                                                                      index]
                                                                  .transactionNumber),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                  '${approvedList[index].duration} days'),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                'Approved',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleSmall
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .green,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              onTap: () {
                                                                showViewRequestPopUp(
                                                                    info:
                                                                        approvedList[
                                                                            index],
                                                                    ref: ref);
                                                              },
                                                              Text(
                                                                'View >',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                      color:
                                                                          kMainColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : DataTable(
                                                      border: TableBorder.all(
                                                        color:
                                                            kBorderColorTextField,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5.0),
                                                      ),
                                                      dividerThickness: 1.0,
                                                      headingRowColor:
                                                          WidgetStateProperty.all(
                                                              kMainColor50),
                                                      showBottomBorder: true,
                                                      headingTextStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                      dataTextStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color:
                                                                      kNutral800),
                                                      horizontalMargin: 20.0,
                                                      columns: const [
                                                        DataColumn(
                                                          label: Text('S.L'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Logo'),
                                                        ),
                                                        DataColumn(
                                                          label:
                                                              Text('Shop Name'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Category'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Phone'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Package'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Amount'),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                              'Transaction No.'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Duration'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Status'),
                                                        ),
                                                        DataColumn(
                                                          label: Text('Action'),
                                                        ),
                                                      ],
                                                      rows: List.generate(
                                                        rejectedList.length,
                                                        (index) => DataRow(
                                                          cells: [
                                                            DataCell(
                                                              Text((index + 1)
                                                                  .toString()),
                                                            ),
                                                            DataCell(
                                                              CircleAvatar(
                                                                radius: 20.0,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        rejectedList[index]
                                                                                .pictureUrl ??
                                                                            ''),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(rejectedList[
                                                                          index]
                                                                      .companyName ??
                                                                  ''),
                                                            ),
                                                            DataCell(
                                                              Text(rejectedList[
                                                                          index]
                                                                      .businessCategory ??
                                                                  ''),
                                                            ),
                                                            DataCell(
                                                              Text(rejectedList[
                                                                          index]
                                                                      .phoneNumber ??
                                                                  ''),
                                                            ),
                                                            DataCell(
                                                              Text(rejectedList[
                                                                      index]
                                                                  .subscriptionName),
                                                            ),
                                                            DataCell(
                                                              Text(rejectedList[
                                                                      index]
                                                                  .amount
                                                                  .toString()),
                                                            ),
                                                            DataCell(
                                                              Text(rejectedList[
                                                                      index]
                                                                  .transactionNumber),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                  '${rejectedList[index].duration} days'),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                'Rejected',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleSmall
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              onTap: () {
                                                                showViewRequestPopUp(
                                                                    info:
                                                                        rejectedList[
                                                                            index],
                                                                    ref: ref);
                                                              },
                                                              Text(
                                                                'View >',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                        color:
                                                                            kMainColor),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }, error: (e, stack) {
                  return Center(
                    child: Text(e.toString()),
                  );
                }, loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                });
        },
      ),
    );
  }
}
