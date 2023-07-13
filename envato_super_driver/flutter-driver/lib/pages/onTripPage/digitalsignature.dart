import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/invoice.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class DigitalSignature extends StatefulWidget {
  const DigitalSignature({Key? key}) : super(key: key);

  @override
  State<DigitalSignature> createState() => _DigitalSignatureState();
}

List points = [];
dynamic signatureFile;

class _DigitalSignatureState extends State<DigitalSignature> {
  var screenshotImage = GlobalKey();
  bool _isLoading = false;
  bool _error = false;

  //navigate
  navigate() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Invoice()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              SizedBox(
                height: media.height * 1,
                width: media.width * 1,
                child: RepaintBoundary(
                  key: screenshotImage,
                  child: CustomPaint(
                    painter: MyPainter(pointlist: points),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding: EdgeInsets.only(
                      left: media.width * 0.05, right: media.width * 0.05),
                  height: media.height * 1,
                  width: media.width * 1,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: media.height * 0.1,
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              languages[choosenLanguage]['text_signature'],
                              style: GoogleFonts.roboto(
                                  fontSize: media.height * twelve,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Positioned(
                              child: Container(
                            height: media.height * 0.1,
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.arrow_back)),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: media.height * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //signature box
                          GestureDetector(
                            onTapDown: (val) {
                              setState(() {
                                final box =
                                    context.findRenderObject() as RenderBox;
                                final point =
                                    box.globalToLocal(val.globalPosition);

                                points
                                    .add({'point': point, 'action': 'dot to'});
                              });
                            },
                            onTapUp: (val) {
                              setState(() {
                                final box =
                                    context.findRenderObject() as RenderBox;
                                final point =
                                    box.globalToLocal(val.globalPosition);

                                points.add(
                                    {'point': point, 'action': 'setstate'});
                              });
                            },
                            onPanStart: (val) {
                              setState(() {
                                final box =
                                    context.findRenderObject() as RenderBox;
                                final point =
                                    box.globalToLocal(val.globalPosition);

                                points
                                    .add({'point': point, 'action': 'move to'});
                              });
                            },
                            onPanUpdate: (val) {
                              setState(() {
                                final box =
                                    context.findRenderObject() as RenderBox;
                                final point =
                                    box.globalToLocal(val.globalPosition);

                                if (point.dx < media.width * 0.95 &&
                                    point.dx > media.width * 0.05 &&
                                    point.dy > media.height * 0.12 &&
                                    point.dy <
                                        (media.width * 1 +
                                            media.height * 0.12)) {
                                  points.add(
                                      {'point': point, 'action': 'line to'});
                                }
                              });
                            },
                            onPanEnd: (val) {
                              setState(() {
                                points.add(
                                    {'point': 'point', 'action': 'setstate'});
                              });
                            },
                            child: Container(
                              height: media.width * 1,
                              width: media.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Colors.black, width: 1.1)),
                            ),
                          ),

                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //retry button
                              Button(
                                width: media.width * 0.3,
                                onTap: () async {
                                  setState(() {
                                    points.clear();
                                  });
                                },
                                text: languages[choosenLanguage]['text_retry'],
                              ),
                              SizedBox(
                                width: media.width * 0.05,
                              ),

                              //submit button
                              Button(
                                width: media.width * 0.3,
                                onTap: () async {
                                  if (points.isNotEmpty) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    RenderRepaintBoundary boundary =
                                        screenshotImage
                                                .currentContext!
                                                .findRenderObject()
                                            as RenderRepaintBoundary;
                                    var image =
                                        await boundary.toImage(pixelRatio: 2);
                                    // print(image);
                                    var file = await image.toByteData(
                                        format: ImageByteFormat.png);
                                    var uintImage = file!.buffer.asUint8List();
                                    Directory paths =
                                        await getTemporaryDirectory();
                                    var path = paths.path;
                                    var name = DateTime.now();
                                    signatureFile = File('$path/$name.png');

                                    signatureFile.writeAsBytesSync(uintImage);

                                    var val = await uploadSignatureImage();
                                    if (val == 'success') {
                                      if (driverReq['is_completed'] == 1) {
                                        navigate();
                                        points.clear();
                                        signatureFile = null;
                                      }
                                    } else {
                                      setState(() {
                                        _error = true;
                                      });
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                text: languages[choosenLanguage]['text_submit'],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              //error popup
              (_error == true)
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
                              padding: EdgeInsets.all(media.width * 0.05),
                              width: media.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: page),
                              child: Column(
                                children: [
                                  Text(
                                    languages[choosenLanguage]
                                        ['text_somethingwentwrong'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: media.width * 0.05,
                                  ),
                                  Button(
                                      onTap: () async {
                                        setState(() {
                                          _error = false;
                                        });
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_ok'])
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                  : Container(),

              //loader
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container()
            ],
          )),
    );
  }
}

//signamture drawing
class MyPainter extends CustomPainter {
  List pointlist;
  MyPainter({required this.pointlist});

  List<Offset> offsetPoints = [];
  Paint line = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..color = Colors.black;
  Paint dot = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 5
    ..color = Colors.black;
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Path paths = Path();
    path.moveTo(0, 0);
    for (int i = 0; i < pointlist.length - 1; i++) {
      if (pointlist[i]['action'] == 'move to') {
        path.moveTo(pointlist[i]['point'].dx, pointlist[i]['point'].dy);
      } else if (pointlist[i]['action'] == 'dot to') {
        paths.moveTo(pointlist[i]['point'].dx, pointlist[i]['point'].dy);
        paths
            .addOval(Rect.fromCircle(center: pointlist[i]['point'], radius: 2));
      } else if (pointlist[i]['action'] == 'setstate') {
      } else {
        path.lineTo(pointlist[i]['point'].dx, pointlist[i]['point'].dy);
      }
    }
    canvas.drawPath(paths, dot);
    canvas.drawPath(path, line);
  }

  //Called when CustomPainter is rebuilt.
  //Returning true because we want canvas to be rebuilt to reflect new changes.
  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}
