import 'dart:convert';
import 'dart:io';

import 'package:farmerica/Config.dart';
import 'package:farmerica/models/CartRequest.dart';

import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Login.dart';
import 'package:farmerica/models/Order.dart';
import 'package:farmerica/models/ParentCategory.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/models/bundledProduct.dart';
import 'package:farmerica/models/coupon.dart';

import 'package:farmerica/networks/Authorization.dart';
import 'package:farmerica/models/TokenResponse.dart';
import 'package:farmerica/models/wrongCredential.dart';

import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Api_Services {
  final client = HttpClient();
  WooCommerceAPI api;

  Api_Services() {
    api = new WooCommerceAPI(
        url: Config.url,
        consumerKey: Config.key,
        consumerSecret: Config.secret);
  }

  Future<Customers> createCustomer({
    String firstName,
    String lastName,
    String email,
    String username,
  }) async {
    var response =
        await api.postAsync("${Config.urlfor}" "${Config.customerUrl}", {
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "username": username
    });
    // print(response);
    Customers customer = Customers.fromJson(response);

    return customer;
  }

  Future createCustomers(
      {String firstName,
      String lastName,
      String email,
      String username}) async {
    http.Response response = await http.post(
        Uri.parse(
            'https://www.farmerica.in/wp-json/wc/v3/customers?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c'),
        body: {
          "email": email,
          "first_name": firstName,
          "last_name": lastName,
          "username": username
        });

    String msg;
    if (response.statusCode == 200) {
      WrongCredential wrongCredential =
          WrongCredential.fromJson(jsonDecode(response.body));
      // print('wrongCredential.message: ${wrongCredential.message}');
      // print(wrongCredential.message);
      msg = wrongCredential.message;
      return msg;
    }
    if (response.statusCode == 201) {
      msg = "Signup successful";

      var customerDetails = Customers.fromJson(jsonDecode(response.body));
      // print(customerDetails.email);
    } else {
      msg = "Your Email-ID is already exists.";
    }
    return msg;
  }

  Future getCustomers(int id) async {
    var url = "${Config.url}" "${Config.urlfor}" "${Config.customerUrl}/$id";
    var response = await api.getAsync(url);

    return response;
  }

  Future<Customers> getCustomersByMail(String mail) async {
    // var url="${Config.customerUrl}?email=$mail";
    // var url="${Config.customerUrl}?email=$mail";
    var url = "${Config.urlfor}customers?email=$mail";

    var response = await api.getAsync(url);

    print('getCustomersByMail: $response');

    Customers customer = Customers.fromJson(response[0]);
    // print('fromJson: ${response[0]}');
    return customer;
  }

  Future getUsernameByMail(String mail) async {
    var url = "${Config.urlfor}${Config.customerUrl}?email=$mail";
    String username;
    var response = await api.getAsync(url);
    if (response.length == 0) {
      username = null;
    } else {
      Customers customer = Customers.fromJson(response[0]);
      print('username: ${customer.firstName}');
      username = customer.username;
    }
    return username;
  }

  Future getToken(String username, String password) async {
    var url = "https://www.farmerica.in/wp-json/jwt-auth/v1/token";
    print('getToken: $url');
    var response = await http.post(
      Uri.parse(url),
      body: {"username": username, "password": password},
    );
    print('response: ${response.body}');
    if(response.statusCode == 403) {
      print('wrong password');
      return response.statusCode;
    }
    TokenResponses data = TokenResponses.fromJson(jsonDecode(response.body));
    print('data: ${data.token}');
    print('password: ${password}');
    print('password: ${password}');
    return data;
    // return data.token;
  }

  Future getTokenDetails(String username, String password) async {
    var url = "https://www.farmerica.in/wp-json/jwt-auth/v1/token";
    var response = await http.post(
      Uri.http(url),
      body: {"username": username, "password": password},
    );
    TokenResponses data = TokenResponses.fromJson(jsonDecode(response.body));

    print("data.token: ${data.token}");
    return data;
  }

  Future authenicateViaJWT(String username, String password) async {
    String token = "";
    var url = "https://www.farmerica.in/wp-json/jwt-auth/v1/token";
    http.Response response = await http.get(
      Uri.http(url),
      headers: {
        "Content-Type": "",
        "Accept": "",
        "Authorization": "Bearer $token"
      },
    );

    TokenResponses data = TokenResponses.fromJson(jsonDecode(response.body));
    // print(data.userEmail);
    // print(response.body);
  }

  Future retrieveUserDetails(String email) async {
    var auth =
        "Basic" + base64Encode(utf8.encode("${Config.key}:${Config.secret}"));
    var url = "${Config.url}" "${Config.emailurl}$email";
    // print('retrieveUserDetails: ${url}');
    http.Response response = await http.get(
      Uri.http(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": auth
      },
    );

    // print(response.body);
  }

  Future getProductsById(int id) async {
    var url = "${Config.urlfor}" "${Config.productUrl}/$id";
    // print('getProductsById: $url');
    var response = await api.getAsync(url);

    Product product = Product.fromJson(response);
    // print('productsByID: ${product.name}');
    return product;
  }


  Future<List<BundledProduct>> getBundled(int id) async {
    var url = "${Config.urlfor}" "${Config.productUrl}/$id?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c";
    // print('getCoupon: $url');
    var response = await api.getAsync(url);
    List<BundledProduct> bundledList = [];
    if(response is List){
      for (var item in response) {
        bundledList.add(BundledProduct.fromJson(item));
      }
    }

    print('bundledList: $bundledList');
    return bundledList;
  }


  Future<List<Coupon>> getCoupon() async {
    var url = "${Config.urlfor}" "${Config.coupons}?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c";
    // print('getCoupon: $url');


    var response = await api.getAsync(url);
    List<Coupon> couponList = [];
    for (var item in response) {
      couponList.add(Coupon.fromJson(item));
    }
    return couponList;
  }


  Future<List<ParentCategory>> getCategory(int parentId) async {
    var url = "${Config.urlfor}" "${Config.categoriesUrl}/$parentId";
    // print('getCategory: $url');
    var response = await api.getAsync(url);

    List<ParentCategory> categoryList = [];
    for (var item in response) {
      categoryList.add(ParentCategory.fromJson(item));
    }
    return categoryList;
  }

  Future<List<Product>> getProducts(int id) async {
    var url = "${Config.urlfor}"
        "${Config.productUrl}?category=$id&per_page=100"
        "&consumer_key=${Config.key}"
        "&consumer_secret=${Config.secret}";

    var response = await api.getAsync(url);
    // print(response);
    List<Product> productList = [];
    // print('getProducts: $url}');
    // print('getProducts: ${response.length}');
    // print('getProducts: ${productList.length}');
    for (var item in response) {
      // print('getProductss: ${Product.fromJson(item)}');
      if (Product.fromJson(item).catalogVisibility == 'visible' && Product.fromJson(item).price.isNotEmpty ) {
        // print('objectItem: $item');
        productList.add(Product.fromJson(item));
      }
    }
    //print('productList: ${productList[0].name}');
    return productList;
  }

  Future<List<Orders>> getOrders() async {
    var url = "${Config.urlfor}" "${Config.orderUrl}?per_page=100";
    var response = await api.getAsync(url);
    // print(response);
    List<Orders> orderList = [];
    for (var item in response) {
      orderList.add(Orders.fromJson(item));
    }

    return orderList;
  }

  Future<List<ParentCategory>> getCategoryById(int id) async {
    var url = "${Config.urlfor}"
        "${Config.productUrl}"
        "?categories=$id";
    // "${Config.parentforCategory}$id";
    // print('getCategoryById: $url');
    var response = await api.getAsync(url);
    List<ParentCategory> categoryList = [];
    for (var item in response) {
      categoryList.add(ParentCategory.fromJson(item));
    }
    // print('returnCategory: ${categoryList.toList()}');
    return categoryList;
  }

  Future<List<Orders>> getOrdersById(int id) async {
    var url = "${Config.urlfor}" "${Config.orderUrl}/$id";
    // print(url);
    var response = await api.getAsync(url);
    // print(response);
    List<Orders> orderList = [];
    for (var item in response) {
      orderList.add(Orders.fromJson(item));
    }
    // print(orderList);

    return orderList;
  }

  Future<List<Orders>> getOrdersByUserId(int id) async {
    var url = "${Config.urlfor}" "${Config.orderUrl}?customers=$id";
    // print('orderUrl: $url');
    var response = await api.getAsync(url);
    // print(response);
    List<Orders> orderList = [];
    for (var item in response) {
      orderList.add(Orders.fromJson(item));
    }
    // print('orderList: $orderList');

    return orderList;
  }

  Future addToCart(int id) async {
    var url = "/?${Config.addtoCartUrl}" "=$id";
    var response = await api.getAsync(url);
    // print(response);
    return response;
  }

  Future deleteAccount(int id) async {
    var url = "${Config.urlfor}" "${Config.customerUrl}/$id?force=true";
    // print(url);
    var response = await api.deleteAsync(url);
    // print(response);
  }

  final String baseUrl = 'https://www.farmerica.in';
  final String consumerKey = 'ck_eedc4b30808be5c1110691e5b29f16280ebd3b72'; // Replace with your consumer key
  final String consumerSecret = 'cs_2313913bc74d5e096c91d308745b50afee52e61c'; // Replace with your consumer secret
  final int customerId = 106;

  Future<void> updateCustomers({
    String email,
    String firstName,
    String lastName,
    String phone,
    String address1,
    String address2,
    String city,
    String postcode,
    int id,
    }) async {
      final String endpoint = '/wp-json/wc/v3/customers/$id';
      final String url = baseUrl + endpoint;
      final String basicAuth = 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'billing': {
          'phone': phone,
          'address_1': address1,
          'address_2': address2,
          'city': city,
          'postcode': postcode,
        },
      }),
    );
      print('updateUrl: $url');
    if (response.statusCode == 200) {
      print('Customer data updated successfully!');
      print('response: $response');
    } else {
      print('Failed to update customer data: ${response.body}');
    }
  }

  ///
  // Future updateCustomers(
  //     {String firstName,
  //     String lastName,
  //     String email,
  //     String username,
  //     String phone,
  //     String address_1,
  //     String address_2,
  //     String city,
  //     String postcode,
  //     int id}) async {
  //   print('userId: $id');
  //   print('userId: $phone');
  //   print(
  //       'email-$email, fName-$firstName, lName-$lastName, phone-$phone, address-1-$address_1, address-2-$address_2, city-$city, pincode-$postcode');
  //
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     // 'Cookie': 'cxssh_status=off; mailpoet_page_view=%7B%22timestamp%22%3A1680481400%7D'
  //   };
  //   var request = http.Request(
  //       'PUT',
  //       Uri.parse(
  //           'https://www.farmerica.in/wp-json/wc/v3/customers/$id?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c'));  //?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c
  //   request.body = json.encode({
  //     "email": email,
  //     "first_name": firstName,
  //     "last_name": lastName,
  //     "billing": {
  //       "phone": phone,
  //       "address_1": address_1,
  //       "address_2": address_2,
  //       "city": city,
  //       "postcode": postcode
  //     }
  //   });
  //   request.headers.addAll(headers);
  //
  //   print('url: $request');
  //   // http.StreamedResponse response = await request.send();
  //   var streamedResponse = await request.send();
  //   var response = await http.Response.fromStream(streamedResponse);
  //
  //   if (response.statusCode == 200) {
  //     // print(await response.stream.bytesToString());
  //     var result = json.decode(response.body) as Map<String, dynamic>;
  //     var customerDetails = Customers.fromJson(result);
  //     print(customerDetails.email);
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  //   ///
  //   // var url = "${Config.urlfor}" "${Config.customerUrl}/$id?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
  //   // print(url);
  //   // var body = (json.encode({
  //   //   "email": email,
  //   //   "first_name": firstName,
  //   //   "last_name": lastName,
  //   //   "billing": {
  //   //     "phone": phone,
  //   //     "address_1": address_1,
  //   //     "address_2": address_2,
  //   //     "city": city,
  //   //     "postcode": postcode,
  //   //   }
  //   //
  //   // }));
  //   // var response = await api.putAsync(url, jsonDecode(body));
  //   // print(response);
  //   //
  //   // var customerDetails = Customers.fromJson(response);
  //   // // print(customerDetails.email);
  // }

  // Future<Orders> createOrder({
  //   String first,
  //   String last,
  //   String city,
  //   String state,
  //   String postcode,
  //   String apartmnt,
  //   String flat,
  //   String mobile,
  //   String mail,
  //   String address,
  //   String country,
  //   String paymentMethod,
  //   String paymentMethodTitle,
  //   String delivery_type,
  //   String delivery_time,
  //   bool setPaid,
  //   int id,
  //   String gift_from,
  //   String gift_message,
  //
  //   List<CartProducts> cartProducts,
  // }) async {
  //   final url = Uri.parse(
  //     '${Config.url}/wp-json/wc/v3/orders?consumer_key=${Config.key}&consumer_secret=${Config.secret}',
  //   );
  //   print('orderURL: $url');
  //   final parameters = <String, dynamic> {
  //     "payment_method": paymentMethod,
  //     "payment_method_title": paymentMethodTitle,
  //     "customer_id": 1,
  //     "set_paid": setPaid,
  //     "billing": {
  //       "first_name": first,
  //       "last_name": last,
  //       "address_1": address,
  //       "address_2": "",
  //       "city": city,
  //       "state": state,
  //       "postcode": postcode,
  //       "country": country,
  //       "email": mail,
  //       "phone": mobile,
  //     },
  //     "shipping": {
  //       "first_name": first,
  //       "last_name": last,
  //       "address_1": address,
  //       "address_2": "",
  //       "city": city,
  //       "state": state,
  //       "postcode": postcode,
  //       "country": country,
  //     },
  //     "meta_data" : [
  //       {
  //         "key": delivery_type.toString(),
  //         "value": delivery_time.toString(),
  //       },
  //       {
  //         "key": gift_from.toString(),
  //         "value": gift_message.toString(),
  //       }
  //     ],
  //     "line_items": cartProducts
  //   };
  //
  //   final request = await client.postUrl(url);
  //   request.headers.set("Content-Type", "application/json; charset=utf-8");
  //   request.write(jsonEncode(parameters));
  //   print('orderURL: ${jsonEncode(parameters)}');
  //   final response = await request.close();
  //   print('orderResponse: $response');
  //   final jsonStrings = await response.transform(utf8.decoder).toList();
  //   final jsonString = jsonStrings.join();
  //   final json = jsonDecode(jsonString) as Map<String, dynamic>;
  //   final order = Orders.fromJson(json);
  //   print('objectOrder: $order');
  //   return order;
  // }
  ///

  Future createOrder({
    String payment_method,
    String payment_method_title,
    String firstName,
    String lastName,
    String addressOne,
    String addressTwo,
    String city,
    String country,
    String state,
    String postcode,
    String email,
    String phone,
    String total,
    int product_id,
    int quantity,
    String delivery_type,
    String delivery_time,
    String gift_from,
    String gift_message,
    List<CartProducts> cartProducts,
    List<Coupon> coupon_lines,
    String coupon,


  }) async {
    final productsData = cartProducts.map((product) => {
      'product_id': product.product_id,
      'quantity': product.quantity, }).toList();

    // final couponData = coupon_lines.map((coupon) => {
    //   'coupon': coupon.code,
    //   'amount': coupon.amount, }).toList();

    print('Prod Qty: ${cartProducts}');
    var url = Uri.parse(
      '${Config.url}/wp-json/wc/v3/orders?consumer_key=${Config.key}&consumer_secret=${Config.secret}',
    );
    var parameters = <String, dynamic>{
      'payment_method_title': 'Cash on Delivery',
      'payment_method': 'cp',
      'billing': {
        'first_name': firstName,
        'last_name': lastName,
        'address_1': addressOne,
        'address_2': addressTwo,
        'city': city,
        'country': country,
        'state': state,
        'postcode': postcode,
        'email': email,
        'phone': phone,
      },
      'shipping': {
        'first_name': firstName,
        'last_name': lastName,
        'address_1': addressOne,
        'address_2': addressTwo,
        'city': city,
        'country': country,
        'state': state,
        'postcode': postcode,
        'email': email,
        'phone': phone,
      },
      // 'line_items': [
      //   {
      //     'product_id': product_id,
      //     "quantity": quantity,
      //   },
      // ],
      "line_items": productsData,
      'meta_data': [
        {"key": "delivery_date", "value": delivery_type},
        {
          "key": "delivery_time",
          "value": delivery_time,
        },
        {"key": "gift_from", "value": gift_from},
        {"key": "gift_message", "value": gift_message}
      ],
      'coupon_lines': [
        {
          "code": coupon.toString(),
        }
      ]
    };

    print('objectCoupon: $coupon');

    final request = await client.postUrl(url);
    request.headers.set("Content-Type", "application/json; charset=utf-8");
    request.write(jsonEncode(parameters));
    final response = await request.close();
    final jsonStrings = await response.transform(utf8.decoder).toList();
    final jsonString = jsonStrings.join();
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final order = Orders.fromJson(json);

    print('orderResponse: ${response}');

    print('order created successfully');
    print('Order Details: ${order}');
    return order;
  }

  // Future<Orders> createOrder({
  //   String first,
  //   last,
  //   city,
  //   state,
  //   postcode,
  //   apartmnt,
  //   flat,
  //   mobile,
  //   mail,
  //   address,
  //   country,
  //   paymentMethod,
  //   paymentMethodTitle,
  //   delivery_type,
  //   delivery_time,
  //   bool setPaid,
  //   int id,
  //   String gift_from,
  //   String gift_message,
  //
  //   List<CartProducts> cartProducts,
  // }) async {
  //   // CreateOrderModel model = CreateOrderModel();
  //   var url = "${Config.urlfor}" "${Config.orderUrl}?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
  //   print('orderUrl: $url');
  //   var body = jsonEncode({
  //     "payment_method": paymentMethod,
  //     "payment_method_title": paymentMethodTitle,
  //     "customer_id": 1,
  //     "set_paid": setPaid,
  //     "billing": {
  //       "first_name": first,
  //       "last_name": last,
  //       "address_1": address,
  //       "address_2": "",
  //       "city": city,
  //       "state": state,
  //       "postcode": postcode,
  //       "country": country,
  //       "email": mail,
  //       "phone": mobile,
  //     },
  //     "shipping": {
  //       "first_name": first,
  //       "last_name": last,
  //       "address_1": address,
  //       "address_2": "",
  //       "city": city,
  //       "state": state,
  //       "postcode": postcode,
  //       "country": country,
  //     },
  //     "meta_data" : [
  //       {
  //         "key": delivery_type.toString(),
  //         "value": delivery_time.toString(),
  //       },
  //       {
  //         "key": gift_from.toString(),
  //         "value": gift_message.toString(),
  //       }
  //     ],
  //     "line_items": cartProducts
  //   });
  //   print('orderBody: $body');
  //   var response = await api.postAsync(url, jsonDecode(body));
  //   Orders order = Orders.fromJson(response);
  //   print('Response: ${response}');
  //   print('orderPOST: $order');
  //   return order;
  // }

  getProduct(List<CartProducts> cartProducts) async {
    int i = 0;
    Api_Services api_services = Api_Services();
    List<Product> products = [];

    while (i < cartProducts.length) {
      Product product =
          await api_services.getProductsById(cartProducts[i].product_id);
      i++;

      products.add(product);
    }

    return products;
  }

  Future loginCustomer(String email, String password) async {
    var response = await api.getAsync(Config.categoriesUrl);
    LoginResponse login = LoginResponse();
    return;
  }
  //
  // Future<List<Category>> getCategories() async {
  //   String parent = "?parent=133";
  //   var response = await api.getAsync(Config.categoriesUrl + parent);
  //   List<Category> categoryList = [];
  //   for (var item in response) {
  //     categoryList.add(Category.fromJson(item));
  //   }
  //   return categoryList;
  // }
  //
  // Future<List<Product>> getProduct(
  //     {String tagId,
  //       String labelName,
  //       String sortBy,
  //       String sortOrder,
  //       String strSearch,
  //       String tagName,
  //       pageNumbr,
  //       int pageSize,
  //       String categoryId}) async {
  //   String tag = tagId == null ? "" : "?tag=$tagId";
  //   var response = await api.getAsync(Config.productUrl + tag);
  //   List<Product> products = [];
  //   for (var item in response) {
  //     products.add(Product.fromJson(item));
  //   }
  //   return products;
  // }
  //
  // Future<OrderDetailsModel> getOrder(String orderId) async{
  //   var url=Config;
  //   String order= orderId==null?"":"/tag=$orderId";
  //   var response= await api.getAsync(Config.orderUrl+orderId,);
  //   OrderDetailsModel orders;
  //   for (var item in response){
  //     OrderDetailsModel.fromJson(item);
  //   }
  //   return orders;
  // }
  //

}

// class MetaDatas {
//   String key;
//   String value;
//
//   MetaDatas({this.key, this.value});
//
//   MetaDatas.fromJson(Map<String, dynamic> json) {
//     key = json['key'];
//     value = json['value'].toString();
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['key'] = this.key;
//     data['value'] = this.value;
//     return data;
//   }
// }
