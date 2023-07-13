import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

import '../../translation/translation.dart';

class SignupMethod extends StatefulWidget {
  const SignupMethod({Key? key}) : super(key: key);

  @override
  State<SignupMethod> createState() => _SignupMethodState();
}

class _SignupMethodState extends State<SignupMethod> {
  @override
  void initState() {
    ischeckownerordriver = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      color: page,
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        ischeckownerordriver = 'driver';
                      });
                    },
                    child: Container(
                      height: media.width * 0.18,
                      width: media.width * 0.8,
                      padding: EdgeInsets.only(left: media.width * 0.02),

                      decoration: BoxDecoration(
                        color: page,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 5.0,
                          ),
                        ],
                        border: ischeckownerordriver == 'driver'
                            ? Border.all(color: buttonColor, width: 3)
                            : null,
                      ),
                      // border: Border.all(color: Colors.blue, width: 3)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            height: media.width * 0.12,
                            width: media.width * 0.12,
                            decoration: BoxDecoration(
                              color: page,
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/cardriver.png'),
                                  fit: BoxFit.contain),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: media.width * 0.04,
                          ),
                          Expanded(
                            child: Text(
                              languages[choosenLanguage]['text_login_driver'],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * sixteen,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        ischeckownerordriver = 'owner';
                      });
                    },
                    child: Container(
                      height: media.width * 0.18,
                      width: media.width * 0.8,
                      padding: EdgeInsets.only(left: media.width * 0.02),
                      decoration: BoxDecoration(
                        color: page,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 5.0,
                          ),
                        ],
                        border: ischeckownerordriver == 'owner'
                            ? Border.all(color: buttonColor, width: 3)
                            : null,
                      ),
                      // border: Border.all(color: Colors.blue, width: 3)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            height: media.width * 0.12,
                            width: media.width * 0.12,
                            decoration: BoxDecoration(
                              color: page,
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/carowner.png'),
                                  fit: BoxFit.contain),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: media.width * 0.04,
                          ),
                          Expanded(
                            child: Text(
                              languages[choosenLanguage]['text_login_owner'],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * sixteen,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ischeckownerordriver != ''
                ? Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    child: Button(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        text: languages[choosenLanguage]['text_continue']),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

// class _SignupMethodState extends State<SignupMethod> {
//   @override
//   void initState() {
//     ischeckownerordriver = '';
//     transportType = '';
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Material(
//       color: page,
//       child: Directionality(
//         textDirection: (languageDirection == 'rtl')
//             ? TextDirection.rtl
//             : TextDirection.ltr,
//         child: Column(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: media.width*0.9,
//                     child: Text(languages[choosenLanguage]['text_taxi'],
//                     style: GoogleFonts.roboto(
//                       fontSize: media.width*twentyeight,
//                       fontWeight: FontWeight.bold,
//                       color: textColor
//                     ),
//                     maxLines: 1,
//                     textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: media.width*0.05,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       InkWell(
//                     onTap: () {
//                       setState(() {
//                         ischeckownerordriver = 'driver';
//                         transportType = 'taxi';
//                       });
//                     },
//                     child: Container(
//                       height: media.width * 0.3,
//                       width: media.width * 0.3,
//                       padding: EdgeInsets.only(left: media.width * 0.02),

//                       decoration: BoxDecoration(
//                         color: page,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(20)),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0.0, 1.0), //(x,y)
//                             blurRadius: 5.0,
//                           ),
//                         ],
//                         border: ischeckownerordriver == 'driver' && transportType == 'taxi'
//                             ? Border.all(color: buttonColor, width: 3)
//                             : null,
//                       ),
//                       // border: Border.all(color: Colors.blue, width: 3)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(media.width * 0.05),
//                             height: media.width * 0.12,
//                             width: media.width * 0.12,
//                             decoration: BoxDecoration(
//                               color: page,
//                               shape: BoxShape.circle,
//                               image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/images/cardriver.png'),
//                                   fit: BoxFit.contain),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.grey,
//                                   offset: Offset(0.0, 1.0), //(x,y)
//                                   blurRadius: 5.0,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: media.width * 0.04,
//                           ),
//                           SizedBox(
//                             width: media.width*0.2,
//                             child: Text(
//                               languages[choosenLanguage]['text_driver'],
//                               maxLines: 1,
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.roboto(
//                                   fontSize: media.width * sixteen,
//                                   fontWeight: FontWeight.bold,
//                                   color: textColor),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         ischeckownerordriver = 'owner';
//                         transportType = 'taxi';
//                       });
//                     },
//                     child: Container(
//                       height: media.width * 0.3,
//                       width: media.width * 0.3,
//                       padding: EdgeInsets.only(left: media.width * 0.02),

//                       decoration: BoxDecoration(
//                         color: page,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(20)),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0.0, 1.0), //(x,y)
//                             blurRadius: 5.0,
//                           ),
//                         ],
//                         border: ischeckownerordriver == 'owner' && transportType == 'taxi'
//                             ? Border.all(color: buttonColor, width: 3)
//                             : null,
//                       ),
//                       // border: Border.all(color: Colors.blue, width: 3)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(media.width * 0.05),
//                             height: media.width * 0.12,
//                             width: media.width * 0.12,
//                             decoration: BoxDecoration(
//                               color: page,
//                               shape: BoxShape.circle,
//                               image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/images/carowner.png'),
//                                   fit: BoxFit.contain),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.grey,
//                                   offset: Offset(0.0, 1.0), //(x,y)
//                                   blurRadius: 5.0,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: media.width * 0.04,
//                           ),
//                           SizedBox(
//                             width: media.width*0.2,
//                             child: Text(
//                               languages[choosenLanguage]['text_owner'],
//                               maxLines: 1,
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.roboto(
//                                   fontSize: media.width * sixteen,
//                                   fontWeight: FontWeight.bold,
//                                   color: textColor),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                     ],
//                   ),
//                   SizedBox(height: media.width*0.05,),
//                   SizedBox(
//                     width: media.width*0.9,
//                     child: Text(languages[choosenLanguage]['text_delivery'],
//                     style: GoogleFonts.roboto(
//                       fontSize: media.width*twentyeight,
//                       fontWeight: FontWeight.bold,
//                       color: textColor
//                     ),
//                     maxLines: 1,
//                     textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: media.width*0.05,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       InkWell(
//                     onTap: () {
//                       setState(() {
//                         ischeckownerordriver = 'driver';
//                         transportType = 'delivery';
//                       });
//                     },
//                     child: Container(
//                       height: media.width * 0.3,
//                       width: media.width * 0.3,
//                       padding: EdgeInsets.only(left: media.width * 0.02),

//                       decoration: BoxDecoration(
//                         color: page,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(20)),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0.0, 1.0), //(x,y)
//                             blurRadius: 5.0,
//                           ),
//                         ],
//                         border: ischeckownerordriver == 'driver' && transportType == 'delivery'
//                             ? Border.all(color: buttonColor, width: 3)
//                             : null,
//                       ),
//                       // border: Border.all(color: Colors.blue, width: 3)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(media.width * 0.05),
//                             height: media.width * 0.12,
//                             width: media.width * 0.12,
//                             decoration: BoxDecoration(
//                               color: page,
//                               shape: BoxShape.circle,
//                               image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/images/deliverydriver.png'),
//                                   fit: BoxFit.contain),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.grey,
//                                   offset: Offset(0.0, 1.0), //(x,y)
//                                   blurRadius: 5.0,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: media.width * 0.04,
//                           ),
//                           SizedBox(
//                             width: media.width*0.2,
//                             child: Text(
//                               languages[choosenLanguage]['text_driver'],
//                               maxLines: 1,
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.roboto(
//                                   fontSize: media.width * sixteen,
//                                   fontWeight: FontWeight.bold,
//                                   color: textColor),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         ischeckownerordriver = 'owner';
//                         transportType = 'delivery';
//                       });
//                     },
//                     child: Container(
//                       height: media.width * 0.3,
//                       width: media.width * 0.3,
//                       padding: EdgeInsets.only(left: media.width * 0.02),

//                       decoration: BoxDecoration(
//                         color: page,
//                         borderRadius:
//                             const BorderRadius.all(Radius.circular(20)),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0.0, 1.0), //(x,y)
//                             blurRadius: 5.0,
//                           ),
//                         ],
//                         border: ischeckownerordriver == 'owner' && transportType == 'delivery'
//                             ? Border.all(color: buttonColor, width: 3)
//                             : null,
//                       ),
//                       // border: Border.all(color: Colors.blue, width: 3)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(media.width * 0.05),
//                             height: media.width * 0.12,
//                             width: media.width * 0.12,
//                             decoration: BoxDecoration(
//                               color: page,
//                               shape: BoxShape.circle,
//                               image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/images/deliveryowner.png'),
//                                   fit: BoxFit.contain),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.grey,
//                                   offset: Offset(0.0, 1.0), //(x,y)
//                                   blurRadius: 5.0,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: media.width * 0.04,
//                           ),
//                           SizedBox(
//                             width: media.width*0.2,
//                             child: Text(
//                               languages[choosenLanguage]['text_owner'],
//                               maxLines: 1,
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.roboto(
//                                   fontSize: media.width * sixteen,
//                                   fontWeight: FontWeight.bold,
//                                   color: textColor),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                     ],
//                   ),
//                   // InkWell(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       ischeckownerordriver = 'driver';
//                   //     });
//                   //   },
//                   //   child: Container(
//                   //     height: media.width * 0.18,
//                   //     width: media.width * 0.8,
//                   //     padding: EdgeInsets.only(left: media.width * 0.02),

//                   //     decoration: BoxDecoration(
//                   //       color: page,
//                   //       borderRadius:
//                   //           const BorderRadius.all(Radius.circular(20)),
//                   //       boxShadow: const [
//                   //         BoxShadow(
//                   //           color: Colors.grey,
//                   //           offset: Offset(0.0, 1.0), //(x,y)
//                   //           blurRadius: 5.0,
//                   //         ),
//                   //       ],
//                   //       border: ischeckownerordriver == 'driver'
//                   //           ? Border.all(color: buttonColor, width: 3)
//                   //           : null,
//                   //     ),
//                   //     // border: Border.all(color: Colors.blue, width: 3)),
//                   //     child: Row(
//                   //       mainAxisAlignment: MainAxisAlignment.start,
//                   //       children: [
//                   //         Container(
//                   //           padding: EdgeInsets.all(media.width * 0.05),
//                   //           height: media.width * 0.12,
//                   //           width: media.width * 0.12,
//                   //           decoration: BoxDecoration(
//                   //             color: page,
//                   //             shape: BoxShape.circle,
//                   //             image: const DecorationImage(
//                   //                 image:
//                   //                     AssetImage('assets/images/cardriver.png'),
//                   //                 fit: BoxFit.contain),
//                   //             boxShadow: const [
//                   //               BoxShadow(
//                   //                 color: Colors.grey,
//                   //                 offset: Offset(0.0, 1.0), //(x,y)
//                   //                 blurRadius: 5.0,
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),
//                   //         SizedBox(
//                   //           width: media.width * 0.04,
//                   //         ),
//                   //         Expanded(
//                   //           child: Text(
//                   //             languages[choosenLanguage]['text_login_driver'],
//                   //             maxLines: 2,
//                   //             textAlign: TextAlign.center,
//                   //             style: GoogleFonts.roboto(
//                   //                 fontSize: media.width * sixteen,
//                   //                 fontWeight: FontWeight.bold,
//                   //                 color: textColor),
//                   //           ),
//                   //         )
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   // SizedBox(
//                   //   height: media.width * 0.1,
//                   // ),
//                   // InkWell(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       ischeckownerordriver = 'owner';
//                   //     });
//                   //   },
//                   //   child: Container(
//                   //     height: media.width * 0.18,
//                   //     width: media.width * 0.8,
//                   //     padding: EdgeInsets.only(left: media.width * 0.02),
//                   //     decoration: BoxDecoration(
//                   //       color: page,
//                   //       borderRadius:
//                   //           const BorderRadius.all(Radius.circular(20)),
//                   //       boxShadow: const [
//                   //         BoxShadow(
//                   //           color: Colors.grey,
//                   //           offset: Offset(0.0, 1.0), //(x,y)
//                   //           blurRadius: 5.0,
//                   //         ),
//                   //       ],
//                   //       border: ischeckownerordriver == 'owner'
//                   //           ? Border.all(color: buttonColor, width: 3)
//                   //           : null,
//                   //     ),
//                   //     // border: Border.all(color: Colors.blue, width: 3)),
//                   //     child: Row(
//                   //       mainAxisAlignment: MainAxisAlignment.start,
//                   //       children: [
//                   //         Container(
//                   //           padding: EdgeInsets.all(media.width * 0.05),
//                   //           height: media.width * 0.12,
//                   //           width: media.width * 0.12,
//                   //           decoration: BoxDecoration(
//                   //             color: page,
//                   //             shape: BoxShape.circle,
//                   //             image: const DecorationImage(
//                   //                 image:
//                   //                     AssetImage('assets/images/carowner.png'),
//                   //                 fit: BoxFit.contain),
//                   //             boxShadow: const [
//                   //               BoxShadow(
//                   //                 color: Colors.grey,
//                   //                 offset: Offset(0.0, 1.0), //(x,y)
//                   //                 blurRadius: 5.0,
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),
//                   //         SizedBox(
//                   //           width: media.width * 0.04,
//                   //         ),
//                   //         Expanded(
//                   //           child: Text(
//                   //             languages[choosenLanguage]['text_login_owner'],
//                   //             maxLines: 2,
//                   //             textAlign: TextAlign.center,
//                   //             style: GoogleFonts.roboto(
//                   //                 fontSize: media.width * sixteen,
//                   //                 fontWeight: FontWeight.bold,
//                   //                 color: textColor),
//                   //           ),
//                   //         )
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//             ischeckownerordriver != ''
//                 ? Container(
//                     padding: EdgeInsets.all(media.width * 0.05),
//                     child: Button(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const Login()));
//                         },
//                         text: languages[choosenLanguage]['text_continue']),
//                   )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
