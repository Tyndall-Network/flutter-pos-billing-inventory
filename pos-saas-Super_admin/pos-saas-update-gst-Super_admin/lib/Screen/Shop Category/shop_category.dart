import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_saas_admin/Provider/shop_category_provider.dart';
import 'package:salespro_saas_admin/Screen/Widgets/Constant%20Data/transparent_button.dart';
import 'package:salespro_saas_admin/model/shop_category_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/Pop Up/Shop Category/edit_category.dart';
import '../Widgets/Pop Up/Shop Category/new_category.dart';
import '../Widgets/Pop Up/Shop Category/view_category.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/Topbar/topbar.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

class ShopCategory extends StatefulWidget {
  const ShopCategory({Key? key}) : super(key: key);

  static const String route = '/shop_category';

  @override
  State<ShopCategory> createState() => _ShopCategoryState();
}

class _ShopCategoryState extends State<ShopCategory> with TickerProviderStateMixin {
  //Add New Category PopUp
  // void showAddCategoryPopUp() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         child: const NewCategory(),
  //       );
  //     },
  //   );
  // }

  //VIEW Category PopUp
  void showViewCategoryPopUP(ShopCategoryModel category) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ViewCategory(categoryModel: category),
        );
      },
    );
  }

  void deleteShopCategory({required String categoryName, required WidgetRef updateProduct, required BuildContext context}) async {
    EasyLoading.show(status: 'Deleting..');
    String customerKey = '';

    await FirebaseDatabase.instance.ref('Admin Panel').child('Category').orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['categoryName'].toString() == categoryName) {
          customerKey = element.key.toString();
        }
      }
    });

    DatabaseReference ref = FirebaseDatabase.instance.ref('Admin Panel/Category/$customerKey'); // Remove single quotes here

    await ref.remove();
    // updateProduct.refresh(shopCategoryProvider);
    Navigator.pop(context);
    EasyLoading.showSuccess('Done');
  }

  late TabController controller;
  int activeIndex = 0;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this, initialIndex: activeIndex);
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  final _horizontalScroll = ScrollController();
  final _verticalScroll = ScrollController();


  @override
  Widget build(BuildContext context) {
    final kSmallScreen=rf.ResponsiveValue<bool>(
      context,
      defaultValue: false,
      conditionalValues: [
        const rf.Condition.between(start: 300, end: 400,value: true)
      ]
    ).value;
    return Scaffold(
      backgroundColor: kDarkWhite,
      // drawer: const Drawer(
      //   child: SideBarWidget(
      //     index: 2,
      //     isTab: false,
      //   ),
      // ),
      // appBar: const GlobalAppbar(),
      body: Consumer(
        builder: (_, ref, watch) {
          AsyncValue<List<ShopCategoryModel>> categoryList = ref.watch(shopCategoryProvider);
          return categoryList.when(data: (categoryList) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Shop Category',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: (() => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                // child:  NewCategory(listOfIncomeCategory: categoryList ?? [],),
                                child:  NewCategory(listOfIncomeCategory: categoryList,),
                              );
                            },
                          )),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: kMainColor600)
                            ),
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                    height: 20,
                                    width: 20,
                                    // padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: kMainColor600),
                                    ),
                                    child: const Icon(Icons.add,color: kMainColor,size: 18,)),
                                const SizedBox(width: 5,),
                                Text(
                                 kSmallScreen?'Category': 'New Category',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kMainColor600,fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width * .25,
                          child: TextField(
                            showCursor: true,
                            cursorColor: kTitleColor,
                            decoration: kInputDecoration.copyWith(
                              hintText: 'Search Anything...',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: kBlueTextColor,
                                  ),
                                  child: const Icon(FeatherIcons.search, color: kWhiteTextColor),
                                ),
                              ),
                              hintStyle: kTextStyle.copyWith(color: kLitGreyColor),
                              contentPadding: const EdgeInsets.all(4.0),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const ExportButton()
                      ],
                    ).visible(false),
                    const SizedBox(height: 10.0),
                    Expanded(
                      child: RawScrollbar(
                        thickness: 8.0,
                        controller: _horizontalScroll,
                        thumbVisibility: true,
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            double kWidth=constraints.maxWidth;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalScroll,
                              child: SingleChildScrollView(
                                // controller: _verticalScroll,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: kWidth
                                  ),
                                  child: DataTable(
                                    border: TableBorder.all(
                                      color: kBorderColorTextField,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    dividerThickness: 1.0,
                                    headingRowColor: WidgetStateProperty.all(kMainColor50),
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
                                        label: Text('Category Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Description'),
                                      ),
                                      DataColumn(
                                        label: Text('Created By'),
                                      ),
                                      DataColumn(
                                        label: Text('Action'),
                                      ),
                                    ],
                                    rows: List.generate(
                                      categoryList.length,
                                          (index) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text((index + 1).toString()),
                                          ),
                                          DataCell(
                                            Text(categoryList[index].categoryName ?? ''),
                                          ),
                                          DataCell(
                                            Text(categoryList[index].description ?? ''),
                                          ),
                                          const DataCell(
                                            Text('Admin'),
                                          ),
                                          DataCell(
                                            PopupMenuButton(
                                              color: Colors.white,
                                              icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (BuildContext bc) => [
                                                PopupMenuItem(
                                                  child: GestureDetector(
                                                    onTap: (() => showViewCategoryPopUP(
                                                      categoryList[index],
                                                    )),
                                                    child: Row(
                                                      children: [
                                                        const Icon(FeatherIcons.eye, size: 18.0, color: kTitleColor),
                                                        const SizedBox(width: 4.0),
                                                        Text(
                                                          'View',
                                                          style: kTextStyle.copyWith(color: kTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  child: GestureDetector(
                                                    onTap: (() =>  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          backgroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                          // child: EditCategory(editCategory: categoryList[index], listOfIncomeCategory: categoryList ?? [],),
                                                          child: EditCategory(editCategory: categoryList[index], listOfIncomeCategory: categoryList,),
                                                        );
                                                      },
                                                    )),
                                                    child: Row(
                                                      children: [
                                                        const Icon(FeatherIcons.edit3, size: 18.0, color: kTitleColor),
                                                        const SizedBox(width: 4.0),
                                                        Text(
                                                          'Edit',
                                                          style: kTextStyle.copyWith(color: kTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible: false,
                                                          context: context,
                                                          builder: (BuildContext dialogContext) {
                                                            final kMoiblePopUp=MediaQuery.of(context).size.width<365;
                                                            return Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(20.0),
                                                                child: Container(
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(15),
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20.0),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        const Text(
                                                                          'Are you want to delete this Shop Category',
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
                                                                                width: kMoiblePopUp?100:130,
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
                                                                                height: 50,
                                                                                width: kMoiblePopUp?100:130,
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
                                                                                deleteShopCategory(
                                                                                    categoryName: categoryList[index].categoryName.toString(),
                                                                                    updateProduct: ref,
                                                                                    context: bc);
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
                                                        const Icon(Icons.delete, size: 18.0, color: kTitleColor),
                                                        const SizedBox(width: 4.0),
                                                        Text(
                                                          'Delete',
                                                          style: kTextStyle.copyWith(color: kTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) {
                                                Navigator.pushNamed(context, '$value');
                                              },
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
                    ),
                  ],
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
