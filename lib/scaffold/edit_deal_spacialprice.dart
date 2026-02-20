import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:ptnsupplier/models/product_all_model.dart';
import 'package:ptnsupplier/models/user_model.dart';
import 'package:ptnsupplier/scaffold/detail_cart.dart';
import 'package:ptnsupplier/scaffold/list_deal_spacialprice.dart';
import 'package:ptnsupplier/utility/my_style.dart';
import 'package:ptnsupplier/utility/normal_dialog.dart';
import 'package:ptnsupplier/models/deal_spacialprice_model.dart';
import 'package:ptnsupplier/scaffold/my_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

class EditDealspacialprice extends StatefulWidget {
  final DealspacialpriceModel? dealModel;
  final UserModel? userModel;

  EditDealspacialprice({Key? key, this.dealModel, this.userModel})
      : super(key: key);

  @override
  _EditDealspacialpriceState createState() => _EditDealspacialpriceState();
}

class _EditDealspacialpriceState extends State<EditDealspacialprice> {
  // Explicit
  DealspacialpriceModel? currentDealModel;
  DealspacialpriceModel? dealModel;
  int? amontCart = 0;
  UserModel? myUserModel;
  String? id; // productID

  String? txtdeal = '',
      txtfree = '',
      txtprice = '',
      txtcost = '',
      txtextra = '',
      txtperiod = '',
      txtnexttime = '',
      txtremark = '';

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
          'https://ptnpharma.com/apisupplier/json_deal_spacialprice.php?memberId=$memberId&id=$id';

      http.Response response = await http.get(Uri.parse(url));
      var result = json.decode(response.body);
      var itemDeal = result['itemsData'];
      print('url = $url');
      print('itemDeal = $itemDeal');

      for (var map in itemDeal) {
        setState(() {
          DealspacialpriceModel currentDealModel =
              DealspacialpriceModel.fromJson(map);
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
              color: Color.fromARGB(255, 20, 176, 189),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 20, 176, 189),
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
                    width: MediaQuery.of(context).size.width * 0.30,
                    padding: EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        // Icon(Icons.restaurant, color: Colors.green[500]),
                        Text('ดีลสั่ง'),
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
                            hintText: 'ดีลสั่ง',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        // Text(
                        //   currentDealModel!.deal!,
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
                    width: MediaQuery.of(context).size.width * 0.30,
                    padding: EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
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
                            hintText: 'แถม',
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
                    width: MediaQuery.of(context).size.width * 0.30,
                    padding: EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        // Icon(Icons.kitchen, color: Colors.green[500]),
                        Text('รวม'),
                        // TextFormField(),
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: <Widget>[
                        // Icon(Icons.restaurant, color: Colors.green[500]),
                        Text('หน่วยการสั่ง'),
                        // TextFormField(),
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: <Widget>[
                        Text('ราคาทุน'),
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          initialValue:
                              currentDealModel!.cost!, // set default value
                          keyboardType: TextInputType.number,
                          onChanged: (string) {
                            txtcost = string.trim();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              top: 6.0,
                            ),
                            // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
                            // border: InputBorder.none,
                            hintText: 'ราคาทุน',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        // Text(
                        //   currentDealModel!.cost!,
                        //   style: TextStyle(
                        //     fontSize: 21.0,
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
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon(Icons.restaurant, color: Colors.green[500]),
                  Text('สินค้าแถมเพิ่มเติม'),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    initialValue: currentDealModel!.extra!, // set default value
                    keyboardType: TextInputType.text,
                    onChanged: (string) {
                      txtextra = string.trim();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        top: 6.0,
                      ),
                      // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
                      // border: InputBorder.none,
                      hintText: 'สินค้าแถมเพิ่มเติม',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  // Text(
                  //   (currentDealModel!.extra! != '')
                  //       ? currentDealModel!.extra!
                  //       : '-',
                  //   style: TextStyle(
                  //     fontSize: 18.0,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color.fromARGB(0xff, 0, 0, 0),
                  //   ),
                  // ),
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
              color: Color.fromARGB(255, 20, 176, 189),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color.fromARGB(255, 20, 176, 189),
              width: 1.0,
            ),
          ),
        ),
        padding: new EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // periodBox(),
            selectDateRangeBox(),
            nexttimeBox(),
            remarkBox(),
            datepostBox(),
          ],
        ),
      ),
    );
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


  Widget periodBox() {
    DateTime formatStart = DateFormat("yyyy-MM-dd").parse(currentDealModel!.period_start!);
    DateTime formatEnd = DateFormat("yyyy-MM-dd").parse(currentDealModel!.period_end!);
    print(formatStart);
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,       
            height: 8.0,
          ),
          Text(
            'ช่วงเวลาจัดรายการ เริ่ม - ถึง :',
            textAlign: TextAlign.left,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text('Selected date: $_selectedDate'),
                // Text('Selected date count: $_dateCount'),
                Text('วันที่จัดรายการ : $_range'),
                // Text('Selected ranges count: $_rangeCount'),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 80,
            right: 0,
            bottom: 0,
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(formatStart,formatEnd),   // DateTime.now().subtract(const Duration(days: 4)),// DateTime.now().add(const Duration(days: 3)),    --- 
            ),
          ),
        ],
      ),
    );
  }

  String dateRangeText = "";
  String newdateRangeText = "";
  // String invdateRangeText = "";
  String psformat = '';
  String peformat = '';
  String invsformat = '';
  String inveformat = '';


  Widget selectDateRangeBox() {
    var invsDate = DateTime.parse(currentDealModel!.period_start!);
    var inveDate = DateTime.parse(currentDealModel!.period_end!);
    invsformat = "${invsDate.day}/${invsDate.month}/${invsDate.year}";
    inveformat = "${inveDate.day}/${inveDate.month}/${inveDate.year}";
    setState(() {
      if(newdateRangeText=='')
        dateRangeText = invsformat + ' - ' + inveformat;    
      else
        dateRangeText = newdateRangeText;    
    });

    return  GestureDetector(
      onTap: () {
        showPickerDateRange(context);
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
            Text('ช่วงเวลาจัดรายการ เริ่ม - ถึง'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset('images/calendar.png'),
                  Text('$dateRangeText'),
                ],
              ),
            ),          
          ],
        ),
      ),
    );
  }


  void showPickerDateRange(BuildContext context) {
    print("canceltext: ${PickerLocalizations.of(context).cancelText}");
    Picker ps = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
              type: PickerDateTimeType.kDMY,
              value: DateTime.parse(currentDealModel!.period_start!),
        ),
        onConfirm: (Picker picker, List value) {
          print((picker.adapter as DateTimePickerAdapter).value);         
        });

    Picker pe = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
              type: PickerDateTimeType.kDMY,
              value: DateTime.parse(currentDealModel!.period_end!),
        ),
        onConfirm: (Picker picker, List value) {
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
            // showMsg(ps.adapter.toString() + 'To' +pe.adapter.toString());
              var psDate = DateTime.parse(ps.adapter.toString());
              var peDate = DateTime.parse(pe.adapter.toString());
               psformat = "${psDate.day}/${psDate.month}/${psDate.year}";
               peformat = "${peDate.day}/${peDate.month}/${peDate.year}";
            setState(() {
              newdateRangeText = psformat + ' - ' + peformat;
            });     
          },
          child: Text(PickerLocalizations.of(context).confirmText ?? ''))
    ];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ช่วงเวลาจัดรายการ"),
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


  Widget nexttimeBox() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 10.0,
            height: 8.0,
          ),
          Text(
            'เวลาที่คาดว่าจัดรายการอีกครั้ง :',
            textAlign: TextAlign.left,
          ),
          TextFormField(
            style: TextStyle(color: Colors.black),
            initialValue: currentDealModel!.nexttime!, // set default value
            keyboardType: TextInputType.multiline,
            onChanged: (string) {
              txtnexttime = string.trim();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 6.0,
              ),
              // prefixIcon: Icon(Icons.mode_edit, color: Colors.grey,size: 15.00,),
              // border: InputBorder.none,
              hintText: 'เวลาที่คาดว่าจัดรายการอีกครั้ง',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          // Text(
          //   currentDealModel!.nexttime!,
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
            'เหตุผลในการเสนอ :',
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
                        return ListDealSpacialprice(
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
    txtcost = txtcost!.replaceAll(',', '');
    txtdeal = txtdeal!.replaceAll(',', '');
    txtfree = txtfree!.replaceAll(',', '');
    // String url =
    //     'https://ptnpharma.com/apisupplier/json_submit_deal.php?memberId=$memberID&medId=$medID&deal_order=$txtdeal&free_order=$txtfree&price_order=$txtprice&price_label=$txtpricelabel&price_retail=$txtpriceretail'; // &note=$txtnote&method=$txtmethod&usefor=$txtusefor&fda=$txtfda;

    String url =
        'https://ptnpharma.com/apisupplier/json_submit_edit_spacialprice.php'; // &note=$txtnote&method=$txtmethod&usefor=$txtusefor&fda=$txtfda;
    print('submitDeal >> $url');
    print(
        'Data option >> ID : $id | deal : $txtdeal |  free : $txtfree | cost : $txtcost | extra : $txtextra | periodstart : $psformat | periodend : $peformat | period : $_range');

    // await http.get(Uri.parse(url)).then((value) {
    //   confirmSubmit();
    // });

    await http.post(Uri.parse(url), body: {
      'memberId': memberID,
      'dealId': medID.toString(),
      'deal': txtdeal,
      'free': txtfree,
      'cost': txtcost,
      'extra': txtextra,
      'period': _range,
      'periodstart': psformat,
      'periodend': peformat,
      'nexttime': txtnexttime,
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
              print(
                  'memberId=$memberID&medId=$medID&deal_order=$txtdeal&free_order=$txtfree&price_order=$txtprice');

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
        title: Text('แก้ไขรายการพิเศษ'),
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
