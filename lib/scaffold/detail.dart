import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:ptnsupplier/models/product_all_model.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/scaffold/detail_cart.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:ptnsupplier/utility/normal_dialog.dart';
import 'package:ptnsupplier/scaffold/my_service.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';


class Detail extends StatefulWidget {
  final ProductAllModel? productAllModel;
  final UserModel? userModel;

  Detail({Key? key, this.productAllModel, this.userModel}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // Explicit
  ProductAllModel? currentProductAllModel;
  ProductAllModel? productAllModel;
  int amontCart = 0;
  UserModel? myUserModel;
  String? id; // productID

  String? txtdeal = '',
      txtfree = '',
      txtprice = '',
      txtpricelabel = '',
      txtpriceretail = '',
      txtnote = '',
      txtdetail = '',
      txtusefor = '',
      txtmethod = '',
      txtfda = '';
  String? memberID;

  late final WebViewController controller;


  // Method
  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    myUserModel = widget.userModel;
    setState(() {
      getProductWhereID();
      // readCart();
    });
  controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(
        Uri.parse(
          'https://your-url.com',
        ),
      );
    addFilesController(controller);
    
  }

  Future<void> addFilesController(WebViewController controllerV) async {
    if (Platform.isAndroid) {
      var controller = (controllerV.platform
          as webview_flutter_android.AndroidWebViewController);
      await controller.setOnShowFileSelector(_androidFilePicker);
    }
  }
  
   Future<List<String>> _androidFilePicker(
    webview_flutter_android.FileSelectorParams params,
  ) async {
    if (params.acceptTypes.any((type) => type == 'image/*')) {
      var picker = image_picker.ImagePicker();
      var photo =
          await picker.pickImage(source: image_picker.ImageSource.gallery);

      if (photo == null) {
        return [];
      }

      var imageData = await photo.readAsBytes();
      var decodedImage = image.decodeImage(imageData)!;
      var scaledImage = image.copyResize(decodedImage, width: 500);
      var jpg = image.encodeJpg(scaledImage, quality: 90);

      var filePath = (await getTemporaryDirectory()).uri.resolve(
            './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
          );
      var file = await File.fromUri(filePath).create(recursive: true);
      await file.writeAsBytes(jpg, flush: true);

      return [file.uri.toString()];
    }

    return [];
  }

  Future<void> getProductWhereID() async {
    if (currentProductAllModel != null) {
      id = currentProductAllModel!.id.toString();
      String url = '${MyStyle().getProductWhereId}$id';
      print('url = $url');
      http.Response response = await http.get(Uri.parse(url));
      var result = json.decode(response.body);
      print('result = $result');

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
                      fontSize: 10,
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
                  'Stock : ',
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
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Text('จำนวนสั่ง'),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue:
                productAllModel!.dealOrder.toString(), // set default value
            keyboardType: TextInputType.number,
            onChanged: (string) {
              txtdeal = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
              //border: InputBorder.none,
              hintText: 'จำนวนสั่ง',
              hintStyle: TextStyle(color: Colors.grey),
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
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Text('แถม'),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue:
                productAllModel!.freeOrder.toString(), // set default value
            keyboardType: TextInputType.number,
            onChanged: (string) {
              txtfree = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
              // border: InputBorder.none,
              hintText: 'แถม',
              hintStyle: TextStyle(color: Colors.grey),
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
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Text('ราคาทุน'),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue: productAllModel!.priceOrder, // set default value
            // keyboardType: TextInputType.number,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),

            onChanged: (string) {
              txtprice = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
              // border: InputBorder.none,
              hintText: 'ราคา',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget pricelabelBox() {
    return Container(
      // decoration: MyStyle().boxLightGreen,
      // height: 35.0,
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.only(left: 10.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Text('ราคาป้าย'),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue: productAllModel!.priceLabel, // set default value
            keyboardType: TextInputType.number,
            onChanged: (string) {
              txtpricelabel = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
              // border: InputBorder.none,
              hintText: 'ราคา',
              hintStyle: TextStyle(color: Colors.grey),
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
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.only(left: 10.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Text('ราคาแนะนำขายปลีก'),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue: productAllModel!.priceRetail, // set default value
            keyboardType: TextInputType.number,
            onChanged: (string) {
              txtpriceretail = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
              // border: InputBorder.none,
              hintText: 'ราคา',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget noteBox() {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        onChanged: (value) {
          txtnote = value.trim();
        },
        keyboardType: TextInputType.multiline,
        maxLines: 2,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
            labelText: 'Note'),
      ),
    );
  }

  Widget fdaBox() {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        onChanged: (value) {
          txtfda = value.trim();
        },
        initialValue: productAllModel!.fda, // set default value
        keyboardType: TextInputType.multiline,
        maxLines: 2,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
            labelText: 'เลขทะเบียน อ.ย. '),
      ),
    );
  }

  Widget useforBox() {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        onChanged: (value) {
          txtusefor = value.trim();
        },
        initialValue: productAllModel!.usefor, // set default value
        keyboardType: TextInputType.multiline,
        maxLines: 2,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
            labelText: 'ใช้รักษา'),
      ),
    );
  }

  Widget methodBox() {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        onChanged: (value) {
          txtmethod = value.trim();
        },
        initialValue: productAllModel!.method, // set default value
        keyboardType: TextInputType.multiline,
        maxLines: 2,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
            labelText: 'วิธีการใช้'),
      ),
    );
  }

  Widget detailBox() {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        onChanged: (value) {
          txtdetail = value.trim();
        },
        initialValue: productAllModel!.detail, // set default value
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.mode_edit, color: Colors.grey),
            labelText: 'รายละเอียด'),
      ),
    );
  }

  Widget showFormDeal() {
    return Card(
      child: Column(
        children: <Widget>[
          Card(
            color: Color.fromRGBO(230, 254, 255, 1),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromRGBO(37, 241, 247, 1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'รายการสั่งซื้อจากตารางสั่งซื้อ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(0xff, 0, 0, 0),
                  ),
                ),
                Row(
                  children: <Widget>[
                    dealBox(),
                    freeBox(),
                  ],
                ),
                Row(
                  children: <Widget>[
                    priceBox(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        children: <Widget>[
                          Text('ราคาขายส่ง'),
                          Text(
                            productAllModel!.priceSale! +
                                '/' +
                                productAllModel!.unitOrderShow!,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(0xff, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Row(
            children: <Widget>[
              pricelabelBox(),
              pricesaleBox(),
            ],
          ),
          useforBox(),
          methodBox(),
          detailBox(),
          fdaBox(),
          noteBox(),
          //  Row(children: <Widget>[priceBox(),priceBox(),],),
          //  Row(children: <Widget>[noteBox()],),
        ],
      ),
    );
  }

  Future<void> submitThread() async {
    // try {
    var medID = currentProductAllModel!.id;
    // String url =
    //     'https://ptnpharma.com/apisupplier/json_submit_deal.php?memberId=$memberID&medId=$medID&deal_order=$txtdeal&free_order=$txtfree&price_order=$txtprice&price_label=$txtpricelabel&price_retail=$txtpriceretail'; // &note=$txtnote&method=$txtmethod&usefor=$txtusefor&fda=$txtfda;

    String url =
        'https://ptnpharma.com/apisupplier/json_submit_deal.php'; // &note=$txtnote&method=$txtmethod&usefor=$txtusefor&fda=$txtfda;
    print('submitDeal >> $url');
    print(
        'Data option >> note : $txtnote |  method : $txtmethod | usefor : $txtusefor | fda : $txtfda |');

    // await http.get(Uri.parse(url)).then((value) {
    //   confirmSubmit();
    // });

    await http.post(Uri.parse(url), body: {
      'memberId': memberID,
      'medId': medID.toString(),
      'deal_order': txtdeal,
      'free_order': txtfree,
      'price_order': txtprice,
      'price_label': txtpricelabel,
      'price_retail': txtpriceretail,
      'note': txtnote,
      'detail': txtdetail,
      'method': txtmethod,
      'usefor': txtusefor,
      'fda': txtfda
    }).then((value) {
      confirmSubmit();
    });
    // } catch (e) {}
  }

  Future<void> confirmSubmit() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Complete'),
            content: Text('แก้ไขดีลเรียบร้อย'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    backProcess();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  void backProcess() {
    Navigator.of(context).pop();
  }

  Widget submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 30.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // color: Color.fromARGB(0xff, 13, 163, 93),
            onPressed: () {
              memberID = myUserModel!.id.toString();
              var medID = currentProductAllModel!.id;

              txtdeal = txtdeal!.replaceAll(',', '');
              txtfree = txtfree!.replaceAll(',', '');
              txtprice = txtprice!.replaceAll(',', '');
              txtpricelabel = txtpricelabel!.replaceAll(',', '');
              txtpriceretail = txtpriceretail!.replaceAll(',', '');
              print(
                  'memberId=$memberID&medId=$medID&deal_order=$txtdeal&free_order=$txtfree&price_order=$txtprice&note=$txtnote');

              submitThread();
            },
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
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

  Widget buttonMoreData() {
    
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
               print('Webview > ' +currentProductAllModel!.title!);
             Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewExample(
                        userModel: myUserModel!,
                        productAllModel : currentProductAllModel,
                        webPage: 'Webview',
                      )));
            },
            child: Text('จัดการรูปและลิงก์', style: TextStyle(fontSize: 16,color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.00, right: 10.00),
          ),
          ElevatedButton(
            onPressed: () {
              print('WebPreview > ' +currentProductAllModel!.title!);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                       builder: (context) => WebViewExample(
                        userModel: myUserModel!,
                        productAllModel : currentProductAllModel,
                       webPage: 'WebPreview',
                      )));
            },
            child: const Text('ดูตัวอย่าง', style: TextStyle(fontSize: 16,color: Colors.white)),
             style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget showPackage(int index) {
    return Text(productAllModel!.unitOrderShow!);
  }

  Widget showChoosePricePackage(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        showDetailPrice(index),
        // incDecValue(index),
      ],
    );
  }

  Widget showDetailPrice(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showPackage(index),
      ],
    );
  }

  Widget showPrice() {
    return Container(
      height: 150.0,
      // color: Colors.grey,
      child: ListView.builder(
        // itemCount: unitSizeModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return showChoosePricePackage(index); // showDetailPrice(index);
        },
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
        title: Text('แก้ไขข้อมูลสต๊อก'),
      ),
      body: productAllModel == null ? showProgress() : showDetailList(),
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Widget addButton() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           Expanded(
  //             child: ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 primary: Colors.lightGreen,
  //               ),
  //               // color: Colors.lightGreen,
  //               child: Text(
  //                 'Update deal',
  //                 style: TextStyle(
  //                     color: Colors.black, fontWeight: FontWeight.bold),
  //               ),
  //               onPressed: () {
  //                 String productID = id;
  //                 String memberID = myUserModel!.id.toString();

  //                 int index = 0;
  //                 List<bool> status = [];

  //                 bool sumStatus = true;
  //                 if (status.length == 1) {
  //                   sumStatus = status[0];
  //                 } else {
  //                   sumStatus = status[0] && status[1];
  //                 }

  //                 if (sumStatus) {
  //                   normalDialog(
  //                       context, 'Do not choose item', 'Please choose item');
  //                 } else {}
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Future<void> addCart(
  //     String productID, String unitSize, int qTY, String memberID) async {
  //   String url =
  //       'https://ptnsupplier.com/api/json_savemycart.php?productID=$productID&unitSize=$unitSize&QTY=$qTY&memberID=$memberID';

  //   http.Response response = await http.get(url).then((response) {
  //     print('upload ok');
  //     readCart();
  //     MaterialPageRoute materialPageRoute =
  //         MaterialPageRoute(builder: (BuildContext buildContext) {
  //       return DetailCart(
  //         userModel: myUserModel,
  //       );
  //     });
  //     Navigator.of(context).push(materialPageRoute);
  //   });
  // }

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
        submitButton(),
        showPhoto(),
        buttonMoreData(),
      ],
    );
  }
}

// class WebViewWidget extends StatefulWidget {
//   WebViewWidget({Key? key}) : super(key: key);

//   @override
//   _WebViewWidgetState createState() => _WebViewWidgetState();
// }

// class _WebViewWidgetState extends State {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Sample WebView Widget"),
//           backgroundColor: MyStyle().bgColor,
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Container(
//                 child: TextButton(
//                     child: Text("Open my Blog"),
//                     onPressed: () {
//                       print("in");
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => WebViewExample()));
//                     }),
//               )
//             ],
//           ),
//         ));
//   }
// }

class WebViewExample extends StatefulWidget {
  final UserModel? userModel;
  final ProductAllModel? productAllModel;
  final String? webPage;
  const WebViewExample({super.key, this.userModel,this.productAllModel,  this.webPage});
  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  UserModel? myUserModel;
  ProductAllModel? currentProductAllModel;
  String? mywebPage;
  late final WebViewController? controller;

  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    currentProductAllModel = widget.productAllModel;
    mywebPage = widget.webPage;

    String? memberId = myUserModel!.id.toString();
    String? productId = currentProductAllModel!.id.toString();
    String? memberCode = myUserModel!.code!;
    String? webPage = mywebPage.toString();


    String? urlView =
        'https://ptnpharma.com/supplier/pages/blueimp/product_mobile.php?mode=u&sup_id=$memberId&id=$productId'; 
    String? txtTitle = 'หน้า.....';
    
    if (webPage == 'chart') {
      urlView =
          'https://ptnpharma.com/supplier/pages/tables/salechart_mobile.php?mode=v&id=$memberId'; //
      txtTitle = 'ชาร์ทยอดขาย';
    } else if (webPage == 'Webview') {
      urlView =
          'https://ptnpharma.com/supplier/pages/blueimp/product_mobile.php?mode=u&sup_id=$memberId&id=$productId'; //
      txtTitle = 'ประวัติการสั่งซื้อ';
    } else if (webPage == 'WebPreview') {
      urlView =
          'https://ptnpharma.com/shop/pages/forms/product_preview.php?mode=v&id=$productId&sup_id=$memberId'; //
      txtTitle = 'รายการของสมนาคุณ ';
    }
    print('urlView > $urlView');
        /*
     else if (webPage == 'suggestion') {
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
      body: WebViewWidget(controller: controller!),
    );
  }

  
  // #enddocregion webview_widget
}


/*
class WebView extends StatefulWidget {
  final ProductAllModel ?productAllModel;
  final UserModel? userModel;

  WebView({Key? key, this.productAllModel, this.userModel}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  ProductAllModel? currentProductAllModel;
  UserModel? myUserModel;

  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    myUserModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    String? memberId = myUserModel!.id.toString();
    String? productId = currentproductAllModel!.id.toString();
    String? memberCode = myUserModel!.code!;
    String? url =
        'https://ptnpharma.com/supplier/pages/blueimp/product_mobile.php?mode=u&sup_id=$memberId&id=$productId'; //
    print('URL ==>> $url');
    return WebviewScaffold(
      url: url, //"https://www.androidmonks.com",
      appBar: AppBar(
        backgroundColor: Colors.lightBlue
        title: Text("จัดการรูปและลิงก์"),
      ),
      withZoom: true,
      withJavascript: true,
      withLocalStorage: true,
      appCacheEnabled: false,
      ignoreSSLErrors: true,
    );
  }
}

class WebPreViewWidget extends StatefulWidget {
  WebPreViewWidget({Key? key}) : super(key: key);

  @override
  _WebPreViewWidgetState createState() => _WebPreViewWidgetState();
}

class _WebPreViewWidgetState extends State {
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
                              builder: (context) => WebPreView()));
                    }),
              )
            ],
          ),
        ));
  }
}

class WebPreView extends StatefulWidget {
  final ProductAllModel ?productAllModel;
  final UserModel? userModel;

  WebPreView({Key? key, this.productAllModel, this.userModel}) : super(key: key);

  @override
  _WebPreViewState createState() => _WebPreViewState();
}

class _WebPreViewState extends State<WebPreView> {
  ProductAllModel? currentProductAllModel;
  UserModel? myUserModel;

  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    myUserModel = widget.userModel;
  }

  @override
  Widget build(BuildContext context) {
    String memberId = myUserModel!.id.toString();
    String productId = currentproductAllModel!.id.toString();
    String memberCode = myUserModel!.code;
    String url =
        'https://ptnpharma.com/shop/pages/forms/product_preview.php?mode=v&id=$productId&sup_id=$memberId'; //

    print('URL ==>> $url');
    return WebviewScaffold(
      url: url, //"https://www.androidmonks.com",
      appBar: AppBar(
        backgroundColor: Colors.lightBlue
        title: Text("ตัวอย่างมุมมองลูกค้า"),
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