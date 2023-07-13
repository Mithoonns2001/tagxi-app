import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocs;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/NavigatorPages/pickcontacts.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:location/location.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

// ignore: must_be_immutable
class DropLocation extends StatefulWidget {
  dynamic from;
  DropLocation({Key? key, this.from}) : super(key: key);

  @override
  State<DropLocation> createState() => _DropLocationState();
}

class _DropLocationState extends State<DropLocation>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  late PermissionStatus permission;
  Location location = Location();
  String _state = '';
  bool _isLoading = false;
  String sessionToken = const Uuid().v4();
  LatLng _center = const LatLng(41.4219057, -102.0840772);
  LatLng _centerLocation = const LatLng(41.4219057, -102.0840772);
  TextEditingController search = TextEditingController();
  String favNameText = '';
  bool _locationDenied = false;
  bool favAddressAdd = false;
  bool _showToast = false;
  bool _getDropDetails = false;
  TextEditingController buyerName = TextEditingController();
  TextEditingController buyerNumber = TextEditingController();
  TextEditingController instructions = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 1000);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _controller?.setMapStyle(mapStyle);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getLocs();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _controller?.setMapStyle(mapStyle);
      }
      if (locationAllowed == true) {
        if (positionStream == null || positionStream!.isPaused) {
          positionStreamData();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  //show toast for demo
  addToast() {
    setState(() {
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showToast = false;
      });
    });
  }

//get current location
  getLocs() async {
    permission = await location.hasPermission();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      setState(() {
        _state = '3';
        _isLoading = false;
      });
    } else if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited) {
      var locs = await geolocs.Geolocator.getLastKnownPosition();
      if (addressList.length != 2 && widget.from == null) {
        if (locs != null) {
          setState(() {
            _center = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
            _centerLocation = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
          });
        } else {
          var loc = await geolocs.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocs.LocationAccuracy.low);
          setState(() {
            _center = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
            _centerLocation = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
          });
        }
      } else if (widget.from != null && widget.from != 'add stop') {
        setState(() {
          buyerName.text = addressList[int.parse(widget.from) - 1].name;
          buyerNumber.text = addressList[int.parse(widget.from) - 1].number;
          instructions.text =
              (addressList[int.parse(widget.from) - 1].instructions != null)
                  ? addressList[int.parse(widget.from) - 1].instructions
                  : '';
          _center = addressList[int.parse(widget.from) - 1].latlng;
          _centerLocation = addressList[int.parse(widget.from) - 1].latlng;
          dropAddressConfirmation = addressList[int.parse(widget.from) - 1]
              .address; //remove in envato
        });
      } else if (widget.from == 'add stop') {
        if (locs != null) {
          setState(() {
            _center = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
            _centerLocation = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
          });
        } else {
          var loc = await geolocs.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocs.LocationAccuracy.low);
          setState(() {
            _center = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
            _centerLocation = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
          });
        }
      } else {
        setState(() {
          _center = addressList.firstWhere((e) => e.type == 'drop').latlng;
          _centerLocation =
              addressList.firstWhere((e) => e.type == 'drop').latlng;
          if (addressList.length >= 2) {
            dropAddressConfirmation = addressList
                .firstWhere((element) => element.type == 'drop')
                .address; //remove in envato
          }
        });
      }

      setState(() {
        _state = '3';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_getDropDetails == false || choosenTransportType == 0) {
          Navigator.pop(context);
          return true;
        } else {
          setState(() {
            _getDropDetails = false;
          });
          return false;
        }
      },
      child: Material(
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: page,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: media.height * 1,
                        width: media.width * 1,
                        child: (_state == '3')
                            ? GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
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
                                    // addToast();
                                    var val = await geoCoding(
                                        _centerLocation.latitude,
                                        _centerLocation.longitude);
                                    setState(() {
                                      _center = _centerLocation;
                                      dropAddressConfirmation = val;
                                    });
                                  } else {
                                    addAutoFill.clear();
                                    search.clear();
                                  }
                                },
                                minMaxZoomPreference:
                                    const MinMaxZoomPreference(8.0, 20.0),
                                myLocationButtonEnabled: false,
                                buildingsEnabled: false,
                                zoomControlsEnabled: false,
                                myLocationEnabled: true,
                              )
                            : (_state == '2')
                                ? Container(
                                    height: media.height * 1,
                                    width: media.width * 1,
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      width: media.width * 0.6,
                                      height: media.width * 0.3,
                                      decoration: BoxDecoration(
                                          color: page,
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 5,
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            languages[choosenLanguage]
                                                ['text_loc_permission'],
                                            style: GoogleFonts.roboto(
                                                fontSize: media.width * sixteen,
                                                color: textColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  _state = '';
                                                });
                                                await location
                                                    .requestPermission();
                                                getLocs();
                                              },
                                              child: Text(
                                                languages[choosenLanguage]
                                                    ['text_ok'],
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        media.width * twenty,
                                                    color: buttonColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
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
                          bottom: 0 + MediaQuery.of(context).viewInsets.bottom,
                          child: (_getDropDetails == false)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 20, left: 20),
                                      child: InkWell(
                                        onTap: () async {
                                          if (locationAllowed == true) {
                                            if (currentLocation != null) {
                                              _controller?.animateCamera(
                                                  CameraUpdate.newLatLngZoom(
                                                      currentLocation, 18.0));
                                              center = currentLocation;
                                            } else {
                                              _controller?.animateCamera(
                                                  CameraUpdate.newLatLngZoom(
                                                      center, 18.0));
                                            }
                                          } else {
                                            if (serviceEnabled == true) {
                                              setState(() {
                                                _locationDenied = true;
                                              });
                                            } else {
                                              await location.requestService();
                                              if (await geolocs
                                                  .GeolocatorPlatform.instance
                                                  .isLocationServiceEnabled()) {
                                                setState(() {
                                                  _locationDenied = true;
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: media.width * 0.1,
                                          width: media.width * 0.1,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 2,
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2)
                                              ],
                                              color: page,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.02)),
                                          child: const Icon(
                                              Icons.my_location_sharp),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.1,
                                    ),
                                    Container(
                                      color: page,
                                      width: media.width * 1,
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      child: Column(
                                        children: [
                                          Container(
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
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                                        color: const Color(
                                                                0xffFF0000)
                                                            .withOpacity(0.3)),
                                                    child: Container(
                                                      height:
                                                          media.width * 0.02,
                                                      width: media.width * 0.02,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                  0xffFF0000)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          media.width * 0.02),
                                                  Expanded(
                                                    child:
                                                        (dropAddressConfirmation ==
                                                                '')
                                                            ? Text(
                                                                languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_pickdroplocation'],
                                                                style: GoogleFonts.roboto(
                                                                    fontSize: media
                                                                            .width *
                                                                        twelve,
                                                                    color:
                                                                        hintColor),
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.7,
                                                                    child: Text(
                                                                      dropAddressConfirmation,
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        fontSize:
                                                                            media.width *
                                                                                twelve,
                                                                        color:
                                                                            textColor,
                                                                      ),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  (favAddress.length <
                                                                          4)
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            if (favAddress.where((element) => element['pick_address'] == dropAddressConfirmation).isEmpty) {
                                                                              setState(() {
                                                                                favSelectedAddress = dropAddressConfirmation;
                                                                                favLat = _center.latitude;
                                                                                favLng = _center.longitude;
                                                                                favAddressAdd = true;
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.favorite_outline,
                                                                            size:
                                                                                media.width * 0.05,
                                                                            color: favAddress.where((element) => element['pick_address'] == dropAddressConfirmation).isEmpty
                                                                                ? Colors.black
                                                                                : buttonColor,
                                                                          ),
                                                                        )
                                                                      : Container()
                                                                ],
                                                              ),
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            height: media.width * 0.03,
                                          ),
                                          Button(
                                              onTap: () async {
                                                if (dropAddressConfirmation !=
                                                    '') {
                                                  //remove in envato
                                                  if (choosenTransportType ==
                                                      0) {
                                                    if (addressList
                                                        .where((element) =>
                                                            element.type ==
                                                            'drop')
                                                        .isEmpty) {
                                                      addressList.add(AddressList(
                                                          id: '2',
                                                          type: 'drop',
                                                          address:
                                                              dropAddressConfirmation,
                                                          latlng: _center));
                                                    } else {
                                                      addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .address =
                                                          dropAddressConfirmation;
                                                      addressList
                                                          .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .type ==
                                                                  'drop')
                                                          .latlng = _center;
                                                    }
                                                  } else if (choosenTransportType ==
                                                      1) {
                                                    if (widget.from == null) {
                                                      if ((addressList
                                                          .where((element) =>
                                                              element.id == '2')
                                                          .isEmpty)) {
                                                        addressList.add(AddressList(
                                                            id: '2',
                                                            type: 'drop',
                                                            address:
                                                                dropAddressConfirmation,
                                                            latlng: _center,
                                                            instructions:
                                                                null));
                                                      } else {
                                                        addressList
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        '2')
                                                                .address =
                                                            dropAddressConfirmation;
                                                        addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    '2')
                                                            .latlng = _center;
                                                      }
                                                    }
                                                    setState(() {
                                                      _getDropDetails = true;
                                                    });
                                                  }
                                                  if (addressList.length == 2 &&
                                                      choosenTransportType ==
                                                          0) {
                                                    var val = await Navigator
                                                        .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookingConfirmation()));
                                                    if (val) {
                                                      setState(() {});
                                                    }
                                                  } else if (addressList.length >=
                                                          2 &&
                                                      buyerName
                                                          .text.isNotEmpty &&
                                                      buyerNumber
                                                          .text.isNotEmpty) {
                                                    if (addressList.length >=
                                                            2 &&
                                                        buyerName
                                                            .text.isNotEmpty &&
                                                        buyerNumber
                                                            .text.isNotEmpty &&
                                                        widget.from == null) {
                                                      var val = await Navigator
                                                          .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          BookingConfirmation()));
                                                      if (val) {
                                                        setState(() {});
                                                      }
                                                    } else if (addressList.length >=
                                                            2 &&
                                                        buyerName
                                                            .text.isNotEmpty &&
                                                        buyerNumber
                                                            .text.isNotEmpty &&
                                                        widget.from != null) {
                                                      Navigator.pop(
                                                          context, true);
                                                    } else if (addressList.length ==
                                                            1 &&
                                                        widget.from == '1' &&
                                                        buyerName
                                                            .text.isNotEmpty &&
                                                        buyerNumber
                                                            .text.isNotEmpty &&
                                                        widget.from != null) {
                                                      Navigator.pop(
                                                          context, true);
                                                    }
                                                  }
                                                }
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_confirm'])
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: media.height * 1,
                                  color: Colors.transparent.withOpacity(0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        color: page,
                                        width: media.width * 1,
                                        padding:
                                            EdgeInsets.all(media.width * 0.05),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: media.width * 0.9,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    (widget.from != '1')
                                                        ? languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_give_buyerdata']
                                                        : languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_give_userdata'],
                                                    style: GoogleFonts.roboto(
                                                        fontSize: media.width *
                                                            sixteen,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  InkWell(
                                                      onTap: () async {
                                                        var nav = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    PickContact(
                                                                        from:
                                                                            1)));
                                                        if (nav) {
                                                          setState(() {
                                                            buyerName.text =
                                                                pickedName;
                                                            buyerNumber.text =
                                                                pickedNumber;
                                                          });
                                                        }
                                                      },
                                                      child: const Icon(Icons
                                                          .contact_page_rounded))
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.03,
                                                  (languageDirection == 'rtl')
                                                      ? media.width * 0.04
                                                      : 0,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02),
                                                  color: page),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {});
                                                },
                                                controller: buyerName,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      languages[choosenLanguage]
                                                          ['text_name'],
                                                  hintStyle: GoogleFonts.roboto(
                                                      fontSize:
                                                          media.width * twelve),
                                                ),
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * twelve),
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.03,
                                                  (languageDirection == 'rtl')
                                                      ? media.width * 0.04
                                                      : 0,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02),
                                                  color: page),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {});
                                                },
                                                controller: buyerNumber,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: '',
                                                  hintText:
                                                      languages[choosenLanguage]
                                                          ['text_givenumber'],
                                                  hintStyle: GoogleFonts.roboto(
                                                      fontSize:
                                                          media.width * twelve),
                                                ),
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * twelve),
                                                maxLength: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.03,
                                                  (languageDirection == 'rtl')
                                                      ? media.width * 0.04
                                                      : 0,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              // height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02),
                                                  color: page),
                                              child: TextField(
                                                controller: instructions,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: '',
                                                  hintText:
                                                      languages[choosenLanguage]
                                                          ['text_instructions'],
                                                  hintStyle: GoogleFonts.roboto(
                                                      fontSize:
                                                          media.width * twelve),
                                                ),
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * twelve),
                                                maxLines: 4,
                                                minLines: 2,
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.03,
                                            ),
                                            Button(
                                              onTap: () async {
                                                if (widget.from != null &&
                                                    widget.from != 'add stop') {
                                                  addressList[int.parse(
                                                              widget.from) -
                                                          1]
                                                      .name = buyerName.text;
                                                  addressList[int.parse(
                                                                  widget.from) -
                                                              1]
                                                          .number =
                                                      buyerNumber.text;
                                                  addressList[int.parse(
                                                                  widget.from) -
                                                              1]
                                                          .address =
                                                      dropAddressConfirmation;
                                                  addressList[int.parse(
                                                              widget.from) -
                                                          1]
                                                      .latlng = _center;
                                                  addressList[int.parse(
                                                                  widget.from) -
                                                              1]
                                                          .instructions =
                                                      (instructions
                                                              .text.isNotEmpty)
                                                          ? instructions.text
                                                          : null;
                                                } else if (widget.from ==
                                                        'add stop' &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty) {
                                                  addressList.add(AddressList(
                                                      id: (addressList.length +
                                                              1)
                                                          .toString(),
                                                      type: 'drop',
                                                      address:
                                                          dropAddressConfirmation,
                                                      latlng: _center,
                                                      name: buyerName.text,
                                                      number: buyerNumber.text,
                                                      instructions:
                                                          (instructions.text
                                                                  .isNotEmpty)
                                                              ? instructions
                                                                  .text
                                                              : null));
                                                } else if (widget.from ==
                                                    null) {
                                                  if (buyerName
                                                          .text.isNotEmpty &&
                                                      buyerNumber
                                                          .text.isNotEmpty) {
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'pickup')
                                                            .name =
                                                        userDetails['name'];
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'pickup')
                                                            .number =
                                                        userDetails['mobile'];
                                                    addressList
                                                        .firstWhere((e) =>
                                                            e.type == 'drop')
                                                        .name = buyerName.text;
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'drop')
                                                            .number =
                                                        buyerNumber.text;
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'drop')
                                                            .instructions =
                                                        (instructions.text
                                                                .isNotEmpty)
                                                            ? instructions.text
                                                            : null;
                                                  }
                                                }

                                                if (addressList.length >= 2 &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty &&
                                                    widget.from == null) {
                                                  var val = await Navigator
                                                      .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BookingConfirmation()));
                                                  if (val) {
                                                    setState(() {});
                                                  }
                                                } else if (addressList.length >=
                                                        2 &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty &&
                                                    widget.from != null) {
                                                  Navigator.pop(context, true);
                                                } else if (addressList.length ==
                                                        1 &&
                                                    widget.from == '1' &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty &&
                                                    widget.from != null) {
                                                  Navigator.pop(context, true);
                                                }
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_confirm'],
                                              color:
                                                  (buyerName.text.isNotEmpty &&
                                                          buyerNumber
                                                              .text.isNotEmpty)
                                                      ? buttonColor
                                                      : Colors.grey,
                                              borcolor:
                                                  (buyerName.text.isNotEmpty &&
                                                          buyerNumber
                                                              .text.isNotEmpty)
                                                      ? buttonColor
                                                      : Colors.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                      //autofill address
                      Positioned(
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                media.width * 0.05,
                                MediaQuery.of(context).padding.top + 12.5,
                                media.width * 0.05,
                                0),
                            width: media.width * 1,
                            height: (addAutoFill.isNotEmpty)
                                ? media.height * 0.6
                                : null,
                            color: (addAutoFill.isEmpty)
                                ? Colors.transparent
                                : page,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                  color: Colors.black
                                                      .withOpacity(0.2),
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
                                      padding: EdgeInsets.fromLTRB(
                                          media.width * 0.05,
                                          0,
                                          media.width * 0.05,
                                          0),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 2)
                                          ],
                                          color: page,
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.05)),
                                      child: TextField(
                                          controller: search,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  (languageDirection == 'rtl')
                                                      ? EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.03)
                                                      : EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.042),
                                              border: InputBorder.none,
                                              hintText: languages[
                                                      choosenLanguage]
                                                  ['text_4lettersforautofill'],
                                              hintStyle: GoogleFonts.roboto(
                                                  fontSize:
                                                      media.width * twelve,
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
                                                            .contains(val
                                                                .toLowerCase()))
                                                    .isNotEmpty) {
                                                  addAutoFill.removeWhere(
                                                      (element) =>
                                                          element['description']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(val
                                                                  .toLowerCase()) ==
                                                          false);
                                                  storedAutoAddress
                                                      .where((element) =>
                                                          element['description']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(val
                                                                  .toLowerCase()))
                                                      .forEach((element) {
                                                    addAutoFill.add(element);
                                                  });
                                                  valueNotifierHome
                                                      .incrementNotifier();
                                                } else {
                                                  getAutoAddress(
                                                      val,
                                                      sessionToken,
                                                      _center.latitude,
                                                      _center.longitude);
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
                                        padding:
                                            EdgeInsets.all(media.width * 0.02),
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
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
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
                                                                    width: media
                                                                            .width *
                                                                        0.1,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                    ),
                                                                    child: const Icon(
                                                                        Icons
                                                                            .access_time),
                                                                  ),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      var val = await geoCodingForLatLng(
                                                                          addAutoFill[i]
                                                                              [
                                                                              'place_id']);
                                                                      setState(
                                                                          () {
                                                                        _center =
                                                                            val;
                                                                        dropAddressConfirmation =
                                                                            addAutoFill[i]['description'];

                                                                        _controller?.moveCamera(CameraUpdate.newLatLngZoom(
                                                                            _center,
                                                                            14.0));
                                                                      });
                                                                      FocusManager
                                                                          .instance
                                                                          .primaryFocus
                                                                          ?.unfocus();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      width: media
                                                                              .width *
                                                                          0.7,
                                                                      child: Text(
                                                                          addAutoFill[i]
                                                                              [
                                                                              'description'],
                                                                          style: GoogleFonts
                                                                              .roboto(
                                                                            fontSize:
                                                                                media.width * twelve,
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

                      //fav address
                      (favAddressAdd == true)
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: media.width * 0.1,
                                            width: media.width * 0.1,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: page),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  favName = '';
                                                  favAddressAdd = false;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.cancel_outlined),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      width: media.width * 0.9,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: page),
                                      child: Column(
                                        children: [
                                          Text(
                                            languages[choosenLanguage]
                                                ['text_saveaddressas'],
                                            style: GoogleFonts.roboto(
                                                fontSize: media.width * sixteen,
                                                color: textColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.025,
                                          ),
                                          Text(
                                            favSelectedAddress,
                                            style: GoogleFonts.roboto(
                                                fontSize: media.width * twelve,
                                                color: textColor),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.025,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    favName = 'Home';
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.01),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height:
                                                            media.height * 0.05,
                                                        width:
                                                            media.width * 0.05,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.2)),
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            (favName == 'Home')
                                                                ? Container(
                                                                    height: media
                                                                            .width *
                                                                        0.03,
                                                                    width: media
                                                                            .width *
                                                                        0.03,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                : Container(),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.01,
                                                      ),
                                                      Text(languages[
                                                              choosenLanguage]
                                                          ['text_home'])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    favName = 'Work';
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.01),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height:
                                                            media.height * 0.05,
                                                        width:
                                                            media.width * 0.05,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.2)),
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            (favName == 'Work')
                                                                ? Container(
                                                                    height: media
                                                                            .width *
                                                                        0.03,
                                                                    width: media
                                                                            .width *
                                                                        0.03,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                : Container(),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.01,
                                                      ),
                                                      Text(languages[
                                                              choosenLanguage]
                                                          ['text_work'])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    favName = 'Others';
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.01),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height:
                                                            media.height * 0.05,
                                                        width:
                                                            media.width * 0.05,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.2)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: (favName ==
                                                                'Others')
                                                            ? Container(
                                                                height: media
                                                                        .width *
                                                                    0.03,
                                                                width: media
                                                                        .width *
                                                                    0.03,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            : Container(),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            media.width * 0.01,
                                                      ),
                                                      Text(languages[
                                                              choosenLanguage]
                                                          ['text_others'])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          (favName == 'Others')
                                              ? Container(
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.025),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2)),
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_enterfavname'],
                                                        hintStyle: GoogleFonts
                                                            .roboto(
                                                                fontSize: media
                                                                        .width *
                                                                    twelve,
                                                                color:
                                                                    hintColor)),
                                                    maxLines: 1,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        favNameText = val;
                                                      });
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          Button(
                                              onTap: () async {
                                                if (favName == 'Others' &&
                                                    favNameText != '') {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  var val =
                                                      await addFavLocation(
                                                          favLat,
                                                          favLng,
                                                          favSelectedAddress,
                                                          favNameText);
                                                  setState(() {
                                                    _isLoading = false;
                                                    if (val == true) {
                                                      favLat = '';
                                                      favLng = '';
                                                      favSelectedAddress = '';
                                                      favNameText = '';
                                                      favName = 'Home';
                                                      favAddressAdd = false;
                                                    }
                                                  });
                                                } else if (favName == 'Home' ||
                                                    favName == 'Work') {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  var val =
                                                      await addFavLocation(
                                                          favLat,
                                                          favLng,
                                                          favSelectedAddress,
                                                          favName);
                                                  setState(() {
                                                    _isLoading = false;
                                                    if (val == true) {
                                                      favLat = '';
                                                      favLng = '';
                                                      favSelectedAddress = '';
                                                      favNameText = '';
                                                      favName = 'Home';
                                                      favAddressAdd = false;
                                                    }
                                                  });
                                                }
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_confirm'])
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
                                              color:
                                                  Colors.black.withOpacity(0.2))
                                        ]),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            width: media.width * 0.8,
                                            child: Text(
                                              languages[choosenLanguage]
                                                  ['text_open_loc_settings'],
                                              style: GoogleFonts.roboto(
                                                  fontSize:
                                                      media.width * sixteen,
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
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: buttonColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    _locationDenied = false;
                                                    _isLoading = true;
                                                  });

                                                  getLocs();
                                                },
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_done'],
                                                  style: GoogleFonts.roboto(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: buttonColor,
                                                      fontWeight:
                                                          FontWeight.w600),
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

                      //loader
                      (_isLoading == true)
                          ? const Positioned(child: Loading())
                          : Container(),
                      (internet == false)
                          ?

                          //no internet
                          Positioned(
                              top: 0,
                              child: NoInternet(
                                onTap: () {
                                  setState(() {
                                    internetTrue();
                                  });
                                },
                              ))
                          : Container()
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
