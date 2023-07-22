import 'package:expense_tracker_app/profilePage.dart';
import 'package:expense_tracker_app/statisticsPage.dart';
import 'package:expense_tracker_app/transactionsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'addTransaction.dart';
import 'budgetPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: SizedBox(
            height: 48,
            child: FloatingActionButton(
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
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: Colors.white,
          extendBody: true,
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
            notchMargin: 2,
            height: 64,
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
