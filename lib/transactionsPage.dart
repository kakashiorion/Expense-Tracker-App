import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class TransactionsPage extends StatefulWidget {
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  var dailySelected = true;
  var dropDownValue = 'All Transactions';
  DateTime dateToday = DateTime.now();
  DateTime dateSelected = DateTime.now();
  int monthSelected = DateTime.now().month;
  int yearSelected = DateTime.now().year;

  DateTime? date1, date2, date3, date4, date5, date6, date7;
  int? month1, month2, month3, month4, month5, month6;
  int? year1;

  DocumentReference docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.email);

  @override
  void initState() {
    super.initState();
    initializeDates();
  }

  void initializeDates() {
    dateSelected = dateToday;
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 48,
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
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: dailySelected
                              ? TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0)))
                              : null,
                          onPressed: () => {
                            setState(() {
                              dailySelected = true;
                            })
                          },
                          child: Text(
                            'Daily',
                            style: TextStyle(
                                color:
                                    dailySelected ? Colors.black : Colors.white,
                                fontSize: 12,
                                fontFamily: 'Lato'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: dailySelected
                              ? null
                              : TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0))),
                          onPressed: () => {
                            setState(() {
                              dailySelected = false;
                            })
                          },
                          child: Text(
                            'Monthly',
                            style: TextStyle(
                                color:
                                    dailySelected ? Colors.white : Colors.black,
                                fontSize: 12,
                                fontFamily: 'Lato'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              dailySelected ? getDates() : getMonths(),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                    child: Container(
                      height: 30,
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
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 2),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down),
                            iconEnabledColor: Colors.lightBlue,
                            style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 11,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold),
                            dropdownColor: Colors.white,
                            value: dropDownValue,
                            onChanged: (String? newValue) => {
                              setState(() {
                                dropDownValue = newValue!;
                              })
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
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: dropDownValue == 'All Transactions'
                              ? dailySelected
                                  ? displayDayTransactions(dateSelected)
                                  : displayMonthTransactions(
                                      monthSelected, yearSelected)
                              : dailySelected
                                  ? displayDayTransactionsByType(
                                      dateSelected, dropDownValue)
                                  : displayMonthTransactionsByType(
                                      monthSelected,
                                      yearSelected,
                                      dropDownValue)),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getDates() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: IconButton(
              iconSize: 16,
              icon: Icon(Icons.arrow_left),
              onPressed: () => {
                setState(() {
                  date1 = date1!.subtract(Duration(days: 7));
                  date2 = date2!.subtract(Duration(days: 7));
                  date3 = date3!.subtract(Duration(days: 7));
                  date4 = date4!.subtract(Duration(days: 7));
                  date5 = date5!.subtract(Duration(days: 7));
                  date6 = date6!.subtract(Duration(days: 7));
                  date7 = date7!.subtract(Duration(days: 7));
                })
              },
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DateMonthListTile(
                  day: days[0],
                  date: date1!,
                  dateSelected: dateSelected,
                  onTap: () => {
                        setState(() {
                          dateSelected = date1!;
                        })
                      }),
              DateMonthListTile(
                  day: days[1],
                  date: date2!,
                  dateSelected: dateSelected,
                  onTap: () => {
                        setState(() {
                          dateSelected = date2!;
                        })
                      }),
              DateMonthListTile(
                  day: days[2],
                  date: date3!,
                  dateSelected: dateSelected,
                  onTap: () => {
                        setState(() {
                          dateSelected = date3!;
                        })
                      }),
              DateMonthListTile(
                  day: days[3],
                  date: date4!,
                  dateSelected: dateSelected,
                  onTap: () => {
                        setState(() {
                          dateSelected = date4!;
                        })
                      }),
              DateMonthListTile(
                  day: days[4],
                  dateSelected: dateSelected,
                  date: date5!,
                  onTap: () => {
                        setState(() {
                          dateSelected = date5!;
                        })
                      }),
              DateMonthListTile(
                  day: days[5],
                  dateSelected: dateSelected,
                  date: date6!,
                  onTap: () => {
                        setState(() {
                          dateSelected = date6!;
                        })
                      }),
              DateMonthListTile(
                  day: days[6],
                  dateSelected: dateSelected,
                  date: date7!,
                  onTap: () => {
                        setState(() {
                          dateSelected = date7!;
                        })
                      }),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: IconButton(
              iconSize: 16,
              icon: Icon(Icons.arrow_right),
              onPressed: () => {
                setState(() {
                  date1 = date1!.add(Duration(days: 7));
                  date2 = date2!.add(Duration(days: 7));
                  date3 = date3!.add(Duration(days: 7));
                  date4 = date4!.add(Duration(days: 7));
                  date5 = date5!.add(Duration(days: 7));
                  date6 = date6!.add(Duration(days: 7));
                  date7 = date7!.add(Duration(days: 7));
                })
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget getMonths() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: IconButton(
              iconSize: 16,
              icon: Icon(Icons.arrow_left),
              onPressed: () => {
                setState(() {
                  if (month1 == 1) {
                    month1 = 7;
                    month2 = 8;
                    month3 = 9;
                    month4 = 10;
                    month5 = 11;
                    month6 = 12;
                    year1 = year1! - 1;
                  } else {
                    month1 = 1;
                    month2 = 2;
                    month3 = 3;
                    month4 = 4;
                    month5 = 5;
                    month6 = 6;
                  }
                })
              },
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MonthYearListTile(
                  month: month1!,
                  monthSelected: monthSelected,
                  yearSelected: yearSelected,
                  year: year1!,
                  onTap: () => {
                        setState(() {
                          monthSelected = month1!;
                          yearSelected = year1!;
                        })
                      }),
              MonthYearListTile(
                  month: month2!,
                  year: year1!,
                  monthSelected: monthSelected,
                  yearSelected: yearSelected,
                  onTap: () => {
                        setState(() {
                          monthSelected = month2!;
                          yearSelected = year1!;
                        })
                      }),
              MonthYearListTile(
                  month: month3!,
                  year: year1!,
                  monthSelected: monthSelected,
                  yearSelected: yearSelected,
                  onTap: () => {
                        setState(() {
                          monthSelected = month3!;
                          yearSelected = year1!;
                        })
                      }),
              MonthYearListTile(
                  month: month4!,
                  year: year1!,
                  monthSelected: monthSelected,
                  yearSelected: yearSelected,
                  onTap: () => {
                        setState(() {
                          monthSelected = month4!;
                          yearSelected = year1!;
                        })
                      }),
              MonthYearListTile(
                  month: month5!,
                  year: year1!,
                  monthSelected: monthSelected,
                  yearSelected: yearSelected,
                  onTap: () => {
                        setState(() {
                          monthSelected = month5!;
                          yearSelected = year1!;
                        })
                      }),
              MonthYearListTile(
                  month: month6!,
                  year: year1!,
                  monthSelected: monthSelected,
                  yearSelected: yearSelected,
                  onTap: () => {
                        setState(() {
                          monthSelected = month6!;
                          yearSelected = year1!;
                        })
                      }),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: IconButton(
              iconSize: 16,
              icon: Icon(Icons.arrow_right),
              onPressed: () => {
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
                    year1 = year1! + 1;
                  }
                })
              },
            ),
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
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data!.docs[index]['Details'],
                    value: snapshot.data!.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data!.docs[index]['Amount'].toString(),
                    type: snapshot.data!.docs[index]['Type'],
                    tId: snapshot.data!.docs[index].id,
                    time: months[snapshot.data!.docs[index]['Month'] - 1]
                            .toString() +
                        ' ' +
                        snapshot.data!.docs[index]['Day'].toString(),
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
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data!.docs[index]['Details'],
                    value: snapshot.data!.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data!.docs[index]['Amount'].toString(),
                    time: months[snapshot.data!.docs[index]['Month'] - 1]
                            .toString() +
                        ' ' +
                        snapshot.data!.docs[index]['Day'].toString(),
                    type: snapshot.data!.docs[index]['Type'],
                    tId: snapshot.data!.docs[index].id,
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
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data!.docs[index]['Details'],
                    value: snapshot.data!.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data!.docs[index]['Amount'].toString(),
                    time: months[snapshot.data!.docs[index]['Month'] - 1]
                            .toString() +
                        ' ' +
                        snapshot.data!.docs[index]['Day'].toString(),
                    type: snapshot.data!.docs[index]['Type'],
                    tId: snapshot.data!.docs[index].id,
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
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.length == 0) {
            return notFound(context);
          } else {
            return ListView.separated(
                padding: EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return TransactionCard(
                    title: snapshot.data!.docs[index]['Details'],
                    value: snapshot.data!.docs[index]['Currency'] +
                        ' ' +
                        snapshot.data!.docs[index]['Amount'].toString(),
                    time: months[snapshot.data!.docs[index]['Month'] - 1]
                            .toString() +
                        ' ' +
                        snapshot.data!.docs[index]['Day'].toString(),
                    type: snapshot.data!.docs[index]['Type'],
                    tId: snapshot.data!.docs[index].id,
                  );
                });
          }
        });
  }
}

class DateMonthListTile extends StatelessWidget {
  DateMonthListTile(
      {required this.day,
      required this.date,
      required this.onTap,
      required this.dateSelected});

  final String day;
  final DateTime date;
  final DateTime dateSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Text(
              day,
              style: weekdayText,
            ),
            SizedBox(height: 4),
            TextButton(
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
          ],
        ),
      ),
    );
  }
}

class MonthYearListTile extends StatelessWidget {
  MonthYearListTile(
      {required this.month,
      required this.year,
      required this.onTap,
      required this.monthSelected,
      required this.yearSelected});

  final int month;
  final int year;
  final int monthSelected;
  final int yearSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: TextButton(
          style: (monthSelected == month && yearSelected == year)
              ? TextButton.styleFrom(backgroundColor: Colors.lightBlue[50])
              : null,
          onPressed: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  Months.values[month - 1].toString().substring(7, 10),
                  style: dayText,
                ),
              ),
              SizedBox(
                height: 8,
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
