import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ptnsupplier/models/product_report_model.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/models/extrapoint_model.dart';
import 'package:ptnsupplier/models/extrapointdetail_model.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:intl/intl.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:ptnsupplier/scaffold/my_service.dart';

// import 'detail_view.dart';
// import 'detail_cart.dart';

class ListPointDetailReport extends StatefulWidget {
  final String? camp_id;
  final UserModel? userModel;
  final String? month;
  final String? year;
  ListPointDetailReport({Key? key, this.camp_id, this.userModel, this.month, this.year}) : super(key: key);

  @override
  _ListProductState createState() => _ListProductState();
}

//class
class Debouncer {
  // delay เวลาให้มีการหน่วง เมื่อ key searchview

  //Explicit
  final int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  //constructor
  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(microseconds: milliseconds!), action);
  }
}

class _ListProductState extends State<ListPointDetailReport> {
  // Explicit
  String? myCampID;
  List<PointReportDetailModel> pointReportDetailModel = []; // set array
  List<PointReportDetailModel> filterPointReportDetailModel = [];
  int? amontCart = 0;
  UserModel? myUserModel;
  String? searchString = '';
  String? totalPrice = '';
  int? amountListView = 6, page = 1;
  String? sort = 'asc';
  ScrollController scrollController = ScrollController();
  final Debouncer debouncer =
      Debouncer(milliseconds: 500); // ตั้งค่า เวลาที่จะ delay
  bool statusStart = true;

  final dateTime = DateTime.now();
  String? month = DateTimeFormat.format(DateTime.now(), format: 'm');
  String? monthname = DateTimeFormat.format(DateTime.now(), format: 'F');
  String? year = DateTimeFormat.format(DateTime.now(), format: 'Y');
  String? expTitle = '';
  String? expName = '';

  // Method
  @override
  void initState() {
    // auto load
    super.initState();
    myCampID = widget.camp_id;
    myUserModel = widget.userModel;
    month = widget.month;
    year = widget.year;
    createController(); // เมื่อ scroll to bottom
    setState(() {
      readData(); // read  ข้อมูลมาแสดง
    });
  }

  void createController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page = page! + 1;
        readData();
        //  print('in the end');

        // setState(() {
        //   amountListView = amountListView + 2;
        //   if (amountListView > filterPointReportDetailModel.length) {
        //     amountListView = filterPointReportDetailModel.length;
        //   }
        // });
      }
    });
  }

  Future<void> readData() async {
    // String? url = MyStyle().readAllProduct;
    int? memberId = myUserModel!.id;

    String? url =
        'https://ptnpharma.com/apisupplier/json_extrapoint_monthlyreport_detail.php?memberId=$memberId&searchKey=$searchString&page=$page&month=$month&year=$year&campId=$myCampID';

    // if (myIndex != 0) {
    //   url = '${MyStyle().readProductWhereMode}$myIndex';
    // }

    http.Response response = await http.get(Uri.parse(url));
    print('url readData ++++>>> $url');
    var result = json.decode(response.body);
    // print('result = $result');
    // print('url ListProduct ====>>>> $url');
    print('result ListProduct ========>>>>> $result');
    var itemProducts = result['itemsProduct'];

    for (var map in itemProducts) {
      PointReportDetailModel productAllModel = PointReportDetailModel.fromJson(map);
      setState(() {
        pointReportDetailModel.add(productAllModel);
        filterPointReportDetailModel = pointReportDetailModel;
      });
    }
    setState(() {
      totalPrice = result['totalPrice'];
      expName = result!['expName']!;
      expTitle = result!['expTitle']!;
    });
  }

  Widget showName() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.90, //0.7 - 50,
          child: Column(
            children: [
              Text(
                expName!,
                style: MyStyle().h3bStyle,
              ),Text(expTitle!),
            ],
          ),
        ),
      ],
    );
  }

  
  Widget showHeader() {
      return Container(
        width: MediaQuery.of(context).size.width * 0.90, //0.7 - 50,
        margin: EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.30, //0.7 - 50,
              child: Text(
                'ลูกค้า',
                style: MyStyle().h3bStyle,
              ),
            ),
             Container(
              width: MediaQuery.of(context).size.width * 0.30, //0.7 - 50,
              child: Text(
                'วันที่',
                style: MyStyle().h3bStyle,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.15, //0.7 - 50,
              child: Text(
              'จำนวน',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
              ),
            ),
          Container(
            width: MediaQuery.of(context).size.width * 0.15, //0.7 - 50,
            child: Text(
              'คะแนน',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ),
          ],
        ),
      );
  }

  Widget showDetail(int? index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90, //0.7 - 50,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.30, //0.7 - 50,
            child: Text(
              filterPointReportDetailModel[index!].customerCode!,
              style: MyStyle().h3bStyle,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.30, //0.7 - 50,
            child: Text(
            filterPointReportDetailModel[index!].datepost!,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
                        ),
          ),
        Container(
          width: MediaQuery.of(context).size.width * 0.15, //0.7 - 50,
          child: Text(
            filterPointReportDetailModel[index!].qty!,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ),
           Container(
          width: MediaQuery.of(context).size.width * 0.15, //0.7 - 50,
          child: Text(
            filterPointReportDetailModel[index].point!,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(0xff, 0, 0, 0),
            ),
          ),
        ),
        ],
      ),
    );
  }


  Widget showText(int? index) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      // height: MediaQuery.of(context).size.width * 0.5,
      width: MediaQuery.of(context).size.width *
          0.95, // MediaQuery.of(context).size.width * 0.80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showDetail(index),
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
        bottom: BorderSide(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
      ),
    );
  }

  Widget showProductItem() {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: pointReportDetailModel.length,
        itemBuilder: (BuildContext buildContext, int? index) {
          return GestureDetector(
            child: Container(
              padding:
                  EdgeInsets.only(top: 1.0, bottom: 1.0, left: 6.0, right: 6.0),
              child: Container(
                decoration: myBoxDecoration(),
                padding: EdgeInsets.only(bottom: 1.0, top: 1.0),
                child: Row(
                  children: <Widget>[
                    showText(index),
                    // showImage(index),
                  ],
                ),
              ),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget showProgressIndicate() {
    return Center(
      child:
          statusStart ? CircularProgressIndicator() : Text('Search not found'),
    );
  }

  Widget showLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget myLayout() {
    return Column(
      children: <Widget>[
        searchForm(),
        showProductItem(),
      ],
    );
  }

  Widget searchForm() {
    return Container(
      decoration: MyStyle().boxLightGray,
      // color: Colors.grey,
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 1.0, bottom: 1.0),
      child: ListTile(
        // trailing: IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {
        //       print('searchString? ===>>> $searchString');
        //       setState(() {
        //         page = 1;
        //         pointReportDetailModel.clear();
        //         readData();
        //       });
        //     }),
        title: TextField(
          decoration:
              InputDecoration(border: InputBorder.none, hintText: 'Search'),
          onChanged: (String? string) {
            searchString = string!.trim();
          },
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            setState(() {
              page = 1;
              pointReportDetailModel.clear();
              readData();
            });
          },
        ),
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

  Widget showContent() {
    return filterPointReportDetailModel.length == 0
        ? showProductItem() // showProgressIndicate()
        : showProductItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: Text('สรุปคะแนนพิเศษ'),
        actions: <Widget>[
          showHome(),
        ],
      ),
      // body: filterPointReportDetailModel.length == 0
      //     ? showProgressIndicate()
      //     : myLayout(),

      body: Column(
        children: <Widget>[
          // searchForm(),
          showName(),

                                                showHeader(),

          showContent(),
        ],
      ),
    );
  }
}
