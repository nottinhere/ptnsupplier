import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:ptnsupplier/models/product_all_model.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/scaffold/detail_cart.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:ptnsupplier/utility/normal_dialog.dart';
import 'package:ptnsupplier/models/deal_closesale_model.dart';
import 'package:ptnsupplier/scaffold/my_service.dart';

class DetailDealclosesale extends StatefulWidget {
  final DealclosesaleModel? dealModel;
  final UserModel? userModel;

  DetailDealclosesale({Key? key, this.dealModel, this.userModel})
      : super(key: key);

  @override
  _DetailDealclosesaleState createState() => _DetailDealclosesaleState();
}

class _DetailDealclosesaleState extends State<DetailDealclosesale> {
  // Explicit
  DealclosesaleModel? currentDealModel;
  DealclosesaleModel? dealModel;
  int? amontCart = 0;
  UserModel? myUserModel;
  String? id; // productID

  String? txtdeal = '', txtfree = '', txtprice = '', txtnote = '';
  String? memberID;

  // Method
  @override
  void initState() {
    super.initState();
    currentDealModel = widget.dealModel;
    myUserModel = widget.userModel;
    setState(() {
      getProductWhereID();
    });
  }

  Future<void> getProductWhereID() async {
    if (currentDealModel != null) {
      id = currentDealModel!.id.toString();
      int? memberId = myUserModel!.id;
      String? url =
          'https://ptnpharma.com/apisupplier/json_deal_closesale.php?memberId=$memberId&id=$id';

      http.Response response = await http.get(Uri.parse(url));
      var result = json.decode(response.body);
      var itemDeal = result['itemsData'];
      print('url = $url');
      print('itemDeal = $itemDeal');

      for (var map in itemDeal) {
        setState(() {
          DealclosesaleModel currentDealModel =
              DealclosesaleModel.fromJson(map);
        });
      }
    }
  }

  Color dealstatuscolor = Color.fromARGB(255, 0, 0, 0);
  Widget showTitle() {
    if (currentDealModel!.dealstatus == '0')
      dealstatuscolor = Color.fromARGB(255, 255, 0, 0);
    else if (currentDealModel!.dealstatus == '1')
      dealstatuscolor = Color.fromARGB(255, 2, 117, 2);
    else if (currentDealModel!.dealstatus == '2')
      dealstatuscolor = Color.fromARGB(255, 0, 0, 255);
    else if (currentDealModel!.dealstatus == '3')
      dealstatuscolor = Color.fromARGB(255, 255, 92, 92);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'สถานะดีล :',
          style: TextStyle(
            fontSize: 14.0,
            // fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        Text(
          currentDealModel!.dealstatustxt!,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: dealstatuscolor,
          ),
        ),
      ],
    );
  }

  Widget showName() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 255, 108, 92),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 255, 108, 92),
              width: 1.0,
            ),
          ),
        ),
        // width: MediaQuery.of(context).size.width * 1.00,
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text(
              currentDealModel!.med!,
              style: TextStyle(
                fontSize: 16.0,
                // fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 16, 149, 161),
              ),
            ),
            (currentDealModel!.dbHilight != '') ? showHilight() : Container(),
          ],
        ),
      ),
    );
  }

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 10.0,
    );
  }

  Widget showDBDeal() {
    return Card(
      color: Color.fromARGB(255, 230, 254, 255),
      shape: BeveledRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(255, 37, 241, 247),
          width: 0.7,
        ),
      ),
      child: Container(
        // width: MediaQuery.of(context).size.width * 1.00,
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Icon(Icons.restaurant, color: Colors.green[500]),
                      Text('จำนวนสั่ง'),
                      Text(
                        currentDealModel!.dbDeal!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(0xff, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // Icon(Icons.timer, color: Colors.green[500]),
                      Text('แถม'),
                      Text(
                        currentDealModel!.dbFree!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(0xff, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Icon(Icons.kitchen, color: Colors.green[500]),
                      Text('จำนวนต่ำสุด'),
                      Text(
                        currentDealModel!.dbCMin!, //dbcMin
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(0xff, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // Icon(Icons.restaurant, color: Colors.green[500]),
                      Text('ราคาทุน'),
                      Text(
                        currentDealModel!.dbPrice!,
                        style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 117, 25),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showDeal() {
    return Card(
      color: Color.fromARGB(255, 245, 245, 245),
      child: Container(
        // width: MediaQuery.of(context).size.width * 1.00,
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Icon(Icons.restaurant, color: Colors.green[500]),
                      Text('ยอด TARGET'),
                      Text(
                        currentDealModel!.target!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(0xff, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // Icon(Icons.timer, color: Colors.green[500]),
                      Text('ยอดที่สั่งแล้ว'),
                      Text(
                        currentDealModel!.currentorder!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(0xff, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // Icon(Icons.kitchen, color: Colors.green[500]),
                      Text('ยอดทีต้องสั่งเพิ่ม'),
                      Text(
                        currentDealModel!.balance!,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(0xff, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.70,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         children: [
            //           // Icon(Icons.restaurant, color: Colors.green[500]),
            //           Text('ยอดทีจะต้องสั่งเพิ่ม'),
            //           Text(
            //             currentDealModel!.balance,
            //             style: TextStyle(
            //               fontSize: 18.0,
            //               fontWeight: FontWeight.bold,
            //               color: Color.fromARGB(0xff, 0, 0, 0),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   width: 10.0,
            //   height: 10.0,
            // ),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // Icon(Icons.restaurant, color: Colors.green[500]),
                        Text('รายละเอียด'),
                        Text(
                          currentDealModel!.note!,
                          style: TextStyle(
                            overflow: TextOverflow.visible,
                            fontSize: 16.0,
                            // fontWeight: FontWeight.bold,
                            color: Color.fromARGB(0xff, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showMoredata() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 255, 108, 92),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 255, 108, 92),
              width: 1.0,
            ),
          ),
        ),
        padding: new EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            extraBox(),
            extraDateBox(),
            periodBox(),
            deadlineBox(),
            remarkBox(),
            datepostBox(),
          ],
        ),
      ),
    );
  }

  Widget extraBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'เมื่อปิดรายการแล้วทางร้านจะได้',
            textAlign: TextAlign.left,
          ),
          Text(
            currentDealModel!.extra!,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget extraDateBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'ช่วงเวลาที่ได้รับ',
            textAlign: TextAlign.left,
          ),
          Text(
            currentDealModel!.extraDate!,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget periodBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'ช่วงเวลาจัดรายการ เริ่ม - ถึง',
            textAlign: TextAlign.left,
          ),
          Text(
            currentDealModel!.period!,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget deadlineBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'สั่งซื้อได้ภายในวันที่',
            textAlign: TextAlign.left,
          ),
          Text(
            currentDealModel!.deadline!,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget remarkBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'หมายเหตุเพิ่มเติม',
            textAlign: TextAlign.left,
          ),
          Text(
            currentDealModel!.remark!,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget datepostBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'วันที่แจ้ง :',
            textAlign: TextAlign.left,
          ),
          Text(
            currentDealModel!.datepost!,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget showHome() {
    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 135, 135, 135),
            shape: CircleBorder(),
          ),
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: 25.0,
          ),
          onPressed: () {
            routeToHome();
          },
        ),
      ],
    );
  }

  void routeToHome() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyService(
        userModel: myUserModel,
      );
    });

    Navigator.of(context).pushAndRemoveUntil(
        materialPageRoute, // pushAndRemoveUntil  clear หน้าก่อนหน้า route with out airrow back
        (Route<dynamic> route) {
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          showHome(),
        ],
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: Text('รายการเสนอปิดตัวเลข'),
      ),
      body: currentDealModel == null ? showProgress() : showDetailList(),
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showDetailList() {
    return Stack(
      children: <Widget>[
        showController(),
        // addButton(),
      ],
    );
  }

  Widget showHilight() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7 - 10,
          child: Text(
            currentDealModel!.dbHilight!,
            style: MyStyle().h3StyleRed,
          ),
        ),
      ],
    );
  }

  ListView showController() {
    return ListView(
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        showTitle(),
        showName(),
        (currentDealModel!.dbPrice != '') ? showDBDeal() : Container(),
        showDeal(),
        showMoredata(),
        // showPhoto(),
        // submitButton(),
      ],
    );
  }
}
