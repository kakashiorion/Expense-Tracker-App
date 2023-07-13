import 'package:expense_tracker_app/profilePage.dart';
import 'package:expense_tracker_app/statisticsPage.dart';
import 'package:expense_tracker_app/transactionsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'addTransaction.dart';
import 'budgetPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  var activeIndex = 0;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: activeIndex == 0
              ? SizedBox(
                  height: 45,
                  child: FloatingActionButton(
                    //shape: CircleBorder(side: BorderSide(width: 0, color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AddTransaction();
                        }),
                      );
                    },
                    backgroundColor: Colors.lightBlue,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: Colors.white,
          extendBody: true,
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(40),
          //   child: AppBar(
          //     centerTitle: false,
          //     title: Text(
          //       getAppBarTitle(activeIndex),
          //       style: appBarTitleText,
          //     ),
          //     backgroundColor: Colors.white,
          //     elevation: 2,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only(
          //           bottomLeft: Radius.circular(8),
          //           bottomRight: Radius.circular(8)),
          //     ),
          //   ),
          // ),
          body: SwipeDetector(
            onSwipeRight: (Offset offset) => setState(() {
              activeIndex -= 1;
              if (activeIndex == -1) activeIndex = 3;
            }),
            onSwipeLeft: (Offset offset) {
              setState(() {
                activeIndex += 1;
                if (activeIndex == 4) activeIndex = 0;
              });
            },
            child: activeIndex == 0
                ? TransactionsPage()
                : activeIndex == 1
                    ? BudgetPage()
                    : activeIndex == 2
                        ? StatisticsPage()
                        : ProfilePage(),
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 0,
            color: Colors.black,
            shape: CircularNotchedRectangle(),
            child: BottomNavigationBar(
              onTap: (selectedBottomIndex) {
                setState(() {
                  activeIndex = selectedBottomIndex;
                });
              },
              currentIndex: activeIndex,
              selectedIconTheme: IconThemeData(opacity: 1.0),
              unselectedIconTheme:
                  IconThemeData(opacity: 1.0, color: Colors.white70),
              selectedItemColor: Colors.lightBlue,
              unselectedItemColor: Colors.white70,
              selectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
                fontFamily: 'Lato',
              ),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money_outlined),
                  label: 'Transactions',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_wallet_outlined),
                    label: 'Budget'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.stacked_bar_chart), label: 'Statistics'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getAppBarTitle(int activeIndex) {
    switch (activeIndex) {
      case 0:
        return 'Transactions';
      case 1:
        return 'Your Budgets';
      case 2:
        return 'Statistics';
      case 3:
        return 'Profile';
      default:
        return 'Transactions';
    }
  }
}
