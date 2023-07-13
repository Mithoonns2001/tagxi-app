import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/cashfreepage.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/flutterwavepage.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/paystackpayment.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/razorpaypage.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/selectwallet.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/walletpage.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/review_page.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  bool _choosePayment = false;
  bool _isLoading = false;

  @override
  void initState() {
    myMarkers.clear();
    promoCode = '';
    payingVia = 0;
    timing = null;
    promoStatus = null;
    super.initState();
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
            Container(
              padding: EdgeInsets.fromLTRB(
                  media.width * 0.05,
                  MediaQuery.of(context).padding.top + media.width * 0.05,
                  media.width * 0.05,
                  media.width * 0.05),
              height: media.height * 1,
              width: media.width * 1,
              color: page,
              //invoice details
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            languages[choosenLanguage]['text_tripsummary'],
                            style: GoogleFonts.roboto(
                                fontSize: media.width * sixteen,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: media.height * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: media.width * 0.13,
                                width: media.width * 0.13,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            userRequestData['driverDetail']
                                                ['data']['profile_picture']),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: media.width * 0.05,
                              ),
                              Text(
                                userRequestData['driverDetail']['data']['name'],
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * eighteen,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: media.height * 0.05,
                          ),
                          SizedBox(
                            width: media.width * 0.72,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          languages[choosenLanguage]
                                              ['text_reference'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * twelve,
                                              color: const Color(0xff898989)),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.02,
                                        ),
                                        Text(
                                          userRequestData['request_number'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * fourteen,
                                              color: textColor),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          languages[choosenLanguage]
                                              ['text_rideType'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * twelve,
                                              color: const Color(0xff898989)),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.02,
                                        ),
                                        Text(
                                          (userRequestData['is_rental'] ==
                                                  false)
                                              ? languages[choosenLanguage]
                                                  ['text_regular']
                                              : languages[choosenLanguage]
                                                  ['text_rental'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * fourteen,
                                              color: textColor),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: media.height * 0.02,
                                ),
                                Container(
                                  height: 2,
                                  color: const Color(0xffAAAAAA),
                                ),
                                SizedBox(
                                  height: media.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          languages[choosenLanguage]
                                              ['text_distance'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * twelve,
                                              color: const Color(0xff898989)),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.02,
                                        ),
                                        Text(
                                          userRequestData['total_distance'] +
                                              ' ' +
                                              userRequestData['unit'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * fourteen,
                                              color: textColor),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          languages[choosenLanguage]
                                              ['text_duration'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * twelve,
                                              color: const Color(0xff898989)),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.02,
                                        ),
                                        Text(
                                          '${userRequestData['total_time']} mins',
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * fourteen,
                                              color: textColor),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info),
                              SizedBox(
                                width: media.width * 0.04,
                              ),
                              Text(
                                languages[choosenLanguage]['text_tripfare'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * fourteen,
                                    color: textColor),
                              )
                            ],
                          ),

                          SizedBox(
                            height: media.height * 0.05,
                          ),
                          (userRequestData['is_rental'] == true)
                              ? Container(
                                  padding: EdgeInsets.only(
                                      bottom: media.width * 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        languages[choosenLanguage]
                                            ['text_ride_type'],
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * fourteen,
                                            color: textColor),
                                      ),
                                      Text(
                                        userRequestData['rental_package_name'],
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * fourteen,
                                            color: textColor),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages[choosenLanguage]['text_baseprice'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['base_price']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages[choosenLanguage]['text_distprice'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['distance_price']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages[choosenLanguage]['text_timeprice'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['time_price']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                            ],
                          ),
                          (userRequestData['requestBill']['data']
                                      ['cancellation_fee'] !=
                                  0)
                              ? SizedBox(
                                  height: media.height * 0.02,
                                )
                              : Container(),
                          (userRequestData['requestBill']['data']
                                      ['cancellation_fee'] !=
                                  0)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languages[choosenLanguage]
                                          ['text_cancelfee'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twelve,
                                          color: textColor),
                                    ),
                                    Text(
                                      userRequestData['requestBill']['data']
                                              ['requested_currency_symbol'] +
                                          ' ' +
                                          userRequestData['requestBill']['data']
                                                  ['cancellation_fee']
                                              .toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twelve,
                                          color: textColor),
                                    ),
                                  ],
                                )
                              : Container(),
                          (userRequestData['requestBill']['data']
                                      ['airport_surge_fee'] !=
                                  0)
                              ? SizedBox(
                                  height: media.height * 0.02,
                                )
                              : Container(),
                          (userRequestData['requestBill']['data']
                                      ['airport_surge_fee'] !=
                                  0)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languages[choosenLanguage]
                                          ['text_surge_fee'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twelve,
                                          color: textColor),
                                    ),
                                    Text(
                                      userRequestData['requestBill']['data']
                                              ['requested_currency_symbol'] +
                                          ' ' +
                                          userRequestData['requestBill']['data']
                                                  ['airport_surge_fee']
                                              .toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twelve,
                                          color: textColor),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages[choosenLanguage]
                                        ['text_waiting_price'] +
                                    ' (' +
                                    userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['waiting_charge_per_min']
                                        .toString() +
                                    ' x ' +
                                    userRequestData['requestBill']['data']
                                            ['calculated_waiting_time']
                                        .toString() +
                                    ' mins' +
                                    ')',
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['waiting_charge']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages[choosenLanguage]['text_convfee'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['admin_commision']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                            ],
                          ),
                          (userRequestData['requestBill']['data']
                                      ['promo_discount'] !=
                                  null)
                              ? SizedBox(
                                  height: media.height * 0.02,
                                )
                              : Container(),
                          (userRequestData['requestBill']['data']
                                      ['promo_discount'] !=
                                  null)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languages[choosenLanguage]
                                          ['text_discount'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twelve,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      userRequestData['requestBill']['data']
                                              ['requested_currency_symbol'] +
                                          ' ' +
                                          userRequestData['requestBill']['data']
                                                  ['promo_discount']
                                              .toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twelve,
                                          color: Colors.red),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages[choosenLanguage]['text_taxes'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['service_tax']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Container(
                            height: 1.5,
                            color: const Color(0xffE0E0E0),
                          ),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languages[choosenLanguage]['text_totalfare'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['total_amount']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twelve,
                                    color: textColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: media.height * 0.02,
                          ),
                          Container(
                            height: 1.5,
                            color: const Color(0xffE0E0E0),
                          ),
                          // SizedBox(height: media.height*0.02,),
                          SizedBox(
                            height: media.height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (userRequestData['payment_opt'] == '1')
                                    ? languages[choosenLanguage]['text_cash']
                                    : (userRequestData['payment_opt'] == '2')
                                        ? languages[choosenLanguage]
                                            ['text_wallet']
                                        : languages[choosenLanguage]
                                            ['text_card'],
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * sixteen,
                                    color: buttonColor),
                              ),
                              Text(
                                userRequestData['requestBill']['data']
                                        ['requested_currency_symbol'] +
                                    ' ' +
                                    userRequestData['requestBill']['data']
                                            ['total_amount']
                                        .toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: media.width * twentysix,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Button(
                      onTap: () async {
                        if (userRequestData['payment_opt'] == '0' &&
                            userRequestData['is_paid'] == 0) {
                          setState(() {
                            _isLoading = true;
                          });
                          await getWalletHistory();
                          setState(() {
                            _isLoading = false;
                            _choosePayment = true;
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Review()));
                        }
                      },
                      text: (userRequestData['payment_opt'] == '0' &&
                              userRequestData['is_paid'] == 0)
                          ? languages[choosenLanguage]['text_pay']
                          : languages[choosenLanguage]['text_confirm'])
                ],
              ),
            ),
            //choose payment method
            (_choosePayment == true)
                ? Positioned(
                    child: Container(
                    height: media.height * 1,
                    width: media.width * 1,
                    color: Colors.transparent.withOpacity(0.6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: media.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _choosePayment = false;
                                  });
                                },
                                child: Container(
                                  height: media.height * 0.05,
                                  width: media.height * 0.05,
                                  decoration: BoxDecoration(
                                    color: page,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.cancel, color: buttonColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: media.width * 0.025),
                        Container(
                          padding: EdgeInsets.all(media.width * 0.05),
                          width: media.width * 0.8,
                          height: media.height * 0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: page),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: media.width * 0.7,
                                  child: Text(
                                    languages[choosenLanguage]
                                        ['text_choose_payment'],
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * eighteen,
                                        fontWeight: FontWeight.w600),
                                  )),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      (walletBalance['stripe'] == true)
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  bottom: media.width * 0.025),
                                              alignment: Alignment.center,
                                              width: media.width * 0.7,
                                              child: InkWell(
                                                onTap: () async {
                                                  addMoney = double.parse(
                                                      userRequestData['requestBill']
                                                                  ['data']
                                                              ['total_amount']
                                                          .toStringAsFixed(2));
                                                  var val =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SelectWallet(
                                                                    from: '1',
                                                                  )));
                                                  if (val != null) {
                                                    if (val) {
                                                      setState(() {
                                                        _isLoading = true;
                                                        _choosePayment = false;
                                                      });
                                                      await getUserDetails();
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: media.width * 0.25,
                                                  height: media.width * 0.125,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/stripe-icon.png'),
                                                          fit: BoxFit.contain)),
                                                ),
                                              ))
                                          : Container(),
                                      (walletBalance['paystack'] == true)
                                          ? Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  bottom: media.width * 0.025),
                                              width: media.width * 0.7,
                                              child: InkWell(
                                                onTap: () async {
                                                  addMoney = int.parse(
                                                      userRequestData['requestBill']
                                                                  ['data']
                                                              ['total_amount']
                                                          .toStringAsFixed(0));
                                                  var val =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PayStackPage(
                                                                    from: '1',
                                                                  )));
                                                  if (val != null) {
                                                    if (val) {
                                                      setState(() {
                                                        _isLoading = true;
                                                        _choosePayment = false;
                                                      });
                                                      await getUserDetails();
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: media.width * 0.25,
                                                  height: media.width * 0.125,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/paystack-icon.png'),
                                                          fit: BoxFit.contain)),
                                                ),
                                              ))
                                          : Container(),
                                      (walletBalance['flutter_wave'] == true)
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  bottom: media.width * 0.025),
                                              alignment: Alignment.center,
                                              width: media.width * 0.7,
                                              child: InkWell(
                                                onTap: () async {
                                                  addMoney = double.parse(
                                                      userRequestData['requestBill']
                                                                  ['data']
                                                              ['total_amount']
                                                          .toStringAsFixed(2));
                                                  var val =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FlutterWavePage(
                                                                    from: '1',
                                                                  )));
                                                  if (val != null) {
                                                    if (val) {
                                                      setState(() {
                                                        _isLoading = true;
                                                        _choosePayment = false;
                                                      });
                                                      await getUserDetails();
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: media.width * 0.25,
                                                  height: media.width * 0.125,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/flutterwave-icon.png'),
                                                          fit: BoxFit.contain)),
                                                ),
                                              ))
                                          : Container(),
                                      (walletBalance['razor_pay'] == true)
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  bottom: media.width * 0.025),
                                              alignment: Alignment.center,
                                              width: media.width * 0.7,
                                              child: InkWell(
                                                onTap: () async {
                                                  addMoney = int.parse(
                                                      userRequestData['requestBill']
                                                                  ['data']
                                                              ['total_amount']
                                                          .toStringAsFixed(0));
                                                  var val =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  RazorPayPage(
                                                                    from: '1',
                                                                  )));
                                                  if (val != null) {
                                                    if (val) {
                                                      setState(() {
                                                        _isLoading = true;
                                                        _choosePayment = false;
                                                      });
                                                      await getUserDetails();
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: media.width * 0.25,
                                                  height: media.width * 0.125,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/razorpay-icon.jpeg'),
                                                          fit: BoxFit.contain)),
                                                ),
                                              ))
                                          : Container(),
                                      (walletBalance['cash_free'] == true)
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  bottom: media.width * 0.025),
                                              alignment: Alignment.center,
                                              width: media.width * 0.7,
                                              child: InkWell(
                                                onTap: () async {
                                                  addMoney = double.parse(
                                                      userRequestData['requestBill']
                                                                  ['data']
                                                              ['total_amount']
                                                          .toStringAsFixed(2));
                                                  var val =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CashFreePage(
                                                                    from: '1',
                                                                  )));
                                                  if (val != null) {
                                                    if (val) {
                                                      setState(() {
                                                        _isLoading = true;
                                                        _choosePayment = false;
                                                      });
                                                      await getUserDetails();
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: media.width * 0.25,
                                                  height: media.width * 0.125,
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/cashfree-icon.jpeg'),
                                                          fit: BoxFit.contain)),
                                                ),
                                              ))
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
                : Container(),

            if (_isLoading == true) const Positioned(child: Loading())
          ],
        ),
      ),
    );
  }
}
