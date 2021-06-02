import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

DateTime dateToday = DateTime.now();
DateTime dateSelected = dateToday;
int monthSelected = dateToday.month;
int yearSelected = dateToday.year;

DateTime date1, date2, date3, date4, date5, date6, date7;
int month1, month2, month3, month4, month5, month6;
int year1;

class _TransactionsPageState extends State<TransactionsPage> {
  var dailySelected = true;
  var dropDownValue = 'All Transactions';

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  DocumentReference docRef;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        docRef = _firestore.collection('users').doc(loggedInUser.email);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    displayToday();
  }

  void displayToday() {
    year1 = dateToday.year;
    switch (dateToday.weekday) {
      case 1:
        date1 = dateToday;
        date2 = dateToday.add(Duration(days: 1));
        date3 = dateToday.add(Duration(days: 2));
        date4 = dateToday.add(Duration(days: 3));
        date5 = dateToday.add(Duration(days: 4));
        date6 = dateToday.add(Duration(days: 5));
        date7 = dateToday.add(Duration(days: 6));
        break;
      case 2:
        date1 = dateToday.subtract(Duration(days: 1));
        date2 = dateToday;
        date3 = dateToday.add(Duration(days: 1));
        date4 = dateToday.add(Duration(days: 2));
        date5 = dateToday.add(Duration(days: 3));
        date6 = dateToday.add(Duration(days: 4));
        date7 = dateToday.add(Duration(days: 5));
        break;
      case 3:
        date1 = dateToday.subtract(Duration(days: 2));
        date2 = dateToday.subtract(Duration(days: 1));
        date3 = dateToday;
        date4 = dateToday.add(Duration(days: 1));
        date5 = dateToday.add(Duration(days: 2));
        date6 = dateToday.add(Duration(days: 3));
        date7 = dateToday.add(Duration(days: 4));
        break;
      case 4:
        date1 = dateToday.subtract(Duration(days: 3));
        date2 = dateToday.subtract(Duration(days: 2));
        date3 = dateToday.subtract(Duration(days: 1));
        date4 = dateToday;
        date5 = dateToday.add(Duration(days: 1));
        date6 = dateToday.add(Duration(days: 2));
        date7 = dateToday.add(Duration(days: 3));
        break;
      case 5:
        date1 = dateToday.subtract(Duration(days: 4));
        date2 = dateToday.subtract(Duration(days: 3));
        date3 = dateToday.subtract(Duration(days: 2));
        date4 = dateToday.subtract(Duration(days: 1));
        date5 = dateToday;
        date6 = dateToday.add(Duration(days: 1));
        date7 = dateToday.add(Duration(days: 2));
        break;
      case 6:
        date1 = dateToday.subtract(Duration(days: 5));
        date2 = dateToday.subtract(Duration(days: 4));
        date3 = dateToday.subtract(Duration(days: 3));
        date4 = dateToday.subtract(Duration(days: 2));
        date5 = dateToday.subtract(Duration(days: 1));
        date6 = dateToday;
        date7 = dateToday.add(Duration(days: 1));
        break;
      case 7:
        date1 = dateToday.subtract(Duration(days: 6));
        date2 = dateToday.subtract(Duration(days: 5));
        date3 = dateToday.subtract(Duration(days: 4));
        date4 = dateToday.subtract(Duration(days: 3));
        date5 = dateToday.subtract(Duration(days: 2));
        date6 = dateToday.subtract(Duration(days: 1));
        date7 = dateToday;
        break;
    }
    switch (dateToday.month) {
      case 1:
      case 7:
        month1 = dateToday.month;
        month2 = dateToday.month + 1;
        month3 = dateToday.month + 2;
        month4 = dateToday.month + 3;
        month5 = dateToday.month + 4;
        month6 = dateToday.month + 5;
        break;
      case 2:
      case 8:
        month1 = dateToday.month - 1;
        month2 = dateToday.month;
        month3 = dateToday.month + 1;
        month4 = dateToday.month + 2;
        month5 = dateToday.month + 3;
        month6 = dateToday.month + 4;
        break;
      case 3:
      case 9:
        month1 = dateToday.month - 2;
        month2 = dateToday.month - 1;
        month3 = dateToday.month;
        month4 = dateToday.month + 1;
        month5 = dateToday.month + 2;
        month6 = dateToday.month + 3;
        break;
      case 4:
      case 10:
        month1 = dateToday.month - 3;
        month2 = dateToday.month - 2;
        month3 = dateToday.month - 1;
        month4 = dateToday.month;
        month5 = dateToday.month + 1;
        month6 = dateToday.month + 2;
        break;
      case 5:
      case 11:
        month1 = dateToday.month - 4;
        month2 = dateToday.month - 3;
        month3 = dateToday.month - 2;
        month4 = dateToday.month - 1;
        month5 = dateToday.month;
        month6 = dateToday.month + 1;
        break;
      case 6:
      case 12:
        month1 = dateToday.month - 5;
        month2 = dateToday.month - 4;
        month3 = dateToday.month - 3;
        month4 = dateToday.month - 2;
        month5 = dateToday.month - 1;
        month6 = dateToday.month;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 36,
                  width: size.width - 20.0,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    border: Border.all(color: Colors.lightBlue),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            style: dailySelected
                                ? TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0)))
                                : null,
                            onPressed: () {
                              setState(() {
                                dailySelected = true;
                              });
                            },
                            child: Text(
                              'Daily',
                              style: TextStyle(
                                  color: dailySelected
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Lato'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: dailySelected
                                ? null
                                : TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0))),
                            onPressed: () {
                              setState(() {
                                dailySelected = false;
                              });
                            },
                            child: Text(
                              'Monthly',
                              style: TextStyle(
                                  color: dailySelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Lato'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                dailySelected ? getDates() : getMonths(),
              ],
            ),
          ),
          Container(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                    child: Container(
                      height: 30,
                      width: size.width / 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.transparent.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: Colors.lightBlue,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 2),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            //iconDisabledColor: Colors.grey,
                            iconEnabledColor: Colors.lightBlue,
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 11,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold),
                            dropdownColor: Colors.white,
                            value: dropDownValue,
                            onChanged: (newValue) {
                              setState(() {
                                dropDownValue = newValue;
                              });
                            },
                            items: <String>[
                              'All Transactions',
                              'Food',
                              'Travel',
                              'Shopping',
                              'Utility',
                              'Income'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height - 200,
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: dropDownValue == 'All Transactions'
                            ? dailySelected
                                ? displayDayTransactions(dateSelected)
                                : displayMonthTransactions(
                                    monthSelected, yearSelected)
                            : dailySelected
                                ? displayDayTransactionsByType(
                                    dateSelected, dropDownValue)
                                : displayMonthTransactionsByType(monthSelected,
                                    yearSelected, dropDownValue)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDates() {
    var size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          child: IconButton(
            iconSize: 16,
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                date1 = date1.subtract(Duration(days: 7));
                date2 = date2.subtract(Duration(days: 7));
                date3 = date3.subtract(Duration(days: 7));
                date4 = date4.subtract(Duration(days: 7));
                date5 = date5.subtract(Duration(days: 7));
                date6 = date6.subtract(Duration(days: 7));
                date7 = date7.subtract(Duration(days: 7));
              });
            },
          ),
        ),
        Container(
          height: 70,
          width: size.width - 80,
          child: ListView(
            itemExtent: (size.width - 80) / 7,
            scrollDirection: Axis.horizontal,
            children:
                //dailySelected ?
                <Widget>[
              DateMonthListTile(
                  day: days[0],
                  date: date1,
                  onTap: () {
                    setState(() {
                      dateSelected = date1;
                    });
                  }),
              DateMonthListTile(
                  day: days[1],
                  date: date2,
                  onTap: () {
                    setState(() {
                      dateSelected = date2;
                    });
                  }),
              DateMonthListTile(
                  day: days[2],
                  date: date3,
                  onTap: () {
                    setState(() {
                      dateSelected = date3;
                    });
                  }),
              DateMonthListTile(
                  day: days[3],
                  date: date4,
                  onTap: () {
                    setState(() {
                      dateSelected = date4;
                    });
                  }),
              DateMonthListTile(
                  day: days[4],
                  date: date5,
                  onTap: () {
                    setState(() {
                      dateSelected = date5;
                    });
                  }),
              DateMonthListTile(
                  day: days[5],
                  date: date6,
                  onTap: () {
                    setState(() {
                      dateSelected = date6;
                    });
                  }),
              DateMonthListTile(
                  day: days[6],
                  date: date7,
                  onTap: () {
                    setState(() {
                      dateSelected = date7;
                    });
                  }),
            ],
          ),
        ),
        Container(
          width: 30,
          child: IconButton(
            iconSize: 16,
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                date1 = date1.add(Duration(days: 7));
                date2 = date2.add(Duration(days: 7));
                date3 = date3.add(Duration(days: 7));
                date4 = date4.add(Duration(days: 7));
                date5 = date5.add(Duration(days: 7));
                date6 = date6.add(Duration(days: 7));
                date7 = date7.add(Duration(days: 7));
              });
            },
          ),
        ),
      ],
    );
  }

  Widget getMonths() {
    var size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          child: IconButton(
            iconSize: 16,
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                if (month1 == 1) {
                  month1 = 7;
                  month2 = 8;
                  month3 = 9;
                  month4 = 10;
                  month5 = 11;
                  month6 = 12;
                  year1 -= 1;
                } else {
                  month1 = 1;
                  month2 = 2;
                  month3 = 3;
                  month4 = 4;
                  month5 = 5;
                  month6 = 6;
                }
              });
            },
          ),
        ),
        Container(
          height: 70,
          width: size.width - 80,
          child: ListView(
            itemExtent: (size.width - 80) / 6,
            scrollDirection: Axis.horizontal,
            children:
                //dailySelected ?
                <Widget>[
              MonthYearListTile(
                  month: month1,
                  year: year1,
                  onTap: () {
                    setState(() {
                      monthSelected = month1;
                      yearSelected = year1;
                    });
                  }),
              MonthYearListTile(
                  month: month2,
                  year: year1,
                  onTap: () {
                    setState(() {
                      monthSelected = month2;
                      yearSelected = year1;
                    });
                  }),
              MonthYearListTile(
                  month: month3,
                  year: year1,
                  onTap: () {
                    setState(() {
                      monthSelected = month3;
                      yearSelected = year1;
                    });
                  }),
              MonthYearListTile(
                  month: month4,
                  year: year1,
                  onTap: () {
                    setState(() {
                      monthSelected = month4;
                      yearSelected = year1;
                    });
                  }),
              MonthYearListTile(
                  month: month5,
                  year: year1,
                  onTap: () {
                    setState(() {
                      monthSelected = month5;
                      yearSelected = year1;
                    });
                  }),
              MonthYearListTile(
                  month: month6,
                  year: year1,
                  onTap: () {
                    setState(() {
                      monthSelected = month6;
                      yearSelected = year1;
                    });
                  }),
            ],
          ),
        ),
        Container(
          width: 30,
          child: IconButton(
            iconSize: 16,
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                if (month1 == 1) {
                  month1 = 7;
                  month2 = 8;
                  month3 = 9;
                  month4 = 10;
                  month5 = 11;
                  month6 = 12;
                } else {
                  month1 = 1;
                  month2 = 2;
                  month3 = 3;
                  month4 = 4;
                  month5 = 5;
                  month6 = 6;
                  year1 += 1;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget notFound(context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset(
              'assets/images/empty_folder.png',
              height: MediaQuery.of(context).size.height / 3,
            ),
          ),
          Text(
            'No transactions found!',
            style: appBarTitleText,
          ),
        ],
      ),
    );
  }

  Widget displayDayTransactions(DateTime date) {
    return StreamBuilder(
        stream: docRef
            .collection('Transactions')
            .where('Day', isEqualTo: date.day)
            .where('Month', isEqualTo: date.month)
            .where('Year', isEqualTo: date.year)
            //.orderBy('Time')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.docs?.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data.docs[index]['Details'],
                    value: snapshot.data.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data.docs[index]['Amount'].toString(),
                    //time: snapshot.data.docs[index]['Time'],
                    type: snapshot.data.docs[index]['Type'],
                    tId: snapshot.data.docs[index].id,
                  );
                });
          }
        });
  }

  Widget displayDayTransactionsByType(DateTime date, String transactionType) {
    return StreamBuilder(
        stream: docRef
            .collection('Transactions')
            .where('Day', isEqualTo: date.day)
            .where('Month', isEqualTo: date.month)
            .where('Year', isEqualTo: date.year)
            .where('Type', isEqualTo: transactionType)
            //.orderBy('Time')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.docs?.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data.docs[index]['Details'],
                    value: snapshot.data.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data.docs[index]['Amount'].toString(),
                    //time: snapshot.data.docs[index]['Time'],
                    type: snapshot.data.docs[index]['Type'],
                    tId: snapshot.data.docs[index].id,
                  );
                });
          }
        });
  }

  Widget displayMonthTransactions(int month, int year) {
    return StreamBuilder(
        stream: docRef
            .collection('Transactions')
            .where('Month', isEqualTo: month)
            .where('Year', isEqualTo: year)
            .orderBy('Day')
            //.orderBy('Time')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.docs?.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data.docs[index]['Details'],
                    value: snapshot.data.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data.docs[index]['Amount'].toString(),
                    time:
                        // snapshot.data.docs[index]['Time'] +
                        //     ' ' +
                        months[snapshot.data.docs[index]['Month'] - 1]
                                .toString() +
                            ' ' +
                            snapshot.data.docs[index]['Day'].toString(),
                    type: snapshot.data.docs[index]['Type'],
                    tId: snapshot.data.docs[index].id,
                  );
                });
          }
        });
  }

  Widget displayMonthTransactionsByType(
      int month, int year, String transactionType) {
    return StreamBuilder(
        stream: docRef
            .collection('Transactions')
            .where('Month', isEqualTo: month)
            .where('Year', isEqualTo: year)
            .where('Type', isEqualTo: transactionType)
            .orderBy('Day')
            //.orderBy('Time')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.docs?.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data.docs[index]['Details'],
                    value: snapshot.data.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data.docs[index]['Amount'].toString(),
                    time:
                        //snapshot.data.docs[index]['Time'] +
                        //     ' ' +
                        months[snapshot.data.docs[index]['Month'] - 1]
                                .toString() +
                            ' ' +
                            snapshot.data.docs[index]['Day'].toString(),
                    type: snapshot.data.docs[index]['Type'],
                    tId: snapshot.data.docs[index].id,
                  );
                });
          }
        });
  }
}

class DateMonthListTile extends StatelessWidget {
  DateMonthListTile({this.day, this.date, this.onTap});

  final String day;
  final DateTime date;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Text(
            day,
            style: weekdayText,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: TextButton(
              style: (dateSelected == date)
                  ? TextButton.styleFrom(backgroundColor: Colors.lightBlue[50])
                  : null,
              onPressed: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: dayText,
                  ),
                  Text(
                    Months.values[date.month - 1].toString().substring(7, 10),
                    style: dayText.copyWith(fontSize: 8),
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

class MonthYearListTile extends StatelessWidget {
  MonthYearListTile({this.month, this.year, this.onTap});

  final int month;
  final int year;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
            child: TextButton(
              style: (monthSelected == month && yearSelected == year)
                  ? TextButton.styleFrom(backgroundColor: Colors.lightBlue[50])
                  : null,
              onPressed: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    Months.values[month - 1].toString().substring(7, 10),
                    style: dayText,
                  ),
                  SizedBox(
                    height: 10,
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
