import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:ptnsupplier/models/product_all_model.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/scaffold/detail_cart.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:ptnsupplier/utility/normal_dialog.dart';
import 'package:ptnsupplier/models/deal_raise_model.dart';
import 'package:ptnsupplier/scaffold/my_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:ptnsupplier/scaffold/list_deal_raise.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

class EditDealraise extends StatefulWidget {
  final DealraiseModel? dealModel;
  final UserModel? userModel;

  EditDealraise({Key? key, this.dealModel, this.userModel}) : super(key: key);

  @override
  _EditDealraiseState createState() => _EditDealraiseState();
}

class _EditDealraiseState extends State<EditDealraise> {
  // Explicit
  DealraiseModel? currentDealModel;
  DealraiseModel? dealModel;
  int? amontCart = 0;
  UserModel? myUserModel;
  String? id; // productID

  String? txtdeal = '', txtfree = '', txtoldprice = '',txtnewprice = '', txtlastpricemaxorder = '', txtlabelchange = '', txtremark = '';
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
          'https://ptnpharma.com/apisupplier/json_deal_raise.php?memberId=$memberId&id=$id';

      http.Response response = await http.get(Uri.parse(url));
      var result = json.decode(response.body);
      var itemDeal = result['itemsData'];
      print('url = $url');
      print('itemDeal = $itemDeal');

      for (var map in itemDeal) {
        setState(() {
          DealraiseModel currentDealModel = DealraiseModel.fromJson(map);
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
              color: Color.fromARGB(255, 248, 168, 5),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 248, 168, 5),
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
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
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
                        currentDealModel!.dbCMin!,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        // Icon(Icons.restaurant, color: Colors.green[500]),
                        Text('จำนวนสั่ง'),
                         TextFormField(
                          style: TextStyle(color: Colors.black),
                          initialValue:
                              currentDealModel!.deal!, // set default value
                          keyboardType: TextInputType.number,
                          onChanged: (string) {
                            txtdeal = string.trim();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              top: 6.0,
                            ),
                            // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
                            // border: InputBorder.none,
                            hintText: 'หมายเหตุเพิ่มเติม',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        // Icon(Icons.timer, color: Colors.green[500]),
                        Text('แถม'),
                          TextFormField(
                          style: TextStyle(color: Colors.black),
                          initialValue:
                              currentDealModel!.free!, // set default value
                          keyboardType: TextInputType.number,
                          onChanged: (string) {
                            txtfree = string.trim();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              top: 6.0,
                            ),
                            // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
                            // border: InputBorder.none,
                            hintText: 'หมายเหตุเพิ่มเติม',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                       
                        // Text(
                        //   currentDealModel!.free!,
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color.fromARGB(0xff, 0, 0, 0),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        // Icon(Icons.kitchen, color: Colors.green[500]),
                        Text('รวม'),
                        Text(
                          currentDealModel!.total!,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(0xff, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        // Icon(Icons.restaurant, color: Colors.green[500]),
                        Text('หน่วยการสั่ง'),
                        Text(
                          currentDealModel!.unit!,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(0xff, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
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
            //           Text('หน่วยการสั่ง'),
            //           Text(
            //             currentDealModel!.unit,
            //             style: TextStyle(
            //               fontSize: 18.0,
            //               fontWeight: FontWeight.bold,
            //               color: Color.fromARGB(0xff, 0, 0, 0),
            //             ),
            //           ),
            //         ],
            //       ),
            //       Column(
            //         children: [
            //           // Icon(Icons.kitchen, color: Colors.green[500]),
            //           Text('ราคาทุน'),
            //           Text(
            //             currentDealModel!.actiondate,
            //             style: TextStyle(
            //               fontSize: 21.0,
            //               fontWeight: FontWeight.bold,
            //               color: Color.fromARGB(0xff, 255, 0, 0),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                   child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon(Icons.restaurant, color: Colors.green[500]),
                        Text('ราคาทุนใหม่'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          initialValue:
                              currentDealModel!.newprice!, // set default value
                          keyboardType: TextInputType.number,
                          onChanged: (string) {
                            txtnewprice = string.trim();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              top: 6.0,
                            ),
                            // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
                            // border: InputBorder.none,
                            hintText: 'ราคาทุนใหม่',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),

                        // Text(
                        //   currentDealModel!.newprice!,
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color.fromARGB(255, 255, 0, 0),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon(Icons.restaurant, color: Colors.green[500]),
                        Text('ราคาทุนปัจจุบัน'),
                            TextFormField(
                          style: TextStyle(color: Colors.black),
                          initialValue:
                              currentDealModel!.oldprice!, // set default value
                          keyboardType: TextInputType.number,
                          onChanged: (string) {
                            txtoldprice = string.trim();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              top: 6.0,
                            ),
                            // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
                            // border: InputBorder.none,
                            hintText: 'ราคาทุนปัจจุบัน',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        // Text(
                        //   currentDealModel!.oldprice!,
                        //   style: TextStyle(
                        //     fontSize: 18.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color.fromARGB(0xff, 255, 0, 0),
                        //   ),
                        // ),
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
              color: Color.fromARGB(255, 248, 168, 5),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 248, 168, 5),
              width: 1.0,
            ),
          ),
        ),
        padding: new EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // actiondateBox(),
            selectDateBox(),
            lastpricemaxorderBox(),
            labelchangeBox(),
            remarkBox(),
            datepostBox(),
          ],
        ),
      ),
    );
  }

  String dateText = "";
  String newdateText = "";
  // String invdateRangeText = "";
  String pkformat = '';
  String invformat = '';

    Widget selectDateBox() {
    var invDate = DateTime.parse(currentDealModel!.actiondate!);
    invformat = "${invDate.day}/${invDate.month}/${invDate.year}";
    // invformat = currentDealModel!.actiondate!;
    setState(() {
      if(newdateText=='')
        dateText = invformat;    
      else
        dateText = newdateText;    
    });

    return  GestureDetector(
      onTap: () {
        showPickerDate(context);
      },
      child:  Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: Colors.grey.shade700,
            width: 1.0, // This would be the width of the underline
          ))
        ),
        child: Column(        
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('วันที่จะปรับราคา'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset('images/calendar.png'),
                  Text('$dateText'),
                ],
              ),
            ),          
          ],
        ),
      ),
    );
  }


  String stateText = "";
    void showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        // adapter: DateTimePickerAdapter(),
        adapter: DateTimePickerAdapter(
                  type: PickerDateTimeType.kDMY,
                  value: DateTime.parse(currentDealModel!.actiondate!),
                ),
        title: Text("วันที่ปรับราคา"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);
          // showMsg(picker.adapter.toString());

         setState(() {
              var pkDate = DateTime.parse(picker.adapter.toString());
               pkformat = "${pkDate.day}/${pkDate.month}/${pkDate.year}";
              // stateText = picker.adapter.toString();
              setState(() {
                newdateText = pkformat;
              });   
          });     
    }).showDialog(context);
  }

 String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  Widget actiondateBox() {
    DateTime formatSelect = DateFormat("yyyy-MM-dd").parse(currentDealModel!.actiondate!);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'วันที่จะปรับราคา',
            textAlign: TextAlign.left,
          ),
          Container(
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: formatSelect,   // DateTime.now().subtract(const Duration(days: 4)),// DateTime.now().add(const Duration(days: 3)),    --- 

            ),
          ),
          // Text(
          //   currentDealModel!.actiondate!,
          //   style: TextStyle(
          //     fontSize: 18.0,
          //     fontWeight: FontWeight.bold,
          //     color: Color.fromARGB(0xff, 0, 0, 0),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget lastpricemaxorderBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'เอ้งชิ้ว - จำนวนที่สั่งได้ในราคาเก่า',
            textAlign: TextAlign.left,
          ),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue: currentDealModel!.lastpricemaxorder!, // set default value
            keyboardType: TextInputType.text,
            onChanged: (string) {
              txtlastpricemaxorder = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
              // border: InputBorder.none,
              hintText: 'เอ้งชิ้ว - จำนวนที่สั่งได้ในราคาเก่า',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          // Text(
          //   currentDealModel!.lastpricemaxorder!,
          //   style: TextStyle(
          //     fontSize: 18.0,
          //     fontWeight: FontWeight.bold,
          //     color: Color.fromARGB(0xff, 0, 0, 0),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget labelchangeBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'สินค้าเปลี่ยนป้ายราคา',
            textAlign: TextAlign.left,
          ),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue: currentDealModel!.labelchange!, // set default value
            keyboardType: TextInputType.text,
            onChanged: (string) {
              txtlabelchange = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
              // border: InputBorder.none,
              hintText: 'สินค้าเปลี่ยนป้ายราคา',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),

          // Text(
          //   currentDealModel!.labelchange!,
          //   style: TextStyle(
          //     fontSize: 18.0,
          //     fontWeight: FontWeight.bold,
          //     color: Color.fromARGB(0xff, 0, 0, 0),
          //   ),
          // ),
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
            'เหตุผลในการเสนอ',
            textAlign: TextAlign.left,
          ),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue: currentDealModel!.remark!, // set default value
            keyboardType: TextInputType.multiline,
            onChanged: (string) {
              txtremark = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
              // border: InputBorder.none,
              hintText: 'เหตุผลในการเสนอ',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          // Text(
          //   currentDealModel!.remark!,
          //   style: TextStyle(
          //     fontSize: 18.0,
          //     fontWeight: FontWeight.bold,
          //     color: Color.fromARGB(0xff, 0, 0, 0),
          //   ),
          // ),
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


  void backProcess() {
    Navigator.of(context).pop();
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
                    // Navigator.of(context).pop();
                    // backProcess();
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
                  child: Text('OK'))
            ],
          );
        });
  } 

Future<void> submitThread() async {
    // try {
    var medID = currentDealModel!.id;
    txtdeal = txtdeal!.replaceAll(',', '');
    txtfree = txtfree!.replaceAll(',', '');
    txtoldprice = txtoldprice!.replaceAll(',', '');
    txtnewprice = txtnewprice!.replaceAll(',', '');
    // String url =
    //     'https://ptnpharma.com/apisupplier/json_submit_deal.php?memberId=$memberID&medId=$medID&deal_order=$txtdeal&free_order=$txtfree&price_order=$txtprice&price_label=$txtpricelabel&price_retail=$txtpriceretail'; // &note=$txtnote&method=$txtmethod&usefor=$txtusefor&fda=$txtfda;

    String url =
        'https://ptnpharma.com/apisupplier/json_submit_edit_raise.php'; // &note=$txtnote&method=$txtmethod&usefor=$txtusefor&fda=$txtfda;
    print('submitDeal >> $url');
    print(
        'Data option >> ID : $id | deal : $txtdeal | free : $txtfree | newprice : $txtnewprice | lastpricemaxorder : $txtlastpricemaxorder | labelchange  : $txtlabelchange | actiondate : $newdateText | remark : $txtremark');

    // await http.get(Uri.parse(url)).then((value) {
    //   confirmSubmit();
    // });

    await http.post(Uri.parse(url), body: {
      'memberId': memberID,
      'dealId': medID.toString(),
      'deal': txtdeal,
      'free': txtfree,
      'newprice': txtnewprice,
      'oldprice': txtoldprice,
      'lastpricemaxorder': txtlastpricemaxorder,
      'labelchange': txtlabelchange,
      'actiondate': newdateText,//_selectedDate,
      'remark': txtremark
    }).then((value) {
      confirmSubmit();
    });
    // // } catch (e) {}
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
              var medID = currentDealModel!.id;
              // print(
              //     'memberId=$memberID&medId=$medID&deal_order=$txtdeal&free_order=$txtfree&price_order=$txtprice');

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          showHome(),
        ],
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: Text('แก้ไขแจ้งปรับราคาสินค้า'),
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
        submitButton(),
      ],
    );
  }
}
