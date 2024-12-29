import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:salespro_saas_admin/Provider/seller_info_provider.dart';
import 'package:salespro_saas_admin/Screen/Dashboard/statistics_user_overview.dart';
import 'package:salespro_saas_admin/Screen/Widgets/static_string/static_string.dart';
import 'package:salespro_saas_admin/model/seller_info_model.dart';
import '../../Provider/get_subscription_request_privider.dart';
import '../../model/subscription_request_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Table Widgets/Dashboard/dashboard_table.dart';
import '../Widgets/Table Widgets/Total Count/total_count_widget.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'dart:html' as html;

class MtDashboard extends StatefulWidget {
  const MtDashboard({super.key});

  static const String route = '/dashboard';

  @override
  State<MtDashboard> createState() => _MtDashboardState();
}

class _MtDashboardState extends State<MtDashboard> {
  int numberOfFree = 0;
  int numberOfMonthly = 0;
  int numberOfHalfYearly = 0;
  int numberOfYear = 0;
  int numberOfLifetime = 0;
  int newReg = 0;

  void getData() async {
    //var data = await FirebaseDatabase.instance.ref('Admin panel');
  }

  @override
  void initState() {
    _setupHistory();
    getData();
    super.initState();
    checkCurrentUserAndRestartApp();
    for (int i = 0;
        i < DateTime(currentDate.year, currentDate.month + 1, 0).day;
        i++) {
      everyDayOfCurrentMonth.add(0);
    }
    ///----------------------------------code--------------------------------
    // for (int i = 0;
    //     i < DateTime(currentDate.year, currentDate.month + 1, 0).day;
    //     i++) {
    //   everyDay.add(0);
    // }

    ///---------------others code---------------------------------
    for (int i = 0;
        i < DateTime(currentDate.year, currentDate.month + 1, 0).day;
        i++) {
      everyDay.add(0);
    }
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
      GoRouter.of(context).go('/dashboard');
    });
  }


  int i = 0;
  int newUserOfCurrentYear = 0;
  List<double> newUserMonthlyOfCurrentYear = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  List<SellerInfoModel> free = [];
  List<SellerInfoModel> monthly = [];
  List<SellerInfoModel> halfYearly = [];
  List<SellerInfoModel> yearly = [];
  List<SellerInfoModel> freeMonth = [];
  List<SellerInfoModel> newUser = [];
  List<SellerInfoModel> newUser30Days = [];
  List<SellerInfoModel> todayRegistration = [];
  List<SellerInfoModel> previousMonthRegistration = [];

  ///____________Incomes___________________________
  List<SubscriptionRequestModel> subOfCurrentYear = [];
  List<SubscriptionRequestModel> subOfCurrentMonth = [];
  List<SubscriptionRequestModel> subOfLastMonth = [];
  List<SubscriptionRequestModel> subOfLastYear = [];
  double totalIncomeOfCurrentYear = 0;
  double totalIncomeOfPreviousYear = 0;
  double totalIncomeOfCurrentMonth = 0;
  List<double> everyMonthOfYear = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> everyDayOfCurrentMonth = [];
  List<int> everyDay = [];
  double totalIncomeOfLastMonth = 0;
  List<SellerInfoModel> shopList = [];

  bool showDrawer = false;
  ScrollController scontroller = ScrollController();
  final _horizontalScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    final tabAndPhoneSize = MediaQuery.of(context).size.width < 1240;
    final knTabAndPhoneSize = MediaQuery.of(context).size.width < 1200;
    final kTitleFontSize = rf.ResponsiveValue<double>(context,
        defaultValue: 16,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.MD.name, value: 18)
        ]).value;
    final itemMobileSize = MediaQuery.of(context).size.width < 577;
    final kChildItemWidth = itemMobileSize
        ? MediaQuery.of(context).size.width - 10
        : knTabAndPhoneSize
            ? MediaQuery.of(context).size.width / 2 - 10
            : MediaQuery.of(context).size.width / 5 - 10;
    final kNItemHeight = tabAndPhoneSize ? 145 : 160;
    final kNItemWidth = itemMobileSize
        ? MediaQuery.of(context).size.width - 39
        : MediaQuery.of(context).size.width / 2 - 45;
    final itemCrossCount = rf.ResponsiveValue<int>(
      context,
      defaultValue: 1,
      conditionalValues: [
        rf.Condition.smallerThan(name: BreakpointName.SM.name, value: 1),
        rf.Condition.largerThan(name: BreakpointName.XS.name, value: 2),
      ],
    ).value;

    final isItem = rf.ResponsiveValue<bool>(
      context,
      defaultValue: false,
      conditionalValues: [
        rf.Condition.smallerThan(name: BreakpointName.SM.name, value: true),
      ],
    ).value;

    i++;
    return Scaffold(
      backgroundColor: kDarkWhite,
      // drawer:  const Drawer(
      //   child: SideBarWidget(
      //     index: 0,
      //     isTab: false,
      //   ),
      // ),
      // appBar: const GlobalAppbar(),
      body: Consumer(
        builder: (_, ref, watch) {
          final sellerInfoData = ref.watch(sellerInfoProvider);
          AsyncValue<List<SellerInfoModel>> infoList =
              ref.watch(sellerInfoProvider);
          AsyncValue<List<SubscriptionRequestModel>> subscriptionData =
              ref.watch(subscriptionRequestProvider);
          return infoList.when(data: (infoList) {
            DateTime t = DateTime.now();
            newUser = [];
            free = [];
            monthly = [];
            halfYearly = [];
            yearly = [];
            freeMonth = [];
            newUser = [];
            newUser30Days = [];
            todayRegistration = [];
            previousMonthRegistration = [];

            for (var element in infoList) {
              if (element.subscriptionName == 'Free') {
                free.add(element);
              } else if (element.subscriptionName == 'Monthly') {
                monthly.add(element);
              } else if (element.subscriptionName == 'Kwa Miezi 6') {
                halfYearly.add(element);
              } else if (element.subscriptionName == 'Yearly') {
                yearly.add(element);
              }
              final subscriptionDate = DateTime.parse(
                  element.userRegistrationDate ??
                      (element.subscriptionDate.toString()));
              if (subscriptionDate.isAfter(sevenDays)) {
                newUser.add(element);
              }
              if (subscriptionDate.isAfter(firstDayOfCurrentYear)) {
                newUserOfCurrentYear++;
                newUserMonthlyOfCurrentYear[subscriptionDate.month - 1]++;
                if (subscriptionDate.isAfter(firstDayOfCurrentMonth)) {
                  newUser30Days.add(element);
                  if (subscriptionDate.difference(t).inHours.abs() <= 24) {
                    newReg++;
                    todayRegistration.add(element);
                  }
                }
                if (subscriptionDate.isAfter(firstDayOfPreviousMonth) &&
                    subscriptionDate.isBefore(firstDayOfCurrentMonth)) {
                  previousMonthRegistration.add(element);
                }
              }
            }

            return subscriptionData.when(data: (paymentData) {
              subOfCurrentYear = [];
              subOfCurrentMonth = [];
              subOfLastMonth = [];
              subOfLastYear = [];
              totalIncomeOfCurrentYear = 0;
              totalIncomeOfPreviousYear = 0;
              totalIncomeOfCurrentMonth = 0;
              everyMonthOfYear = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
              totalIncomeOfLastMonth = 0;
              shopList = [];
              for (var element in paymentData) {
                if (element.status == 'approved') {
                  final subscriptionDate =
                      DateTime.tryParse(element.approvedDate.toString()) ??
                          DateTime.now();

                  if (subscriptionDate.isAfter(firstDayOfCurrentYear)) {
                    totalIncomeOfCurrentYear += element.amount;

                    if (subscriptionDate.month <= everyMonthOfYear.length) {
                      everyMonthOfYear[subscriptionDate.month - 1] +=
                          element.amount;
                    }

                    if (subscriptionDate.day <= everyDay.length) {
                      everyDay[subscriptionDate.day - 1] += element.amount;
                    }

                    subOfCurrentYear.add(element);

                    if (subscriptionDate.isAfter(firstDayOfCurrentMonth)) {
                      totalIncomeOfCurrentMonth += element.amount;
                      subOfCurrentMonth.add(element);
                      if (subscriptionDate.day <=
                          everyDayOfCurrentMonth.length) {
                        everyDayOfCurrentMonth[subscriptionDate.day - 1]++;
                      }
                    }

                    if (subscriptionDate.isAfter(firstDayOfPreviousMonth) &&
                        subscriptionDate.isBefore(firstDayOfCurrentMonth)) {
                      totalIncomeOfLastMonth += element.amount;
                      subOfLastMonth.add(element);
                    }
                    if (subscriptionDate.isAfter(firstDayOfPreviousYear) &&
                        subscriptionDate.isBefore(firstDayOfCurrentYear)) {
                      totalIncomeOfPreviousYear += element.amount;
                      subOfLastYear.add(element);
                    }
                  }
                }
              }

              ///----------------------------------payment data-------------------------

              // for (var element in paymentData) {
              //   if (element.status == 'approved') {
              //     final subscriptionDate =
              //         DateTime.tryParse(element.approvedDate.toString()) ??
              //             DateTime.now();
              //
              //     if (subscriptionDate.isAfter(firstDayOfCurrentYear)) {
              //       totalIncomeOfCurrentYear += element.amount;
              //
              //       everyMonthOfYear[subscriptionDate.month - 1] +=
              //           element.amount;
              //       everyDay[subscriptionDate.day - 1] += element.amount;
              //
              //       subOfCurrentYear.add(element);
              //
              //       if (subscriptionDate.isAfter(firstDayOfCurrentMonth)) {
              //         totalIncomeOfCurrentMonth += element.amount;
              //         subOfCurrentMonth.add(element);
              //         // everyDayOfCurrentMonth[subscriptionDate.day - 1]++;
              //         everyDay[subscriptionDate.day - 1] += element.amount;
              //
              //       }
              //
              //       if (subscriptionDate.isAfter(firstDayOfPreviousMonth) &&
              //           subscriptionDate.isBefore(firstDayOfCurrentMonth)) {
              //         totalIncomeOfLastMonth += element.amount;
              //         subOfLastMonth.add(element);
              //       }
              //       if (subscriptionDate.isAfter(firstDayOfPreviousYear) &&
              //           subscriptionDate.isBefore(firstDayOfCurrentYear)) {
              //         totalIncomeOfPreviousYear += element.amount;
              //         subOfLastYear.add(element);
              //       }
              //     }
              //   }
              // }
              Widget buildRow(Widget first, Widget second) {
                return Row(
                  children: [
                    Expanded(child: first),
                    const SizedBox(width: 10),
                    Expanded(child: second),
                  ],
                );
              }

              Widget buildGridView(bool isItem, int crossAxisCount) {
                return Container(
                  padding: EdgeInsets.all(isItem ? 0 : 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: isItem ? Colors.transparent : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: kBorderColorTextField.withOpacity(0.1),
                        blurRadius: 4,
                        blurStyle: BlurStyle.inner,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: kNItemWidth / kNItemHeight,
                      // childAspectRatio: kItemAspectRation,
                      crossAxisCount: crossAxisCount,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return TopSellingStore(
                            newReg1: newUser,
                            monthlyReg: newUser30Days,
                            previousReg: previousMonthRegistration,
                            totalUSer: infoList.length.toString(),
                          );
                        case 1:
                          return Subscribed(
                            subOfCurrentMonth: subOfCurrentMonth,
                            subOfCurrentYear: subOfCurrentYear,
                            subOfLastMonth: subOfLastMonth,
                            totalNewUserCurrentYear: newUserOfCurrentYear,
                            userInMonthOfYear: newUserMonthlyOfCurrentYear,
                          );
                        case 2:
                          return IncomeSection(
                            totalIncomeCurrentMonths: totalIncomeOfCurrentMonth,
                            totalIncomeLastMonth: totalIncomeOfLastMonth,
                            totalIncomeCurrentYear: totalIncomeOfCurrentYear,
                            allMonthData: everyMonthOfYear,
                          );
                        case 3:
                          return ExpenseSection(
                            totalIncomeCurrentMonths: totalIncomeOfCurrentMonth,
                            totalIncomeLastMonth: totalIncomeOfLastMonth,
                            totalIncomeCurrentYear: totalIncomeOfCurrentYear,
                            allMonthData: everyMonthOfYear,
                            totalIncomeLastYear: totalIncomeOfPreviousYear,
                          );
                        default:
                          return Container(
                            height: 0,
                          );
                      }
                    },
                  ),
                );
              }

              Widget buildStatisticsData() {
                return StatisticsData(
                  totalIncomeCurrentMonths: totalIncomeOfCurrentMonth,
                  totalIncomeLastMonth: totalIncomeOfLastMonth,
                  totalIncomeCurrentYear: totalIncomeOfCurrentYear,
                  allMonthData: everyMonthOfYear,
                  allDay: everyDay,
                  totalUser: double.parse(infoList.length.toString()),
                  freeUser: double.parse(free.length.toString()),
                );
              }

              Widget buildDetailedView(bool isItem) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: isItem ? Colors.transparent : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: kBorderColorTextField.withOpacity(0.1),
                        blurRadius: 4,
                        blurStyle: BlurStyle.inner,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        buildRow(
                          TopSellingStore(
                            newReg1: newUser,
                            monthlyReg: newUser30Days,
                            previousReg: previousMonthRegistration,
                            totalUSer: infoList.length.toString(),
                          ),
                          Subscribed(
                            subOfCurrentMonth: subOfCurrentMonth,
                            subOfCurrentYear: subOfCurrentYear,
                            subOfLastMonth: subOfLastMonth,
                            totalNewUserCurrentYear: newUserOfCurrentYear,
                            userInMonthOfYear: newUserMonthlyOfCurrentYear,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildRow(
                          IncomeSection(
                            totalIncomeCurrentMonths: totalIncomeOfCurrentMonth,
                            totalIncomeLastMonth: totalIncomeOfLastMonth,
                            totalIncomeCurrentYear: totalIncomeOfCurrentYear,
                            allMonthData: everyMonthOfYear,
                          ),
                          ExpenseSection(
                            totalIncomeCurrentMonths: totalIncomeOfCurrentMonth,
                            totalIncomeLastMonth: totalIncomeOfLastMonth,
                            totalIncomeCurrentYear: totalIncomeOfCurrentYear,
                            allMonthData: everyMonthOfYear,
                            totalIncomeLastYear: totalIncomeOfPreviousYear,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              Widget widgetRecentRegistaredUser() {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recently Registered Users',
                        style: TextStyle(
                            color: kTitleColor,
                            fontSize: kTitleFontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      sellerInfoData.when(data: (sellerSnap) {
                        shopList = sellerSnap;
                        List<SellerInfoModel> lastShopList = shopList.length > 5
                            ? shopList.sublist(shopList.length - 5)
                            : shopList;
                        lastShopList = lastShopList.reversed.toList();
                        return RawScrollbar(
                          controller: _horizontalScroll,
                          thumbVisibility: true,
                          thickness: 8.0,
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              double tableWidth = constraints.maxWidth;
                              return SingleChildScrollView(
                                controller: _horizontalScroll,
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints:
                                      BoxConstraints(minWidth: tableWidth),
                                  child: DataTable(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    border: TableBorder.all(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        color: kBorderColorTextField),
                                    showCheckboxColumn: true,
                                    dividerThickness: 1.0,
                                    dataRowColor: const WidgetStatePropertyAll(
                                        Colors.white),
                                    headingRowColor: WidgetStateProperty.all(
                                        const Color(0xffF8F1FF)),
                                    showBottomBorder: false,
                                    headingTextStyle: const TextStyle(
                                      color: kTitleColor,
                                    ),
                                    dataTextStyle: const TextStyle(
                                        color: Color(0xff525252)),
                                    columns: const [
                                      DataColumn(label: Text('S.L')),
                                      DataColumn(label: Text('Name')),
                                      DataColumn(label: Text('Email')),
                                      DataColumn(
                                          label: Text(
                                        'Subscription Plan',
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    ],
                                    rows: List.generate(
                                      lastShopList.reversed.toList().length,
                                      (index) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              (index + 1).toString(),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          DataCell(
                                            Text(lastShopList[index]
                                                .companyName
                                                .toString()),
                                          ),
                                          DataCell(
                                            Text(lastShopList[index]
                                                .email
                                                .toString()),
                                          ),
                                          DataCell(
                                            Text(lastShopList[index]
                                                .subscriptionName
                                                .toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int getCrossAxisCount(BuildContext context) {
                          final width = MediaQuery.of(context).size.width;
                          if (width >= 1200) {
                            // Example width for large screens (Desktop)
                            return 5;
                          } else if (width >= 992) {
                            // Example width for medium screens (Tablets)
                            return 2;
                          } else if (width >= 577) {
                            // Example width for small screens (Mobile)
                            return 2;
                          } else {
                            // Default value for extra small screens
                            return 1;
                          }
                        }

                        final crossAxisCount = getCrossAxisCount(context);

                        final double kChildItemHeight = MediaQuery.of(context).size.width >= 1240 && MediaQuery.of(context).size.width < 3000
                            ? 120.0
                            : 90.0;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: kChildItemWidth / kChildItemHeight,
                          ),
                          itemCount: 5, // The number of items in your grid
                          itemBuilder: (context, index) {
                            // Return the appropriate TotalCount widget based on index
                            switch (index) {
                              case 0:
                                return TotalCount(
                                  icon: 'images/user.svg',
                                  title: 'Total User',
                                  count: infoList.length.toString(),
                                  backgroundColor: const Color(0xFFDAD4FF),
                                  iconBgColor: const Color(0xFF8424FF),
                                );
                              case 1:
                                return TotalCount(
                                  icon: 'images/new.svg',
                                  title: 'New User',
                                  count: newUser.length.toString(),
                                  backgroundColor: const Color(0xFFFFE4C1),
                                  iconBgColor: const Color(0xFFFFA609),
                                );
                              case 2:
                                return TotalCount(
                                  icon: 'images/free.svg',
                                  title: 'Free Plan User',
                                  count: free.length.toString(),
                                  backgroundColor: const Color(0xFFCFFFCA),
                                  iconBgColor: const Color(0xFF0ED128),
                                );
                              case 3:
                                return TotalCount(
                                  icon: 'images/month.svg',
                                  title: 'Monthly Plan User',
                                  count: monthly.length.toString(),
                                  backgroundColor: const Color(0xFFFFE2EB),
                                  iconBgColor: const Color(0xFFFF2267),
                                );
                              case 4:
                                return TotalCount(
                                  icon: 'images/year.svg',
                                  title: 'Yearly Plan User',
                                  count: yearly.length.toString(),
                                  backgroundColor: Colors.blue.withOpacity(0.1),
                                  iconBgColor: Colors.blue,
                                );
                              default:
                                return Container(); // Fallback in case of an unexpected index
                            }
                          },
                        );
                      },
                    ),

                    ///-------------
                    ResponsiveGridRow(children: [
                      ResponsiveGridCol(
                          xl: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: buildStatisticsData(),
                          )),
                      ResponsiveGridCol(
                          xl: 5,
                          child: knTabAndPhoneSize
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: buildGridView(isItem, itemCrossCount),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: buildDetailedView(isItem),
                                ))
                    ]),

                    ResponsiveGridRow(children: [
                      ResponsiveGridCol(
                          xl: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: widgetRecentRegistaredUser(),
                          )),
                      ResponsiveGridCol(
                          xl: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: UserOverView(
                              totalUser: double.parse(
                                infoList.length.toString(),
                              ),
                              freeUser: double.parse(
                                free.length.toString(),
                              ),
                            ),
                          ))
                    ]),
                  ],
                ),
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
