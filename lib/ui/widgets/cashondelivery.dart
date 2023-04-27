import 'dart:convert';

import 'package:farmerica/models/CartRequest.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/Config.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Order.dart' as o;
import 'package:farmerica/models/Order.dart';
import 'package:http/http.dart' as http;
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/dashboard.dart';
import 'package:farmerica/utils/sharedServices.dart';

class CashOnDelivery extends StatefulWidget {
  int id;
  var shippingMode;
  String delivery_type;
  String delivery_time;
  String gift_from;
  String gift_message;
  List cartProducts;

  CashOnDelivery({
    this.id,
    this.shippingMode,
    this.delivery_type,
    this.delivery_time,
    this.gift_from,
    this.gift_message,
    this.cartProducts,
  });

  @override
  State<CashOnDelivery> createState() => _CashOnDeliveryState();
}

class _CashOnDeliveryState extends State<CashOnDelivery> {
  Customers loginDetails;
  SharedServices sharedServices = SharedServices();

  Future<Customers> getValidation() async {
    final login1 = await sharedServices.loginDetails();
    return login1;
  }

  List<Orders> orderList = [];

  Api_Services api_services = Api_Services();

  Future<List<Orders>> orderId;
  Future<List<Orders>> getList() async {
    orderList = await api_services.getOrdersByUserId(widget.id);
    // orderId = '${orderList[0].id}';
    print('OrderData: ${orderList[0].id}');
    return orderList;
  }

  List<CartProducts> cartProducts = [];

  @override
  void initState() {
    getValidation().then((value) => setState(() {
      loginDetails = value;
    }));
    orderId = getList();
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // orderList.forEach((element) {
    //   print('elements: ${element.id}');
    // });

    if (orderList == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff00ab55),
          title: Image.network(
            'https://www.farmerica.in/wp-content/uploads/2023/01/farmerica-logo.png',
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 25),
                    child: const Text(
                      'Thank You!!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                const Text(
                  'Your order is Placed!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0XFFF0F0F1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FutureBuilder<List<Orders>>(
                          future: orderId,
                          builder: (context, snapshot) {
                            var orderIds;
                            if (snapshot.hasData) {
                              orderIds = snapshot.data[0].id;
                              print('orderId: ${snapshot.data[0].id}');
                            }
                            return Text('Order number: ${orderIds.toString()}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500));
                          }),
                      const SizedBox(width: 25),
                      Text('Date : ${widget.delivery_type}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 25),
                      Text('Total: ${widget.cartProducts[0].price}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 25),
                      Text('Gift From: ${widget.gift_from.toString()}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 25),
                      Text('Gift Msg: ${widget.gift_message.toString()}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      cartProducts.remove(0);
                      
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => BasePage(
                            customer: loginDetails,
                            title: "Farmerica App",
                          )), (route) => false);
                    },
                    child: const Text('Continue Shopping')),

                // Container(
                //   width: double.infinity,
                //   height: 180,
                //   margin: EdgeInsets.symmetric(horizontal: 10),
                //   decoration: BoxDecoration(
                //     color: Color(0XFFF0F0F1),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Text('Pr: ${orderList[0].toString()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                //       SizedBox(width: 25),
                //       Text('Date : ${orderList[0].dateCreated.toString()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                //       SizedBox(width: 25),
                //       Text('Total: ${orderList[0].total.toString()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                //
                //       SizedBox(width: 25),
                //       // Text('Gift From: ${orderList[0].metaData[1].value.toString()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                //
                //       SizedBox(width: 25),
                //       // Text('Gift To: ${orderList[0].metaData[2].value.toString()}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
