import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:expense_tracker_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionSummaryPage extends StatefulWidget {
  final String transactionId;

  const TransactionSummaryPage({super.key, required this.transactionId});

  @override
  State<TransactionSummaryPage> createState() => _TransactionSummaryPageState();
}

class _TransactionSummaryPageState extends State<TransactionSummaryPage> {
  _TransactionSummaryPageState();

  @override
  void initState() {
    super.initState();
    setTransactionValues();
  }

  bool deleted = false;
  bool editing = false;
  String type = '';
  String details = '';
  double? amount = 0.0;
  String currency = 'INR';
  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  void setTransactionValues() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('Transactions')
        .doc(widget.transactionId)
        .get()
        .then((value) {
      type = value['Type'];
      details = value['Details'];
      amount = value['Amount'];
      currency = value['Currency'];
      day = value['Day'];
      month = value['Month'];
      year = value['Year'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Transaction Summary ',
          style: appBarTitleText,
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: editing
                            ? const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20)
                            : const EdgeInsets.only(
                                top: 30, bottom: 20, left: 40, right: 40),
                        child: editing
                            ? TransactionInputTile(
                                title: 'Edit type of transaction',
                                actionWidget: SizedBox(),
                                inputWidget: DropdownButton<String>(
                                  value: type,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined),
                                  iconSize: 16,
                                  elevation: 2,
                                  style: inputTextStyle,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      type = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Food',
                                    'Travel',
                                    'Utility',
                                    'Shopping',
                                    'Income'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              )
                            : TransactionDetailTile(
                                title: 'Type',
                                icon: getIcon(type),
                                details: type,
                                type: type,
                              ),
                      ),
                      Padding(
                        padding: editing
                            ? const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20)
                            : const EdgeInsets.only(
                                top: 20, bottom: 20, left: 40, right: 40),
                        child: editing
                            ? TransactionInputTile(
                                title: 'Change transaction details',
                                actionWidget: SizedBox(),
                                inputWidget: TextField(
                                    onChanged: (detailsText) {
                                      setState(() {
                                        details = detailsText;
                                      });
                                    },
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                        hintText: 'Groceries',
                                        hintStyle:
                                            titleText.copyWith(fontSize: 14),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder()),
                                    style: displayTextStyle),
                              )
                            : TransactionDetailTile(
                                title: 'Details',
                                icon: Icon(Icons.wifi_protected_setup_outlined),
                                details: details,
                                type: type,
                              ),
                      ),
                      Padding(
                        padding: editing
                            ? const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20)
                            : const EdgeInsets.only(
                                top: 20, bottom: 20, left: 40, right: 40),
                        child: editing
                            ? TransactionInputTile(
                                title: 'Change amount',
                                actionWidget: SizedBox(),
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
                                              onSelect:
                                                  (Currency currencySelection) {
                                                setState(() {
                                                  currency =
                                                      currencySelection.code;
                                                });
                                              });
                                        },
                                        label: Text(
                                          currency,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
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
                                                amount = 0.0;
                                              });
                                            } else {
                                              setState(() {
                                                amount = double.tryParse(
                                                    detailsText);
                                              });
                                            }
                                          },
                                          cursorColor: Colors.black,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              border: OutlineInputBorder()),
                                          style: displayTextStyle),
                                    ),
                                  ],
                                ),
                              )
                            : TransactionDetailTile(
                                title: 'Amount',
                                icon:
                                    Icon(Icons.account_balance_wallet_outlined),
                                details:
                                    currency + ' ' + amount!.toStringAsFixed(2),
                                type: type,
                              ),
                      ),
                      Padding(
                        padding: editing
                            ? const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20)
                            : const EdgeInsets.only(
                                top: 20, bottom: 30, left: 40, right: 40),
                        child: editing
                            ? TransactionInputTile(
                                title: 'Change date of transaction',
                                actionWidget: SizedBox(),
                                inputWidget: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 45,
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
                                      Text(
                                          day.toString() +
                                              ' ' +
                                              months[month - 1] +
                                              ' ' +
                                              year.toString(),
                                          style: displayTextStyle),
                                    ],
                                  ),
                                ),
                              )
                            : TransactionDetailTile(
                                title: 'DateTime',
                                icon: Icon(Icons.calendar_today_sharp),
                                details: day.toString() +
                                    ' ' +
                                    months[month - 1] +
                                    ' ' +
                                    year.toString() +
                                    ' ',
                                type: type,
                              ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: editing
                      ? SizedBox()
                      : SizedBox(
                          width: size.width / 1.5,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('DONE',
                                style: inputTextStyle.copyWith(
                                    color: Colors.white)),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 48),
                              backgroundColor: Colors.lightBlue,
                              elevation: 2,
                              shadowColor: Colors.white,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width / 4,
                        child: TextButton(
                          onPressed: () async {
                            if (editing) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.email)
                                  .collection('Transactions')
                                  .doc(widget.transactionId)
                                  .update({
                                'Type': type,
                                'Details': details,
                                'Day': day,
                                'Month': month,
                                'Year': year,
                                'Currency': currency,
                                'Amount': amount,
                              });
                              setState(() {
                                editing = false;
                              });
                            } else {
                              setState(() {
                                editing = true;
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(
                                color:
                                    editing ? Colors.green : Colors.lightBlue),
                            elevation: 2,
                            shadowColor: Colors.white,
                          ),
                          child: Text(
                            editing ? 'Save' : 'Edit',
                            style: dayText.copyWith(
                                color:
                                    editing ? Colors.green : Colors.lightBlue),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: editing ? 0 : 16,
                      ),
                      SizedBox(
                        width: editing ? 0 : size.width / 4,
                        child: editing
                            ? null
                            : TextButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              Text('Delete this transaction?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('YES',
                                                  style: dayText.copyWith(
                                                      color: Colors.redAccent)),
                                              onPressed: () {
                                                deleted = true;
                                                Navigator.of(context).pop();
                                                //Delete transaction and move to home page
                                              },
                                            ),
                                            TextButton(
                                              child: Text('NO', style: dayText),
                                              onPressed: () {
                                                deleted = false;
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                  if (deleted) {
                                    Navigator.of(context).pop();
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.email)
                                        .collection('Transactions')
                                        .doc(widget.transactionId)
                                        .delete();
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.redAccent),
                                  elevation: 2,
                                  shadowColor: Colors.white,
                                ),
                                child: Text(
                                  'Delete',
                                  style:
                                      dayText.copyWith(color: Colors.redAccent),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
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
      day = dateOfTransaction.day;
      month = dateOfTransaction.month;
      year = dateOfTransaction.year;
    });
  }

  Icon getIcon(String type) {
    var iconColor = Colors.white;
    if (type == TransactionType.Food.toString().substring(16)) {
      return Icon(
        Icons.fastfood_outlined,
        color: iconColor,
      );
    } else if (type == TransactionType.Shopping.toString().substring(16)) {
      return Icon(
        Icons.shopping_basket_outlined,
        color: iconColor,
      );
    } else if (type == TransactionType.Travel.toString().substring(16)) {
      return Icon(
        Icons.flight_outlined,
        color: iconColor,
      );
    } else if (type == TransactionType.Utility.toString().substring(16)) {
      return Icon(
        Icons.wb_incandescent_outlined,
        color: iconColor,
      );
    } else {
      return Icon(
        Icons.attach_money_outlined,
        color: iconColor,
      );
    }
  }
}
