import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:railway/ui/home_screen.dart';
import 'ui/train_tracking/model.dart';
import 'ui/tickets.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:railway/utils/colors_file.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

bool refresh = true;
int counter = 0;
int counter1 = 0;
int counter2 = 0;
int counter3 = 0;
StreamSubscription _locationSubscription;
Location _locationTracker = Location();
Position _currentPosition;
Circle circle;
Marker marker;
var allMarkers = HashSet<Marker>();
List<Polyline> myPolyline = [];
BitmapDescriptor customMarker;
GoogleMapController _controller;
dynamic loca = LatLng(31.218610752908937, 29.942156790466374);
getTrainmarker() async {
  customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'images/train_png.png');
}

class Mapss extends StatefulWidget {
  const Mapss({Key key}) : super(key: key);
  @override
  _MapssState createState() => _MapssState();
}

class _MapssState extends State<Mapss> {
  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/train_png1.png");
    return byteData.buffer.asUint8List();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getTrainmarker();
      createPolyline();
      getcurrentlocation();
      checkstation();

      counter++;
      if (refresh == true) {
        Future.delayed(const Duration(seconds: 30), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
          allMarkers.clear();
        });
      }
    });
  }

  getrainlocation(int count, dynamic responsedata) async {
    LatLng loc = LatLng(responsedata[count.toString()]['lat'],
        responsedata[count.toString()]['lng']);
    print(loc.latitude.toString() + loc.longitude.toString());
    setState(() {
      loca = loc;
    });
    return loca;
  }

  @override
  Widget build(BuildContext context) {
    print(_currentPosition.toString());
    return WillPopScope(
        onWillPop: () => refreshstate(),
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            backgroundColor: blueAppColor,
            bottom: PreferredSize(
                preferredSize: Size.square(20),
                child: Container(
                    padding: EdgeInsets.only(bottom: 20),
                    // height: 200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  refresh = false;
                                });
                                Navigator.pop(context);
                                setState(() {
                                  refresh = false;
                                  allMarkers.clear();
                                  counter = 0;
                                });
                              },
                              icon: Icon(Icons.arrow_back)),
                          Container(
                            padding: const EdgeInsets.only(right: 30, left: 20),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Train Tracking",
                                  style: TextStyle(
                                    color: primaryAppColor,
                                    fontSize: 25,
                                  ),
                                )),
                          ),
                        ]))),
          ),
          body: _currentPosition == null
              ? Center(child: Container(child: Text('Loading Maps...')))
              : GoogleMap(
                  mapType: MapType.hybrid,
                  polylines: myPolyline.toSet(),
                  initialCameraPosition: CameraPosition(target: loca, zoom: 12),
                  onMapCreated: (GoogleMapController googleMapController) {
                    _controller = googleMapController;
                    allMarkers.add(
                      Marker(
                          markerId: MarkerId('train'),
                          icon: customMarker,
                          position: loca),
                    );
                  },
                  /*  coffeeShops.forEach((element) {
                        allMarkers.add(Marker(
                            markerId: MarkerId(element.stationName),
                            draggable: false,
                            infoWindow: InfoWindow(
                                title: element.stationName, snippet: element.address),
                            position: element.locationCoords));
                      });
                     */
                  markers: allMarkers,
                ),
        ));
  }

  void getcurrentlocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  createPolyline() {
    myPolyline.add(Polyline(
        polylineId: PolylineId('1'),
        color: Colors.blue,
        width: 3,
        points: [
          LatLng(31.218610752908937, 29.942156790466374),
          LatLng(31.031580857134745, 30.488025875983332),
          LatLng(30.783109054618496, 30.993628700680027),
          LatLng(30.499529362952416, 31.16089471138503),
          LatLng(30.06460723927716, 31.25022562739004),
          LatLng(30.010296924484695, 31.20634973839642),
          LatLng(28.096427875759424, 30.751405415724406),
          LatLng(27.1733740916874, 31.18388237941898),
          LatLng(26.562536076692133, 31.676018321525998),
          LatLng(26.164224517611014, 32.70147891152025),
          LatLng(25.70088137302431, 32.64300448065244),
          LatLng(24.1003693156064, 32.899116499355685),
        ]));
  }

  checkstation() async {
    print(startloc);
    print(endloc);
    if (startloc == 'Alex' && endloc == 'Damanhour') {
      dynamic response =
          await rootBundle.loadString('assets/json/alexdam.json');
      dynamic responsedata = await json.decode(response);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        setState(() {
          counter++;
        });
        getrainlocation(counter, responsedata);
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 25;
        });
        getrainlocation(counter, responsedata);
      }
    }
    if (startloc == 'Alex' && endloc == 'Tanta') {
      dynamic response =
          await rootBundle.loadString('assets/json/alexdam.json');
      dynamic responsedata = await json.decode(response);
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata[counter.toString()]['lat'] != Null) {
          setState(() {
            counter++;
          });
          getrainlocation(counter, responsedata);
        } else {
          setState(() {
            counter1++;
          });
          getrainlocation(counter1, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter1 = 25;
        });
        getrainlocation(counter1, responsedata1);
      }
    }
    if (startloc == 'Alex' && endloc == 'banha') {
      dynamic response =
          await rootBundle.loadString('assets/json/alexdam.json');
      dynamic responsedata = await json.decode(response);
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata[counter.toString()]['lat'] != Null) {
          setState(() {
            counter++;
          });
          getrainlocation(counter, responsedata);
        } else if (responsedata1[counter1.toString()]['lat'] != false) {
          setState(() {
            counter1++;
          });
          getrainlocation(counter1, responsedata1);
        } else
          setState(() {
            counter2++;
          });
        getrainlocation(counter2, responsedata2);
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter2 = 12;
        });
        getrainlocation(counter2, responsedata2);
      }
    }
    if (startloc == 'Alex' && endloc == 'Cairo') {
      dynamic response =
          await rootBundle.loadString('assets/json/alexdam.json');
      dynamic responsedata = await json.decode(response);
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      dynamic response3 =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata3 = await json.decode(response3);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata[counter.toString()]['lat'] != false) {
          setState(() {
            counter++;
          });
          getrainlocation(counter, responsedata);
        } else if (responsedata1[counter1.toString()]['lat'] != false) {
          setState(() {
            counter1++;
          });
          getrainlocation(counter1, responsedata1);
        } else if (responsedata2[counter2.toString()]['lat'] != false) {
          setState(() {
            counter2++;
          });
          getrainlocation(counter2, responsedata2);
        } else {
          setState(() {
            counter3++;
          });
          getrainlocation(counter3, responsedata3);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter3 = 29;
        });
        getrainlocation(counter3, responsedata3);
      }
    }
    if (startloc == 'Damanhour' && endloc == 'Alex') {
      dynamic response =
          await rootBundle.loadString('assets/json/alexdam.json');
      dynamic responsedata = await json.decode(response);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (counter == 0) {
          setState(() {
            counter = 26;
          });
        }
        setState(() {
          counter--;
        });
        getrainlocation(counter, responsedata);
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 25;
        });
        getrainlocation(counter, responsedata);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      }
    }
    if (startloc == 'Damanhour' && endloc == 'Tanta') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 26;
            });
          } else {
            setState(() {
              counter--;
            });
          }
          getrainlocation(counter, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 26;
        });
        getrainlocation(counter, responsedata1);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter1, responsedata1);
      }
    }
    if (startloc == 'Damanhour' && endloc == 'banha') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter1.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 26;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata1);
        } else if (responsedata2[counter2.toString()]['lat'] != false) {
          if (counter2 == 0) {
            setState(() {
              counter2 = 12;
            });
          }
          setState(() {
            counter2++;
          });
          getrainlocation(counter2, responsedata2);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata1);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter2 = 0;
        });
        getrainlocation(counter2, responsedata2);
      }
    }
    if (startloc == 'Damanhour' && endloc == 'Cairo') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      dynamic response3 =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata3 = await json.decode(response3);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 26;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata1);
        } else if (responsedata2[counter1.toString()]['lat'] != false) {
          if (counter1 == 0) {
            setState(() {
              counter1 = 26;
            });
          }
          setState(() {
            counter1--;
          });
          getrainlocation(counter1, responsedata2);
        } else if (responsedata2[counter2.toString()]['lat'] != false) {
          setState(() {
            if (counter3 == 0) {
              setState(() {
                counter3 = 26;
              });
            }
            counter3--;
          });
          getrainlocation(counter3, responsedata3);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata1);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter3 = 0;
        });
        getrainlocation(counter3, responsedata3);
      }
    }
    if (startloc == 'banha' && endloc == 'Cairo') {
      dynamic response =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata = await json.decode(response);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        setState(() {
          counter++;
        });
        getrainlocation(counter, responsedata);
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 29;
        });
        getrainlocation(counter, responsedata);
      }
    }
    if (startloc == 'banha' && endloc == 'Tanta') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata1 = await json.decode(response1);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 12;
            });
          } else {
            setState(() {
              counter--;
            });
          }
          getrainlocation(counter, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 12;
        });
        getrainlocation(counter, responsedata1);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter1, responsedata1);
      }
    }
    if (startloc == 'banha' && endloc == 'Damanhour') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata2[counter1.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 12;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata2);
        } else if (responsedata1[counter2.toString()]['lat'] != false) {
          if (counter2 == 0) {
            setState(() {
              counter2 = 26;
            });
          }
          setState(() {
            counter2--;
          });
          getrainlocation(counter2, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata1);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter2 = 0;
        });
        getrainlocation(counter2, responsedata2);
      }
    }
    if (startloc == 'banha' && endloc == 'Alex') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 12;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata1);
        } else if (responsedata2[counter1.toString()]['lat'] != false) {
          if (counter1 == 0) {
            setState(() {
              counter1 = 26;
            });
          }
          setState(() {
            counter1--;
          });
          getrainlocation(counter1, responsedata2);
        } else if (responsedata2[counter2.toString()]['lat'] != false) {
          setState(() {
            if (counter3 == 0) {
              setState(() {
                counter3 = 25;
              });
            }
            counter3--;
          });
          getrainlocation(counter3, responsedata2);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 12;
        });
        getrainlocation(counter, responsedata2);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter3 = 25;
        });
        getrainlocation(counter3, responsedata2);
      }
    }
    if (startloc == 'Tanta' && endloc == 'banha') {
      dynamic response =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata = await json.decode(response);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (counter == 0) {
          setState(() {
            counter = 12;
          });
        }
        setState(() {
          counter--;
        });
        getrainlocation(counter, responsedata);
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 12;
        });
        getrainlocation(counter, responsedata);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      }
    }
    if (startloc == 'Tanta' && endloc == 'Damanhour') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 26;
            });
          } else {
            setState(() {
              counter--;
            });
          }
          getrainlocation(counter, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata1);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 26;
        });
        getrainlocation(counter, responsedata1);
      }
    }
    if (startloc == 'Tanta' && endloc == 'Alex') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/alexdam.json');
      dynamic responsedata2 = await json.decode(response2);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 26;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata2);
        } else if (responsedata1[counter2.toString()]['lat'] != false) {
          if (counter2 == 0) {
            setState(() {
              counter2 = 25;
            });
          }
          setState(() {
            counter2--;
          });
          getrainlocation(counter2, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata2);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter2 = 0;
        });
        getrainlocation(counter2, responsedata1);
      }
    }
    if (startloc == 'Tanta' && endloc == 'Cairo') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 12;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata2);
        } else if (responsedata2[counter1.toString()]['lat'] != false) {
          if (counter1 == 0) {
            setState(() {
              counter1 = 29;
            });
          }
          setState(() {
            counter1--;
          });
          getrainlocation(counter1, responsedata2);
        } else if (responsedata2[counter2.toString()]['lat'] != false) {
          setState(() {
            if (counter3 == 0) {
              setState(() {
                counter3 = 25;
              });
            }
            counter3--;
          });
          getrainlocation(counter3, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 12;
        });
        getrainlocation(counter, responsedata1);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter3 = 29;
        });
        getrainlocation(counter3, responsedata1);
      }
    }
    if (startloc == 'Cairo' && endloc == 'Alex') {
      dynamic response =
          await rootBundle.loadString('assets/json/alexdam.json');
      dynamic responsedata = await json.decode(response);
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      dynamic response3 =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata3 = await json.decode(response3);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata3[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 29;
            });
            setState(() {
              counter--;
            });
            getrainlocation(counter, responsedata3);
          } else if (responsedata2[counter1.toString()]['lat'] != false) {
            if (counter1 == 0) {
              setState(() {
                counter3 = 12;
              });
              setState(() {
                counter1--;
              });
              getrainlocation(counter1, responsedata2);
            } else if (responsedata1[counter2.toString()]['lat'] != false) {
              if (counter1 == 0) {
                setState(() {
                  counter3 = 26;
                });
                setState(() {
                  counter2--;
                });
                getrainlocation(counter2, responsedata1);
              } else {
                if (counter3 == 0) {
                  setState(() {
                    counter3 = 25;
                  });
                }
                setState(() {
                  counter3--;
                });
                getrainlocation(counter3, responsedata);
              }
            } else if (asas.hour == DateTime.now().hour &&
                asas.minute == DateTime.now().minute) {
              setState(() {
                counter = 0;
              });
              getrainlocation(counter, responsedata3);
            } else if (bsbs.hour < DateTime.now().hour &&
                bsbs.minute < DateTime.now().minute) {
              setState(() {
                counter3 = 0;
              });
              getrainlocation(counter3, responsedata);
            }
          }
        }
      }
    }
    if (startloc == 'Cairo' && endloc == 'Damanhour') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/damtanta.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      dynamic response3 =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata3 = await json.decode(response3);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata3[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 26;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata3);
        } else if (responsedata2[counter1.toString()]['lat'] != false) {
          if (counter1 == 0) {
            setState(() {
              counter1 = 12;
            });
          }
          setState(() {
            counter1--;
          });
          getrainlocation(counter1, responsedata2);
        } else if (responsedata1[counter2.toString()]['lat'] != false) {
          setState(() {
            if (counter3 == 0) {
              setState(() {
                counter3 = 26;
              });
            }
            counter3--;
          });
          getrainlocation(counter3, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata3);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter3 = 0;
        });
        getrainlocation(counter3, responsedata1);
      }
    }
    if (startloc == 'Cairo' && endloc == 'banha') {
      dynamic response =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata = await json.decode(response);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        setState(() {
          if (counter == 0) {
            setState(() {
              counter = 29;
            });
          }
          counter--;
        });
        getrainlocation(counter, responsedata);
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 29;
        });
        getrainlocation(counter, responsedata);
      }
      if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter = 0;
        });
        getrainlocation(counter, responsedata);
      }
    }
    if (startloc == 'Cairo' && endloc == 'Tanta') {
      dynamic response1 =
          await rootBundle.loadString('assets/json/banhacairo.json');
      dynamic responsedata1 = await json.decode(response1);
      dynamic response2 =
          await rootBundle.loadString('assets/json/tantabanha.json');
      dynamic responsedata2 = await json.decode(response2);
      if (asas.hour > DateTime.now().hour &&
          asas.minute > DateTime.now().minute) {
        if (responsedata1[counter.toString()]['lat'] != false) {
          if (counter == 0) {
            setState(() {
              counter = 29;
            });
          }
          setState(() {
            counter--;
          });
          getrainlocation(counter, responsedata2);
        } else if (responsedata2[counter1.toString()]['lat'] != false) {
          if (counter1 == 0) {
            setState(() {
              counter1 = 12;
            });
          }
          setState(() {
            counter1--;
          });
          getrainlocation(counter1, responsedata1);
        }
      } else if (asas.hour == DateTime.now().hour &&
          asas.minute == DateTime.now().minute) {
        setState(() {
          counter = 29;
        });
        getrainlocation(counter, responsedata2);
      } else if (bsbs.hour < DateTime.now().hour &&
          bsbs.minute < DateTime.now().minute) {
        setState(() {
          counter3 = 0;
        });
        getrainlocation(counter3, responsedata1);
      }
    }
  }

  refreshstate() {
    setState(() {
      refresh = false;
    });
  }
}
