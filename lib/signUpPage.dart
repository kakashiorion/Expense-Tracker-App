import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

String email = '';
String password = '';
String name = '';
String dob = '';

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('users');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Expense Tracker App Sign Up',
            style: appBarTitleText,
          ),
          leadingWidth: 0,
          backgroundColor: Colors.white,
          elevation: 1,
          bottomOpacity: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Login'),
                style: TextButton.styleFrom(
                    textStyle: TextStyle(
                  color: Colors.lightBlue,
                  fontFamily: 'Lato',
                  fontSize: 12,
                )),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 30,
                    right: 30,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign up to Expense Tracker',
                        style: TextStyle(fontSize: 25, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Start tracking your daily financial transactions in one place and manage budget for different categories of expenses',
                        style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(height: 180, child: Image.asset('assets/images/investment.png')),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: TextField(
                    onChanged: (newName) {
                      setState(() {
                        name = newName;
                      });
                    },
                    autofocus: false,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'John Doe',
                      hintStyle: TextStyle(fontSize: 15, fontFamily: 'Lato', fontWeight: FontWeight.normal, color: Colors.black26),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: TextField(
                    onChanged: (newUserName) {
                      setState(() {
                        email = newUserName;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'abcd@gmail.com',
                      hintStyle: TextStyle(fontSize: 15, fontFamily: 'Lato', fontWeight: FontWeight.normal, color: Colors.black26),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    'Password',
                    style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (newPassword) {
                            setState(() {
                              password = newPassword;
                            });
                          },
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          obscureText: true,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            hintText: '********',
                            hintStyle: TextStyle(fontSize: 15, fontFamily: 'Lato', fontWeight: FontWeight.normal, color: Colors.black26),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10), color: password.length != 0 ? Colors.lightBlue : Colors.grey),
                        child: IconButton(
                            enableFeedback: false,
                            color: Colors.white,
                            icon: Icon(
                              Icons.chevron_right,
                              size: 25,
                            ),
                            onPressed: () async {
                              try {
                                final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                                if (newUser != null) {
                                  users.doc(email).set({'Name': name, 'Email': email, 'Password': password, 'Date Of Birth': dob});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Created account for: ' + newUser.user.email),
                                      action: SnackBarAction(
                                        label: 'Login Page',
                                        onPressed: () {
                                          Navigator.pop(context, newUser.user.email);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message),
                                  ),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: Text(
                    'Date Of Birth (Optional)',
                    style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 35,
                        child: FloatingActionButton(
                          onPressed: () async {
                            pickDate(context);
                          },
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.date_range_sharp,
                            color: Colors.lightBlue,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(dob, style: titleTextStyle),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     top: 10,
                //     left: 30,
                //     right: 30,
                //     bottom: 10,
                //   ),
                //   child: Container(
                //     height: 70,
                //     alignment: Alignment.center,
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Text(
                //           'or',
                //           style: TextStyle(
                //               fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                //         ),
                //         OutlinedButton(
                //           onPressed: () {},
                //           style: ButtonStyle(
                //               side: MaterialStateProperty.all(BorderSide(color: Colors.lightBlue))),
                //           child: Container(
                //             width: 200,
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               children: [
                //                 Icon(
                //                   Icons.group_add,
                //                 ),
                //                 Text(
                //                   'Sign up with Google',
                //                 ),
                //               ],
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickDate(context) async {
    DateTime initialDate = DateTime.now();
    final dateOfBirth = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.input, context: context, initialDate: initialDate, firstDate: DateTime(1960), lastDate: DateTime.now());
    if (dateOfBirth == null) return '';
    setState(() {
      dob = dateOfBirth.day.toString() + '-' + dateOfBirth.month.toString() + '-' + dateOfBirth.year.toString();
    });
  }
}