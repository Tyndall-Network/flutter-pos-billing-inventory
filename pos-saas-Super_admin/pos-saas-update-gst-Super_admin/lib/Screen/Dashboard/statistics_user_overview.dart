import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_framework/responsive_framework.dart';
import '../../currency.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/static_string/static_string.dart';
import 'custome_pie.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsData extends StatefulWidget {
  const StatisticsData({
    Key? key,
    required this.totalIncomeCurrentYear,
    required this.totalIncomeCurrentMonths,
    required this.totalIncomeLastMonth,
    required this.allMonthData,
    required this.allDay,
    required this.totalUser,
    required this.freeUser,
  }) : super(key: key);

  final double totalIncomeCurrentYear;
  final double totalIncomeCurrentMonths;
  final double totalIncomeLastMonth;
  final List<double> allMonthData;
  final List<int> allDay;
  final double totalUser;
  final double freeUser;

  @override
  _StatisticsDataState createState() => _StatisticsDataState();
}

class _StatisticsDataState extends State<StatisticsData> {
  late List<MonthlyIncomeData> data;
  late List<DailyIncomeData> dailyData;
  List<String> monthList = ['This Month', 'Yearly'];
  String selectedMonth = 'Yearly';

  @override
  void initState() {
    super.initState();
    data = List.generate(
      12,
          (index) => MonthlyIncomeData(
        ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][index],
        widget.allMonthData[index],
      ),
    );
    dailyData = List.generate(
      widget.allDay.length,
          (index) => DailyIncomeData(
        (index + 1).toString(),
        widget.allDay[index].toDouble(),
      ),
    );
  }

  DropdownButton<String> getCategories() {
    return DropdownButton<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      items: monthList.map((String des) {
        return DropdownMenuItem<String>(
          value: des,
          child: Text(
            des,
            style: const TextStyle(
              color: kNutral600,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
      value: selectedMonth,
      onChanged: (value) {
        setState(() {
          selectedMonth = value!;
        });
      },
    );
  }

  final _horizontalScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max, // Ensure Row takes up the full width
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  blurStyle: BlurStyle.inner,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Text(
                        'Earning Overview',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(color: kNutral300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: getCategories(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: kNutral300, thickness: 1.0,height: 1,),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle,color: kMainColor600,size: 8,),
                    // Text('Total income:$currency${widget.totalIncomeCurrentYear}',)
                    RichText(text:
                    TextSpan(text: 'Total Income: ',style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kNutral600,fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: '$currency${widget.totalIncomeCurrentYear}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kTitleColor,fontWeight: FontWeight.w500)
                      )
                    ]))
                  ],
                ),
                Visibility(
                  visible: selectedMonth == 'Yearly',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 300, // Fixed height for the chart
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 10000,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: kNutral300,
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${(value / 1000).round()}k',
                                    style: const TextStyle(color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][value.toInt()],
                                    style: const TextStyle(color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          minX: 0,
                          maxX: 11,
                          minY: 0,
                          maxY: widget.totalIncomeCurrentYear,
                          lineBarsData: [
                            LineChartBarData(
                              spots: data.asMap().entries.map((e) {
                                return FlSpot(e.key.toDouble(), e.value.sales);
                              }).toList(),
                              isCurved: true,
                              color: kMainColor600,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xff8424FF).withOpacity(0.2),
                                    const Color(0xff8424FF).withOpacity(0.1),
                                    const Color(0xff8424FF).withOpacity(0.05),
                                  ],
                                ),
                              ),
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedMonth == 'This Month',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double chartWidth = widget.allDay.length * 40; // Dynamic width based on number of days
                        chartWidth = chartWidth > constraints.maxWidth ? chartWidth : constraints.maxWidth; // Ensure chart width is at least the screen width

                        return RawScrollbar(
                          thumbVisibility: true,
                          thickness: 8.0,
                          controller: _horizontalScroll,
                          child: SizedBox(
                            height: 300, // Fixed height for the chart
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _horizontalScroll,
                              child: SizedBox(
                                width: chartWidth,
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      horizontalInterval: 10000,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey,
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        );
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      rightTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              '${(value / 1000).round()}k',
                                              style: const TextStyle(color: Colors.grey),
                                            );
                                          },
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              (value.toInt() + 1).toString(),
                                              style: const TextStyle(color: Colors.grey),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                      border: Border.all(color: Colors.black, width: 1),
                                    ),
                                    minX: 0,
                                    maxX: widget.allDay.length.toDouble() - 1,
                                    minY: 0,
                                    maxY: widget.totalIncomeCurrentYear,
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: dailyData.asMap().entries.map((e) {
                                          return FlSpot(e.key.toDouble(), e.value.sales);
                                        }).toList(),
                                        isCurved: true,
                                        color: kMainColor600,
                                        barWidth: 2,
                                        isStrokeCapRound: true,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0xff8424FF).withOpacity(0.2),
                                              const Color(0xff8424FF).withOpacity(0.1),
                                              const Color(0xff8424FF).withOpacity(0.05),
                                            ],
                                          ),
                                        ),
                                        dotData: FlDotData(show: false),
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
      ],
    );
  }
}




class UserOverView extends StatefulWidget {
  const UserOverView({
    super.key,
    required this.totalUser,
    required this.freeUser,
  });

  final double totalUser;
  final double freeUser;

  @override
  State<UserOverView> createState() => _UserOverViewState();
}

class _UserOverViewState extends State<UserOverView> {
  @override
  Widget build(BuildContext context) {

    final double responsiveWidth = ResponsiveValue<double>(
      context,
      defaultValue: double.infinity,
      conditionalValues:  [
        const Condition.between(start: 320,end: 490, value: 20.0),
        const Condition.between(start: 1240,end: 1350, value: 30.0),
        const Condition.between(start: 1351,end: 1500, value: 45.0),
      ],
    ).value;

    // Determine which widget to display based on the screen size
    Widget widgetToDisplay;

    if (responsiveWidth == 20.0) {
      widgetToDisplay = SizedBox(width: responsiveWidth);
    } else if (responsiveWidth == 30.0) {
      widgetToDisplay = SizedBox(width: responsiveWidth);
    } else if (responsiveWidth == 45.0) {
      widgetToDisplay = SizedBox(width: responsiveWidth);
    } else {
      widgetToDisplay = const Expanded(child: SizedBox()); // Keep Expanded here
    }

    double freePercentage = (widget.freeUser * 100) / widget.totalUser;
    double paidPercentage = 100 - freePercentage;

    final double kTitleFontSize = rf.ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: [
        rf.Condition.largerThan(name: BreakpointName.MD.name, value: 18),
      ],
    ).value;

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        final bool tabAndPhoneSize = MediaQuery.of(context).size.width < 1200;

        // Calculate the size of the pie chart dynamically
        double pieChartSize = width * 0.5;
        if (pieChartSize > 200) pieChartSize = 200; // Max size
        if (pieChartSize < 120) pieChartSize = 120; // Min size to avoid overflow

        return Container(
          alignment: Alignment.center,
          height: tabAndPhoneSize ? null : 355,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                blurStyle: BlurStyle.inner,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 10,
                ),
                child: Text(
                  'User Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: kTitleFontSize,
                  ),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1.0,
                color: Color(0xffE5E5E5),
              ),
              SizedBox(height: width * 0.015), // Responsive spacing
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widgetToDisplay,
                    // Pie chart in the center
                    Center(
                      child: SizedBox(
                        height: pieChartSize,
                        width: pieChartSize,
                        child: CustomPaint(
                          size: Size(pieChartSize, pieChartSize),
                          painter: PieChartPainter(
                            data: [freePercentage, paidPercentage],
                            colors: [const Color(0xff00BF71), kMainColor],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16.0), // Spacing between the chart and the indicators

                    // Indicators
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Indicator(
                            size: 12, // Adjusted size
                            color: Colors.green,
                            text: 'Free: ',
                            isSquare: false,
                            percent: '${freePercentage.toStringAsFixed(2)}%',
                          ),
                          const SizedBox(height: 16),
                          Indicator(
                            size: 12, // Adjusted size
                            color: kMainColor,
                            text: 'Premium: ',
                            isSquare: false,
                            percent: '${paidPercentage.toStringAsFixed(2)}%',
                          ),
                        ],
                      ),
                    ),

                    // Right side spacing or expansion
                    widgetToDisplay
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MonthlyIncomeData {
  MonthlyIncomeData(this.month, this.sales);

  final String month;
  final double sales;
}

class DailyIncomeData {
  DailyIncomeData(this.day, this.sales);

  final String day;
  final double sales;
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.percent,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final String percent;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            text: TextSpan(
                text: text,
                style: const TextStyle(
                  color: kGreyTextColor,
                ),
                children: [
                  TextSpan(
                    text: percent,
                    style: const TextStyle(
                      color: kTitleColor,
                    ),
                  )
                ]),
          ),
        ),
      ],
    );
  }
}