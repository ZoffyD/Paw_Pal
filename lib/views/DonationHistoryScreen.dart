import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/model/donation.dart';

import '../model/user.dart';
import '../myconfig.dart';

class MyDonationScreen extends StatefulWidget {
  final User user;
  const MyDonationScreen({super.key, required this.user});

  @override
  State<MyDonationScreen> createState() => _MyDonationScreenState();
}

class _MyDonationScreenState extends State<MyDonationScreen> {
  List<Donation> donationList = [];
  String status = "Loading ...";

  @override
  void initState() {
    super.initState();
    loadDonation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
    );
  }

  void loadDonation() async{
    try{
      var response=
      await http
      .get(
        Uri.parse("${Myconfig.baseUrl}/api/get_my_donation.php"),
      );

      if(response.statusCode ==200){
        var data = jsonDecode(response.body);
        if(data['success'] == true){
          var list = data['data'] as List;
          setState((){
            donationList = list.map((item)=> Donation.fromJson(item)).toList();
            status = donationList.isEmpty ? "No donation found": "";
          });
        }else{
          setState((){
            
            status =  "No history available";
          });
        }
      }
    }catch(e){
      setState((){    
            status =  "Connection Error";
          });
    }
  }
}
