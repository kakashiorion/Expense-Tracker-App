import 'package:expense_tracker_app/transactionSummaryPage.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';

class AddTransaction extends StatefulWidget {
  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction>
    with SingleTickerProviderStateMixin {
  DocumentReference docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.email);
  TransactionType transactionTypeSelected = TransactionType.Food;

  int progressValue = 1;
  String transactionDetails = '';
  double? amountDetails = 0.0;
  DateTime dateDetails = DateTime.now();
  String currencySelected = 'INR';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Transaction',
          style: appBarTitleText,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        bottomOpacity: 1.0,
        bottom: MyLinearProgressIndicator(
          minHeight: 1.2,
          value: progressValue / 5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
          backgroundColor: Colors.grey,
        ),
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
      body: WillPopScope(
        onWillPop: () async {
          if (progressValue <= 1) {
            return true;
          } else {
            setState(() {
              progressValue -= 1;
            });
            return false;
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              progressValue >= 1
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(children: [
                          progressValue == 1
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(children: [
                                      Container(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            'assets/images/money_saving.png',
                                            height: size.height / 2.5,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 40,
                                                  right: 40),
                                              child: Text(
                                                'What kind of transaction is it?',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontFamily: 'Lato',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30,
                                                  right: 30,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TransactionTypeTile(
                                                      onTap: () {
                                                        setState(() {
                                                          transactionTypeSelected =
                                                              TransactionType
                                                                  .Food;
                                                          progressValue += 1;
                                                        });
                                                      },
                                                      type:
                                                          TransactionType.Food,
                                                      circleAvatar:
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TransactionTypeTile(
                                                      onTap: () {
                                                        setState(() {
                                                          transactionTypeSelected =
                                                              TransactionType
                                                                  .Travel;
                                                          progressValue += 1;
                                                        });
                                                      },
                                                      type: TransactionType
                                                          .Travel,
                                                      circleAvatar:
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30,
                                                  right: 30,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TransactionTypeTile(
                                                      onTap: () {
                                                        setState(() {
                                                          transactionTypeSelected =
                                                              TransactionType
                                                                  .Shopping;
                                                          progressValue += 1;
                                                        });
                                                      },
                                                      type: TransactionType
                                                          .Shopping,
                                                      circleAvatar:
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TransactionTypeTile(
                                                      onTap: () {
                                                        setState(() {
                                                          transactionTypeSelected =
                                                              TransactionType
                                                                  .Utility;
                                                          progressValue += 1;
                                                        });
                                                      },
                                                      type: TransactionType
                                                          .Utility,
                                                      circleAvatar:
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40,
                                                  right: 40,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Container(
                                                height: 2,
                                                color: Colors.black12,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30,
                                                  right: 30,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TransactionTypeTile(
                                                      onTap: () {
                                                        setState(() {
                                                          transactionTypeSelected =
                                                              TransactionType
                                                                  .Income;
                                                          progressValue += 1;
                                                        });
                                                      },
                                                      type: TransactionType
                                                          .Income,
                                                      circleAvatar:
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                                  ],
                                )
                              : SizedBox(),
                          progressValue >= 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 40, right: 40),
                                  child: TransactionDetailTile(
                                    title: 'Transaction type',
                                    icon: getImage(transactionTypeSelected),
                                    details: transactionTypeSelected
                                        .toString()
                                        .substring(16),
                                    type: transactionTypeSelected
                                        .toString()
                                        .substring(16),
                                  ),
                                )
                              : SizedBox(),
                          progressValue >= 3
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 40, right: 40),
                                  child: TransactionDetailTile(
                                    title: 'Transaction details',
                                    icon: Icon(
                                        Icons.wifi_protected_setup_outlined),
                                    details: transactionDetails,
                                    type: transactionTypeSelected
                                        .toString()
                                        .substring(16),
                                  ),
                                )
                              : SizedBox(),
                          progressValue >= 4
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 40, right: 40),
                                  child: TransactionDetailTile(
                                    title: 'Amount',
                                    icon: Icon(
                                        Icons.account_balance_wallet_outlined),
                                    details: currencySelected +
                                        ' ' +
                                        amountDetails.toString(),
                                    type: transactionTypeSelected
                                        .toString()
                                        .substring(16),
                                  ),
                                )
                              : SizedBox(),
                        ]),
                      ),
                    )
                  : SizedBox(),
              progressValue == 2
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 30, right: 30),
                        child: TransactionInputTile(
                          title: 'What is the transaction about?',
                          inputWidget: TextField(
                              autofocus: true,
                              onChanged: (detailsText) {
                                setState(() {
                                  transactionDetails = detailsText;
                                });
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  hintText: 'Groceries',
                                  hintStyle: titleText.copyWith(fontSize: 14),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder()),
                              style: displayTextStyle),
                          actionWidget: FloatingActionButton(
                            elevation: 2,
                            onPressed: () {
                              if (transactionDetails != '') {
                                setState(() {
                                  progressValue = 3;
                                });
                              }
                            },
                            child: Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.lightBlue,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              progressValue == 3
                  ? Container(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 30, right: 30),
                          //Show Transaction details
                          child: TransactionInputTile(
                            title: 'Enter amount',
                            inputWidget: Row(
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                      onChanged: (detailsText) {
                                        if (detailsText == '') {
                                          setState(() {
                                            amountDetails = 0.0;
                                          });
                                        } else {
                                          setState(() {
                                            amountDetails =
                                                double.tryParse(detailsText);
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
                            actionWidget: FloatingActionButton(
                              elevation: 2,
                              onPressed: () {
                                if (amountDetails != 0.0) {
                                  setState(() {
                                    progressValue = 4;
                                    amountDetails = double.parse(
                                        amountDetails!.toStringAsFixed(2));
                                  });
                                }
                              },
                              child: Icon(
                                Icons.skip_next_rounded,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.lightBlue,
                            ),
                          )),
                    )
                  : SizedBox(),
              progressValue == 4
                  ? Container(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 30, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TransactionInputTile(
                                  title: 'Pick date of transaction',
                                  inputWidget: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 55,
                                          child: FloatingActionButton(
                                            onPressed: () async {
                                              pickDate(context);
                                            },
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.date_range_sharp,
                                              color: Colors.lightBlue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(formatDate(dateDetails),
                                            style: displayTextStyle),
                                      ],
                                    ),
                                  ),
                                  actionWidget: SizedBox()),
                              Padding(
                                padding: EdgeInsets.only(top: 50.0),
                                child: SizedBox(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(
                                            color: Colors.pink,
                                            fontFamily: 'Lato',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        backgroundColor: Colors.lightBlue,
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    onPressed: () async {
                                      DocumentReference txnId;
                                      //Add Transaction details to Firestore
                                      txnId = await docRef
                                          .collection('Transactions')
                                          .add({
                                        'Type': transactionTypeSelected
                                            .toString()
                                            .substring(16),
                                        'Details': transactionDetails,
                                        'Amount': amountDetails,
                                        'Day': dateDetails.day,
                                        'Month': dateDetails.month,
                                        'Year': dateDetails.year,
                                        'Currency': currencySelected
                                      });

                                      //Move to transaction summary page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AnimatedSplashScreen(
                                            duration: 1000,
                                            backgroundColor: Colors.lightBlue,
                                            splash: Image(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  'assets/images/successTxn.gif'),
                                            ),
                                            nextScreen: TransactionSummaryPage(
                                                transactionId: txnId.id),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Finish',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future pickDate(context) async {
    DateTime initialDate = DateTime.now();
    final dateOfTransaction = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2010),
        lastDate: DateTime.now());
    if (dateOfTransaction == null) return '';
    setState(() {
      dateDetails = dateOfTransaction;
    });
  }

  String formatDate(DateTime dateTime) {
    return dateTime.day.toString() +
        '-' +
        dateTime.month.toString() +
        '-' +
        dateTime.year.toString();
  }
}
