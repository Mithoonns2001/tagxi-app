import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tagyourtaxi_driver/pages/language/languages.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/docs_onprocess.dart';
import 'package:tagyourtaxi_driver/pages/vehicleInformations/upload_docs.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import 'package:http/http.dart' as http;

import '../login/signupmethod.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

dynamic package;

class _LoadingPageState extends State<LoadingPage> {
  String dot = '.';
  bool updateAvailable = false;
  dynamic _version;
  bool _isLoading = false;

  var demopage = TextEditingController();

  //navigate
  navigate() {
    if (userDetails['uploaded_document'] == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Docs()));
    } else if (userDetails['uploaded_document'] == true &&
        userDetails['approve'] == false) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DocsProcess(),
          ));
    } else if (userDetails['uploaded_document'] == true &&
        userDetails['approve'] == true) {
      //status approved
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Maps()),
          (route) => false);
    }
  }

  @override
  void initState() {
    getLanguageDone();

    super.initState();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

//get language json and data saved in local (bearer token , choosen language) and find users current status
  getLanguageDone() async {
    package = await PackageInfo.fromPlatform();
    if (platform == TargetPlatform.android) {
      _version = await FirebaseDatabase.instance
          .ref()
          .child('driver_android_version')
          .get();
    } else {
      _version = await FirebaseDatabase.instance
          .ref()
          .child('driver_ios_version')
          .get();
    }
    if (_version.value != null) {
      var version = _version.value.toString().split('.');
      var packages = package.version.toString().split('.');

      for (var i = 0; i < version.length || i < packages.length; i++) {
        if (i < version.length && i < packages.length) {
          if (int.parse(packages[i]) < int.parse(version[i])) {
            setState(() {
              updateAvailable = true;
            });
            break;
          } else if (int.parse(packages[i]) > int.parse(version[i])) {
            setState(() {
              updateAvailable = false;
            });
            break;
          }
        } else if (i >= version.length && i < packages.length) {
          setState(() {
            updateAvailable = false;
          });
          break;
        } else if (i < version.length && i >= packages.length) {
          setState(() {
            updateAvailable = true;
          });
          break;
        }
      }
    }

    if (updateAvailable == false) {
      await getDetailsOfDevice();
      if (internet == true) {
        var val = await getLocalData();

        //if user is login and check waiting for approval status and send accordingly
        if (val == '3') {
          navigate();
        }
        //if user is not login in this device
        else if (val == '2') {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignupMethod()));
          });
        } else {
          //user installing first time and didnt yet choosen language
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Languages()));
          });
        }
      } else {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: media.height * 1,
              width: media.width * 1,
              decoration: const BoxDecoration(
                color: Color(0xffF7F7F7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(media.width * 0.01),
                    width: media.width * 0.429,
                    height: media.width * 0.429,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain)),
                  ),
                ],
              ),
            ),

            //update available

            (updateAvailable == true)
                ? Positioned(
                    top: 0,
                    child: Container(
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: media.width * 0.9,
                              padding: EdgeInsets.all(media.width * 0.05),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: page,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: media.width * 0.8,
                                      child: Text(
                                        'New version of this app is available in store, please update the app for continue using',
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            fontWeight: FontWeight.w600),
                                      )),
                                  SizedBox(
                                    height: media.width * 0.05,
                                  ),
                                  Button(
                                      onTap: () async {
                                        if (platform ==
                                            TargetPlatform.android) {
                                          openBrowser(
                                              'https://play.google.com/store/apps/details?id=${package.packageName}');
                                        } else {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          var response = await http.get(Uri.parse(
                                              'http://itunes.apple.com/lookup?bundleId=${package.packageName}'));
                                          if (response.statusCode == 200) {
                                            openBrowser(jsonDecode(
                                                    response.body)['results'][0]
                                                ['trackViewUrl']);
                                          }

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      text: 'Update')
                                ],
                              ))
                        ],
                      ),
                    ))
                : Container(),

            //loader
            (_isLoading == true && internet == true)
                ? const Positioned(top: 0, child: Loading())
                : Container(),

            //internet is not connected
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(
                      onTap: () {
                        //try again
                        setState(() {
                          internetTrue();
                          getLanguageDone();
                        });
                      },
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
