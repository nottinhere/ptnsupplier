import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ptnsupplier/main.dart';
import 'package:ptnsupplier/models/product_all_model.dart';
import 'package:ptnsupplier/models/promote_model.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/models/news_model.dart';

import 'package:ptnsupplier/scaffold/detail.dart';
import 'package:ptnsupplier/scaffold/list_product.dart';
import 'package:ptnsupplier/scaffold/list_product_outofstock.dart';
import 'package:ptnsupplier/scaffold/list_product_overstock.dart';
import 'package:ptnsupplier/scaffold/list_product_losesale.dart';
import 'package:ptnsupplier/scaffold/list_product_highdemand.dart';
import 'package:ptnsupplier/scaffold/list_product_monthlyreport.dart';
import 'package:ptnsupplier/scaffold/list_product_alert.dart';
import 'package:ptnsupplier/scaffold/list_deal_spacialprice.dart';
import 'package:ptnsupplier/scaffold/list_deal_closesale.dart';
import 'package:ptnsupplier/scaffold/list_deal_raise.dart';
import 'package:ptnsupplier/scaffold/list_extrapoint_monthlyreport.dart';


import 'package:ptnsupplier/scaffold/detail_news.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

class Home extends StatefulWidget {
  final UserModel? userModel;

  Home({Key? key, this.userModel}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Explicit
  // List<PromoteModel> promoteModels = [];
  List<Widget> promoteLists = [];
  List<String> urlImages = [];
  List<String> urlImagesSuggest = [];

  int amontCart = 0, banerIndex = 0, suggessIndex = 0, newsIndex = 0;
  UserModel? myUserModel;
  List<ProductAllModel> promoteModels = [];

  NewsModel? newsModel;
  String imageNews = '';
  String subjectNews = '';

  List<NewsModel>? newsModels = [];

  ScrollController scrollController = ScrollController();

  // Method
  @override
  void initState() {
    super.initState();
    readListNews();
    myUserModel = widget.userModel;
  }

  // Future<void> readNews() async {
  //   String? url = 'https://ptnpharma.com/apisupplier/json_supnewsdetail.php';
  //   http.Response response = await http.get(Uri.parse(url));
  //   var result = json.decode(response.body);
  //   var mapItemNews =
  //       result['itemsData']; // dynamic    จะส่ง value อะไรก็ได้ รวมถึง null
  //   for (var map in mapItemNews) {
  //     // PromoteModel promoteModel = PromoteModel.fromJson(map);
  //     NewsModel? newsModel = NewsModel.fromJson(map);
  //     String? urlImage = newsModel.photo;
  //     String? subject = newsModel.subject;
  //     setState(() {
  //       //promoteModels.add(promoteModel); // push ค่าลง arra
  //       subjectNews = subject!;
  //       imageNews = urlImage!;
  //     });
  //   }
  // }

  Future<void> readListNews() async {
    String? url =
        'https://www.ptnpharma.com/apisupplier/json_supnews.php?limit=7'; // ?memberId=$memberId
    print('urlNews >> $url');

    http.Response response = await http.get(Uri.parse(url));
    var result = json.decode(response.body);
    var mapItemNews =
        result['itemsData']; // dynamic    จะส่ง value อะไรก็ได้ รวมถึง null

    print('mapItemNews >> $mapItemNews');

    for (var map in mapItemNews) {
      NewsModel? newsModel = NewsModel.fromJson(map);
      // String? postdate = popupModel!.postdate!;
      // String? subject = popupModel!.subject!;
      setState(() {
        //promoteModels.add(promoteModel); // push ค่าลง array
        newsModels!.add(newsModel);
        // subjectList.add(subject);
        // postdateList.add(postdate);
      });
    }
    // print('newsModels.length (readNews) >> $newsModels ');
  }

  Image showImageNetWork(String urlImage) {
    return Image.network(urlImage);
  }

  Widget myCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  } 

  void routeToListProduct(int index) {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return ListProduct(
        index: index,
        userModel: myUserModel,
      );
    });
    Navigator.of(context).push(materialPageRoute);
  }

  Widget profileBox() {
    String login = myUserModel!.subject!;
    int loginStatus = myUserModel!.status!;

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.lightBlue.shade50,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 45.0,
                  child: Image.asset('images/icon_user.png'),
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  '$login', // 'ผู้แทน : $login',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click profile');
          // routeToListProduct(0);
        },
      ),
    );
  }

  // Widget newsBox() {
  //   String login = myUserModel!.subject!;
  //   return Container(
  //     width: MediaQuery.of(context).size.width * 0.9,
  //     // height: 80.0,
  //     child: GestureDetector(
  //       child: Card(
  //         // color: Colors.lightBlue.shade50,
  //         child: Container(
  //           padding: EdgeInsets.all(16.0),
  //           alignment: AlignmentDirectional(0.0, 0.0),
  //           child: Column(
  //             children: <Widget>[
  //               Text(
  //                 subjectNews, // 'ผู้แทน : $login',
  //                 style: TextStyle(
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black),
  //               ),
  //               SizedBox(
  //                 width: 10.0,
  //                 height: 8.0,
  //               ),
  //               Image.network(
  //                 imageNews,
  //                 width: MediaQuery.of(context).size.width * 0.9,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       onTap: () {
  //         print('This is News');
  //         // int? index;
  //         MaterialPageRoute materialPageRoute =
  //             MaterialPageRoute(builder: (BuildContext buildContext) {
  //           return DetailNews(
  //             // index: index,
  //             userModel: myUserModel,
  //           );
  //         });
  //         Navigator.of(context).push(materialPageRoute);
  //       },
  //     ),
  //   );
  // }

  Widget logoutBox() {
    String login = myUserModel!.subject!;
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.lightBlue.shade50,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 45.0,
                  child: Image.asset('images/icon_logout.png'),
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click logout');
          logOut();
        },
      ),
    );
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    await sharedPreferences.remove('user');
    await sharedPreferences.remove('password');

    // exit(0);
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (BuildContext buildContext) {
        return MyApp();
      },
    );
    Navigator.of(context).push(materialPageRoute);
  }

  Widget productList() {
    // all product
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_drugs.png'),
                ),
                Text(
                  'รายการสินค้า',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click promotion');
          routeToListProduct(0);
        },
      ),
    );
  }

  Widget outofStock() {
    // outofstock
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_outofstock.png'),
                ),
                Text(
                  'ขาดสต๊อก',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click newproduct');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListProductOutofstock(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget overStock() {
    // overstock
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_overstock3.png'),
                ),
                Text(
                  'ล้นสต๊อก',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click updateprice');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListProductOverstock(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget loseSale() {
    // losesale
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_losesale.png'),
                ),
                Text(
                  'ไม่เคลื่อนไหว',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click recommend');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListProductLosesale(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget detalSpecialPrice() {
    // overstock
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_dealspacialprice.png'),
                ),
                Text(
                  'รายการพิเศษ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click deal spacialprice');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListDealSpacialprice(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget dealClosesale() {
    // overstock
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_dealclosesale.png'),
                ),
                Text(
                  'เสนอปิดตัวเลข',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click monthly report');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListDealClosesale(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget report() {
    // overstock
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_report.png'),
                ),
                Text(
                  'สรุปรายเดือน',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click monthly report');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListProductReport(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

    Widget report_extrapoint() {
    // overstock
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_pointredeem.png'),
                ),
                Text(
                  'สรุปคะแนนพิเศษ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click monthly report');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListPointReport(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }



  Widget dealRaise() {
    // overstock
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_dealraise.png'),
                ),
                Text(
                  'แจ้งปรับราคา',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click monthly report');
          int? index;
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return ListDealRaise(
              index: index,
              userModel: myUserModel,
            );
          });
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget chart() {
    String webPage = 'chart';
    String login = myUserModel!.subject!;
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_chart.png'),
                ),
                Text(
                  'ชาร์ทยอดขาย',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click offer new item');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewExample(
                        userModel: myUserModel!,
                        webPage: webPage,
                      )));
        },
      ),
    );
  }

  Widget offerItem() {
    String webPage = 'offerItem';
    String login = myUserModel!.subject!;
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/offer.png'),
                ),
                Text(
                  'เสนอยาใหม่',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click offer new item');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewExample(
                        userModel: myUserModel,
                        webPage: webPage,
                      )));
        },
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.blueGrey.shade100,
          width: 1.0,
        ),
        // bottom: BorderSide(
        //   color: Colors.blueGrey.shade100,
        //   width: 1.0,
        // ),
      ),
    );
  }

    Widget listNews() {
    // print('newsModels.length (listNews) >> ' + newsModels!.length.toString());
    return ListView.builder(
      controller: scrollController,
      itemCount: newsModels!.length,
      itemBuilder: (BuildContext buildContext, int index) {
        return Column(
          children: [
            // Text(newsModels!.length.toString()),
            GestureDetector(
              child: Container(
                height: 70,
                child: Container(
                  decoration: myBoxDecoration(),
                  padding: EdgeInsets.only(top: 1.5),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          newsModels![index].subject!,
                          style: MyStyle().h3Style,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                MaterialPageRoute materialPageRoute =
                    MaterialPageRoute(builder: (BuildContext buildContext) {
                  return DetailNews(
                    newsModel: newsModels![index],
                    userModel: myUserModel!,
                  );
                });
                Navigator.of(context).push(materialPageRoute);
              },
            ),
          ],
        );
      },
    );
  }



  Widget showNews() {
    // print('newsModels.length (showNews) >> ' + newsModels!.length.toString());

    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.4,
        child: newsModels!.isNotEmpty ? listNews() : Container(),
      ),
    );
  }

  Widget logout() {
    // losesale
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      // height: 80.0,
      child: GestureDetector(
        child: Card(
          // color: Colors.green.shade100,
          child: Container(
            padding: EdgeInsets.all(16.0),
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 70.0,
                  child: Image.asset('images/icon_logout.png'),
                ),
                Text(
                  'ออกจากระบบ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('You click square logout');
          logOut();
        },
      ),
    );
  }

  Widget row1Menu() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        productList(),
        outofStock(),
      ],
    );
  }

  Widget row2Menu() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        overStock(),
        loseSale(),
      ],
    );
  }

  Widget row3Menu() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        detalSpecialPrice(),
        dealClosesale(),
      ],
    );
  }

  Widget row4Menu() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        offerItem(),
        dealRaise(),
      ],
    );
  }

  Widget row5Menu() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        report(),
        report_extrapoint(),
      ],
    );
  }

  Widget row6Menu() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.max,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // offerItem(),
        chart(),
        logout(),
      ],
    );
  }

  Widget mySizebox() {
    return SizedBox(
      width: 10.0,
      height: 10.0,
    );
  }

  Widget homeMenu() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      alignment: Alignment(0.0, 0.0),
      // color: Colors.green.shade50,
      // height: MediaQuery.of(context).size.height * 0.5 - 81,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          row1Menu(),
          mySizebox(),
          row2Menu(),
          mySizebox(),
          row3Menu(),
          mySizebox(),
          row4Menu(),
          mySizebox(),
          row5Menu(),
          mySizebox(),
          row6Menu(),
          // logoutBox(),
          mySizebox(),
          mySizebox(),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          
          headTitle('ข้อมูลของคุณ', Icons.verified_user),
          profileBox(),
          //    headTitle('Seggest Item',Icons.thumb_up),
          //  suggest(),
          headTitle('เมนู', Icons.home),
          homeMenu(),
          headTitle('ข่าวสาร', Icons.bookmark),
          // newsBox(),
          showNews(),
        ],
      ),
    );
  }

  void showMsg(String msg) {
    final state = ScaffoldMessenger.of(context);
    state.showSnackBar(SnackBar(content: Text(msg)));
  }

  
  String stateText = "";
    void showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        // adapter: DateTimePickerAdapter(),
        adapter: DateTimePickerAdapter(
                  type: PickerDateTimeType.kDMY,
                  value: DateTime.now().add(const Duration(days: 3)),
                ),
        title: Text("Select Data"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
          showMsg(picker.adapter.toString());

         setState(() {
          // var outputFormat = DateFormat('dd/MM/yyyy');
          // var outputDate = outputFormat.format(picker.adapter);
            // DateFormat dateFormat = DateFormat("dd/MM/yyyy");
            // DateTime dateTime = dateFormat.parse(picker.adapter.toString());

            // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(picker.adapter.toString());
            stateText = picker.adapter.toString();
          });     
    }).showDialog(context);
  }

  void showPickerDateRange(BuildContext context) {
    print("canceltext: ${PickerLocalizations.of(context).cancelText}");

    Picker ps = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
              type: PickerDateTimeType.kDMY,
              value: DateTime.now().add(const Duration(days: 3)),
        ),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        });

    Picker pe = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
              type: PickerDateTimeType.kDMY,
              value: DateTime.now().add(const Duration(days: 5)),
        ),        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
        });

    List<Widget> actions = [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(PickerLocalizations.of(context).cancelText ?? '')),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm?.call(ps, ps.selecteds);
            pe.onConfirm?.call(pe, pe.selecteds);
            // showMsg(ps.selecteds.toString() + 'To' +pe.selecteds.toString());
            showMsg(ps.adapter.toString() + 'To' +pe.adapter.toString());

          },
          child: Text(PickerLocalizations.of(context).confirmText ?? ''))
    ];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Date Range"),
            actions: actions,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("วันที่เริ่มรายการ:"),
                ps.makePicker(),
                Text("จนถึง:"),
                pe.makePicker()
              ],
            ),
          );
        });
  }



  Widget headTitle(String string, IconData iconData) {
    // Widget  แทน object ประเภทไดก็ได้
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            size: 24.0,
            color: MyStyle().textColor,
          ),
          mySizebox(),
          Text(
            string,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: MyStyle().textColor,
            ),
          ),
        ],
      ),
    );
  }
}


class WebViewExample extends StatefulWidget {
  final UserModel? userModel;
  final String? webPage;
  const WebViewExample({super.key, this.userModel, this.webPage});
  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  UserModel? myUserModel;
  String? mywebPage;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    mywebPage = widget.webPage;
    String? memberId = myUserModel!.id.toString();
    String? memberCode = myUserModel!.code.toString();
    String webPage = mywebPage.toString();


    String? urlView =
        'https://ptnpharma.com/supplier/pages/tables/salechart_mobile.php?mode=v&id=$memberId'; //
    String? txtTitle = 'หน้า.....';
    
    if (webPage == 'chart') {
      urlView =
          'https://ptnpharma.com/supplier/pages/tables/salechart_mobile.php?mode=v&id=$memberId'; //offerItem
      txtTitle = 'ชาร์ทยอดขาย';
    }else if (webPage == 'offerItem') {
      urlView =
          'https://ptnpharma.com/supplier/form_offermed_mobile.php?memberId=$memberId&memberCode=$memberCode'; //
      txtTitle = 'เสนอยาใหม่';
    } 
    /*
     else if (webPage == 'history') {
      urlView =
          'https://www.ptnpharma.com/shop/pages/tables/orderhistory_mb.php?memberId=$memberId&memberCode=$memberCode'; //
      txtTitle = 'ประวัติการสั่งซื้อ';
    } else if (webPage == 'reward') {
      urlView =
          'https://www.ptnpharma.com/shop/pages/tables/reward_list_mb.php?memberId=$memberId&memberCode=$memberCode'; //
      txtTitle = 'รายการของสมนาคุณ ';
    } else if (webPage == 'suggestion') {
      urlView =
          'https://www.ptnpharma.com/shop/pages/forms/complain_mobile.php?memberId=$memberId&memberCode=$memberCode'; //
      txtTitle = 'ข้อเสนอแนะ ';
    } else {
      urlView =
          'https://www.ptnpharma.com/shop/pages/forms/complain_mobile.php?memberId=$memberId&memberCode=$memberCode'; //
      txtTitle = 'แจ้งร้องเรียน';
    }
    */
    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(urlView));
    // #enddocregion webview_controller
  }


  // #docregion webview_widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          title:
              const Text('PTN Pharma', style: TextStyle(color: Colors.white))),
      body: WebViewWidget(controller: controller),
    );
  }
  // #enddocregion webview_widget
}


/****************************************************************************** 
class WebViewWidget extends StatefulWidget {
  WebViewWidget({Key? key}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sample WebView Widget"),
          backgroundColor: MyStyle().bgColor,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                child: TextButton(
                    child: Text("Open my Blog"),
                    onPressed: () {
                      print("in");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WebView()));
                    }),
              )
            ],
          ),
        ));
  }
}

class WebView extends StatefulWidget {
  final UserModel? userModel;

  WebView({Key? key, this.userModel}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  UserModel? myUserModel;

  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    String memberId = myUserModel!.id.toString();
    String memberCode = myUserModel!.code;
    String url =
        'https://ptnpharma.com/supplier/form_offermed_mobile.php?memberId=$memberId&memberCode=$memberCode'; //
    print('URL ==>> $url');
    return WebviewScaffold(
      url: url, //"https://www.androidmonks.com",
      appBar: AppBar(
        backgroundColor: MyStyle().barColor,
        title: Text("ฟอร์มเสนอยาใหม่"),
      ),
      withZoom: true,
      withJavascript: true,
      withLocalStorage: true,
      appCacheEnabled: false,
      ignoreSSLErrors: true,
    );
  }
}

class WebViewChartWidget extends StatefulWidget {
  WebViewChartWidget({Key? key}) : super(key: key);

  @override
  _WebViewChartWidgetState createState() => _WebViewChartWidgetState();
}

class _WebViewChartWidgetState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sample WebView Widget"),
          backgroundColor: MyStyle().bgColor,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                child: TextButton(
                    child: Text("Open my Blog"),
                    onPressed: () {
                      print("in");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewChart()));
                    }),
              )
            ],
          ),
        ));
  }
}

class WebViewChart extends StatefulWidget {
  final UserModel? userModel;

  WebViewChart({Key? key, this.userModel}) : super(key: key);

  @override
  _WebViewChartState createState() => _WebViewChartState();
}

class _WebViewChartState extends State<WebViewChart> {
  UserModel? myUserModel;

  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    String memberId = myUserModel!.id.toString();
    String memberCode = myUserModel!.code;
    String url =
        'https://ptnpharma.com/supplier/pages/tables/salechart_mobile.php?mode=v&id=$memberId'; //
    print('URL ==>> $url');
    return WebviewScaffold(
      url: url, //"https://www.androidmonks.com",
      appBar: AppBar(
        backgroundColor: MyStyle().barColor,
        title: Text("ชาร์ทเปรียบเทียบยอดขาย"),
      ),
      withZoom: true,
      withJavascript: true,
      withLocalStorage: true,
      appCacheEnabled: false,
      ignoreSSLErrors: true,
    );
  }
}
*/