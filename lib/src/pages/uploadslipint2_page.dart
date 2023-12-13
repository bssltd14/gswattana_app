import 'dart:convert';
import 'dart:io';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gswattanaapp/src/models/intredeem_response.dart';
import 'package:gswattanaapp/src/models/mobileapppaymentint_response.dart';
import 'package:gswattanaapp/src/pages/home_page.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:gswattanaapp/src/pages/qrcodepromptpay_page.dart';
import 'package:gswattanaapp/src/utils/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class UploadSlipInt2Page extends StatefulWidget {
  UploadSlipInt2Page();

  @override
  _UploadSlipInt2PageState createState() => _UploadSlipInt2PageState();
}

TextEditingController timeinput = TextEditingController();
TextEditingController amountPay = TextEditingController();
TextEditingController amountGetReduce = TextEditingController();

class _UploadSlipInt2PageState extends State<UploadSlipInt2Page> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  MobileAppPaymentIntResponse _mobileAppPaymentIntResponse =
      MobileAppPaymentIntResponse();

  File _imageFile;
  DateTime _selectedDate = DateTime.now();
  int _counterValue = 1;
  String _AmountGetNew;
  double _AmountPayCal;

  String _setImage() {
    String _mTitle = "${Constant.BankAccInt}";

    if (_mTitle == "กรุงศรีอยุธยา") {
      return "assets/images/bank-bay.png";
    } else if (_mTitle == "ธ.ก.ส") {
      return "assets/images/bank-baac.png";
    } else if (_mTitle == "กรุงเทพ") {
      return "assets/images/bank-bbl.png";
    } else if (_mTitle == "ซีไอเอ็มบี ไทย") {
      return "assets/images/bank-cimbt.png";
    } else if (_mTitle == "ออมสิน") {
      return "assets/images/bank-gsb.png";
    } else if (_mTitle == "ไอซีบีซี (ไทย)") {
      return "assets/images/bank-icbc.png";
    } else if (_mTitle == "กสิกรไทย") {
      return "assets/images/bank-kbank.png";
    } else if (_mTitle == "เกียรตินาคินภัทร") {
      return "assets/images/bank-kk.png";
    } else if (_mTitle == "กรุงไทย") {
      return "assets/images/bank-ktb.png";
    } else if (_mTitle == "แลนด์ แอนด์ เฮ้าส์") {
      return "assets/images/bank-lh.png";
    } else if (_mTitle == "ไทยพาณิชย์") {
      return "assets/images/bank-scb.png";
    } else if (_mTitle == "ทิสโก้") {
      return "assets/images/bank-tisco.png";
    } else if (_mTitle == "ทหารไทยธนชาต") {
      return "assets/images/bank-ttb.png";
    } else if (_mTitle == "ยูโอบี") {
      return "assets/images/bank-uob.png";
    }

    print("_mTitle: $_mTitle"); // works
// works
  }

  Future<bool> getIntRedeem() async {
    Constant.DayCal = 0;
    Constant.MonthCal = 0;
    Constant.IntCal = 0;
    try {
      print("getIntRedeem");
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'serverId': Constant.ServerId,
        'customerId': Constant.CustomerId
      };
      final url =
          "${Constant.API}/Calculator/intredeem?branchname=${Constant.MobileAppPaymentIntBranchName}&pawnid=${Constant.MobileAppPaymentIntBillId}";
      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      print(url);
      print("getIntRedeem : ${url}");
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final IntRedeemResponse intRedeemResponse =
            IntRedeemResponse.fromJson(json.decode(response.body));
        Constant.DayCal = intRedeemResponse.dayCal;
        Constant.MonthCal = intRedeemResponse.monthCal;
        Constant.IntCal = intRedeemResponse.intCal;
        print("IntRedeemResponse Complete");
        return true;
      } else {
        print("Failed to load IntRedeemResponse ${response.statusCode}");
        return false;
      }
    } catch (_) {
      print("${_}");
    }
  }

  @override
  void initState() {
    DateFormat dateFormat = DateFormat("HH:mm");
    timeinput.text = dateFormat.format(DateTime.now());
    amountPay.text = Constant.formatNumber
        .format(double.parse(Constant.IntCal.toString().replaceAll(",", "")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg-white.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "เพิ่มรูปสลิปโอน ${Constant.MobileAppPaymentIntType} ${Constant.MobileAppPaymentIntBillId}",
            style: TextStyle(color: Constant.FONT_COLOR_MENU),
          ),
          iconTheme: IconThemeData(
            color: Constant.FONT_COLOR_MENU,
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          //margin: const EdgeInsets.all(40.0),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: new AssetImage(_setImage()))),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constant.BankAccInt,
                              style: TextStyle(
                                fontSize: 20,
                                color: Constant.FONT_COLOR_MENU,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              Constant.BankAcctNameInt,
                              style: TextStyle(
                                fontSize: 20,
                                color: Constant.FONT_COLOR_MENU,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  Constant.BankAcctNoInt,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Constant.FONT_COLOR_MENU,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Constant.FONT_COLOR_MENU,
                                    ),
                                    onPressed: () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: Constant.BankAcctNoInt));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Copied to clipboard'),
                                      ));
                                    }),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: FutureBuilder(
                      future: getIntRedeem(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == true) {
                            return Column(
                              children: [
                                Text(
                                  "จำนวนเงินต้น ${Constant.formatNumber.format(double.parse(Constant.Amountget.toString().replaceAll(",", "")))} บาท",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Constant.FONT_COLOR_MENU,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "ระยะเวลา ${Constant.MonthCal} เดือน ${Constant.DayCal} วัน ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Constant.FONT_COLOR_MENU,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "ดอกเบี้ยที่ต้องชำระ ${Constant.formatNumber.format(Constant.IntCal)} บาท",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Constant.FONT_COLOR_MENU,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   padding: EdgeInsets.only(left: 10, right: 10),
                  //   child: Center(
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width * 0.6,
                  //       child: TextFormField(
                  //         readOnly: false,
                  //         onSaved: (amountGetReduce) {
                  //           _mobileAppPaymentIntResponse.amountGetReduce =
                  //               double.parse(amountGetReduce
                  //                   .toString()
                  //                   .replaceAll(",", ""));
                  //         },
                  //         onChanged: (value) {
                  //           if (value.isEmpty) {
                  //             setState(() => amountPay.text = "" );
                  //           } else {
                  //             setState(() {
                  //               _AmountPayCal = double.parse(value);
                  //               amountPay.text = Constant.formatNumber
                  //                   .format(_AmountPayCal + Constant.IntCal);

                  //             });
                  //           }
                  //         },
                  //         validator: RequiredValidator(
                  //             errorText: "กรุณาใส่จำนวนเงินที่โอน"),
                  //         // // ignore: missing_return
                  //         // validator: (value){
                  //         //   if (value.isEmpty) {
                  //         //     return "กรุณาใส่จำนวนเงินที่ต้องการลดเงินต้น";
                  //         //   } else if ( double.parse(value) >=  double.parse(Constant.Amountget)){
                  //         //     return "จำนวนทีืต้องการลดเงินต้น มากกว่า เงินต้นเดิม";
                  //         //   } else {
                  //         //     return null;
                  //         //   }
                  //         // },
                  //         style: TextStyle(
                  //           fontSize: 24,
                  //           color: Constant.FONT_COLOR_MENU,
                  //         ),
                  //         textAlign: TextAlign.right,
                  //         keyboardType: TextInputType.number,
                  //         autofocus: true,
                  //         decoration: InputDecoration(
                  //           labelText: "จำนวนเงินต้นที่ต้องการลด",
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "จำนวน",
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         color: Constant.FONT_COLOR_MENU,
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Center(
                  //       child: CounterButton(
                  //         loading: false,
                  //         onChange: (int val) {
                  //           setState(() {
                  //             if (val <= 0) {
                  //               _counterValue = 1;
                  //             } else {
                  //               _counterValue = val;
                  //             }

                  //             amountPay.text = Constant.formatNumber.format(
                  //                 double.parse(Constant.IntPerMonth) *
                  //                     _counterValue);
                  //           });
                  //         },
                  //         count: _counterValue,
                  //         countColor: Constant.FONT_COLOR_MENU,
                  //         buttonColor: Constant.FONT_COLOR_MENU,
                  //         progressColor: Constant.FONT_COLOR_MENU,
                  //       ),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Text(
                  //       "เดือน",
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         color: Constant.FONT_COLOR_MENU,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 10),
                  Container(
                    child: _imageFile == null
                        ? Column(
                            children: [
                              Container(
                                height: 150,
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 150,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                              Text("เลือกรูป หรือ ถ่ายรูป สลิป",
                                  style: TextStyle(color: Colors.red))
                            ],
                          )
                        : Container(
                            child: Image.file(
                              _imageFile,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              Constant.PRIMARY_COLOR,
                              Constant.SECONDARY_COLOR,
                            ],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Constant.PRIMARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Constant.SECONDARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Text(
                            "เลือกรูปสลิป",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // ignore: missing_return
                          onPressed: () {
                            _getFromGallery();
                          },
                          //padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              Constant.PRIMARY_COLOR,
                              Constant.SECONDARY_COLOR,
                            ],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Constant.PRIMARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Constant.SECONDARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Text(
                            "ถ่ายรูปสลิป",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // ignore: missing_return
                          onPressed: () {
                            _getFromCamera();
                          },
                          //padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: FutureBuilder(
                      future: getIntRedeem(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == true) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black45))),
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Center(
                                    child: Text(
                                      "จำนวนเงินที่โอน ${Constant.formatNumber.format(Constant.IntCal)} บาท",
                                      style: TextStyle(
                                        fontSize: 26,
                                        color: Constant.FONT_COLOR_MENU,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.only(left: 10, right: 10),
                  //   child: Center(
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width * 0.8,
                  //       child: TextFormField(
                  //         readOnly: true,
                  //         controller: amountPay,
                  //         onSaved: (price) {
                  //           _mobileAppPaymentIntResponse.price =
                  //               double.parse(price);
                  //         },
                  //         validator: RequiredValidator(
                  //             errorText: "กรุณาใส่จำนวนเงินที่โอน"),
                  //         style: TextStyle(
                  //           fontSize: 24,
                  //           color: Constant.FONT_COLOR_MENU,
                  //         ),
                  //         textAlign: TextAlign.right,
                  //         keyboardType: TextInputType.number,
                  //         autofocus: true,
                  //         decoration: InputDecoration(
                  //           labelText: "จำนวนเงินที่โอน",
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Container(
                  //   padding: EdgeInsets.only(left: 10, right: 10),
                  //   child: Center(
                  //     child: Container(
                  //       width: MediaQuery.of(context).size.width * 0.8,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(8)),
                  //         gradient: LinearGradient(
                  //           colors: [
                  //             Constant.PRIMARY_COLOR,
                  //             Constant.SECONDARY_COLOR,
                  //           ],
                  //         ),
                  //         boxShadow: <BoxShadow>[
                  //           BoxShadow(
                  //             color: Constant.PRIMARY_COLOR,
                  //             //offset: Offset(1.0, 6.0),
                  //             //blurRadius: 20.0,
                  //           ),
                  //           BoxShadow(
                  //             color: Constant.SECONDARY_COLOR,
                  //             //offset: Offset(1.0, 6.0),
                  //             //blurRadius: 20.0,
                  //           ),
                  //         ],
                  //       ),
                  //       child: TextButton(
                  //         style: ButtonStyle(
                  //           foregroundColor:
                  //               MaterialStateProperty.all<Color>(Colors.white),
                  //         ),
                  //         child: Text(
                  //           "สร้าง QR Code สำหรับโอน",
                  //           style: TextStyle(
                  //               color: Color(0xFFf0e19b),
                  //               fontSize: 20.0,
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //         // ignore: missing_return
                  //         onPressed: () {
                  //           _formKey.currentState.save();
                  //           Constant.PaymentPromptpay = _AmountPayCal +Constant.IntCal;

                  //           print("${Constant.PaymentPromptpay}");
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => QRCodePromptpayPage(),
                  //             ),
                  //           );
                  //         },
                  //         //padding: EdgeInsets.all(16.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              Constant.PRIMARY_COLOR,
                              Constant.SECONDARY_COLOR,
                            ],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Constant.PRIMARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Constant.SECONDARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Text(
                            "วันที่โอน ${Constant.formatDate.format(Constant.SelectDate)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // ignore: missing_return
                          onPressed: () {
                            _selectDate(context);
                          },
                          //padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          controller: timeinput,
                          onSaved: (timeTran) {
                            _mobileAppPaymentIntResponse.timeTran = timeTran;
                          },
                          validator:
                              RequiredValidator(errorText: "กรุณาใส่เวลาโอน"),
                          style: TextStyle(
                            fontSize: 24,
                            color: Constant.FONT_COLOR_MENU,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText: "เวลาโอน",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          onSaved: (remark) {
                            _mobileAppPaymentIntResponse.remark = remark;
                          },
                          style: TextStyle(
                              fontSize: 24, color: Constant.FONT_COLOR_MENU),
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText: "หมายเหตุ (ถ้ามี)",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              Constant.PRIMARY_COLOR,
                              Constant.SECONDARY_COLOR,
                            ],
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Constant.PRIMARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Constant.SECONDARY_COLOR,
                              //offset: Offset(1.0, 6.0),
                              //blurRadius: 20.0,
                            ),
                          ],
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: Text(
                            "ยืนยันส่งสลิป",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // ignore: missing_return
                          onPressed: () async {
                            var statusCode;

                            if (_imageFile != null) {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          child: Row(
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(width: 10),
                                              Text("กำลังบันทึกข้อมูล")
                                            ],
                                          ),
                                        ),
                                      );
                                    });

                                print(
                                    "${_mobileAppPaymentIntResponse.price} ${_mobileAppPaymentIntResponse.remark}");

                                String fileName = basename(_imageFile.path);
                                await _storage
                                    .ref()
                                    .child("gswattanaapp_app")
                                    .child(fileName)
                                    .putFile(_imageFile)
                                    .then((taskSnapshot) async {
                                  print("upload pic to firebase complete");

                                  if (taskSnapshot.state == TaskState.success) {
                                    await _storage
                                        .ref()
                                        .child("gswattanaapp_app")
                                        .child(fileName)
                                        .getDownloadURL()
                                        .then((url) async {
                                      //ได้ url มาแล้วค่อยเอาไปบันทึกลง api
                                      print(url);

                                      try {
                                        print("upload data api");

                                        Map<String, String> headers = {
                                          "Accept": "application/json",
                                          "content-type": "application/json",
                                          'serverId': Constant.ServerId,
                                          'customerId': Constant.CustomerId
                                        };

                                        var requestBody = jsonEncode({
                                          "branchName": Constant
                                              .MobileAppPaymentIntBranchName,
                                          "type":
                                              Constant.MobileAppPaymentIntType,
                                          "status": "รออนุมัติ",
                                          "custId":
                                              Constant.MobileAppPaymentIntCustId,
                                          "custName": Constant.CUSTNAME,
                                          "billId":
                                              Constant.MobileAppPaymentIntBillId,
                                          "picLink": url,
                                          "price": Constant.IntCal,
                                          "remark":
                                              _mobileAppPaymentIntResponse.remark,
                                          "tranBank": "",
                                          "tranBankAccNo": "",
                                          "dateTran": Constant
                                              .formatDateToDatabase
                                              .format(Constant.SelectDate),
                                          "timeTran":
                                              _mobileAppPaymentIntResponse.timeTran,
                                          "dayPay": Constant.DayCal,
                                          "monthPay": Constant.MonthCal
                                        });

                                        final response = await http.post(
                                          Uri.parse(
                                              "${Constant.API}/AddMobileAppPaymentInt"),
                                          headers: headers,
                                          body: requestBody,
                                        );

                                        statusCode = response.statusCode;
                                      } catch (_) {
                                        showDialogNotUpload(context);
                                        print("${_}");
                                      }
                                    }).catchError((onError) {
                                      print("Got Error $onError");
                                    });
                                  }
                                });

                                Navigator.pop(
                                    context); //ปิด dialog กำลังบันทึกข้อมูล

                                if (statusCode == 204) {
                                  showDialogUploadComplete(context);

                                  //sendnoti
                                  Map<String, String> headersSendnoti = {
                                    "Accept": "application/json",
                                    "content-type": "application/json",
                                    'serverId': Constant.ServerId,
                                    'customerId': Constant.CustomerId,
                                    'onesignalappid': Constant.OneSignalAppId,
                                    'onesignalrestkey': Constant.OneSignalRestkey
                                  };

                                  final responseSendnoti = await http.put(
                                      Uri.parse(
                                          "${Constant.API}/AddMobileAppNotiSent?BranchName=${Constant.MobileAppPaymentIntBranchName}&NotiTitle=ต่อดอก&NotiRefNo=${Constant.MobileAppPaymentIntBillId}&NotiDetail=รออนุมัติ ยอดเงิน ${Constant.formatNumber.format(Constant.IntCal)} บาท&CustTel=${Constant.CUSTTEL}"),
                                      headers: headersSendnoti);

                                  print("AddMobileAppPaymentInt complete");
                                  _formKey.currentState.reset();
                                  setState(() {
                                    _imageFile = null;
                                    _counterValue = 1;
                                    amountPay.text = Constant.formatNumber.format(
                                        double.parse(Constant.IntPerMonth.toString().replaceAll(",", "")) *
                                            _counterValue);
                                  });
                                } else {
                                  showDialogNotUpload(context);
                                  print(
                                      "Failed AddMobileAppPaymentInt data api ${statusCode}");
                                }
                              }
                            }

                            // if (_imageFile != null) {
                            //   String fileName = basename(_imageFile.path);
                            //   _storage
                            //       .ref()
                            //       .child("gsrw_app")
                            //       .child(fileName)
                            //       .putFile(_imageFile);
                            // }
                          },
                          //padding: EdgeInsets.all(16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//   _uploadImageFirebase(String imagePath) {
//     String fileName = basename(_imageFile.path);
//     FirebaseStorage.instance
//         .ref()
//         .child("gsrcgold_app/$fileName")
//         .putFile(File(imagePath))
//         .then((taskSnapshot) {
//       print("task done");

// // download url when it is uploaded
//       if (taskSnapshot.state == TaskState.success) {
//         FirebaseStorage.instance
//             .ref()
//             .child("gsrcgold_app/$fileName")
//             .getDownloadURL()
//             .then((url) {
//           print("Here is the URL of Image $url");
//           return url;
//         }).catchError((onError) {
//           print("Got Error $onError");
//         });
//       }
//     });
//   }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        Constant.SelectDate = selectedDate;
      });
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void showDialogNotUpload(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ไม่สามารถเพิ่มรูปได้กรุณาลองใหม่อีกครั้ง',
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 20,
                  color: Constant.FONT_COLOR_MENU,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogUploadComplete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'แจ้งเข้าระบบเรียบร้อยแล้วค่ะ 😊',
            style: TextStyle(color: Constant.FONT_COLOR_MENU),
          ),
          content: Container(
            height: 100,
            child: Column(
              children: [
                Text(
                  "กรุณารออัพเดทจากทางร้าน ภายใน 24 ชั่วโมง",
                  style: TextStyle(
                      fontSize: 15,
                      height: 1.2,
                      color: Constant.FONT_COLOR_MENU),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "❗️กรุณาอย่าแจ้งซ้ำ❗️ จะทำให้การอนุมัติล่าช้าได้ค่ะ",
                  style:
                      TextStyle(fontSize: 15, height: 1.2, color: Colors.red),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 20,
                  color: Constant.FONT_COLOR_MENU,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Dismiss alert dialo
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (route) => false); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogBeforeDueDate(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "❗️ไม่สามารถทำรายการได้" +
                "\n" +
                "\n" +
                "จำนวนเงินลดต้น มากกว่าเงินต้นเดิม",
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 20,
                  color: Constant.FONT_COLOR_MENU,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Dismiss alert dialo
              },
            ),
          ],
        );
      },
    );
  }
}
