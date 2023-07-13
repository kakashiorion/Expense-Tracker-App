import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'createBudget.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

late int monthSelected;
late int yearSelected;

class _BudgetPageState extends State<BudgetPage> {
  final _auth = FirebaseAuth.instance;
  dynamic loggedInUser;
  late DocumentReference docRef;

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                  color: Colors.grey)
            ],
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 40,
                        //width: size.width - 120,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            'Expense Budgets',
                            style: appBarTitleText.copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CreateBudget();
                            }));
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              getMonths(),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: displayBudgets(monthSelected, yearSelected),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  Widget displayBudgets(int month, int year) {
    return StreamBuilder(
        stream: docRef
            .collection('Budgets')
            .where('Month', isEqualTo: month)
            .where('Year', isEqualTo: year)
            .orderBy('Time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active ||
              !snapshot.hasData ||
              snapshot.data!.docs.length == 0) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.asset(
                      'assets/images/empty_folder.png',
                      height: MediaQuery.of(context).size.height / 2.5,
                    ),
                  ),
                  Text(
                    'No budgets found!',
                    style: appBarTitleText,
                  ),
                ],
              ),
            );
          } else {
            return Container(
              child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final type = snapshot.data!.docs[index]['Type'];
                    final currency = snapshot.data!.docs[index]['Currency'];
                    final limit = snapshot.data!.docs[index]['Limit'];
                    final title = snapshot.data!.docs[index]['Title'];
                    final id = snapshot.data!.docs[index].id;
                    final time = snapshot.data!.docs[index]['Time'];
                    Widget totalValueWidget =
                        txnValue(month, year, type, currency, limit.toDouble());
                    return Dismissible(
                      key: UniqueKey(),
                      background: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.redAccent[100],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                      //size: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Swipe to Delete',
                                  style: weekdayText,
                                )
                              ],
                            ),
                          )),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (dismissDirection) {
                        docRef.collection('Budgets').doc(id).delete();
                        setState(() {
                          snapshot.data!.docs.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Budget removed'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                docRef.collection('Budgets').add({
                                  'Type': type,
                                  'Title': title,
                                  'Limit': limit,
                                  'Month': month,
                                  'Year': year,
                                  'Currency': currency,
                                  'Time': time
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: BudgetTile(
                        budgetTitle: title,
                        budgetValue: totalValueWidget,
                        currency: currency,
                        budgetCategory: type,
                      ),
                    );
                  }),
            );
          }
        });
  }

  Widget txnValue(
      int month, int year, String type, String currency, double limit) {
    return StreamBuilder(
        stream: docRef
            .collection('Transactions')
            .where('Month', isEqualTo: month)
            .where('Year', isEqualTo: year)
            .where('Type', isEqualTo: type)
            .where('Currency', isEqualTo: currency)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency + ' 0',
                  style: appBarTitleText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Limit: ' + limit.toString(),
                  style: budgetText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'UNUSED',
                  style: budgetText.copyWith(color: Colors.green),
                ),
              ],
            );
          } else {
            double value = 0.0;
            snapshot.data!.docs.forEach((element) {
              value += element['Amount'];
              //print('$elementValue  ${element['Details']}');
            });
            final ratio = value * 100 / limit;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency + ' ' + value.toString(),
                  style: appBarTitleText,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Limit: ' + limit.toString(),
                  style: budgetText,
                ),
                SizedBox(
                  height: 5,
                ),
                ratio > 100
                    ? Text(
                        'OVERSPENT',
                        style: budgetText.copyWith(color: Colors.red),
                      )
                    : Text(
                        '${ratio.toInt()} %',
                        style: budgetText.copyWith(
                            color: ratio > 80
                                ? Colors.red
                                : ratio > 50
                                    ? Colors.orange
                                    : Colors.green),
                      ),
              ],
            );
          }
        });
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
        year: yearDisplayed,
        onTap: () {
          setState(() {
            monthSelected = monthDisplayed;
            yearSelected = yearDisplayed;
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
        initialScrollOffset: (size.width - 40) * x * 12 / (365 * 6),
        keepScrollOffset: true);

    return Container(
      height: 70,
      width: size.width - 40,
      child: ListView(
        controller: scrollController,
        itemExtent: (size.width - 40) / 6,
        scrollDirection: Axis.horizontal,
        children: listMonths,
      ),
    );
  }
}

class MonthYearListTile extends StatelessWidget {
  MonthYearListTile(
      {required this.month, required this.year, required this.onTap});

  final int month;
  final int year;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      child: SizedBox(
        height: 50,
        child: TextButton(
          style: (monthSelected == month && yearSelected == year)
              ? TextButton.styleFrom(backgroundColor: Colors.lightBlue[50])
              : null,
          onPressed: onTap(),
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
    );
  }
}

class BudgetTile extends StatelessWidget {
  BudgetTile(
      {required this.budgetTitle,
      required this.budgetValue,
      required this.budgetCategory,
      required this.currency});

  final String budgetTitle;
  final Widget budgetValue;
  final String budgetCategory;
  final String currency;

  Icon getIcon(String type) {
    late Icon icon;
    if (type == TransactionType.Food.toString().substring(16)) {
      icon = Icon(Icons.fastfood_outlined);
    } else if (type == TransactionType.Shopping.toString().substring(16)) {
      icon = Icon(Icons.shopping_basket_outlined);
    } else if (type == TransactionType.Travel.toString().substring(16)) {
      icon = Icon(Icons.flight_outlined);
    } else if (type == TransactionType.Utility.toString().substring(16)) {
      icon = Icon(Icons.wb_incandescent_outlined);
    } else if (type == TransactionType.Income.toString().substring(16)) {
      icon = Icon(Icons.attach_money_outlined);
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(-2, 0), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                          borderRadius: new BorderRadius.circular(5.0)),
                      height: 40,
                      width: 40,
                      child: getIcon(budgetCategory),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        budgetTitle,
                        style: appBarTitleText,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: budgetValue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
