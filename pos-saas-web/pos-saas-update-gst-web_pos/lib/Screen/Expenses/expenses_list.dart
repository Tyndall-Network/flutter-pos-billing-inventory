import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/Provider/all_expanse_provider.dart';
import 'package:salespro_admin/Screen/Expenses/expense_category.dart';
import 'package:salespro_admin/Screen/Expenses/expense_edit.dart';
import 'package:salespro_admin/Screen/Expenses/new_expense.dart';
import 'package:salespro_admin/commas.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../const.dart';
import '../../currency.dart';
import '../../model/expense_model.dart';
import '../Widgets/Constant Data/constant.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../Widgets/Constant Data/export_button.dart';
import '../Widgets/Footer/footer.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/TopBar/top_bar_widget.dart';
import 'expense_details.dart';

class ExpensesList extends StatefulWidget {
  const ExpensesList({Key? key}) : super(key: key);

  static const String route = '/expenses';

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  String searchItem = '';
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, 1);

  List<String> month = ['This Month', 'Last Month', 'Last 6 Month', 'This Year'];

  String selectedMonth = 'This Month';

  DropdownButton<String> getMonth() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in month) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: selectedMonth,
      onChanged: (value) {
        setState(() {
          selectedMonth = value!;
          switch (selectedMonth) {
            case 'This Month':
              {
                var date = DateTime(DateTime.now().year, DateTime.now().month, 1).toString();

                selectedDate = DateTime.parse(date);
                selected2ndDate = DateTime.now();
              }
              break;
            case 'Last Month':
              {
                selectedDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
                selected2ndDate = DateTime(DateTime.now().year, DateTime.now().month, 0);
              }
              break;
            case 'Last 6 Month':
              {
                selectedDate = DateTime(DateTime.now().year, DateTime.now().month - 6, 1);
                selected2ndDate = DateTime.now();
              }
              break;
            case 'This Year':
              {
                selectedDate = DateTime(DateTime.now().year, 1, 1);
                selected2ndDate = DateTime.now();
              }
              break;
          }
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  DateTime selected2ndDate = DateTime.now();

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selected2ndDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selected2ndDate) {
      setState(() {
        selected2ndDate = picked;
      });
    }
  }

  double calculateAllExpense({required List<ExpenseModel> allExpense}) {
    double totalExpense = 0;
    for (var element in allExpense) {
      totalExpense += element.amount.toDouble();
    }

    return totalExpense;
  }

  ScrollController mainScroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCurrentUserAndRestartApp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) {
          final expenses = ref.watch(expenseProvider);
          return expenses.when(data: (allExpenses) {
            List<ExpenseModel> reverseAllExpense = allExpenses.reversed.toList();
            List<ExpenseModel> showExpense = [];
            for (var element in reverseAllExpense) {
              if (element.expanseFor.toLowerCase().contains(searchItem.toLowerCase()) &&
                  (selectedDate.isBefore(DateTime.parse(element.expenseDate)) || DateTime.parse(element.expenseDate).isAtSameMomentAs(selectedDate)) &&
                  (selected2ndDate.isAfter(DateTime.parse(element.expenseDate)) || DateTime.parse(element.expenseDate).isAtSameMomentAs(selected2ndDate))) {
                showExpense.add(element);
              }
            }
            return Scaffold(
                backgroundColor: kDarkWhite,
                body: Scrollbar(
                  controller: mainScroll,
                  child: SingleChildScrollView(
                    controller: mainScroll,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 240,
                          child: SideBarWidget(
                            index: 10,
                            isTab: false,
                          ),
                        ),
                        Container(
                          // width: context.width() < 1080 ? 1080 - 240 : MediaQuery.of(context).size.width - 240,
                          width: MediaQuery.of(context).size.width < 1275 ? 1275 - 240 : MediaQuery.of(context).size.width - 240,
                          decoration: const BoxDecoration(color: kDarkWhite),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //_______________________________top_bar____________________________
                                const TopBar(),

                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: kWhite,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 125,
                                              child: FormField(
                                                builder: (FormFieldState<dynamic> field) {
                                                  return InputDecorator(
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    child: Theme(
                                                        data: ThemeData(highlightColor: dropdownItemColor, focusColor: dropdownItemColor, hoverColor: dropdownItemColor),
                                                        child: DropdownButtonHideUnderline(child: getMonth())),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 20.0),
                                            Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), border: Border.all(color: kGreyTextColor)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(shape: BoxShape.rectangle, color: kGreyTextColor),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          lang.S.of(context).between,
                                                          style: kTextStyle.copyWith(color: kWhite),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ).onTap(() => _selectDate(context)),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      lang.S.of(context).to,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      '${selected2ndDate.day}/${selected2ndDate.month}/${selected2ndDate.year}',
                                                      style: kTextStyle.copyWith(color: kTitleColor),
                                                    ).onTap(() => _selectedDate(context)),
                                                    const SizedBox(width: 10.0),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0, bottom: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: const Color(0xFFCFF4E3),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$currency ${myFormat.format(double.tryParse(calculateAllExpense(allExpense: expenses.value ?? []).toString()) ?? 0)}',
                                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(
                                                lang.S.of(context).totalExpense,
                                                style: kTextStyle.copyWith(color: kTitleColor),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: kWhite),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Expenses List',
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                            ),
                                            const Spacer(),

                                            ///___________search________________________________________________-
                                            Container(
                                              height: 40.0,
                                              width: 300,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), border: Border.all(color: kGreyTextColor.withOpacity(0.1))),
                                              child: AppTextField(
                                                showCursor: true,
                                                cursorColor: kTitleColor,
                                                onChanged: (value) {
                                                  setState(() {
                                                    searchItem = value;
                                                  });
                                                },
                                                textFieldType: TextFieldType.NAME,
                                                decoration: kInputDecoration.copyWith(
                                                  contentPadding: const EdgeInsets.all(10.0),
                                                  hintText: ('Search by Invoice...'),
                                                  hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                                                  border: InputBorder.none,
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                    borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                                                  ),
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                    borderSide: BorderSide(color: kBorderColorTextField, width: 1),
                                                  ),
                                                  suffixIcon: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30.0),
                                                        color: kGreyTextColor.withOpacity(0.1),
                                                      ),
                                                      child: const Icon(
                                                        FeatherIcons.search,
                                                        color: kTitleColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20.0),
                                            Container(
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                              child: Text(
                                                'Expense Category',
                                                style: kTextStyle.copyWith(color: kWhite),
                                              ),
                                            ).onTap(
                                              () => const ExpenseCategory().launch(context),
                                            ),
                                            const SizedBox(width: 20.0),
                                            Container(
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                              child: Row(
                                                children: [
                                                  const Icon(FeatherIcons.plus, color: kWhite, size: 18.0),
                                                  const SizedBox(width: 5.0),
                                                  Text(
                                                    'New Expenses',
                                                    style: kTextStyle.copyWith(color: kWhite),
                                                  ),
                                                ],
                                              ),
                                            ).onTap(
                                              () async {
                                                Navigator.of(context).pushNamed(NewExpense.route);
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),
                                        Divider(
                                          thickness: 1.0,
                                          color: kGreyTextColor.withOpacity(0.2),
                                        ),

                                        ///__________expense_LIst____________________________________________________________________

                                        const SizedBox(height: 10.0),
                                        showExpense.isNotEmpty
                                            ? Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(15),
                                                    decoration: const BoxDecoration(color: kbgColor),
                                                    child: const Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SizedBox(width: 50, child: Text('S.L')),
                                                        SizedBox(width: 78, child: Text('Date')),
                                                        SizedBox(width: 150, child: Text('Created By')),
                                                        SizedBox(width: 100, child: Text('Category')),
                                                        SizedBox(width: 150, child: Text('Note')),
                                                        SizedBox(width: 100, child: Text('Payment Type')),
                                                        SizedBox(width: 70, child: Text('Amount')),
                                                        SizedBox(width: 30, child: Icon(FeatherIcons.settings)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: (MediaQuery.of(context).size.height - 315).isNegative ? 0 : MediaQuery.of(context).size.height - 315,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: const AlwaysScrollableScrollPhysics(),
                                                      itemCount: showExpense.length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(15),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  ///______________S.L__________________________________________________
                                                                  SizedBox(
                                                                    width: 50,
                                                                    child: Text((index + 1).toString(), style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                  ),

                                                                  ///______________Date__________________________________________________
                                                                  SizedBox(
                                                                    width: 78,
                                                                    child: Text(
                                                                      showExpense[index].expenseDate.substring(0, 10),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 2,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor, overflow: TextOverflow.ellipsis),
                                                                    ),
                                                                  ),

                                                                  ///____________Created By_________________________________________________
                                                                  SizedBox(
                                                                    width: 150,
                                                                    child: Text(showExpense[index].expanseFor,
                                                                        maxLines: 2, overflow: TextOverflow.ellipsis, style: kTextStyle.copyWith(color: kGreyTextColor)),
                                                                  ),

                                                                  ///______Category___________________________________________________________
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Text(
                                                                      showExpense[index].category,
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///___________note______________________________________________

                                                                  SizedBox(
                                                                    width: 150,
                                                                    child: Text(
                                                                      showExpense[index].note.toString(),
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///___________Payment tYpe____________________________________________________
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Text(
                                                                      showExpense[index].paymentType.toString(),
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///___________Amount____________________________________________________

                                                                  SizedBox(
                                                                    width: 70,
                                                                    child: Text(
                                                                      myFormat.format(int.tryParse(showExpense[index].amount.toString()) ?? 0),
                                                                      style: kTextStyle.copyWith(color: kGreyTextColor),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),

                                                                  ///_______________actions_________________________________________________
                                                                  SizedBox(
                                                                    width: 30,
                                                                    child: Theme(
                                                                      data: ThemeData(
                                                                          highlightColor: dropdownItemColor, focusColor: dropdownItemColor, hoverColor: dropdownItemColor),
                                                                      child: PopupMenuButton(
                                                                        surfaceTintColor: Colors.white,
                                                                        padding: EdgeInsets.zero,
                                                                        itemBuilder: (BuildContext bc) => [
                                                                          PopupMenuItem(
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                showDialog(
                                                                                  barrierDismissible: false,
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return StatefulBuilder(
                                                                                      builder: (context, setStates) {
                                                                                        return Dialog(
                                                                                          surfaceTintColor: Colors.white,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(20.0),
                                                                                          ),
                                                                                          child: ExpenseDetails(expense: showExpense[index], manuContext: bc),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  const Icon(Icons.remove_red_eye_outlined, size: 18.0, color: kTitleColor),
                                                                                  const SizedBox(width: 4.0),
                                                                                  Text(
                                                                                    'View',
                                                                                    style: kTextStyle.copyWith(color: kTitleColor),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          ///____________edit___________________________________________
                                                                          PopupMenuItem(
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                ExpenseEdit(
                                                                                  expenseModel: showExpense[index],
                                                                                  menuContext: bc,
                                                                                ).launch(context);
                                                                              },
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
                                                                        ],
                                                                        child: Center(
                                                                          child: Container(
                                                                              height: 18,
                                                                              width: 18,
                                                                              alignment: Alignment.centerRight,
                                                                              child: const Icon(
                                                                                Icons.more_vert_sharp,
                                                                                size: 18,
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double.infinity,
                                                              height: 1,
                                                              color: kGreyTextColor.withOpacity(0.2),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const EmptyWidget(title: 'No Expense Found'),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(visible: MediaQuery.of(context).size.height != 0, child: const Footer()),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
            // return ExpensesTableWidget(expenses: allExpenses);
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
