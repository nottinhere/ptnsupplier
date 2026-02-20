import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:ptnsupplier/models/product_all_model.dart';
import 'package:ptnsupplier/models/deal_spacialprice_model.dart';
import 'package:ptnsupplier/scaffold/detail_deal_spacialprice.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:ptnsupplier/scaffold/my_service.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;

class ListDealSpacialprice extends StatefulWidget {
  // ListDealSpacialprice
  final int? index;
  final UserModel? userModel;
  final DealspacialpriceModel? dealModel;

  ListDealSpacialprice({Key? key, this.index, this.userModel, this.dealModel})
      : super(key: key);

  @override
  _ListDealSpacialpriceState createState() => _ListDealSpacialpriceState();
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

class _ListDealSpacialpriceState extends State<ListDealSpacialprice> {
  // Explicit
  int? myIndex;
  UserModel? myUserModel;
  List<DealspacialpriceModel> allDealModels = []; // set array
  List<DealspacialpriceModel> filterDealModels = [];

  String? searchString = '';

  int amountListView = 6, page = 1;
  String? sort = 'asc';
  ScrollController scrollController = ScrollController();
  final Debouncer debouncer =
      Debouncer(milliseconds: 500); // ตั้งค่า เวลาที่จะ delay
  bool statusStart = true;
  String? subjectMed = '';
  // Method
  @override
  void initState() {
    // auto load
    super.initState();
    myIndex = widget.index;
    myUserModel = widget.userModel;

    createController(); // เมื่อ scroll to bottom

    setState(() {
      readData(); // read  ข้อมูลมาแสดง
      // readCart();
    });
  }

  void createController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page = page! + 1;
        readData();
      }
    });
  }

  Future<void> readData() async {
    int? memberId = myUserModel!.id;
    if (page == 1) {
      filterDealModels = [];
    }
    String? url =
        'https://ptnpharma.com/apisupplier/json_deal_spacialprice.php?memberId=$memberId&searchKey=$searchString&page=$page&sort=$sort';
    http.Response response = await http.get(Uri.parse(url));
    var result = json.decode(response.body);
    print('url = $url');
    var itemDeal = result['itemsData'];
    for (var map in itemDeal) {
      DealspacialpriceModel dealModel = DealspacialpriceModel.fromJson(map);
      String? subject = dealModel.med;
      DealspacialpriceModel allDealModel = DealspacialpriceModel.fromJson(map);
      setState(() {
        allDealModels.add(allDealModel);
        filterDealModels = allDealModels;
      });
    }
  }

  Future<void> pulldown() async {
    setState(() {
      page = 1;
      filterDealModels.clear();
      readData();
    });
  }

  Color dealstatuscolor = Color.fromARGB(255, 0, 0, 0);
  Widget showName(int index) {
    if (filterDealModels[index].dealstatus == '0')
      dealstatuscolor = Color.fromARGB(255, 255, 0, 0);
    else if (filterDealModels[index].dealstatus == '1')
      dealstatuscolor = Color.fromARGB(255, 2, 117, 2);
    else if (filterDealModels[index].dealstatus == '2')
      dealstatuscolor = Color.fromARGB(255, 0, 0, 255);
    else if (filterDealModels[index].dealstatus == '3')
      dealstatuscolor = Color.fromARGB(255, 255, 92, 92);
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'สถานะดีล : ',
                style: TextStyle(
                  fontSize: 16.0,
                  // fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Text(
                filterDealModels[index].dealstatustxt!,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: dealstatuscolor,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.90, //0.7 - 50,
          child: Text(
            filterDealModels[index].med!,
            style: MyStyle().h3bStyle,
          ),
        ),
      ],
    );
  }

  Widget showDeal(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            // Icon(Icons.timer, color: Colors.green[500]),
            Text('ดีลสั่ง'),
            Text(
              filterDealModels[index].deal!,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
        Column(
          children: [
            // Icon(Icons.restaurant, color: Colors.green[500]),
            Text('แถม'),
            Text(
              filterDealModels[index].free!,
              style: TextStyle(
                fontSize: 16.0,
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
              filterDealModels[index].unit!,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
        Column(
          children: [
            // Icon(Icons.kitchen, color: Colors.green[500]),
            Text('ทุน'),
            Text(
              filterDealModels[index].cost!,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
      ],
    );
    // return Text('na');
  }

  Widget showDate(int index) {
    var str = filterDealModels[index].datepost;
    var parts = str!.split(' ');
    var datepostD = parts[0].trim();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            // Icon(Icons.kitchen, color: Colors.green[500]),
            Text('ช่วงจัดรายการ'),
            Text(
              filterDealModels[index].period!,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0xff, 0, 0, 0),
              ),
            ),
          ],
        ),
        Column(
          children: [
            // Icon(Icons.kitchen, color: Colors.green[500]),
            Text('วันที่แจ้ง'),
            Text(
              datepostD,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 119, 42, 42),
              ),
            ),
          ],
        ),
      ],
    );
    // return Text('na');
  }

  Widget showHilight(int index) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7 - 10,
          child: Text(
            filterDealModels[index].dbHilight!,
            style: MyStyle().h3StyleRed,
          ),
        ),
      ],
    );
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      // height: MediaQuery.of(context).size.width * 0.5,
      width: MediaQuery.of(context).size.width *
          0.95, // MediaQuery.of(context).size.width * 0.80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          showName(index),
          (filterDealModels[index].dbHilight != '')
              ? showHilight(index)
              : Container(),
          showDeal(index),
          showDate(index),
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Color.fromARGB(255, 20, 176, 189),
          width: 3.0,
        ),
        bottom: BorderSide(
          color: Color.fromARGB(255, 20, 176, 189),
          width: 3.0,
        ),
      ),
    );
  }

  Widget showProductItem() {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: filterDealModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return GestureDetector(
            child: Container(
              padding:
                  EdgeInsets.only(top: 3.0, bottom: 3.0, left: 6.0, right: 6.0),
              child: Card(
                // color: Color.fromRGBO(235, 254, 255, 1.0),

                child: Container(
                  decoration: myBoxDecoration(),
                  padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: Row(
                    children: <Widget>[
                      showText(index),
                      // showImage(index),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              MaterialPageRoute materialPageRoute =
                  MaterialPageRoute(builder: (BuildContext buildContext) {
                return DetailDealspacialprice(
                  dealModel: filterDealModels[index],
                  userModel: myUserModel,
                );
              });
              Navigator.of(context).push(materialPageRoute);
            },
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

  Widget searchForm() {
    return Container(
      decoration: MyStyle().boxLightGray,
      // color: Colors.grey,
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 1.0, bottom: 1.0),
      child: ListTile(
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
              filterDealModels.clear();
              readData();
            });
          },
        ),
      ),
    );
  }

  Widget sortButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10.0),
          child: SizedBox(
            height: 30.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 14)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                       builder: (context) => WebViewExample(
                        userModel: myUserModel!,
                        webPage: 'FormDeal',
                      )));
              },
              child: const Text('+ เสนอดีล'),
            ),
          ),
        ),
        Container(
          child: TextButton.icon(
              // color: Colors.red,
              icon: Icon(Icons.sort), //`Icon` to display
              label: Text('เรียงตามสถานะ'), //`Text` to display
              onPressed: () {
                print('searchString? ===>>> $searchString');
                setState(() {
                  page = 1;
                  sort = (sort == 'asc') ? 'desc' : 'asc';
                  filterDealModels.clear();
                  readData();
                });
              }),
        ),
      ],
    );
  }

  Widget showContent() {
    return filterDealModels.length == 0
        ? showProductItem() // showProgressIndicate()
        : showProductItem();
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
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: Text('เสนอรายการพิเศษ'),
        actions: <Widget>[
          showHome(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: pulldown,
        child: Column(
          children: <Widget>[
            searchForm(),
            sortButton(),
            showContent(),
          ],
        ),
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
        'https://ptnpharma.com/supplier/pages/forms/dealclosesale_mobile.php?mode=v&memberId=$memberId'; //
    String? txtTitle = 'หน้า.....';

    
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


class WebViewFromDeal extends StatefulWidget {
  final UserModel? userModel;

  WebViewFromDeal({Key? key, this.userModel}) : super(key: key);

  @override
  _WebViewFromDealState createState() => _WebViewFromDealState();
}

class _WebViewFromDealState extends State<WebViewFromDeal> {
  UserModel? myUserModel;

  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    String? memberId = myUserModel!.id.toString();
    String? memberCode = myUserModel!.code!;
    String? url =
        'https://ptnpharma.com/supplier/pages/forms/dealspacialprice_mobile.php?mode=v&memberId=$memberId'; //
    print('URL ==>> $url');
    return WebviewScaffold(
      url: url, //"https://www.androidmonks.com",
      appBar: AppBar(
        backgroundColor: Colors.lightBlue
        title: Text("ฟอร์มเสนอรายการพิเศษ"),
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