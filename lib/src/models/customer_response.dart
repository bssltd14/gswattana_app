// To parse this JSON data, do
//
//     final customerResponse = customerResponseFromJson(jsonString);

import 'dart:convert';
//
//CustomerResponse customerResponseFromJson(String str) => CustomerResponse.fromJson(json.decode(str));
//
//String customerResponseToJson(CustomerResponse data) => json.encode(data.toJson());

class CustomerResponse {
  String custId;
  String custName;
  String custTel;
  String custThaiId;
  String memberId;
  double custPoint;
  double custUsePoint;
  double custRemainPoint;
  String mobileAppPassword;

  CustomerResponse({
    this.custId,
    this.custName,
    this.custTel,
    this.custThaiId,
    this.memberId,
    this.custPoint,
    this.custUsePoint,
    this.custRemainPoint,
    this.mobileAppPassword,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      CustomerResponse(
        custId: json["custId"],
        custName: json["custName"],
        custTel: json["custTel"],
        custThaiId: json["custThaiId"],
        memberId: json["memberId"],
        custPoint:
            json["custPoint"] == null ? 0 : json["custPoint"].toDouble(),
        custUsePoint: json["custUsePoint"] == null
            ? 0
            : json["custUsePoint"].toDouble(),
        custRemainPoint: json["custRemainPoint"] == null
            ? 0
            : json["custRemainPoint"].toDouble(),
            mobileAppPassword:
            json["mobileAppPassword"] == null ? "" : json["mobileAppPassword"],
      );

  Map<String, dynamic> toJson() => {
        "custId": custId,
        "custName": custName,
        "custTel": custTel,
        "custThaiId": custThaiId,
        "memberId": memberId,
        "custPoint": custPoint,
        "custUsePoint": custUsePoint,
        "custRemainPoint": custRemainPoint,
        "mobileAppPassword": mobileAppPassword,
      };
}
