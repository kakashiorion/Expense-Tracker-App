import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'homePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  User? user;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  String email = '';
  String password = '';
  checkUserLoggedIn() async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user == false)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            leading: null,
            title: Text(
              'Expense Tracker App Login',
              style: appBarTitleText,
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            bottomOpacity: 1.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpPage();
                    }));
                  },
                  child: Text('Sign up'),
                  style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.lightBlue),
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
                  Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Image.asset('assets/images/waiter.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      bottom: 20,
                    ),
                    child: Text(
                      'Login to your account',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    child: TextField(
                      autofocus: false,
                      onChanged: (newUserName) {
                        setState(() {
                          email = newUserName;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'abcd@gmail.com',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                            color: Colors.black26),
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
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            autofocus: false,
                            onChanged: (newPassword) {
                              setState(() {
                                password = newPassword;
                              });
                            },
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () =>
                                FocusScope.of(context).nextFocus(),
                            obscureText: true,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: '********',
                              hintStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black26),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: password.length != 0
                                  ? Colors.lightBlue
                                  : Colors.grey),
                          child: IconButton(
                              color: Colors.white,
                              icon: Icon(
                                Icons.chevron_right,
                                size: 25,
                              ),
                              onPressed: () async {
                                try {
                                  bool docRefExists = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(email)
                                      .get()
                                      .then((value) {
                                    return value.exists;
                                  });
                                  if (!docRefExists) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'No user with this email!'),
                                          );
                                        });
                                  } else {
                                    _auth.signInWithEmailAndPassword(
                                        email: email, password: password);
                                    await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return HomePage();
                                    }));
                                  }
                                } on FirebaseAuthException catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.message ?? ""),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 30,
                      right: 30,
                      bottom: 10,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 8,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'or',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold),
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              if (kIsWeb) {
                                GoogleAuthProvider authProvider =
                                    GoogleAuthProvider();

                                try {
                                  await _auth.signInWithPopup(authProvider);
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return HomePage();
                                  }));
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                GoogleSignInAccount? googleSignInAccount =
                                    await _googleSignIn.signIn();

                                final GoogleSignInAuthentication?
                                    googleSignInAuthentication =
                                    await googleSignInAccount!.authentication;

                                final AuthCredential credential =
                                    GoogleAuthProvider.credential(
                                  accessToken:
                                      googleSignInAuthentication!.accessToken,
                                  idToken: googleSignInAuthentication.idToken,
                                );

                                try {
                                  final UserCredential userCredential =
                                      await _auth
                                          .signInWithCredential(credential);

                                  user = userCredential.user;
                                  DocumentReference docRef = FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(user!.email);
                                  docRef.get().then((docSnapshot) => {
                                        if (!docSnapshot.exists)
                                          //If first time signin in, create document
                                          {
                                            docRef.set({
                                              'Email': user!.email,
                                              'Photo Location': user!.photoURL,
                                              'Name': user!.displayName,
                                              'Date Of Birth': "N/A"
                                            })
                                          }
                                      });
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return HomePage();
                                  }));
                                } catch (e) {
                                  print(e);
                                }
                              }
                              return;
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.lightBlue)),
                            ),
                            child: Container(
                              width: max(
                                  200, MediaQuery.of(context).size.width / 3),
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.login,
                                  ),
                                  Text(
                                    'Login with Google',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 20),
                  //   child: Center(
                  //     child: RichText(
                  //       text: TextSpan(
                  //         text: 'Forgot Password?',
                  //         style: dayText,
                  //         recognizer: TapGestureRecognizer()
                  //           ..onTap = () {
                  //             //TODO: Add forgot password flow.
                  //           },
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
