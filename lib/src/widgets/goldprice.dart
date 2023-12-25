import 'dart:ffi';

import 'package:gswattanaapp/src/models/goldprice_response.dart';
import 'package:gswattanaapp/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

Future<bool> fetchGoldPrice() async {
  try {
    String GoldPrice = "";

    final url = "http://150.95.88.227:1150/GoldPrice";
    print(url);
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // final List<GoldPriceResponse> goldPriceResponse =
      //     List<GoldPriceResponse>.from(
      //         goldPriceResponseFromJson(response.body));
      // print("fetchGoldPrice Complete");
      // // return goldPriceResponse;
      // Constant.GoldPrice =
      //     "${Constant.formatNumber.format(double.parse(goldPriceResponse[4].bid))} - ${Constant.formatNumber.format(double.parse(goldPriceResponse[4].ask))} ";
      // // Constant.GoldPrice = "${goldPriceResponse[4].name}";

      GoldPrice = response.body;
      if (GoldPrice.length > 0) {
        final SplitValue = GoldPrice.split("|");

        if (SplitValue.length > 0) {
          Constant.GoldPrice = "${SplitValue[1]} - ${SplitValue[0]}";
          Constant.GoldPriceSale = SplitValue[0];
          Constant.GoldPriceBuy = SplitValue[1];
          Constant.GoldPriceText = SplitValue[4];
          Constant.GoldPriceUpDown = SplitValue[5];
        }
      }

      print(Constant.GoldPrice);
      return true;
    }
    print('Network failed GoldPriceService');
    return false;
  } catch (_) {
    print("${_}");
  }
}

class BuildGoldPrice extends StatefulWidget {
  @override
  _BuildGoldPriceState createState() => _BuildGoldPriceState();
}

class _BuildGoldPriceState extends State<BuildGoldPrice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse("https://www.goldtraders.or.th/")),
      child: Container(
        child: FutureBuilder(
            future: fetchGoldPrice(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(" ราคาทองแท่ง  ${Constant.GoldPrice}",
                              style: TextStyle(
                                  fontSize: 18, color: Constant.FONT_COLOR)),
                                  SizedBox(width: 10,),
                          int.parse(Constant.GoldPriceUpDown) > 0
                              ? Icon(
                                  FontAwesome.arrow_up,
                                  size: 18,
                                  color: Colors.green,
                                )
                              : Icon(
                                  FontAwesome.arrow_down,
                                  size: 18,
                                  color: Colors.red,
                                ),
                          int.parse(Constant.GoldPriceUpDown) > 0
                              ? Text(" ${Constant.GoldPriceUpDown}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.green))
                              : Text(" ${Constant.GoldPriceUpDown}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(" ประจำวันที่ ${Constant.GoldPriceText}",
                          style: TextStyle(
                              fontSize: 16, color: Constant.FONT_COLOR)),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
