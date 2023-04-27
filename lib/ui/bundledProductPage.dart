import 'dart:convert';

import 'package:farmerica/Config.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/utils/pincode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:farmerica/models/Products.dart' as p;

class BundledProductPage extends StatefulWidget {
  final int productId;

  BundledProductPage({this.productId});

  @override
  State<BundledProductPage> createState() => _BundledProductPageState();
}

class _BundledProductPageState extends State<BundledProductPage> {
  p.Product product;
  Map<String, dynamic> _product;

  List<dynamic> dummyId = [];
  Future _fetchProduct() async {
    final response = await http.get(Uri.parse(
        'https://www.farmerica.in/wp-json/wc/v3/products/${widget.productId}?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c'));

    if (response.statusCode == 200) {
      final product = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        _product = product;

        _product['meta_data'][0]['value'].forEach((key, value) {
          setState(() {
            dummyId.add(value['id']);
          });
        });
      });
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> getProductsById(int id) async {
    final response = await http
        .get(Uri.parse('https://www.farmerica.in/wp-json/wc/v3/products/$id?consumer_key=ck_eedc4b30808be5c1110691e5b29f16280ebd3b72&consumer_secret=cs_2313913bc74d5e096c91d308745b50afee52e61c'));

    if (response.statusCode == 200) {
      final product = jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(product);
    } else {
      throw Exception('Failed to load product');
    }
  }

  int counter = 0;
  int minValue = 0;
  int maxValue = 10;
  ValueChanged<int> onChanged;
  Map<int, int> counts = {};
  bool flag = false;
  bool errorMsg = true;

  double get totalCount {
    double total = 0;
    counts.forEach((index, count) {
      if (count > 0) {
        total += count;
        print('totalCount: $count');
      }
    });
    return total;
  }

  @override
  void initState() {
    _fetchProduct();
    print(dummyId.toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Future<Product>> products = dummyId.map((id) => getProductsById(int.parse(id))).toList();
    List<Product> cart = [];

    if (_product == null) {
      print('Meta Data is loading');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff00ab55),
          centerTitle: true,
          title: Image.asset(
            'assets/farmerica-logo.png',
            color: Colors.white,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00ab55),
        centerTitle: true,
        title: Text(_product['name'].toString()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_product['name'], style: Theme.of(context).textTheme.headline4),
              // Text(parse(_product['description'].body.text).documentElement.text, style: Theme.of(context).textTheme.headline4),
              FutureBuilder<List<Product>>(
                future: Future.wait(products),
                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    double totalPrice = 0.0;
                    counts.forEach((index, count) {
                      if (count > 0) {
                        print('total: ${snapshot.data[index].price}');
                        print('total: ${snapshot.data[index].price.runtimeType}');
                        print('total: ${count.runtimeType}');
                        print('total: $totalPrice');
                        print('total: ${totalPrice.runtimeType}');
                        totalPrice += double.parse(snapshot.data[index].price) * count;
                      }
                    });
                    return Column(
                      children: [
                        Text("₹" '$totalPrice', style: Theme.of(context).textTheme.headline6),
                        // Text('Total Count: ${counts.values.reduce((sum, count) => sum + count)}'),
                        Text('Total Price: $totalPrice'),
                        GridView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            Product product = snapshot.data[index];
                            int count = counts[index] ?? 0;
                            return Card(
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                        product.images[0].src,
                                        height: 145,
                                        fit: BoxFit.contain,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 50,
                                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.75)),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                product.name,
                                                maxLines: 2,
                                                style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w300, fontSize: 15),
                                              )),
                                              Text(
                                                '₹ ${product.price}',
                                                style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w500, fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (count > 0) {
                                              counts[index] = count - 1;
                                              Fluttertoast.showToast(
                                                msg: "${product.name} removed from cart",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                      Text('${counts[index] ?? 0}'),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            counts[index] = count + 1;
                                            print('count: $count');
                                            print('countIndex: ${counts[index]}');

                                            // Provider.of<CartModel>(context, listen: false);
                                            cart.add(product);
                                            Provider.of<CartModel>(context, listen: false).addCartProduct(
                                              product.id,
                                              counts[index],
                                              product.name,
                                              product.price,
                                              product.images[0].src,
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    'Delivery Check',
                    style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 80,
                    child: Autocomplete(
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          setState(() {
                            flag = false;
                            errorMsg = true;
                          });
                          if (textEditingValue.text != pinCodes) {
                            setState(() {
                              errorMsg = false;
                            });
                          }
                          return const Iterable.empty();
                        }

                        return pinCodes.where((element) {
                          return element.contains(textEditingValue.text);
                        });
                      },
                      onSelected: (value) async {
                        setState(() {
                          flag = true;
                          errorMsg = false;
                        });
                      },
                    ),
                  ),
                  flag
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          decoration: const BoxDecoration(color: Color(0xfff7f6f7)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${String.fromCharCode(8226)} Shipping methods available for your location:'),
                              Text('${String.fromCharCode(8226)} Free shipping'),
                              Text('${String.fromCharCode(8226)} Midnight Delivery 11pm to 12am: 200.00'),
                              Text('${String.fromCharCode(8226)} Early morning Delivery 6:30am to 7am : 75.00'),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff00ab55),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "BUY NOW",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: errorMsg
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  decoration: const BoxDecoration(color: Color(0xfff7f6f7)),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.info, color: Color(0xffb81c23)),
                                      SizedBox(width: 10),
                                      Text('Please enter a postcode / ZIP.', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  decoration: const BoxDecoration(color: Color(0xfff7f6f7)),
                                  child: const Text('Delivery not available', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black))),
                        )
                ],
              ),

              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
