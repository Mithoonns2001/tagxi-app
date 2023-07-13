import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/pages/referralcode/referral_code.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import './login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

String name = ''; //name of user
String email = ''; // email of user
dynamic proImageFile1;

class _GetStartedState extends State<GetStarted> {
  bool _loading = false;
  var verifyEmailError = '';
  var _error = '';
  ImagePicker picker = ImagePicker();
  bool _pickImage = false;
  String _permission = '';

  getGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.photos.request();
    }
    return status;
  }

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//pick image from gallery
  pickImageFromGallery() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        proImageFile1 = pickedFile?.path;
        _pickImage = false;
      });
    } else {
      setState(() {
        _permission = 'noPhotos';
      });
    }
  }

//pick image from camera
  pickImageFromCamera() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        proImageFile1 = pickedFile?.path;
        _pickImage = false;
      });
    } else {
      setState(() {
        _permission = 'noCamera';
      });
    }
  }

  //navigate
  navigate() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Referral()),
        (route) => false);
  }

  TextEditingController emailText =
      TextEditingController(); //email textediting controller
  TextEditingController nameText =
      TextEditingController(); //name textediting controller

  @override
  void initState() {
    proImageFile1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        body: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: media.width * 0.08, right: media.width * 0.08),
                height: media.height * 1,
                width: media.width * 1,
                color: page,
                child: Column(
                  children: [
                    Container(
                        height: media.height * 0.12,
                        width: media.width * 1,
                        color: topBar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.arrow_back)),
                          ],
                        )),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: media.height * 0.04,
                          ),
                          SizedBox(
                            width: media.width * 1,
                            child: Text(
                              languages[choosenLanguage]['text_get_started'],
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * twentyeight,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          ),
                          SizedBox(
                            height: media.height * 0.012,
                          ),
                          Text(
                            languages[choosenLanguage]['text_fill_form'],
                            style: GoogleFonts.roboto(
                                fontSize: media.width * sixteen,
                                color: textColor.withOpacity(0.3)),
                          ),
                          SizedBox(height: media.height * 0.04),

                          Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _pickImage = true;
                                });
                              },
                              child: proImageFile1 != null
                                  ? Container(
                                      height: media.width * 0.4,
                                      width: media.width * 0.4,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: backgroundColor,
                                          image: DecorationImage(
                                              image: FileImage(
                                                  File(proImageFile1)),
                                              fit: BoxFit.cover)),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      height: media.width * 0.4,
                                      width: media.width * 0.4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: backgroundColor,
                                      ),
                                      child: Text(
                                        languages[choosenLanguage]
                                            ['text_add_photo'],
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * fourteen,
                                            color: textColor),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: media.height * 0.04),
                          InputField(
                            icon: Icons.person_outline_rounded,
                            text: languages[choosenLanguage]['text_name'],
                            onTap: (val) {
                              setState(() {
                                name = nameText.text;
                              });
                            },
                            textController: nameText,
                          ),
                          SizedBox(
                            height: media.height * 0.012,
                          ),
                          InputField(
                            icon: Icons.email_outlined,
                            text: languages[choosenLanguage]['text_email'],
                            onTap: (val) {
                              setState(() {
                                email = emailText.text;
                              });
                            },
                            textController: emailText,
                            color: (verifyEmailError == '') ? null : Colors.red,
                          ),
                          SizedBox(
                            height: media.height * 0.012,
                          ),

                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: underline))),
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        countries[phcode]['dial_code'],
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            color: textColor),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  phnumber,
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * sixteen,
                                      color: textColor,
                                      letterSpacing: 2),
                                )
                              ],
                            ),
                          ),
                          //email already exist error
                          (_error != '')
                              ? Container(
                                  width: media.width * 0.8,
                                  margin:
                                      EdgeInsets.only(top: media.height * 0.03),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _error,
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: Colors.red),
                                  ),
                                )
                              : Container(),

                          SizedBox(
                            height: media.height * 0.065,
                          ),
                          (nameText.text.isNotEmpty &&
                                  emailText.text.isNotEmpty)
                              ? Container(
                                  width: media.width * 1,
                                  alignment: Alignment.center,
                                  child: Button(
                                      onTap: () async {
                                        String pattern =
                                            r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                        RegExp regex = RegExp(pattern);
                                        if (regex.hasMatch(emailText.text)) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();

                                          setState(() {
                                            verifyEmailError = '';
                                            _error = '';
                                            _loading = true;
                                          });
                                          //validate email already exist
                                          var result = await validateEmail();

                                          if (result == 'success') {
                                            setState(() {
                                              verifyEmailError = '';
                                              _error = '';
                                            });
                                            var register = await registerUser();
                                            if (register == 'true') {
                                              //referral page
                                              navigate();
                                            } else {
                                              setState(() {
                                                _error = register.toString();
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              verifyEmailError =
                                                  result.toString();
                                              _error = result.toString();
                                            });
                                          }
                                          setState(() {
                                            _loading = false;
                                          });
                                        } else {
                                          setState(() {
                                            verifyEmailError =
                                                languages[choosenLanguage]
                                                    ['text_email_validation'];
                                            _error = languages[choosenLanguage]
                                                ['text_email_validation'];
                                          });
                                        }
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_next']))
                              : Container()
                        ],
                      ),
                    )),
                  ],
                ),
              ),

              (_pickImage == true)
                  ? Positioned(
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _pickImage = false;
                          });
                        },
                        child: Container(
                          height: media.height * 1,
                          width: media.width * 1,
                          color: Colors.transparent.withOpacity(0.6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(media.width * 0.05),
                                width: media.width * 1,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                    border: Border.all(
                                      color: borderLines,
                                      width: 1.2,
                                    ),
                                    color: page),
                                child: Column(
                                  children: [
                                    Container(
                                      height: media.width * 0.02,
                                      width: media.width * 0.15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.01),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                pickImageFromCamera();
                                              },
                                              child: Container(
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: media.width * 0.064,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.01,
                                            ),
                                            Text(
                                              languages[choosenLanguage]
                                                  ['text_camera'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width * ten,
                                                  color:
                                                      const Color(0xff666666)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                pickImageFromGallery();
                                              },
                                              child: Container(
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    size: media.width * 0.064,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.01,
                                            ),
                                            Text(
                                              languages[choosenLanguage]
                                                  ['text_gallery'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width * ten,
                                                  color:
                                                      const Color(0xff666666)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  : Container(),

              //permission denied popup
              (_permission != '')
                  ? Positioned(
                      child: Container(
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: media.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _permission = '';
                                      _pickImage = false;
                                    });
                                  },
                                  child: Container(
                                    height: media.width * 0.1,
                                    width: media.width * 0.1,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: page),
                                    child: const Icon(Icons.cancel_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            width: media.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: page,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2.0,
                                      spreadRadius: 2.0,
                                      color: Colors.black.withOpacity(0.2))
                                ]),
                            child: Column(
                              children: [
                                SizedBox(
                                    width: media.width * 0.8,
                                    child: Text(
                                      (_permission == 'noPhotos')
                                          ? languages[choosenLanguage]
                                              ['text_open_photos_setting']
                                          : languages[choosenLanguage]
                                              ['text_open_camera_setting'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: textColor,
                                          fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(height: media.width * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          await openAppSettings();
                                        },
                                        child: Text(
                                          languages[choosenLanguage]
                                              ['text_open_settings'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen,
                                              color: buttonColor,
                                              fontWeight: FontWeight.w600),
                                        )),
                                    InkWell(
                                        onTap: () async {
                                          (_permission == 'noCamera')
                                              ? pickImageFromCamera()
                                              : pickImageFromGallery();
                                          setState(() {
                                            _permission = '';
                                          });
                                        },
                                        child: Text(
                                          languages[choosenLanguage]
                                              ['text_done'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen,
                                              color: buttonColor,
                                              fontWeight: FontWeight.w600),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  : Container(),

              //internet not connected
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          setState(() {
                            internetTrue();
                          });
                        },
                      ))
                  : Container(),

              //loader
              (_loading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
