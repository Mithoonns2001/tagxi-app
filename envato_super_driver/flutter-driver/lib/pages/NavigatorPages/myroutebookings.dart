import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translation/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocs;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MyRouteBooking extends StatefulWidget {
  const MyRouteBooking({Key? key}) : super(key: key);

  @override
  State<MyRouteBooking> createState() => _MyRouteBookingState();
}

class _MyRouteBookingState extends State<MyRouteBooking> {
  bool _isLoading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        children: [
          Container(
            height: media.height * 1,
            width: media.width * 1,
            color: page,
            padding: EdgeInsets.all(media.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: media.width * 0.05),
                      width: media.width * 1,
                      alignment: Alignment.center,
                      child: Text(
                        languages[choosenLanguage]['text_my_route'],
                        style: GoogleFonts.roboto(
                            fontSize: media.width * twenty,
                            fontWeight: FontWeight.w600,
                            color: textColor),
                      ),
                    ),
                    Positioned(
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: const Icon(Icons.arrow_back)))
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Container(
                        padding: EdgeInsets.all(media.width * 0.05),
                        width: media.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: page,
                            border: Border.all(color: Colors.grey, width: 1.1)
                            // boxShadow: [
                            //   BoxShadow(
                            //     blurRadius: 1.0,
                            //     spreadRadius: 1.0,
                            //     color: Colors.black.withOpacity(0.4)
                            //   )
                            // ]
                            ),
                        child: (userDetails['my_route_address'] != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        languages[choosenLanguage]
                                            ['text_home_address'],
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      if (userDetails[
                                              'enable_my_route_booking'] !=
                                          1)
                                        InkWell(
                                            onTap: () async {
                                              var nav = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ChooseHomeAddress()));
                                              if (nav != null) {
                                                if (nav) {
                                                  setState(() {});
                                                }
                                              }
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              size: media.width * sixteen,
                                            ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: media.width * 0.025,
                                  ),
                                  SizedBox(
                                    width: media.width * 0.8,
                                    child: Text(
                                      userDetails['my_route_address'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * twelve),
                                    ),
                                  )
                                ],
                              )
                            : InkWell(
                                onTap: () async {
                                  var nav = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ChooseHomeAddress()));
                                  if (nav != null) {
                                    if (nav) {
                                      setState(() {});
                                    }
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      languages[choosenLanguage]
                                          ['text_add_home_address'],
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.025,
                                    ),
                                    const Icon(Icons.add)
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                )),
                if (userDetails['my_route_address'] != null)
                  Button(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        var dist = calculateDistance(
                            center.latitude,
                            center.longitude,
                            double.parse(
                                userDetails['my_route_lat'].toString()),
                            double.parse(
                                userDetails['my_route_lng'].toString()));

                        if (dist > 5000.0 ||
                            userDetails['enable_my_route_booking'] == "1") {
                          var val = await enableMyRouteBookings(
                              center.latitude, center.longitude);
                          if (val != 'success') {
                            setState(() {
                              _error = val;
                            });
                          }
                        } else {
                          _error = languages[choosenLanguage]
                              ['text_myroute_warning'];
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      text: (userDetails['enable_my_route_booking'] == 1)
                          ? languages[choosenLanguage]['text_disable_myroute']
                          : languages[choosenLanguage]['text_enable_myroute'])
              ],
            ),
          ),
          (_error != '')
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
                              SizedBox(
                                width: media.width * 0.8,
                                child: Text(
                                  _error.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * sixteen,
                                      color: textColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Button(
                                  onTap: () async {
                                    setState(() {
                                      _error = '';
                                    });
                                  },
                                  text: languages[choosenLanguage]['text_ok'])
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
    );
  }
}

class ChooseHomeAddress extends StatefulWidget {
  const ChooseHomeAddress({Key? key}) : super(key: key);

  @override
  State<ChooseHomeAddress> createState() => _ChooseHomeAddressState();
}

class _ChooseHomeAddressState extends State<ChooseHomeAddress> {
  GoogleMapController? _controller;
  TextEditingController search = TextEditingController();
  LatLng _centerLocation = center;
  String homeAddressConfirmation = '';
  LatLng homeAddressLatLng = center;
  FocusNode textFocus = FocusNode();
  bool _isLoading = false;
  String _error = '';
  String _success = '';
  bool _showToast = false;
  String sessionToken = const Uuid().v4();
  final _debouncer = Debouncer(milliseconds: 1000);
  bool _locationDenied = false;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _controller?.setMapStyle(mapStyle);
    });
  }

  getLocs() async {
    //  var permission = await location.hasPermission();

    //   if (permission == PermissionStatus.denied ||
    //       permission == PermissionStatus.deniedForever) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   } else if (permission == PermissionStatus.granted ||
    //       permission == PermissionStatus.grantedLimited) {
    //     var locs = await geolocs.Geolocator.getLastKnownPosition();
    //     if (locs != null) {
    //       setState(() {
    //         _center = LatLng(double.parse(locs.latitude.toString()),
    //             double.parse(locs.longitude.toString()));
    //         _centerLocation = LatLng(double.parse(locs.latitude.toString()),
    //             double.parse(locs.longitude.toString()));
    //       });
    //     } else {
    //       var loc = await geolocs.Geolocator.getCurrentPosition(
    //           desiredAccuracy: geolocs.LocationAccuracy.low);
    //       setState(() {
    //         _center = LatLng(double.parse(loc.latitude.toString()),
    //             double.parse(loc.longitude.toString()));
    //         _centerLocation = LatLng(double.parse(loc.latitude.toString()),
    //             double.parse(loc.longitude.toString()));
    //       });
    //     }
    var val = await geoCoding(center.latitude, center.longitude);
    setState(() {
      homeAddressConfirmation = val;
      homeAddressLatLng = center;
    });
    _controller?.animateCamera(CameraUpdate.newLatLngZoom(center, 14.0));
    // setState(() {
    //   _state = '3';
    //   _isLoading = false;
    // });
    // }
  }

  //show toast for demo
  addToast() {
    setState(() {
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showToast = false;
        });
      }
    });
  }

  @override
  void initState() {
    getLocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            return Container(
              height: media.height * 1,
              width: media.width * 1,
              color: page,
              child: Stack(children: [
                SizedBox(
                  height: media.height * 1,
                  width: media.width * 1,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: center,
                      zoom: 14.0,
                    ),
                    onCameraMove: (CameraPosition position) {
                      //pick current location
                      setState(() {
                        _centerLocation = position.target;
                      });
                    },
                    onCameraIdle: () async {
                      if (addAutoFill.isEmpty) {
                        var val = await geoCoding(_centerLocation.latitude,
                            _centerLocation.longitude);
                        setState(() {
                          homeAddressConfirmation = val;
                          homeAddressLatLng = _centerLocation;
                        });
                      } else {
                        addAutoFill.clear();
                        search.clear();
                      }
                    },
                  ),
                ),

                Positioned(
                    child: Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: (media.height / 2) - media.width * 0.08,
                      ),
                      Image.asset(
                        'assets/images/dropmarker.png',
                        width: media.width * 0.07,
                        height: media.width * 0.08,
                      ),
                    ],
                  ),
                )),

                Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          media.width * 0.05,
                          MediaQuery.of(context).padding.top + 12.5,
                          media.width * 0.05,
                          0),
                      width: media.width * 1,
                      height:
                          (addAutoFill.isNotEmpty) ? media.height * 0.6 : null,
                      color: (addAutoFill.isEmpty) ? Colors.transparent : page,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: media.width * 0.1,
                                  width: media.width * 0.1,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 2)
                                      ],
                                      color: page),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.arrow_back),
                                ),
                              ),
                              Container(
                                height: media.width * 0.1,
                                width: media.width * 0.75,
                                padding: EdgeInsets.fromLTRB(media.width * 0.05,
                                    0, media.width * 0.05, 0),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2)
                                    ],
                                    color: page,
                                    borderRadius: BorderRadius.circular(
                                        media.width * 0.05)),
                                child: TextField(
                                    focusNode: textFocus,
                                    controller: search,
                                    decoration: InputDecoration(
                                        contentPadding: (languageDirection ==
                                                'rtl')
                                            ? EdgeInsets.only(
                                                bottom: media.width * 0.03)
                                            : EdgeInsets.only(
                                                bottom: media.width * 0.042),
                                        border: InputBorder.none,
                                        hintText: languages[choosenLanguage]
                                            ['text_4lettersforautofill'],
                                        hintStyle: GoogleFonts.roboto(
                                            fontSize: media.width * twelve,
                                            color: hintColor)),
                                    maxLines: 1,
                                    onChanged: (val) {
                                      _debouncer.run(() {
                                        if (val.length >= 4) {
                                          if (storedAutoAddress
                                              .where((element) =>
                                                  element['description']
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains(
                                                          val.toLowerCase()))
                                              .isNotEmpty) {
                                            addAutoFill.removeWhere((element) =>
                                                element['description']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        val.toLowerCase()) ==
                                                false);

                                            storedAutoAddress
                                                .where((element) =>
                                                    element['description']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(
                                                            val.toLowerCase()))
                                                .forEach((element) {
                                              addAutoFill.add(element);
                                            });
                                            valueNotifierHome
                                                .incrementNotifier();
                                          } else {
                                            getAutoAddress(
                                                val,
                                                sessionToken,
                                                _centerLocation.latitude,
                                                _centerLocation.longitude);
                                          }
                                        } else if (val.isEmpty) {
                                          setState(() {
                                            addAutoFill.clear();
                                          });
                                        }
                                      });
                                    }),
                              )
                            ],
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          (addAutoFill.isNotEmpty)
                              ? Container(
                                  height: media.height * 0.45,
                                  padding: EdgeInsets.all(media.width * 0.02),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          media.width * 0.05),
                                      color: page),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: addAutoFill
                                          .asMap()
                                          .map((i, value) {
                                            return MapEntry(
                                                i,
                                                (i < 7)
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0,
                                                                media.width *
                                                                    0.04,
                                                                0,
                                                                media.width *
                                                                    0.04),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.1,
                                                              width:
                                                                  media.width *
                                                                      0.1,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .grey[200],
                                                              ),
                                                              child: const Icon(
                                                                  Icons
                                                                      .access_time),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                var val = await geoCodingForLatLng(
                                                                    addAutoFill[
                                                                            i][
                                                                        'place_id']);
                                                                setState(() {
                                                                  _centerLocation =
                                                                      val;
                                                                  homeAddressLatLng =
                                                                      val;
                                                                  homeAddressConfirmation =
                                                                      addAutoFill[
                                                                              i]
                                                                          [
                                                                          'description'];

                                                                  _controller?.moveCamera(
                                                                      CameraUpdate.newLatLngZoom(
                                                                          _centerLocation,
                                                                          14.0));
                                                                });
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                width: media
                                                                        .width *
                                                                    0.7,
                                                                child: Text(
                                                                    addAutoFill[
                                                                            i][
                                                                        'description'],
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      fontSize:
                                                                          media.width *
                                                                              twelve,
                                                                      color:
                                                                          textColor,
                                                                    ),
                                                                    maxLines:
                                                                        2),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container());
                                          })
                                          .values
                                          .toList(),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    )),

                Positioned(
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          child: InkWell(
                            onTap: () async {
                              // _controller?.animateCamera(CameraUpdate.newLatLngZoom(center, 18.0));
                              if (locationAllowed == true) {
                                _controller?.animateCamera(
                                    CameraUpdate.newLatLngZoom(center, 18.0));
                              } else {
                                if (serviceEnabled == true) {
                                  setState(() {
                                    _locationDenied = true;
                                  });
                                } else {
                                  await location.requestService();
                                  if (await geolocs.GeolocatorPlatform.instance
                                      .isLocationServiceEnabled()) {
                                    setState(() {
                                      _locationDenied = true;
                                    });
                                  }
                                }
                              }

                              // if (locationAllowed == true) {
                              //   if(currentLocation != null){
                              //     _controller?.animateCamera(
                              //         CameraUpdate.newLatLngZoom(
                              //             currentLocation, 18.0));
                              //             center = currentLocation;
                              //     }else{
                              //       _controller?.animateCamera(
                              //         CameraUpdate.newLatLngZoom(
                              //             center, 18.0));
                              //     }
                              // } else {
                              //   if (serviceEnabled == true) {
                              //     setState(() {
                              //       _locationDenied = true;
                              //     });
                              //   } else {
                              //     await location.requestService();
                              //     if (await geolocs
                              //         .GeolocatorPlatform.instance
                              //         .isLocationServiceEnabled()) {
                              //       setState(() {
                              //         _locationDenied = true;
                              //       });
                              //     }
                              //   }
                              // }
                            },
                            child: Container(
                              height: media.width * 0.1,
                              width: media.width * 0.1,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2)
                                  ],
                                  color: page,
                                  borderRadius: BorderRadius.circular(
                                      media.width * 0.02)),
                              child: const Icon(Icons.my_location_sharp),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.1,
                        ),
                        Container(
                          color: page,
                          width: media.width * 1,
                          padding: EdgeInsets.all(media.width * 0.05),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  textFocus.requestFocus();
                                },
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        media.width * 0.03,
                                        media.width * 0.01,
                                        media.width * 0.03,
                                        media.width * 0.01),
                                    height: media.width * 0.1,
                                    width: media.width * 0.9,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.02),
                                        color: page),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: media.width * 0.04,
                                          width: media.width * 0.04,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xff319900)
                                                  .withOpacity(0.3)),
                                          child: Container(
                                            height: media.width * 0.02,
                                            width: media.width * 0.02,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff319900)),
                                          ),
                                        ),
                                        SizedBox(width: media.width * 0.02),
                                        Expanded(
                                          child: (homeAddressConfirmation == '')
                                              ? Text(
                                                  languages[choosenLanguage][
                                                      'text_choose_homeaddress'],
                                                  style: GoogleFonts.roboto(
                                                      fontSize:
                                                          media.width * twelve,
                                                      color: hintColor),
                                                )
                                              : Text(
                                                  homeAddressConfirmation,
                                                  style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * twelve,
                                                    color: textColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: media.width * 0.1,
                              ),
                              Button(
                                  // onTap: () async {
                                  //   if (dropAddressConfirmation != '') {
                                  //     //remove in envato
                                  //     if (addressList
                                  //         .where((element) =>
                                  //             element.id == 'drop')
                                  //         .isEmpty) {
                                  //       addressList.add(AddressList(
                                  //           id: 'drop',
                                  //           address:
                                  //               dropAddressConfirmation,
                                  //           latlng: _center));
                                  //     } else {
                                  //       addressList
                                  //               .firstWhere((element) =>
                                  //                   element.id == 'drop')
                                  //               .address =
                                  //           dropAddressConfirmation;
                                  //       addressList
                                  //           .firstWhere((element) =>
                                  //               element.id == 'drop')
                                  //           .latlng = _center;
                                  //     }
                                  //     if (addressList.length == 2) {
                                  //       var val =
                                  //           await Navigator.pushReplacement(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                   builder: (context) =>
                                  //                       BookingConfirmation()));
                                  //       if (val) {
                                  //         setState(() {});
                                  //       }
                                  //     }
                                  //   }
                                  // },

                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    var add = await addHomeAddress(
                                        homeAddressLatLng.latitude,
                                        homeAddressLatLng.longitude,
                                        homeAddressConfirmation);
                                    if (add == 'success') {
                                      _success = languages[choosenLanguage]
                                          ['text_address_added_success'];
                                    } else {
                                      _error = add;
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  text: languages[choosenLanguage]
                                      ['text_confirm'])
                            ],
                          ),
                        ),
                      ],
                    )),

                (_locationDenied == true)
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
                                        _locationDenied = false;
                                      });
                                    },
                                    child: Container(
                                      height: media.height * 0.05,
                                      width: media.height * 0.05,
                                      decoration: BoxDecoration(
                                        color: page,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.cancel,
                                          color: buttonColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: media.width * 0.025),
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
                                        languages[choosenLanguage]
                                            ['text_open_loc_settings'],
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
                                            await perm.openAppSettings();
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
                                            setState(() {
                                              _locationDenied = false;
                                              _isLoading = true;
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

                (_error != '')
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
                                    SizedBox(
                                      width: media.width * 0.8,
                                      child: Text(
                                        _error.toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            color: textColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Button(
                                        onTap: () async {
                                          setState(() {
                                            _error = '';
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

                (_success != '')
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
                                    SizedBox(
                                      width: media.width * 0.8,
                                      child: Text(
                                        _success.toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            fontSize: media.width * sixteen,
                                            color: textColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Button(
                                        onTap: () async {
                                          setState(() {
                                            _success = '';
                                          });
                                          Navigator.pop(context, true);
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

                //display toast
                (_showToast == true)
                    ? Positioned(
                        top: media.height * 0.5,
                        child: Container(
                          width: media.width * 0.9,
                          margin: EdgeInsets.all(media.width * 0.05),
                          padding: EdgeInsets.all(media.width * 0.025),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: page),
                          child: Text(
                            'Auto address by scrolling map feature is not available in demo',
                            style: GoogleFonts.roboto(
                                fontSize: media.width * twelve,
                                color: textColor),
                            textAlign: TextAlign.center,
                          ),
                        ))
                    : Container(),

                //loader
                (_isLoading == true)
                    ? const Positioned(top: 0, child: Loading())
                    : Container()
              ]),
            );
          }),
    );
  }
}

class Debouncer {
  final int milliseconds;
  dynamic action;
  dynamic _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
