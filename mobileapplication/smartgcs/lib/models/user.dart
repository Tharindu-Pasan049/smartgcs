import 'package:flutter/material.dart';
import 'package:smartgcs/utils/data.dart';
import 'dart:io';
enum UserType { Client, Vendor }


class User {
  final String id;
  String profileId;
  final String token;
   final String phone;
  final String email;
  final UserType userType;
   final String username;
  bool markedForDelete = false;

  User({
    @required this.id,
    this.profileId,
    @required this.token,
     @required this.phone,
    @required this.email,
     @required this.username,
    @required this.userType,
    this.markedForDelete
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': id,
      'userProfileId': profileId,
      'userEmail': email,
      'userUserType': userType.toString(),
      'userToken': token,
      'userMarkedForDelete': markedForDelete
    };
  }
}

class Client {
  String id;
  String name;
  String phone;
  String email;
 // List<double> pos;
  String username;
  String address;
  String dateCreated;
  String subAccountCode;

  Client({this.id, this.name, this.phone,this.email, this.username, this.address,
    this.dateCreated});

  void update({String name, String phone, List<double> pos, String username, String address, String subAccountCode}){
    this.name = name ?? this.name;
    this.phone = phone ?? this.phone;
   // this.pos = pos ?? this.pos;
    this.username = username ?? this.username;
    this.address = address ?? this.address;
    this.subAccountCode = subAccountCode ?? this.subAccountCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': id,
      'clientName': name,
      'clientPhone': phone,
      'clientUsername': username,
      'clientAddress': address,
      'clientDateCreated': dateCreated,
      'clientSubAccountCode': subAccountCode
    };
  }

  Client.fromMap(Map<String, dynamic> data){
    id = data["clientId"];
    name = data[Datakeys.clientName];
   //pos = data[Datakeys.clientPos] == null ? this.pos : data[Datakeys.clientPos].map<double>((x) {return double.parse(x.toString());}).toList();
    phone = data[Datakeys.clientPhone];
    username = data[Datakeys.clientUsername];
    address = data[Datakeys.clientAddress];
    dateCreated = data[Datakeys.clientDateCreated];
    subAccountCode = data["clientSubAccountCode"];
  }
}

class Vendor {
  String id;
  String name;
  String email;

  String imageUrl;
  List<double> pos;
  String companyName;
  String companyAddress;
  String phone;
  String username;
  String address;
  String dateCreated;
  
  bool verified;
  double distance;
  String subAccountCode;

  Vendor({this.id, this.name,this.email,this.imageUrl, this.pos, this.companyName, this.companyAddress, this.phone,
    this.username, this.address, this.dateCreated,this.verified, this.distance,
    this.subAccountCode});

  void update({String name, String phone, String imageUrl, List<double> pos, String username, String address, String companyName, String companyAddress, int rating, int rate, double distance, bool verified, String subAccountCode}){
    this.name = name ?? this.name;
    this.imageUrl = imageUrl ?? this.imageUrl;
    this.phone = phone ?? this.phone;
    this.pos = pos ?? this.pos;
    this.username = username ?? this.username;
    this.address = address ?? this.address;
    this.companyName = companyName ?? this.companyName;
    this.companyAddress = companyAddress ?? this.companyAddress;
   
    this.distance = distance ?? this.distance;
    this.verified = verified ?? this.verified;
    this.subAccountCode = subAccountCode ?? this.subAccountCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'vendorId': id,
      'vendorName': name,
      'vendorImageUrl': imageUrl,
      'vendorPos': pos,
      'vendorPhone': phone,
      'vendorUsername': username,
      'vendorAddress': address,
      'vendorCompanyName': companyName,
      'vendorCompanyAddress': companyAddress,
      'vendorDateCreated': dateCreated,
      
      'vendorVerified': verified,
      'distance': distance,
      'vendorSubAccountCode': subAccountCode
    };
  }

  Vendor.fromMap(Map<String, dynamic> data){
    id = data["vendorId"];
    name = data[Datakeys.vendorName];
    phone = data[Datakeys.vendorPhone];
    pos = data[Datakeys.vendorPos];
    imageUrl = data["vendorimageUrl"];
    companyName = data[Datakeys.vendorCompanyName];
    companyAddress = data[Datakeys.vendorCompanyAddress];
    username = data[Datakeys.vendorUsername];
    address = data[Datakeys.vendorAddress];
    verified = data[Datakeys.vendorVerified];

    dateCreated = data[Datakeys.vendorDateCreated];
    subAccountCode = data["vendorSubAccountCode"];
  }
}

class IDCardClass {
  static String userid;
  static String type;
  
}
class Temp{
  static String n;
  static String u;
  static String p;
  static String e;
  static String a;
  static String d;

}
class CurrentPosition{
  static double x;
  static double y;
}
class BinPosition{
  static double x;
  static double y;
}