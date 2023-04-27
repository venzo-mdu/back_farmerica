import 'dart:ui';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/models/Products.dart' as p;
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/CartPage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({this.product});

  final p.Product product;
  Customers customer;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int selected = 1;
  bool loa = true;
  String parsHtml(String as) {
    final htmls = parse(as);
    final String pars = parse(htmls.body.text).documentElement.text;
    // print(pars);
    setState(() {
      loa = false;
    });
    return pars;
  }
  List<Product> response;

  String shortDes;
  final List<String> pinCodes = [
    '751001',
    '752103',
    '751022',
    '751020',
    '752103',
    '751003',
    '751009',
    '752102',
    '751014',
    '751018',
    '752100',
    '752101',
    '752102',
    '752103',
    '751002',
    '751009',
    '751003',
    '752101',
    '752100',
    '752103',
    '752103',
    '751003',
    '751002',
    '751022',
    '751014',
    '751001',
    '751009',
    '751001',
    '752102',
    '752100',
    '752102',
    '751006',
    '751011',
    '752102',
    '751016',
    '752102',
    '752103',
    '752102',
    '751019',
    '751025',
    '752100',
    '752102',
    '751003',
    '751002',
    '751002',
    '751015',
    '751002',
    '752101',
    '752101',
    '752100',
    '751024',
    '752102',
    '751024',
    '751019',
    '751006',
    '751002',
    '752103',
    '751002',
    '751030',
    '751001',
    '751002',
    '752100',
    '751006',
    '751022',
    '752102',
    '752103',
    '751003',
    '751017',
    '751017',
    '751017',
    '752101',
    '751012',
    '752102',
    '751002',
    '751001',
    '751017',
    '752103',
    '751024',
    '751019',
    '751020',
    '752102',
    '752102',
    '751008',
    '751010',
    '751013',
    '751023',
    '751007',
    '751021',
    '751005',
    '751002',
    '752100',
    '751019',
    '752102',
    '752100',
    '751007',
    '752100',
    '751006',
    '751002',
    '751003',
    '752100',
    '752102',
    '751009',
    '751004',
    '751007',
    '752054',
    '752050',
    '752054',
    '752054',
    '752050',
    '752054',
    '752054',
    '752050',
    '752050',
    '752050',
    '752050',
    '752054',
    '752054',
    '752054',
    '752054',
    '752050',
    '752050',
    '752054',
    '752050',
    '752054',
    '752050',
    '752050',
    '753015'
  ];
  var pincodeController = TextEditingController();
  bool flag = false;
  bool errorMsg = true;
  SharedPreferences pinCodePrefs;

  @override
  void initState() {
    super.initState();
    shortDes = parsHtml(widget.product.shortDescription);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = (screenSize.height) / 2;

    List<Product> cart = [];
    String title = widget.product.name;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff00ab55),
        title: Text(
          widget.product.name,
          maxLines: 3,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'OutFit',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          // container for the image of the product
          Container(
            height: screenHeight - 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    widget.product.images[0].src,
                  )),
            ),
          ),
          // provides vertical space of 10 pxl
          const SizedBox(height: 10),

          // container for the price & detail contents of the product
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                buildRowPriceRating(),
                const SizedBox(height: 10),
                Text(widget.product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'OutFit',
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 10),
                Text(loa ? "" : shortDes, style: normalText),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Delivery Check',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'OutFit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      // child: Autocomplete(
                      //   optionsBuilder: (textEditingValue) {
                      //     if (textEditingValue.text == '') {
                      //       setState(() {
                      //         flag = false;
                      //         errorMsg = true;
                      //       });
                      //       if(textEditingValue.text != pinCodes) {
                      //         setState(() {
                      //           errorMsg = false;
                      //         });
                      //       }
                      //       return const Iterable.empty();
                      //     }
                      //
                      //     return pinCodes.where((element) {
                      //       return element.contains(textEditingValue.text);
                      //     });
                      //   },
                      //   onSelected: (value) async {
                      //     pinCodePrefs = await SharedPreferences.getInstance();
                      //     pinCodePrefs.setString('pinCode', value);
                      //
                      //     setState(() {
                      //       flag = true;
                      //       errorMsg = false;
                      //     });
                      //
                      //     print('the $value was selected');
                      //     print('pinCodePrefs: ${pinCodePrefs.toString()}');
                      //   },
                      // ),
                      ///
                      child: TextFormField(
                        // initialValue: 'hi' ?? pinCodePrefs.getString('pinCode'),
                        controller: pincodeController,
                        onSaved: (value) {
                          value = pincodeController.text;
                        },
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.postalCode],
                        decoration: const InputDecoration(
                          hintText: "Postcode / ZIP",
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(0))),
                        ),
                        validator: (value){},
                      ),
                    ),
                  ],
                ),
                Center(
                  heightFactor: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffb240),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      // pinCodePrefs = await SharedPreferences.getInstance();
                      // pinCodePrefs.setString('pinCode', pincodeController.text);

                      TextInput.finishAutofillContext();
                      bool found = pinCodes.contains(pincodeController.text);
                      if(found) {
                        print('Same');
                        setState(() {
                          flag = true;
                          errorMsg = false;
                          // print('shippingVisibility: $shippingVisibility');
                        });
                      } else {
                        setState(() {
                          flag = false;
                          errorMsg = false;
                          // print('shippingVisibility: $shippingVisibility');
                        });
                      }
                    },
                    // color: product.color,
                    child: const Text(
                      "CHECK",
                      style: TextStyle(
                        fontSize: 15,

                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                flag
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        decoration:
                            const BoxDecoration(color: Color(0xfff7f6f7)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                '${String.fromCharCode(8226)} Shipping methods available for your location:'),
                            Text('${String.fromCharCode(8226)} Free shipping'),
                            Text(
                                '${String.fromCharCode(8226)} Midnight Delivery 11pm to 12am: 200.00'),
                            Text(
                                '${String.fromCharCode(8226)} Early morning Delivery 6:30am to 7am : 75.00'),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00ab55),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Provider.of<CartModel>(context, listen: false);
                                cart.add(widget.product);
                                Provider.of<CartModel>(context, listen: false)
                                    .addCartProduct(
                                        widget.product.id,
                                        1,
                                        widget.product.name,
                                        widget.product.price,
                                        widget.product.images[0].src,
                                );
                                Fluttertoast.showToast(
                                  msg:
                                      "${widget.product.name} successfully added to cart",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => CartScreen(
                                //         product: response,
                                //         details: widget.customer,
                                //       fromMainPage: false,
                                //         )));
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) => BasePage(selected:2)), (route) => false);

                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => BasePage(
                                //           title: "Farmerica App",
                                //           customer: customer,
                                //         )));
                              },
                              // color: product.color,
                              child: const Text(
                                "BUY NOW",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: pincodeController.text.isEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration:
                                    const BoxDecoration(color: Color(0xfff7f6f7)),
                                child: Row(
                                  children: const [
                                    Icon(Icons.info, color: Color(0xffb81c23)),
                                    SizedBox(width: 10),
                                    Text('Please enter a postcode / ZIP.',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration:
                                    const BoxDecoration(color: Color(0xfff7f6f7)),
                                child: const Text('Delivery not available',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)))),
              ],
            ),
          ),
        ],
      ),
    );

  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      //  backgroundColor: product.color,
      title: Text(
        widget.product.name,
        style: const TextStyle(fontSize: 22),
      ),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.add_shopping_cart,
            size: 30,
          ),
        )
      ],
    );
  }

  Row buildRowPriceRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Price: ₹${widget.product.price}", style: largeText),
        // RatingBarIndicator(
        //   rating: 3.75,
        //   itemBuilder: (context, index) => Icon(
        //     Icons.star,
        //     color: Colors.amberAccent,
        //   ),
        //   itemCount: 5,
        //   itemSize: 25.0,
        //   direction: Axis.horizontal,
        // ),
      ],
    );
  }
}

TextStyle smallText = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
);

TextStyle normalText = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);

TextStyle mediumText = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

TextStyle largeText = const TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);
