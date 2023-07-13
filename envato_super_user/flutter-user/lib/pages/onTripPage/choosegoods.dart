import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class ChooseGoods extends StatefulWidget {
  const ChooseGoods({Key? key}) : super(key: key);

  @override
  State<ChooseGoods> createState() => _ChooseGoodsState();
}

String selectedGoodsId = '';
dynamic _selGoods;

class _ChooseGoodsState extends State<ChooseGoods> {
  TextEditingController goodsText = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    _selGoods = null;
    getGoods();

    super.initState();
  }

  getGoods() async {
    await getGoodsList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: media.height * 1,
                width: media.width * 1,
                color: page,
                padding: EdgeInsets.only(
                    left: media.width * 0.05, right: media.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).padding.top +
                            media.width * 0.05),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: media.width * 0.05),
                          width: media.width * 1,
                          alignment: Alignment.center,
                          child: Text(
                            languages[choosenLanguage]['text_choose_goods'],
                            style: GoogleFonts.roboto(
                                fontSize: media.width * twenty,
                                fontWeight: FontWeight.w600,
                                color: textColor),
                          ),
                        ),
                        Positioned(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Icon(Icons.arrow_back)))
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                          children: goodsTypeList
                              .asMap()
                              .map((i, value) {
                                return MapEntry(
                                    i,
                                    Container(
                                      width: media.width * 0.8,
                                      padding:
                                          EdgeInsets.all(media.width * 0.02),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selGoods = goodsTypeList[i]['id']
                                                .toString();
                                            goodsSize =
                                                languages[choosenLanguage]
                                                    ['text_loose'];
                                            goodsText.clear();
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: media.width * 0.6,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: media.width * 0.6,
                                                    child: Text(
                                                      goodsTypeList[i]
                                                          ['goods_type_name'],
                                                      style: GoogleFonts.roboto(
                                                          fontSize:
                                                              media.width *
                                                                  sixteen),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  (_selGoods ==
                                                              goodsTypeList[i]
                                                                      ['id']
                                                                  .toString() &&
                                                          goodsSize != '')
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: media
                                                                          .width *
                                                                      0.01),
                                                          width:
                                                              media.width * 0.6,
                                                          child: Text(
                                                            goodsSize,
                                                            style: GoogleFonts.roboto(
                                                                fontSize: media
                                                                        .width *
                                                                    twelve),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ))
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: media.width * 0.05,
                                              width: media.width * 0.05,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: (_selGoods ==
                                                      goodsTypeList[i]['id']
                                                          .toString())
                                                  ? Container(
                                                      height:
                                                          media.width * 0.03,
                                                      width: media.width * 0.03,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.black),
                                                    )
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              })
                              .values
                              .toList()),
                    )),
                    SizedBox(
                      height: media.width * 0.025,
                    ),
                    (_selGoods != null)
                        ? Container(
                            margin:
                                EdgeInsets.only(bottom: media.width * 0.025),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (goodsSize !=
                                            languages[choosenLanguage]
                                                ['text_loose']) {
                                          setState(() {
                                            goodsSize =
                                                languages[choosenLanguage]
                                                    ['text_loose'];
                                            goodsText.clear();
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: media.width * 0.04,
                                        width: media.width * 0.04,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            shape: BoxShape.circle),
                                        alignment: Alignment.center,
                                        child: (goodsSize ==
                                                languages[choosenLanguage]
                                                    ['text_loose'])
                                            ? Container(
                                                height: media.width * 0.02,
                                                width: media.width * 0.02,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                              )
                                            : Container(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: media.width * 0.02,
                                    ),
                                    SizedBox(
                                        width: media.width * 0.25,
                                        child: Text(
                                          languages[choosenLanguage]
                                              ['text_loose'],
                                          style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                  ],
                                ),
                                SizedBox(width: media.width * 0.05),

                                //choose loose or qty
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (goodsSize ==
                                            languages[choosenLanguage]
                                                ['text_loose']) {
                                          setState(() {
                                            goodsSize = '';
                                            goodsText.clear();
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: media.width * 0.04,
                                        width: media.width * 0.04,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            shape: BoxShape.circle),
                                        alignment: Alignment.center,
                                        child: (goodsSize !=
                                                languages[choosenLanguage]
                                                    ['text_loose'])
                                            ? Container(
                                                height: media.width * 0.02,
                                                width: media.width * 0.02,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                              )
                                            : Container(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: media.width * 0.02,
                                    ),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.fromLTRB(
                                            media.width * 0.03,
                                            media.width * 0.0,
                                            media.width * 0.03,
                                            media.width * 0.01),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: borderLines),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: media.width * 0.1,
                                        width: media.width * 0.3,
                                        child: (goodsSize !=
                                                languages[choosenLanguage]
                                                    ['text_loose'])
                                            ? TextField(
                                                controller: goodsText,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: languages[
                                                            choosenLanguage][
                                                        'text_quantitywithunit'],
                                                    hintStyle:
                                                        GoogleFonts.roboto(
                                                            fontSize:
                                                                media.width *
                                                                    twelve)),
                                                onChanged: (val) {
                                                  setState(() {
                                                    goodsSize = goodsText.text;
                                                  });
                                                },
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * twelve),
                                              )
                                            : Text(
                                                languages[choosenLanguage]
                                                    ['text_quantitywithunit'],
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: hintColor)))
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Button(
                        onTap: () {
                          setState(() {
                            if (goodsSize != '' && _selGoods != null) {
                              selectedGoodsId = _selGoods;
                              Navigator.pop(context, true);
                            }
                          });
                        },
                        text: languages[choosenLanguage]['text_confirm']),
                    SizedBox(
                      height: media.width * 0.05,
                    )
                  ],
                ),
              ),

              //loader
              (_isLoading == true)
                  ? const Positioned(child: Loading())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
