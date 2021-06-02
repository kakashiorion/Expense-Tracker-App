import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class CreateBudget extends StatefulWidget {
  const CreateBudget({Key key}) : super(key: key);

  @override
  _CreateBudgetState createState() => _CreateBudgetState();
}

String expenseTypeSelected;
int monthSelected;
int yearSelected;

class _CreateBudgetState extends State<CreateBudget> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser;
  String email;
  //String budgetTitle;
  double budgetLimit;
  String currencySelected = 'INR';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    monthSelected = DateTime.now().month;
    yearSelected = DateTime.now().year;
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        email = loggedInUser.email;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Create a budget',
            style: appBarTitleText,
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          bottomOpacity: 1.0,
          leading: IconButton(
              iconSize: 20,
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
              splashColor: null,
              splashRadius: 1),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pick budget month',
                      style: titleText.copyWith(fontSize: 15),
                    ),
                  ),
                  getMonths(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select expense type',
                      style: titleText.copyWith(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      itemExtent: (size.width - 40) / 4,
                      children: [
                        ExpenseTypeCard(
                          expenseType: 'Food',
                          icon: Icons.restaurant_outlined,
                          onTap: () {
                            setState(() {
                              expenseTypeSelected = 'Food';
                            });
                          },
                        ),
                        ExpenseTypeCard(
                          expenseType: 'Travel',
                          icon: Icons.flight_outlined,
                          onTap: () {
                            setState(() {
                              expenseTypeSelected = 'Travel';
                            });
                          },
                        ),
                        ExpenseTypeCard(
                          expenseType: 'Shopping',
                          icon: Icons.shopping_basket_outlined,
                          onTap: () {
                            setState(() {
                              expenseTypeSelected = 'Shopping';
                            });
                          },
                        ),
                        ExpenseTypeCard(
                          expenseType: 'Utility',
                          icon: Icons.wb_incandescent_outlined,
                          onTap: () {
                            setState(() {
                              expenseTypeSelected = 'Utility';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Text(
                  //     'Enter a budget title (Optional)',
                  //     style: titleText.copyWith(fontSize: 15),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextField(
                  //       onChanged: (detailsText) {
                  //         setState(() {
                  //           budgetTitle = detailsText;
                  //         });
                  //       },
                  //       cursorColor: Colors.black,
                  //       decoration: InputDecoration(
                  //           hintText: 'Groceries',
                  //           hintStyle: titleText.copyWith(fontSize: 12),
                  //           filled: true,
                  //           fillColor: Colors.white,
                  //           contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  //           border: OutlineInputBorder()),
                  //       style: displayTextStyle),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Enter the budget limit',
                      style: titleText.copyWith(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton.icon(
                            onPressed: () {
                              showCurrencyPicker(
                                  context: context,
                                  showFlag: true,
                                  showCurrencyName: true,
                                  showCurrencyCode: true,
                                  onSelect: (Currency currency) {
                                    setState(() {
                                      currencySelected = currency.code;
                                    });
                                  });
                            },
                            label: Text(
                              currencySelected,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                              onChanged: (detailsText) {
                                if (detailsText == '') {
                                  setState(() {
                                    budgetLimit = 0.0;
                                  });
                                } else {
                                  setState(() {
                                    budgetLimit = double.tryParse(detailsText);
                                  });
                                }
                              },
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder()),
                              style: displayTextStyle),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: SizedBox(
                        height: 35,
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              primary: Colors.lightBlue),
                          onPressed: () {
                            // if (budgetTitle == null || budgetTitle == '') {
                            //   budgetTitle = '$expenseTypeSelected budget';
                            // }
                            final docRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(email);
                            //Add Budget details to Firestore
                            docRef.collection('Budgets').add({
                              'Type': expenseTypeSelected,
                              'Title': '$expenseTypeSelected budget',
                              'Limit': budgetLimit,
                              'Month': monthSelected,
                              'Year': yearSelected,
                              'Currency': currencySelected,
                              'Time': DateTime.now()
                            });
                            Navigator.pop(context);
                          },

                          child: Text(
                            'Create',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.normal),
                          ),

                          // backgroundColor: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMonths() {
    var size = MediaQuery.of(context).size;

    var month1 = DateTime.now().month;
    var year1 = DateTime.now().year;

    //Show till y months forward.
    final y = 12;
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

    return Container(
      height: 70,
      width: size.width - 40,
      child: ListView(
        itemExtent: (size.width - 40) / 6,
        scrollDirection: Axis.horizontal,
        children: listMonths,
      ),
    );
  }
}

class MonthYearListTile extends StatelessWidget {
  MonthYearListTile({this.month, this.year, this.onTap});

  final int month;
  final int year;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(style: BorderStyle.solid, color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        height: 50,
        child: TextButton(
          style: (monthSelected == month && yearSelected == year)
              ? TextButton.styleFrom(backgroundColor: Colors.lightBlue)
              : null,
          onPressed: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Months.values[month - 1].toString().substring(7, 10),
                style: dayText.copyWith(
                    color: (monthSelected == month && yearSelected == year)
                        ? Colors.white
                        : Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                year.toString(),
                style: dayText.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.normal,
                    color: (monthSelected == month && yearSelected == year)
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseTypeCard extends StatelessWidget {
  ExpenseTypeCard({this.expenseType, this.icon, this.onTap});

  final IconData icon;
  final String expenseType;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          color: expenseType == expenseTypeSelected
              ? Colors.lightBlue
              : Colors.white,
          border: Border.all(color: Colors.lightBlue, width: 0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: TextButton(
          onPressed: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Icon(
                  icon,
                  color: expenseType == expenseTypeSelected
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                expenseType,
                style: appBarTitleText.copyWith(
                    color: expenseType == expenseTypeSelected
                        ? Colors.white
                        : Colors.black,
                    fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}
