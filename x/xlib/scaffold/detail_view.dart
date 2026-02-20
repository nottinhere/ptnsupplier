import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ptnsupplier/models/product_all_model.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/scaffold/detail_cart.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:ptnsupplier/utility/normal_dialog.dart';
import 'package:ptnsupplier/scaffold/my_service.dart';

class DetailView extends StatefulWidget {
  final ProductAllModel ?productAllModel;
  final UserModel? userModel;

  DetailView({Key? key, this.productAllModel, this.userModel}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<DetailView> {
  // Explicit
  ProductAllModel? currentProductAllModel;
  ProductAllModel?  productAllModel;
  int amontCart = 0;
  UserModel? myUserModel;
  String? id; // productID

  String? txtdeal = '', txtfree = '', txtprice = '', txtnote = '';
  String? memberID;

  // Method
  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    myUserModel = widget.userModel;
    setState(() {
      getProductWhereID();
    });
  }

  Future<void> getProductWhereID() async {
    if (currentProductAllModel != null) {
      id = currentProductAllModel!.id.toString();
      String url = '${MyStyle().getProductWhereId}$id';
      print('url = $url');
      http.Response response = await http.get(Uri.parse(url));
      var result = json.decode(response.body);
      print('result detail = $result');

      var itemProducts = result['itemsProduct'];
      for (var map in itemProducts) {
        print('map = $map');

        setState(() {
          productAllModel = ProductAllModel.fromJson(map);
          // Map<String, dynamic> priceListMap = map['price_list'];
        });
      } // for
    }
  }

  Widget promotionTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.blue.shade400,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'โปรโมชัน',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click promotion');
          // routeToListProduct(2);
        },
      ),
    );
  }

  Widget updatepriceTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.blue.shade400,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'จะปรับราคา',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click update price');
          // routeToListProduct(3);
        },
      ),
    );
  }

  Widget recommendTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.blue.shade400,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'สินค้าแนะนำ',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click recommend');
          // routeToListProduct(3);
        },
      ),
    );
  }

  Widget newproductTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.blue.shade400,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'สินค้าใหม่',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click new item');
          // routeToListProduct(1);
        },
      ),
    );
  }

  Widget notreceiveTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.blue.shade400,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  'สั่งแล้วไม่ได้รับ',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click not receive');
          // routeToListProduct(4);
        },
      ),
    );
  }

  Widget cancelTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.red.shade800,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  productAllModel!.itemStatusText!,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click not receive');
          // routeToListProduct(4);
        },
      ),
    );
  }

  Widget showTag() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 5.0,
          height: 8.0,
        ),
        // productAllModel!.itemStatus == 0 ? cancelTag() : Container(),
        productAllModel!.itemStatus != 1 ? cancelTag() : Container(),
        (productAllModel!.promotion == 1 && productAllModel!.itemStatus == 1)
            ? promotionTag()
            : Container(),
        (productAllModel!.newproduct == 1 && productAllModel!.itemStatus == 1)
            ? newproductTag()
            : Container(),
        (productAllModel!.updateprice == 1 && productAllModel!.itemStatus == 1)
            ? updatepriceTag()
            : Container(),
        SizedBox(
          width: 5.0,
          height: 8.0,
        )
      ],
    );
  }

  Widget showHilight() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7 - 10,
          child: Text(
            productAllModel!.hilight!,
            style: MyStyle().h3StyleRed,
          ),
        ),
      ],
    );
  }

  Widget showTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productAllModel!.title!,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(0xff, 56, 80, 82),
          ),
        ),
        (productAllModel!.hilight != '') ? showHilight() : Container(),
      ],
    );
  }

  Widget showImage() {
    return Card(
      child: Container(
        // width: MediaQuery.of(context).size.width * 1.00,
        padding: new EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Code :' + productAllModel!.productCode!,
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(0xff, 16, 149, 161),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Stock',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    // color: Color.fromARGB(0xff, 16, 149, 161),
                  ),
                ),
                Text(
                  productAllModel!.percentStock! + '%',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    // color: Color.fromARGB(0xff, 16, 149, 161),
                  ),
                ),
              ],
            ),
            Image.network(
              productAllModel!.emotical!,
              width: MediaQuery.of(context).size.width * 0.16,
            ),
          ],
        ),
      ),
    );
  }

  Widget showStock() {
    return Card(
      child: Container(
        // width: MediaQuery.of(context).size.width * 1.00,
        padding: new EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Icon(Icons.restaurant, color: Colors.green[500]),
                Text('ขาย/เดือน'),
                Text(
                  productAllModel!.cMin!,
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
                Text('สต๊อก'),
                Text(
                  productAllModel!.sumStock!,
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
                Text('หน่วย'),
                Text(
                  productAllModel!.unitOrderShow!,
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
    );
  }

  Widget dealBox() {
    return Container(
      // decoration: MyStyle().boxLightGreen,
      // height: 35.0,
      width: MediaQuery.of(context).size.width * 0.40,
      padding: EdgeInsets.only(left: 10.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Text('จำนวนสั่ง '),
          Text(
            productAllModel!.dealOrder.toString(),
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

  Widget freeBox() {
    return Container(
      // decoration: MyStyle().boxLightGreen,
      // height: 35.0,
      width: MediaQuery.of(context).size.width * 0.40,
      padding: EdgeInsets.only(left: 20.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Text('แถม'),
          Text(
            productAllModel!.freeOrder.toString(),
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

  Widget priceBox() {
    return Container(
      // decoration: MyStyle().boxLightGreen,
      // height: 35.0,
      width: MediaQuery.of(context).size.width * 0.30,
      padding: EdgeInsets.only(left: 10.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Text('ราคา'),
          Text(
            productAllModel!.priceOrder!,
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

  Widget pricesaleBox() {
    return Container(
      // decoration: MyStyle().boxLightGreen,
      // height: 35.0,
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.only(left: 10.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Text('ราคาขาย'),
          Text(
            productAllModel!.priceSale! + '/' + productAllModel!.unitOrderShow!,
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

  Widget showFormDeal() {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                dealBox(),
                freeBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget showPrice() {
    return Card(
      child: Container(
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                priceBox(),
                pricesaleBox(),
              ],
            ),

            //  Row(children: <Widget>[priceBox(),priceBox(),],),
            //  Row(children: <Widget>[noteBox()],),
          ],
        ),
      ),
    );
  }

  Widget showPhoto() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5 - 50,
      child: Image.network(
        productAllModel!.photo!,
        fit: BoxFit.contain,
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
        title: Text('รายละเอียดข้อมูลสต๊อก'),
      ),
      body: productAllModel == null ? showProgress() : showDetailList(),
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

  ListView showController() {
    return ListView(
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        showTitle(),
        showTag(),
        showImage(),
        showStock(),
        showFormDeal(),
        showPrice(),
        showPhoto(),
        // submitButton(),
      ],
    );
  }
}
