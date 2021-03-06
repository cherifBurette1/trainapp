import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:railway/ApiFunctions/Api.dart';
import 'package:railway/models/trips_model.dart';
import 'package:railway/ui/signUp.dart';
import 'package:railway/ui/train_tracking/StationsRoute/stations_route.dart';
import 'package:railway/utils/colors_file.dart';
import 'package:railway/utils/custom_widgets/custom_button.dart';
import 'package:railway/utils/global_vars.dart';
import 'package:railway/utils/navigator.dart';
import 'package:mailer/mailer.dart';

import 'home_page.dart';

dynamic train_id;

sendMail(String mail) async {
  String username = "railwaymti@gmail.com";
  String password = "Ab1234566.";
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'railwayMTI')
    ..recipients.add(mail)
    ..subject = "Railway email verification"
    ..html =
        "<p>Railway MTI</p> <hr> <p>dear user,</p> <p>we are sending you this mail to notify you that you trip has been booked successfully and notifying you that no refunds are available under any circumstances</p> <p>Have a safe trip!</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('message not sent becase of ' + e.toString());
  }
}

class Trip {
  final int id;
  final String name;

  Trip({
    this.id,
    this.name,
  });
}

List<Trip> trips = [
  Trip(
    id: 0,
    name: "car 1",
  ),
  Trip(
    id: 1,
    name: "car 2",
  ),
  Trip(
    id: 2,
    name: "car 3",
  ),
  Trip(
    id: 3,
    name: "car 4",
  ),
  Trip(
    id: 4,
    name: "car 5",
  ),
  Trip(
    id: 5,
    name: "car 6",
  ),
];

class BookTicket extends StatefulWidget {
  final Success success;

  BookTicket({this.success});

  @override
  _BookTicketState createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  final GlobalKey<ScaffoldState> scafoldState = new GlobalKey<ScaffoldState>();

  final ticketsCounter = List.generate(100, (counter) => ++counter);

  counter() {
    int count = 0;
    for (int i = 0; i < widget.success.seats.length; i++) {
      if (widget.success.seats[i].status == "available") {
        count++;
      } else
        count = count;
    }
    return count;
  }

// List <Success> classA=<Success>[];
  List<Seats> classACar = <Seats>[];
  List<Seats> classBCar = <Seats>[];
  List<Seats> classCCar = <Seats>[];

  classACounter() {
    List<Seats> count = <Seats>[];
    for (int i = 0; i < widget.success.seats.length; i++) {
      if (widget.success.seats[i].car.level.Class == "A") {
        count.add(widget.success.seats[i]);
      } else
        count = count;
    }

    return classACar.addAll(count);
  }

  classBCounter() {
    List<Seats> count = <Seats>[];
    for (int i = 0; i < widget.success.seats.length; i++) {
      if (widget.success.seats[i].car.level.Class == "B") {
        count.add(widget.success.seats[i]);
      } else
        count = count;
    }

    return classBCar.addAll(count);
  }

  classCCounter() {
    List<Seats> count = <Seats>[];
    for (int i = 0; i < widget.success.seats.length; i++) {
      if (widget.success.seats[i].car.level.Class == "C") {
        count.add(widget.success.seats[i]);
      } else
        count = count;
    }

    return classCCar.addAll(count);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classACounter();
    classBCounter();
    classCCounter();
  }

  @override
  Widget build(BuildContext context) {
    print("classA ::: ${classACar.length}");
    print("classB ::: ${classBCar.length}");
    print("classC ::: ${classCCar.length}");
    return Scaffold(
      backgroundColor: whiteColor,
      key: scafoldState,
      appBar: AppBar(
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
                      onPressed: () => navigateAndClearStack(
                          context, HomePage(currentIndex: 1)),
                      icon: Icon(Icons.arrow_back)),
                  Container(
                    padding: const EdgeInsets.only(right: 30, left: 20),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Book A Ticket",
                          style: TextStyle(
                            color: primaryAppColor,
                            fontSize: 25,
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 30, left: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        "images/ticket.svg",
                        color: primaryAppColor,
                        width: 12,
                        height: 35,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.1,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "- Station :",
                        style: TextStyle(fontSize: 20, color: blueAppColor),
                      ),
                      InkWell(
                        onTap: () {
                          navigateAndKeepStack(
                              context, TripStations(success: widget.success));
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "View Train",
                            style: TextStyle(
                              fontSize: 14,
                              color: blackColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.success.baseStation.name,
                            style: TextStyle(fontSize: 20, color: blackColor),
                          ),
                          Icon(Icons.arrow_forward),
                          Text(
                            widget.success.destinationStation.name,
                            style: TextStyle(fontSize: 20, color: blackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "- Time :",
                    style: TextStyle(fontSize: 20, color: blueAppColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            widget.success.departTime,
                            style: TextStyle(fontSize: 18, color: blackColor),
                          ),
                          Icon(Icons.arrow_forward),
                          Text(
                            widget.success.arrivalTime,
                            style: TextStyle(fontSize: 18, color: blackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "- Choose Seat :",
                    style: TextStyle(fontSize: 20, color: blueAppColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  classACar.length == 0
                      ? Container()
                      : Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          color: Color(0xFFEEC800),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Class A",
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xFF7F5A01)),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton(
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: Color(0xffb8c3cb)),
                      isExpanded: true,
                      underline: SizedBox(),
                      dropdownColor: whiteColor,
                      style: TextStyle(color: blackColor),
                      value: train_id,
                      onChanged: (newValue) {
                        setState(() {
                          train_id = newValue;
                          print(train_id);
                        });
                      },
                      hint: Text('car 1'),
                      items: trips.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem.id,
                          child: Text(valueItem.name),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  classACar.length == 0
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 50,

                          child: GridView.builder(
                            itemCount: classACar.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1.5,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: classACar[index].status == "available"
                                      ? () {
                                          Api(context).bookTicketApi(
                                              scafoldState,
                                              classACar[index].id);
                                          sendMail(userEmail);
                                        }
                                      : () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          "images/seatIcon.svg",
                                          width: 50,
                                          color: classACar[index].status ==
                                                  "available"
                                              ? greenColor
                                              : redColor,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              top: 5),
                                          child:
                                              Text("${ticketsCounter[index]}"),
                                          // child: Text("1"),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  classBCar.length == 0
                      ? Container()
                      : Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          color: Colors.brown.shade400,
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Class B",
                                    style: TextStyle(
                                        fontSize: 20, color: whiteColor),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: DropdownButton(
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        color: Color(0xffb8c3cb)),
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    dropdownColor: whiteColor,
                                    style: TextStyle(color: blackColor),
                                    value: train_id,
                                    onChanged: (newValue) {
                                      setState(() {
                                        train_id = newValue;
                                        print(train_id);
                                      });
                                    },
                                    hint: Text('car 1'),
                                    items: trips.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem.id,
                                        child: Text(valueItem.name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ])),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  classBCar.length == 0
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 50,
                          child: GridView.builder(
                            itemCount: classBCar.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1.5,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: classBCar[index].status == "available"
                                      ? () {
                                          Api(context).bookTicketApi(
                                              scafoldState,
                                              classBCar[index].id);
                                          sendMail(userEmail);
                                        }
                                      : () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          "images/seatIcon.svg",
                                          width: 50,
                                          color: classBCar[index].status ==
                                                  "available"
                                              ? greenColor
                                              : redColor,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  25,
                                              top: 5),
                                          child:
                                              Text("${ticketsCounter[index]}"),
                                          // child: Text("1"),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Trip Seats :",
                            style: TextStyle(fontSize: 20, color: blueAppColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.success.seats.length}",
                            style: TextStyle(fontSize: 20, color: blueAppColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Available :",
                            style: TextStyle(fontSize: 20, color: blueAppColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${counter()}",
                            style: TextStyle(fontSize: 20, color: blueAppColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              // SizedBox(
              //   height: 50,
              // ),
              // CustomButton(
              //     bttnName: "Book",
              //     bttnHeight: 55,
              //     bttnWidth: 368,
              //     bttnNameSize: 18,
              //     onPress: () {}),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
