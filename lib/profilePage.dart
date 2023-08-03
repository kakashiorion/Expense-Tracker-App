import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/cameraPicture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'loginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          alignment: Alignment.topCenter,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Profile',
                    style: appBarTitleText.copyWith(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: OutlinedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    },
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.lightBlue))),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Logout',
                            style: titleText.copyWith(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.logout,
                            color: Colors.lightBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    spreadRadius: 2,
                    color: Colors.grey)
              ],
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(email)
                            .get(),
                        builder: (context, snapshot) {
                          String imageLocation = snapshot.hasData
                              ? snapshot.data!.get('Photo Location')
                              : "";
                          return CircleAvatar(
                            backgroundImage: getPicture(imageLocation),
                            minRadius: 40,
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                        child: TextButton(
                            onPressed: () async {
                              await editProfilePicture(context);
                              setState(() {});
                            },
                            child: Text(
                              'Edit Photo',
                              style: weekdayText.copyWith(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(email)
                              .get(),
                          builder: (BuildContext context, snapshot) {
                            return Text(
                              snapshot.hasData
                                  ? snapshot.data!.get('Name')
                                  : "",
                              style: displayTextStyle,
                            );
                          }),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   'Budgeting Score :10',
                      //   style: dayText,
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height - 300,
            child: Wrap(
              direction: Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30),
                  child: Text(
                    'Email',
                    style: titleText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30),
                  child: Text(
                    email ?? "",
                    style: appBarTitleText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 30),
                  child: Text(
                    'Date of Birth',
                    style: titleText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30),
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(email)
                          .get(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.hasData
                              ? snapshot.data!.get('Date Of Birth')
                              : "",
                          style: appBarTitleText,
                        );
                      }),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 30.0, left: 30),
                //   child: Text(
                //     'Password',
                //     style: titleText,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10.0, left: 30),
                //   child: Text(
                //     '******',
                //     style: appBarTitleText,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  dynamic getPicture(String imageLocation) {
    try {
      if (imageLocation.substring(0, 4) == 'http') {
        return NetworkImage(imageLocation);
      }
      return AssetImage('assets/images/profPhoto.jpg');
    } catch (e) {
      print(e);
    }
  }
}

Future<String> editProfilePicture(context) async {
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[0];
  //final secondCamera = cameras[1];
  final String resultLocation =
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
    return TakePictureScreen(
      camera1: firstCamera,
    );
  }));
  return resultLocation;
}
