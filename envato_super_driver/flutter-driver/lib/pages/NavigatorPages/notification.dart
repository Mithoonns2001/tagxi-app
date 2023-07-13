import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  bool error = false;
  dynamic notificationid;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    await getnotificationHistory();
    if (mounted) {
      isLoading = false;
    }
  }

  bool showinfo = false;
  int? showinfovalue;

  bool showToastbool = false;

  showToast() async {
    setState(() {
      showToastbool = true;
    });
    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        showToastbool = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Stack(children: [
                  Container(
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                    padding: EdgeInsets.fromLTRB(media.width * 0.05,
                        media.width * 0.05, media.width * 0.05, 0),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
                        Stack(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(bottom: media.width * 0.05),
                              width: media.width * 1,
                              alignment: Alignment.center,
                              child: Text(
                                languages[choosenLanguage]['text_notification']
                                    .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twenty,
                                    fontWeight: FontWeight.w600,
                                    color: textColor),
                              ),
                            ),
                            Positioned(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.arrow_back)))
                          ],
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              //wallet history
                              (notificationHistory.isNotEmpty)
                                  ? Column(
                                      children: [
                                        Column(
                                          children: notificationHistory
                                              .asMap()
                                              .map((i, value) {
                                                return MapEntry(
                                                    i,
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          showinfovalue = i;
                                                          showinfo = true;
                                                        });
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: media.width *
                                                                0.02,
                                                            bottom:
                                                                media.width *
                                                                    0.02),
                                                        width:
                                                            media.width * 0.9,
                                                        padding: EdgeInsets.all(
                                                            media.width *
                                                                0.025),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    borderLines,
                                                                width: 1.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: page),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                    height: media
                                                                            .width *
                                                                        0.1067,
                                                                    width: media
                                                                            .width *
                                                                        0.1067,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        color: const Color(0xff000000)
                                                                            .withOpacity(
                                                                                0.05)),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Icon(
                                                                        Icons
                                                                            .notifications)),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.025,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: media
                                                                              .width *
                                                                          0.55,
                                                                      child:
                                                                          Text(
                                                                        notificationHistory[i]['title']
                                                                            .toString(),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts.roboto(
                                                                            fontSize: media.width *
                                                                                fourteen,
                                                                            color:
                                                                                textColor,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.01,
                                                                    ),
                                                                    SizedBox(
                                                                      width: media
                                                                              .width *
                                                                          0.55,
                                                                      child:
                                                                          Text(
                                                                        notificationHistory[i]['body']
                                                                            .toString(),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontSize:
                                                                              media.width * twelve,
                                                                          color:
                                                                              hintColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.01,
                                                                    ),
                                                                    SizedBox(
                                                                      width: media
                                                                              .width *
                                                                          0.55,
                                                                      child:
                                                                          Text(
                                                                        notificationHistory[i]['converted_created_at']
                                                                            .toString(),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts.roboto(
                                                                            fontSize: media.width *
                                                                                twelve,
                                                                            color:
                                                                                textColor,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Expanded(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerRight,
                                                                        width: media.width *
                                                                            0.15,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              error = true;
                                                                              notificationid = notificationHistory[i]['id'];
                                                                            });
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.delete_forever),
                                                                        ))
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.02,
                                                            ),
                                                            if (notificationHistory[
                                                                        i]
                                                                    ['image'] !=
                                                                null)
                                                              Image.network(
                                                                notificationHistory[
                                                                    i]['image'],
                                                                height: media
                                                                        .width *
                                                                    0.1,
                                                                width: media
                                                                        .width *
                                                                    0.8,
                                                                fit: BoxFit
                                                                    .contain,
                                                              )
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                              })
                                              .values
                                              .toList(),
                                        ),
                                        (notificationHistoryPage[
                                                    'pagination'] !=
                                                null)
                                            ? (notificationHistoryPage[
                                                            'pagination']
                                                        ['current_page'] <
                                                    notificationHistoryPage[
                                                            'pagination']
                                                        ['total_pages'])
                                                ? InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      await getNotificationPages(
                                                          'page=${notificationHistoryPage['pagination']['current_page'] + 1}');
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          media.width * 0.025),
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.05),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: page,
                                                          border: Border.all(
                                                              color:
                                                                  borderLines,
                                                              width: 1.2)),
                                                      child: Text(
                                                        languages[
                                                                choosenLanguage]
                                                            ['text_loadmore'],
                                                        style: GoogleFonts
                                                            .roboto(
                                                                fontSize: media
                                                                        .width *
                                                                    sixteen,
                                                                color:
                                                                    textColor),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                            : Container()
                                      ],
                                    )
                                  : Container(
                                      height: media.width * 0.7,
                                      width: media.width * 0.7,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/nodatafound.gif'),
                                              fit: BoxFit.contain)),
                                    ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  (showinfo == true)
                      ? Positioned(
                          top: 0,
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
                                      Container(
                                          height: media.height * 0.1,
                                          width: media.width * 0.1,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: page),
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  showinfo = false;
                                                  showinfovalue = null;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.cancel_outlined))),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: page),
                                  child: Column(
                                    children: [
                                      Text(
                                        notificationHistory[showinfovalue!]
                                                ['title']
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            color: textColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Text(
                                        notificationHistory[showinfovalue!]
                                                ['body']
                                            .toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: media.width * fourteen,
                                          color: hintColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      if (notificationHistory[showinfovalue!]
                                              ['image'] !=
                                          null)
                                        Image.network(
                                          notificationHistory[showinfovalue!]
                                              ['image'],
                                          height: media.width * 0.4,
                                          width: media.width * 0.4,
                                          fit: BoxFit.contain,
                                        )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))
                      : Container(),
                  (error == true)
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
                                            ['text_delete_notification'],
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            color: textColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Button(
                                              onTap: () async {
                                                setState(() {
                                                  error = false;
                                                  notificationid = null;
                                                });
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_no']),
                                          SizedBox(
                                            width: media.width * 0.05,
                                          ),
                                          Button(
                                              onTap: () async {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                var result =
                                                    await deleteNotification(
                                                        notificationid);
                                                if (result == 'success') {
                                                  setState(() {
                                                    getdata();

                                                    error = false;
                                                    isLoading = false;
                                                    showToast();
                                                  });
                                                } else {
                                                  // setState(() {
                                                  //   logout = true;
                                                  // });
                                                }
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_yes']),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : Container(),
                  (isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container(),
                  (showToastbool == true)
                      ? Positioned(
                          bottom: media.height * 0.2,
                          left: media.width * 0.2,
                          right: media.width * 0.2,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(media.width * 0.025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent.withOpacity(0.6)),
                            child: Text(
                              languages[choosenLanguage]
                                  ['text_notification_deleted'],
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * twelve,
                                  color: Colors.white),
                            ),
                          ))
                      : Container()
                ]),
              );
            }));
  }
}
