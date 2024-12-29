import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/seller_info_provider.dart';
import '../../Provider/subacription_plan_provider.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/Pop Up/Reports/view_reports.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/Topbar/topbar.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  static const String route = '/reports';

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  String? _calculateEndDate(String? startDateString, int durationDays) {
    if (startDateString != null) {
      DateTime startDate = DateTime.parse(startDateString);
      DateTime endDate = startDate.add(Duration(days: durationDays));
      return endDate.toString().substring(0, 10); // Assuming you want only date part
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUserAndRestartApp();
  }
  final _horizontalScroll = ScrollController();
  final _verticalScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const GlobalAppbar(),
      // drawer:  Drawer(
      //   // backgroundColor: kNutral900,
      //   // shape: RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.circular(0)
      //   // ),
      //   child: SideBarWidget(
      //     index: 3,
      //     isTab: false,
      //   ),
      // ),
      backgroundColor: kDarkWhite,

      body: Consumer(
        builder: (_, ref, watch) {
          final reports = ref.watch(sellerInfoProvider);
          final subs = ref.watch(subscriptionPlanProvider);
          return reports.when(data: (reports) {
            return subs.when(data: (snapShot) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reports',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10.0),
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
                          controller: _horizontalScroll,
                          thickness: 8.0,
                          thumbVisibility: true,
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              final kWidth=constraints.maxWidth;
                              return SingleChildScrollView(
                                controller: _horizontalScroll,
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
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
                                      horizontalMargin: 20.0,
                                      columnSpacing: 20.0,
                                      columns: const [
                                        DataColumn(
                                          label: Text('Date'),
                                        ),
                                        DataColumn(
                                          label: Text('Shop Name'),
                                        ),
                                        DataColumn(
                                          label: Text('Category'),
                                        ),
                                        DataColumn(
                                          label: Text('Package'),
                                        ),
                                        DataColumn(
                                          label: Text('Start'),
                                        ),
                                        DataColumn(
                                          label: Text('End'),
                                        ),
                                        DataColumn(
                                          label: Text('Method'),
                                        ),
                                        DataColumn(
                                          label: Text('Action'),
                                        ),
                                      ],
                                      rows: List.generate(reports.length, (index) {
                          
                                        int? currentDuration;
                                        for (var element in snapShot) {
                                          if (element.subscriptionName == reports[index].subscriptionName) {
                                            currentDuration = element.duration;
                                            break; // Stop loop once duration is found
                                          }
                                        }
                                        // Calculate end date
                                        final endDate = _calculateEndDate(reports[index].subscriptionDate, currentDuration ?? 0);
                          
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(reports[index].subscriptionDate?.substring(0, 10) ?? ''),
                                            ),
                                            DataCell(
                                              Text(reports[index].companyName ?? ''),
                                            ),
                                            DataCell(
                                              Text(reports[index].businessCategory ?? ''),
                                            ),
                                            DataCell(
                                              Text(reports[index].subscriptionName ?? ''),
                                            ),
                                            DataCell(
                                              Text(reports[index].subscriptionDate?.substring(0, 10) ?? ''),
                                            ),
                                            DataCell(
                                              Text(endDate ?? ''),
                                            ),
                                            DataCell(
                                              Text(reports[index].subscriptionMethod ?? ''),
                                            ),
                                            DataCell(
                                              PopupMenuButton(
                                                color: Colors.white,
                                                icon: const Icon(FeatherIcons.moreVertical, size: 18.0),
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (BuildContext bc) => [
                                                  PopupMenuItem(
                                                    child: GestureDetector(
                                                      onTap: (() => showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return Dialog(
                                                            backgroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            child: ViewReport(sellerInfoModel: reports[index], endDate: endDate,),
                                                          );
                                                        },
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
                                                ],
                                                onSelected: (value) {
                                                  Navigator.pushNamed(context, '$value');
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
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