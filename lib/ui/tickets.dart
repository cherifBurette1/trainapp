import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:railway/ApiFunctions/Api.dart';
import 'package:railway/models/tickets.dart';
import 'package:railway/utils/colors_file.dart';
import 'package:railway/utils/global_vars.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

int counter = 0;

class Tickets extends StatefulWidget {
  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  TicketsModel ticketsModel;
  List<Success> ticketsList = List();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      gettingData();
    });
//    showHud();
  }

  gettingData() {
    setState(() {
      Api(context).userTicketsApi(_scaffoldKey).then((value) {
        ticketsModel = value;
        ticketsModel.success.forEach((element) {
          setState(() {
            ticketsList.add(element);
          });
        });
      });
    });
  }

  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  Container(
                    padding: const EdgeInsets.only(right: 30, left: 20),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your Tickets",
                          style: TextStyle(
                            color: primaryAppColor,
                            fontSize: 25,
                          ),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${ticketsList.length}",
                        style: TextStyle(fontSize: 25, color: primaryAppColor),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10, left: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            "images/ticket.svg",
                            color: primaryAppColor,
                            width: 12,
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
          )),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ticketsList.length == 0
            ? Center(
                child: Text(
                  "You have no tickets.",
                  style: TextStyle(fontSize: 20, color: blueAppColor),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  // padding: EdgeInsets.all(20),
                  itemCount: ticketsList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                "images/ticket_sample1.png",
                                height: 130,
                                color: blackColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 200, top: 20),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${userId}",
                                style:
                                    TextStyle(fontSize: 15, color: whiteColor),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 200, top: 50),
                              alignment: Alignment.topCenter,
                              child: SvgPicture.asset(
                                "images/train.svg",
                                color: blueAppColor,
                                height: 30,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 200, top: 100),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${ticketsList[index].tripData.price} EGP",
                                style:
                                    TextStyle(fontSize: 15, color: whiteColor),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 200, top: 20),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${ticketsList[index].tripData.trip.baseStation.name.toString()}",
                                style:
                                    TextStyle(fontSize: 15, color: whiteColor),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${ticketsList[index].tripData.trip.destinationStation.name}",
                                style:
                                    TextStyle(fontSize: 15, color: whiteColor),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 200, top: 55),
                              alignment: Alignment.topCenter,
                              child: Icon(
                                Icons.airline_seat_recline_normal_sharp,
                                color: whiteColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 60),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Class ${ticketsList[index].tripData.Class}",
                                style:
                                    TextStyle(fontSize: 15, color: whiteColor),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 200, top: 100),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${ticketsList[index].tripData.trip.departTime.split(":")[0] + ":" + ticketsList[index].tripData.trip.departTime.split(":")[1]}",
                                style:
                                    TextStyle(fontSize: 15, color: whiteColor),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 100),
                              alignment: Alignment.topCenter,
                              child: Text(
                                "${ticketsList[index].tripData.trip.arrivalTime.split(":")[0] + ":" + ticketsList[index].tripData.trip.arrivalTime.split(":")[1]}",
                                style:
                                    TextStyle(fontSize: 15, color: whiteColor),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${ticketsList[index].ticketTime.split(".")[0].split("T")}",
                                style: TextStyle(color: blueAppColor),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: redColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Color(0xff1D1D1D),
                                          title: Text(
                                            "Delete Ticket ?",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Api(context).deleteTicketApi(
                                                      _scaffoldKey,
                                                      ticketsList[index]
                                                          .seatId);
                                                },
                                                child: Text(
                                                  "delete",
                                                )),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "cancel",
                                                )),
                                          ],
                                          content: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            child: Center(
                                              child: Text(
                                                " Delete This Ticket ?",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.save,
                                  color: Colors.pink,
                                ),
                                onPressed: () {
                                  _createPDF(
                                      "${userId}",
                                      "${ticketsList[index].tripData.trip.baseStation.name.toString()}",
                                      "${ticketsList[index].tripData.trip.destinationStation.name}",
                                      "${ticketsList[index].tripData.trip.departTime.split(":")[0] + ":" + ticketsList[index].tripData.trip.departTime.split(":")[1]}",
                                      "${ticketsList[index].tripData.trip.arrivalTime.split(":")[0] + ":" + ticketsList[index].tripData.trip.arrivalTime.split(":")[1]}",
                                      "${ticketsList[index].tripData.Class}",
                                      "${ticketsList[index].tripData.price} EGP");
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: blueAppColor,
                        )
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }

  Future<void> _createPDF(String id, String base, String dest, String dep,
      String arr, String class1, String price) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    document.pageSettings.size = PdfPageSize.a4;
    page.graphics.drawString('Railway',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold));
    page.graphics.drawString('________________________________________',
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold));
    drawGrid(id, base, dest, dep, arr, class1, price, page);
    //page.graphics.drawString('         ' + "ID:                  " + dest,
    //  PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold));
    /*   page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '         ' + "Base Station:                  " + base,
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '         ' + "Destination Station:                  " + dest,
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '         ' + "Departure Station:                  " + dep,
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '         ' + "arrival Station:                  " + arr,
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString('         ' + "Class:                  " + class1,
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString(
        '                                                          ',
        PdfStandardFont(PdfFontFamily.helvetica, 14));
    page.graphics.drawString('         ' + "Price:                  " + price,
        PdfStandardFont(PdfFontFamily.helvetica, 14)); */
    List<int> bytes = document.save();
    document.dispose();
    savePdfFile1(bytes);
  }

  Future<void> savePdfFile1(List<int> bytes) async {
    final dir = await getExternalStorageDirectory();
    print("Directoryyyyyyyyy:${dir.path}");

    final String path = "${dir.path}/flutter_sample$counter.pdf";
    counter++;
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(path);
  }

  static void drawGrid(String id, String base, String dest, String dep,
      String arr, String class1, String price, PdfPage page) {
    final grid = PdfGrid();
    grid.columns.add(count: 2);
    final headerrow = grid.headers.add(1)[0];
    headerrow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerrow.style.textBrush = PdfBrushes.white;
    headerrow.cells[0].value = 'Name';
    headerrow.cells[1].value = 'Value';
    headerrow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final row = grid.rows.add();
    row.cells[0].value = '   Id';
    row.cells[1].value = "   " + id;
    final row1 = grid.rows.add();
    row1.cells[0].value = '   Base Station';
    row1.cells[1].value = "   " + base;
    final row3 = grid.rows.add();
    row3.cells[0].value = '   Destination Station';
    row3.cells[1].value = "   " + dest;
    final row4 = grid.rows.add();
    row4.cells[0].value = '   Departure Time';
    row4.cells[1].value = "   " + dep;
    final row5 = grid.rows.add();
    row5.cells[0].value = '   Arrival Time';
    row5.cells[1].value = "   " + arr;
    final row6 = grid.rows.add();
    row6.cells[0].value = '   Class';
    row6.cells[1].value = "   " + class1;
    final row7 = grid.rows.add();
    row7.cells[0].value = '   Price';
    row7.cells[1].value = "   " + price;
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 40, 0, 0),
    );

    // row.cells[2].value = 'Base Station';
    // row.cells[3].value = base;
    // row.cells[4].value = 'Destination Station';
    // row.cells[5].value = dest;
    // row.cells[6].value = 'Departure Time';
    // row.cells[7].value = dep;
    // row.cells[8].value = 'Arrival Time';
    // row.cells[9].value = arr;
    // row.cells[10].value = 'Class';
    // row.cells[11].value = class1;
    // row.cells[10].value = 'Price';
    // row.cells[11].value = price;
  }
}
