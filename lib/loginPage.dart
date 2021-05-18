import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'homePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

String email = '';
String password = '';
String logoutResult = '';

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  User user;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  checkUserLoggedIn() async {
    User user = await FirebaseAuth.instance.currentUser;
    if (user != null)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Expense Tracker App Login',
            style: appBarTitleText,
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          bottomOpacity: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  child: Container(height: 200, child: Image.asset('assets/images/waiter.png')),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 20,
                  ),
                  child: Text(
                    'Login to your account',
                    style: TextStyle(fontSize: 25, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    'Email',
                    style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.w200),
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
                    style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.w200),
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
                            color: Colors.white,
                            icon: Icon(
                              Icons.chevron_right,
                              size: 25,
                            ),
                            onPressed: () async {
                              try {
                                final loginUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                                if (loginUser != null) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(email)
                                      .set({'Email': email, 'Password': password}, SetOptions(merge: true));

                                  logoutResult = await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return HomePage();
                                  }));
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
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 30,
                    right: 30,
                    bottom: 10,
                  ),
                  child: Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'or',
                          style: TextStyle(fontSize: 12, fontFamily: 'Lato', fontWeight: FontWeight.bold),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            if (kIsWeb) {
                              GoogleAuthProvider authProvider = GoogleAuthProvider();

                              try {
                                final UserCredential userCredential = await _auth.signInWithPopup(authProvider);

                                user = userCredential.user;
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

                              if (googleSignInAccount != null) {
                                final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

                                final AuthCredential credential = GoogleAuthProvider.credential(
                                  accessToken: googleSignInAuthentication.accessToken,
                                  idToken: googleSignInAuthentication.idToken,
                                );

                                try {
                                  final UserCredential userCredential = await _auth.signInWithCredential(credential);

                                  user = userCredential.user;
                                  DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(user.email);
                                  docRef.get().then((docSnapshot) => {
                                        if (!docSnapshot.exists)
                                          {
                                            docRef.set({
                                              'Email': user.email,
                                              'Photo Location': user.photoURL,
                                              'Name': 'Jack Philly',
                                              'Date Of Birth': '01-01-2000'
                                            }, SetOptions(merge: true))
                                          }
                                      });

                                  logoutResult = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return HomePage();
                                  }));
                                  if (logoutResult == 'logout') {
                                    //googleSignInAccount = null;
                                    _googleSignIn.disconnect();
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }
                            }

                            return user;
                          },
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(color: Colors.lightBlue)),
                          ),
                          child: Container(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Forgot Password?',
                        style: dayText,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //TODO: Add forgot password flow.
                          },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
