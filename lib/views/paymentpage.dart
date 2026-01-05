import 'package:flutter/material.dart';
import 'package:pawpal/myconfig.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double amount;

  const PaymentScreen({super.key, required this.user, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
late WebViewController _webcontroller;
  @override
  void initState() {
    super.initState();

    String userid =widget.user.id ?? "0";
    String name = widget.user.name ?? "Guest";
    String email = widget.user.email ?? "Guest@gmail.com";
    String phone = widget.user.phone ?? "0123456789";
    String amount = widget.amount.toStringAsFixed(2);

    String url ="${Myconfig.baseUrl}/api/payment.php?"
      "userid = $userid&"
      "name = $name&"
      "email = $email&"
      "phone = $phone&"
      "amount = $amount";

     
      _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Payment Gateway",
        style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F3C88),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close, color: Colors.white))
      ),
      body: WebViewWidget(controller: _webcontroller),
    );
    
  }
}
