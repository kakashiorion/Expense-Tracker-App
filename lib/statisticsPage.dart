import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'constants.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final _auth = FirebaseAuth.instance;
  dynamic loggedInUser;
  late DocumentReference docRef;
  bool monthlyStatsSelected = false;

  late int monthSelected;
  late int yearSelected;
  int touchIndex = -1;

  final Color foodColor = Color(0xff70c1b3);
  final Color travelColor = Color(0xff247ba0);
  final Color shoppingColor = Color(0xfff25f5c);
  final Color utilityColor = Color(0xffffe066);

  double? food0, food1, food2, food3, food4, food5, food6;
  double? travel0, travel1, travel2, travel3, travel4, travel5, travel6;
  double? utility0, utility1, utility2, utility3, utility4, utility5, utility6;
  double? shopping0,
      shopping1,
      shopping2,
      shopping3,
      shopping4,
      shopping5,
      shopping6;
  double foodThisWeekTotal = 0,
      travelThisWeekTotal = 0,
      utilityThisWeekTotal = 0,
      shoppingThisWeekTotal = 0,
      thisWeekTotal = 0;

  double foodMonthTotal = 0,
      travelMonthTotal = 0,
      utilityMonthTotal = 0,
      shoppingMonthTotal = 0,
      monthTotal = 0;
  double foodBudget = 0,
      travelBudget = 0,
      utilityBudget = 0,
      shoppingBudget = 0;

  final borderRadius = const BorderRadius.all(Radius.circular(2));

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        docRef = FirebaseFirestore.instance.collection('users').doc(user.email);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
    monthSelected = DateTime.now().month;
    yearSelected = DateTime.now().year;
    setThisWeekExpenseValues();
    setMonthExpenseValues();
  }

  final date0 = DateTime.now().subtract(Duration(days: 6));
  final date1 = DateTime.now().subtract(Duration(days: 5));
  final date2 = DateTime.now().subtract(Duration(days: 4));
  final date3 = DateTime.now().subtract(Duration(days: 3));
  final date4 = DateTime.now().subtract(Duration(days: 2));
  final date5 = DateTime.now().subtract(Duration(days: 1));
  final date6 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.lightBlue,
          indicator: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 1,
                    spreadRadius: 1,
                    color: Colors.black12)
              ],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  style: BorderStyle.solid, width: 2, color: Colors.lightBlue)),
          indicatorWeight: 0,
          indicatorPadding: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          tabs: [
            /**First tab - THIS WEEK**/
            Tab(
              //
              child: Text(
                'This week',
                style: appBarTitleText.copyWith(color: Colors.lightBlue),
              ),
            ),
            /**Second tab - MONTHLY**/
            Tab(
              child: Text(
                'Monthly',
                style: appBarTitleText.copyWith(color: Colors.lightBlue),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            /** First tab shows weekly stats*/
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          color: Colors.grey)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 60,
                  width: size.width - 30,
                  child: Center(
                      child: Text(
                    'Total expenses (this week): $thisWeekTotal',
                    style: appBarTitleText,
                  )),
                ),
                Container(
                  height: size.height - 200,
                  child: SingleChildScrollView(
                    child: thisWeekTotal > 0
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? size.height / 3.5
                                      : size.height / 2,
                                  child: Card(
                                    shadowColor: Colors.grey,
                                    elevation: 5,
                                    color: Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.portrait
                                                ? size.width / 2
                                                : size.width / 4,
                                            child: PieChart(
                                              PieChartData(
                                                centerSpaceRadius: 25,
                                                sections:
                                                    getThisWeekPieSectionData(),
                                                pieTouchData: PieTouchData(
                                                    touchCallback: (event,
                                                        pieTouchResponse) {
                                                  setState(() {
                                                    final desiredTouch =
                                                        pieTouchResponse
                                                                is! PointerExitEvent &&
                                                            pieTouchResponse
                                                                is! PointerUpEvent;
                                                    if (desiredTouch &&
                                                        pieTouchResponse
                                                                ?.touchedSection !=
                                                            null) {
                                                      touchIndex =
                                                          pieTouchResponse!
                                                              .touchedSection!
                                                              .touchedSectionIndex;
                                                    } else {
                                                      touchIndex = -1;
                                                    }
                                                  });
                                                }),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.portrait
                                                ? size.width / 4
                                                : size.width / 9,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(children: [
                                                  Container(
                                                    color: foodColor,
                                                    height: 18,
                                                    width: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  RichText(
                                                      text: TextSpan(
                                                          text: 'Food',
                                                          style: labelText,
                                                          children: [
                                                        TextSpan(
                                                          text:
                                                              ' \n ${foodThisWeekTotal.toStringAsFixed(2)}',
                                                          style: valueText,
                                                        ),
                                                      ]))
                                                ]),
                                                Row(
                                                  children: [
                                                    Container(
                                                      color: travelColor,
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    RichText(
                                                        text: TextSpan(
                                                            text: 'Travel',
                                                            style: labelText,
                                                            children: [
                                                          TextSpan(
                                                            text:
                                                                ' \n ${travelThisWeekTotal.toStringAsFixed(2)}',
                                                            style: valueText,
                                                          ),
                                                        ]))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      color: utilityColor,
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    RichText(
                                                        text: TextSpan(
                                                            text: 'Utility',
                                                            style: labelText,
                                                            children: [
                                                          TextSpan(
                                                            text:
                                                                ' \n ${utilityThisWeekTotal.toStringAsFixed(2)}',
                                                            style: valueText,
                                                          ),
                                                        ]))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      color: shoppingColor,
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    RichText(
                                                        text: TextSpan(
                                                            text: 'Shopping',
                                                            style: labelText,
                                                            children: [
                                                          TextSpan(
                                                            text:
                                                                ' \n ${shoppingThisWeekTotal.toStringAsFixed(2)}',
                                                            style: valueText,
                                                          ),
                                                        ]))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? size.height / 3.5
                                      : size.height / 2,
                                  //width: MediaQuery.of(context).orientation == Orientation.portrait ? size.width - 30 : size.width / 3,
                                  child: Card(
                                    shadowColor: Colors.grey,
                                    elevation: 5,
                                    color: Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: BarChart(
                                        BarChartData(
                                          alignment: BarChartAlignment.center,
                                          barTouchData: BarTouchData(
                                            enabled: true,
                                          ),
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 5,
                                              getTitlesWidget:
                                                  (double value, addedStyles) {
                                                switch (value.toInt()) {
                                                  case 0:
                                                    return Text(days[
                                                        date0.weekday - 1]);
                                                  case 1:
                                                    return Text(days[
                                                        date1.weekday - 1]);
                                                  case 2:
                                                    return Text(days[
                                                        date2.weekday - 1]);
                                                  case 3:
                                                    return Text(days[
                                                        date3.weekday - 1]);
                                                  case 4:
                                                    return Text(days[
                                                        date4.weekday - 1]);
                                                  case 5:
                                                    return Text(days[
                                                        date5.weekday - 1]);
                                                  case 6:
                                                    return Text('Today');
                                                  default:
                                                    return Text('');
                                                }
                                              },
                                            )),
                                            leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 0,
                                                  interval: [
                                                        food0,
                                                        food1,
                                                        food2,
                                                        food3,
                                                        food4,
                                                        food5,
                                                        food6,
                                                        travel0,
                                                        travel1,
                                                        travel2,
                                                        travel3,
                                                        travel4,
                                                        travel5,
                                                        travel6,
                                                        utility0,
                                                        utility1,
                                                        utility2,
                                                        utility3,
                                                        utility4,
                                                        utility5,
                                                        utility6,
                                                        shopping0,
                                                        shopping1,
                                                        shopping2,
                                                        shopping3,
                                                        shopping4,
                                                        shopping5,
                                                        shopping6,
                                                        2
                                                      ].reduce((a, b) =>
                                                          max(a!, b!))! /
                                                      2.ceilToDouble()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Image.asset(
                                  'assets/images/empty_folder.png',
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                ),
                              ),
                              Center(
                                child: Text(
                                  'No data for this week!',
                                  style: appBarTitleText,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            /** Second tab shows monthly stats*/
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          color: Colors.grey)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: getMonths(),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 0.5,
                          spreadRadius: 0.5,
                          color: Colors.grey)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 40,
                  width: size.width - 30,
                  child: Center(
                      child: Text(
                    'Total expenses (this month): $monthTotal',
                    style: appBarTitleText,
                  )),
                ),
                Expanded(
                  child: Container(
                    //height: size.height - 240,
                    child: SingleChildScrollView(
                      child: monthTotal > 0
                          ? Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? size.height / 3.5
                                            : size.height / 2,
                                    child: Card(
                                      shadowColor: Colors.grey,
                                      elevation: 5,
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.portrait
                                                  ? size.width / 2
                                                  : size.width / 4,
                                              child: PieChart(
                                                PieChartData(
                                                  centerSpaceRadius: 25,
                                                  sections:
                                                      getMonthlyPieSectionData(),
                                                  pieTouchData: PieTouchData(
                                                      touchCallback: (event,
                                                          pieTouchResponse) {
                                                    setState(() {
                                                      final desiredTouch =
                                                          pieTouchResponse
                                                                  is! PointerExitEvent &&
                                                              pieTouchResponse
                                                                  is! PointerUpEvent;
                                                      if (desiredTouch &&
                                                          pieTouchResponse!
                                                                  .touchedSection !=
                                                              null) {
                                                        touchIndex =
                                                            pieTouchResponse
                                                                .touchedSection!
                                                                .touchedSectionIndex;
                                                      } else {
                                                        touchIndex = -1;
                                                      }
                                                    });
                                                  }),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.portrait
                                                  ? size.width / 4
                                                  : size.width / 9,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(children: [
                                                    Container(
                                                      color: foodColor,
                                                      height: 18,
                                                      width: 18,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    RichText(
                                                        text: TextSpan(
                                                            text: 'Food',
                                                            style: labelText,
                                                            children: [
                                                          TextSpan(
                                                            text:
                                                                ' \n ${foodMonthTotal.toStringAsFixed(2)}',
                                                            style: valueText,
                                                          ),
                                                        ]))
                                                  ]),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        color: travelColor,
                                                        height: 18,
                                                        width: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              text: 'Travel',
                                                              style: labelText,
                                                              children: [
                                                            TextSpan(
                                                              text:
                                                                  ' \n ${travelMonthTotal.toStringAsFixed(2)}',
                                                              style: valueText,
                                                            ),
                                                          ]))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        color: utilityColor,
                                                        height: 18,
                                                        width: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              text: 'Utility',
                                                              style: labelText,
                                                              children: [
                                                            TextSpan(
                                                              text:
                                                                  ' \n ${utilityMonthTotal.toStringAsFixed(2)}',
                                                              style: valueText,
                                                            ),
                                                          ]))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        color: shoppingColor,
                                                        height: 18,
                                                        width: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      RichText(
                                                          text: TextSpan(
                                                              text: 'Shopping',
                                                              style: labelText,
                                                              children: [
                                                            TextSpan(
                                                              text:
                                                                  ' \n ${shoppingMonthTotal.toStringAsFixed(2)}',
                                                              style: valueText,
                                                            ),
                                                          ]))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? size.height / 3.5
                                            : size.height / 2,
                                    child: Card(
                                      shadowColor: Colors.grey,
                                      elevation: 5,
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              child: Row(children: [
                                                Container(
                                                  color: Colors.white,
                                                  height: 12,
                                                  width: 12,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Budget',
                                                    style: labelText),
                                              ]),
                                            ),
                                            BarChart(
                                              BarChartData(
                                                alignment:
                                                    BarChartAlignment.center,
                                                barTouchData: BarTouchData(
                                                  enabled: true,
                                                ),
                                                titlesData: FlTitlesData(
                                                  show: true,
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      interval: 5,
                                                      getTitlesWidget:
                                                          (double value,
                                                              addedStyle) {
                                                        switch (value.toInt()) {
                                                          case 0:
                                                            return Text('Food');
                                                          case 1:
                                                            return Text(
                                                                'Travel');
                                                          case 2:
                                                            return Text(
                                                                'Utility');
                                                          case 3:
                                                            return Text(
                                                                'Shopping');
                                                          default:
                                                            return Text('');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: true,
                                                        reservedSize: 12,
                                                        interval: [
                                                              foodMonthTotal,
                                                              travelMonthTotal,
                                                              utilityMonthTotal,
                                                              shoppingMonthTotal,
                                                              travelBudget,
                                                              foodBudget,
                                                              shoppingBudget,
                                                              utilityBudget,
                                                              2
                                                            ].reduce(max) /
                                                            2.ceilToDouble()),
                                                  ),
                                                ),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                groupsSpace: 35,
                                                barGroups: getMonthlyBarData(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Image.asset(
                                    'assets/images/empty_folder.png',
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'No data for this month!',
                                    style: appBarTitleText,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getMonths() {
    var size = MediaQuery.of(context).size;
    //Show months from x days back
    final x = 365;
    var month1 = DateTime.now().subtract(Duration(days: x)).month;
    var year1 = DateTime.now().subtract(Duration(days: x)).year;

    //Show till y months forward.
    final y = 25;
    List<MonthYearListTile> listMonths = [];
    for (int i = 0; i < y; i++) {
      var monthDisplayed = month1;
      var yearDisplayed = year1;
      MonthYearListTile tile = MonthYearListTile(
        month: monthDisplayed,
        monthSelected: monthSelected,
        yearSelected: yearSelected,
        year: yearDisplayed,
        onTap: () {
          setState(() {
            monthSelected = monthDisplayed;
            yearSelected = yearDisplayed;
            setMonthExpenseValues();
          });
        },
      );
      listMonths.add(tile);
      month1 += 1;
      if (month1 > 12) {
        month1 = 1;
        year1 += 1;
      }
    }
    ScrollController scrollController = ScrollController(
        initialScrollOffset: (size.width - 20) * x * 12 / (365 * 6),
        keepScrollOffset: true);

    return Container(
      height: 60,
      width: size.width - 20,
      child: ListView(
        controller: scrollController,
        itemExtent: (size.width - 20) / 6,
        scrollDirection: Axis.horizontal,
        children: listMonths,
      ),
    );
  }

  void setThisWeekExpenseValues() {
    food0 = 0.0;
    food1 = 0.0;
    food2 = 0.0;
    food3 = 0.0;
    food4 = 0.0;
    food5 = 0.0;
    food6 = 0.0;
    travel0 = 0.0;
    travel1 = 0.0;
    travel2 = 0.0;
    travel3 = 0.0;
    travel4 = 0.0;
    travel5 = 0.0;
    travel6 = 0.0;
    utility0 = 0.0;
    utility1 = 0.0;
    utility2 = 0.0;
    utility3 = 0.0;
    utility4 = 0.0;
    utility5 = 0.0;
    utility6 = 0.0;
    shopping0 = 0.0;
    shopping1 = 0.0;
    shopping2 = 0.0;
    shopping3 = 0.0;
    shopping4 = 0.0;
    shopping5 = 0.0;
    shopping6 = 0.0;

    docRef.collection('Transactions').get().then((snapshot) {
      snapshot.docs.forEach((element) {
        //Set date0 values
        try {
          if (element['Day'] == date0.day &&
              element['Month'] == date0.month &&
              element['Year'] == date0.year) {
            if (element['Type'] == 'Food') {
              food0 = food0! + element['Amount'];
            } else if (element['Type'] == 'Travel') {
              travel0 = travel0! + element['Amount'];
            } else if (element['Type'] == 'Shopping') {
              shopping0 = shopping0! + element['Amount'];
            } else if (element['Type'] == 'Utility') {
              utility0 = utility0! + element['Amount'];
            }
          }
          //Set date1 values
          if (element.get('Day') == date1.day &&
              element.get('Month') == date1.month &&
              element.get('Year') == date1.year) {
            if (element.get('Type') == 'Food') {
              food1 = food1! + element.get('Amount');
            } else if (element.get('Type') == 'Travel') {
              travel1 = travel1! + element.get('Amount');
            } else if (element.get('Type') == 'Shopping') {
              shopping1 = shopping1! + element.get('Amount');
            } else if (element.get('Type') == 'Utility') {
              utility1 = utility1! + element.get('Amount');
            }
          }
          //Set date2 values
          if (element.get('Day') == date2.day &&
              element.get('Month') == date2.month &&
              element.get('Year') == date2.year) {
            if (element.get('Type') == 'Food') {
              food2 = food2! + element.get('Amount');
            } else if (element.get('Type') == 'Travel') {
              travel2 = travel2! + element.get('Amount');
            } else if (element.get('Type') == 'Shopping') {
              shopping2 = shopping2! + element['Amount'];
            } else if (element.get('Type') == 'Utility') {
              utility2 = utility2! + element.get('Amount');
            }
          }
          //Set date3 values
          if (element.get('Day') == date3.day &&
              element.get('Month') == date3.month &&
              element.get('Year') == date3.year) {
            if (element.get('Type') == 'Food') {
              food3 = food3! + element.get('Amount');
            } else if (element.get('Type') == 'Travel') {
              travel3 = travel3! + element.get('Amount');
            } else if (element.get('Type') == 'Shopping') {
              shopping3 = shopping3! + element['Amount'];
            } else if (element.get('Type') == 'Utility') {
              utility3 = utility3! + element.get('Amount');
            }
          }
          //Set date4 values
          if (element.get('Day') == date4.day &&
              element.get('Month') == date4.month &&
              element.get('Year') == date4.year) {
            if (element.get('Type') == 'Food') {
              food4 = food4! + element.get('Amount');
            } else if (element.get('Type') == 'Travel') {
              travel4 = travel4! + element.get('Amount');
            } else if (element.get('Type') == 'Shopping') {
              shopping4 = shopping4! + element['Amount'];
            } else if (element.get('Type') == 'Utility') {
              utility4 = utility4! + element.get('Amount');
            }
          }
          //Set date5 values
          if (element.get('Day') == date5.day &&
              element.get('Month') == date5.month &&
              element.get('Year') == date5.year) {
            if (element.get('Type') == 'Food') {
              food5 = food5! + element.get('Amount');
            } else if (element.get('Type') == 'Travel') {
              travel5 = travel5! + element.get('Amount');
            } else if (element.get('Type') == 'Shopping') {
              shopping5 = shopping5! + element['Amount'];
            } else if (element.get('Type') == 'Utility') {
              utility5 = utility5! + element.get('Amount');
            }
          }
          //Set date6 values
          if (element.get('Day') == date6.day &&
              element.get('Month') == date6.month &&
              element.get('Year') == date6.year) {
            if (element.get('Type') == 'Food') {
              food6 = food6! + element.get('Amount');
            } else if (element.get('Type') == 'Travel') {
              travel6 = travel6! + element.get('Amount');
            } else if (element.get('Type') == 'Shopping') {
              shopping6 = shopping6! + element.get('Amount');
            } else if (element.get('Type') == 'Utility') {
              utility6 = utility6! + element.get('Amount');
            }
          }
        } on Exception catch (e) {
          print(e);
        }
      });
      foodThisWeekTotal =
          food0! + food1! + food2! + food3! + food4! + food5! + food6!;
      travelThisWeekTotal = travel0! +
          travel1! +
          travel2! +
          travel3! +
          travel4! +
          travel5! +
          travel6!;
      shoppingThisWeekTotal = shopping0! +
          shopping1! +
          shopping2! +
          shopping3! +
          shopping4! +
          shopping5! +
          shopping6!;
      utilityThisWeekTotal = utility0! +
          utility1! +
          utility2! +
          utility3! +
          utility4! +
          utility5! +
          utility6!;
      thisWeekTotal = foodThisWeekTotal +
          travelThisWeekTotal +
          utilityThisWeekTotal +
          shoppingThisWeekTotal;
      setState(() {});
    });
  }

  List<BarChartGroupData> getThisWeekStackedBarData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              toY: food0! + travel0! + utility0! + shopping0!,
              rodStackItems: [
                BarChartRodStackItem(0, food0!, foodColor),
                BarChartRodStackItem(food0!, food0! + travel0!, travelColor),
                BarChartRodStackItem(food0! + travel0!,
                    food0! + travel0! + utility0!, utilityColor),
                BarChartRodStackItem(food0! + travel0! + utility0!,
                    food0! + travel0! + utility0! + shopping0!, shoppingColor),
              ],
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              toY: food1! + travel1! + utility1! + shopping1!,
              rodStackItems: [
                BarChartRodStackItem(0, food1!, foodColor),
                BarChartRodStackItem(food1!, food1! + travel1!, travelColor),
                BarChartRodStackItem(food1! + travel1!,
                    food1! + travel1! + utility1!, utilityColor),
                BarChartRodStackItem(food1! + travel1! + utility1!,
                    food1! + travel1! + utility1! + shopping1!, shoppingColor),
              ],
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              toY: food2! + travel2! + utility2! + shopping2!,
              rodStackItems: [
                BarChartRodStackItem(0, food2!, foodColor),
                BarChartRodStackItem(food2!, food2! + travel2!, travelColor),
                BarChartRodStackItem(food2! + travel2!,
                    food2! + travel2! + utility2!, utilityColor),
                BarChartRodStackItem(food2! + travel2! + utility2!,
                    food2! + travel2! + utility2! + shopping2!, shoppingColor),
              ],
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              toY: food3! + travel3! + utility3! + shopping3!,
              rodStackItems: [
                BarChartRodStackItem(0, food3!, foodColor),
                BarChartRodStackItem(food3!, food3! + travel3!, travelColor),
                BarChartRodStackItem(food3! + travel3!,
                    food3! + travel3! + utility3!, utilityColor),
                BarChartRodStackItem(food3! + travel3! + utility3!,
                    food3! + travel3! + utility3! + shopping3!, shoppingColor),
              ],
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              toY: food4! + travel4! + utility4! + shopping4!,
              rodStackItems: [
                BarChartRodStackItem(0, food4!, foodColor),
                BarChartRodStackItem(food4!, food4! + travel4!, travelColor),
                BarChartRodStackItem(food4! + travel4!,
                    food4! + travel4! + utility4!, utilityColor),
                BarChartRodStackItem(food4! + travel4! + utility4!,
                    food4! + travel4! + utility4! + shopping4!, shoppingColor),
              ],
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              toY: food5! + travel5! + utility5! + shopping5!,
              rodStackItems: [
                BarChartRodStackItem(0, food5!, foodColor),
                BarChartRodStackItem(food5!, food5! + travel5!, travelColor),
                BarChartRodStackItem(food5! + travel5!,
                    food5! + travel5! + utility5!, utilityColor),
                BarChartRodStackItem(food5! + travel5! + utility5!,
                    food5! + travel5! + utility5! + shopping5!, shoppingColor),
              ],
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barsSpace: 10,
        barRods: [
          BarChartRodData(
              toY: food6! + travel6! + utility6! + shopping6!,
              rodStackItems: [
                BarChartRodStackItem(0, food6!, foodColor),
                BarChartRodStackItem(food6!, food6! + travel6!, travelColor),
                BarChartRodStackItem(food6! + travel6!,
                    food6! + travel6! + utility6!, utilityColor),
                BarChartRodStackItem(food6! + travel6! + utility6!,
                    food6! + travel6! + utility6! + shopping6!, shoppingColor),
              ],
              borderRadius: borderRadius),
        ],
      ),
    ];
  }

  List<PieChartSectionData> getThisWeekPieSectionData() {
    if (thisWeekTotal == 0) {
      thisWeekTotal = 1;
    }
    return [
      PieChartSectionData(
        radius: touchIndex == 0 ? 50 : 40,
        titleStyle: budgetText,
        title: ((foodThisWeekTotal) * 100 ~/ thisWeekTotal).toString() + ' % ',
        color: foodColor,
        value: foodThisWeekTotal,
      ),
      PieChartSectionData(
        radius: touchIndex == 1 ? 50 : 40,
        titleStyle: budgetText,
        title: ((travelThisWeekTotal) * 100 ~/ thisWeekTotal).toString() + ' %',
        color: travelColor,
        value: travelThisWeekTotal,
      ),
      PieChartSectionData(
        radius: touchIndex == 2 ? 50 : 40,
        titleStyle: budgetText,
        title:
            ((utilityThisWeekTotal) * 100 ~/ thisWeekTotal).toString() + ' %',
        color: utilityColor,
        value: utilityThisWeekTotal,
      ),
      PieChartSectionData(
        radius: touchIndex == 3 ? 50 : 40,
        titleStyle: budgetText,
        title:
            ((shoppingThisWeekTotal) * 100 ~/ thisWeekTotal).toString() + ' %',
        color: shoppingColor,
        value: shoppingThisWeekTotal,
      ),
    ];
  }

  void setMonthExpenseValues() {
    foodMonthTotal = 0.0;

    travelMonthTotal = 0.0;

    utilityMonthTotal = 0.0;

    shoppingMonthTotal = 0.0;

    foodBudget = 0.0;
    travelBudget = 0.0;
    utilityBudget = 0.0;
    shoppingBudget = 0.0;

    docRef
        .collection('Transactions')
        .where('Month', isEqualTo: monthSelected)
        .where('Year', isEqualTo: yearSelected)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Set month expense values
        try {
          if (element['Type'] == 'Food') {
            foodMonthTotal += element['Amount'];
          } else if (element['Type'] == 'Travel') {
            travelMonthTotal += element['Amount'];
          } else if (element['Type'] == 'Shopping') {
            shoppingMonthTotal += element['Amount'];
          } else if (element['Type'] == 'Utility') {
            utilityMonthTotal += element['Amount'];
          }
        } on Exception catch (e) {
          print(e);
        }
      });
      monthTotal = foodMonthTotal +
          travelMonthTotal +
          shoppingMonthTotal +
          utilityMonthTotal;
      setState(() {});
    });

    docRef
        .collection('Budgets')
        .where('Month', isEqualTo: monthSelected)
        .where('Year', isEqualTo: yearSelected)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Set month expense values
        try {
          if (element['Type'] == 'Food') {
            foodBudget = element['Limit'];
          } else if (element['Type'] == 'Travel') {
            travelBudget = element['Limit'];
          } else if (element['Type'] == 'Shopping') {
            shoppingBudget = element['Limit'];
          } else if (element['Type'] == 'Utility') {
            utilityBudget = element['Limit'];
          }
        } on Exception catch (e) {
          print(e);
        }
      });
      setState(() {});
    });
  }

  List<PieChartSectionData> getMonthlyPieSectionData() {
    if (monthTotal == 0) monthTotal = 1;
    return [
      PieChartSectionData(
        radius: touchIndex == 0 ? 50 : 40,
        titleStyle: budgetText,
        title: ((foodMonthTotal) * 100 ~/ monthTotal).toString() + ' % ',
        color: foodColor,
        value: foodMonthTotal,
      ),
      PieChartSectionData(
        radius: touchIndex == 1 ? 50 : 40,
        titleStyle: budgetText,
        title: ((travelMonthTotal) * 100 ~/ monthTotal).toString() + ' %',
        color: travelColor,
        value: travelMonthTotal,
      ),
      PieChartSectionData(
        radius: touchIndex == 2 ? 50 : 40,
        titleStyle: budgetText,
        title: ((utilityMonthTotal) * 100 ~/ monthTotal).toString() + ' %',
        color: utilityColor,
        value: utilityMonthTotal,
      ),
      PieChartSectionData(
        radius: touchIndex == 3 ? 50 : 40,
        titleStyle: budgetText,
        title: ((shoppingMonthTotal) * 100 ~/ monthTotal).toString() + ' %',
        color: shoppingColor,
        value: shoppingMonthTotal,
      ),
    ];
  }

  List<BarChartGroupData> getMonthlyBarData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
              width: 15,
              toY: foodMonthTotal,
              color: foodColor,
              borderRadius: borderRadius),
          //Food budget data
          BarChartRodData(
              width: 15,
              toY: foodBudget,
              color: Colors.white,
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
              width: 15,
              toY: travelMonthTotal,
              color: travelColor,
              borderRadius: borderRadius),
          //Travel budget data
          BarChartRodData(
              width: 15,
              toY: travelBudget,
              color: Colors.white,
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
              width: 15,
              toY: utilityMonthTotal,
              color: utilityColor,
              borderRadius: borderRadius),
          //Utility budget data
          BarChartRodData(
              width: 15,
              toY: utilityBudget,
              color: Colors.white,
              borderRadius: borderRadius),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
              width: 15,
              toY: shoppingMonthTotal,
              color: shoppingColor,
              borderRadius: borderRadius),
          //Shopping budget data
          BarChartRodData(
              width: 15,
              toY: shoppingBudget,
              color: Colors.white,
              borderRadius: borderRadius),
        ],
      ),
    ];
  }
}

class MonthYearListTile extends StatelessWidget {
  MonthYearListTile(
      {required this.month,
      required this.year,
      required this.onTap,
      required this.yearSelected,
      required this.monthSelected});

  final int month;
  final int year;
  final int yearSelected;
  final int monthSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: TextButton(
              style: (monthSelected == month && yearSelected == year)
                  ? TextButton.styleFrom(backgroundColor: Colors.lightBlue[50])
                  : null,
              onPressed: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    Months.values[month - 1].toString().substring(7, 10),
                    style: dayText,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    year.toString(),
                    style: dayText.copyWith(
                        fontSize: 9, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
