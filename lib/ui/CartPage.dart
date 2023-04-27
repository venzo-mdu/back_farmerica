import 'dart:async';
import 'dart:math';
import 'package:farmerica/models/coupon.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/Products.dart' as p;
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/categories.dart';
import 'package:farmerica/ui/createOrder.dart';
import "package:provider/provider.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/ui/productDetails.dart';
import 'package:farmerica/models/global.dart' as Globals;
import 'package:shared_preferences/shared_preferences.dart';

class AddtoCart {
  int addtoCart;
  AddtoCart({
    this.addtoCart,
  });
}

class CartScreen extends StatefulWidget {
  final bool fromMainPage;
  static String routeName = "/cart";
  List<p.Product> product;
  Customers details;

  CartScreen({this.product, this.details, this.fromMainPage});
  @override
  _CartScreenState createState() => _CartScreenState();
}

enum shipping { Free_Shipping, Midnight_Delivery_11pm_to_12am, Early_morning_Delivery_6am_to_7am }

var totalprice = 0;

class _CartScreenState extends State<CartScreen> {
  int counter = 1;
  int arraySize = 1;
  List counterArray = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

  double subTotals = 0.0;

  List<AddtoCart> addtoCart = [];
  List<Product> product;
  Product cart;
  int quantity = 1;
  int selected = 2;
  String title = "My Cart";
  var totalIndexPrice;
  double totalIndexPrices = 0.0;
  double totalSubtotal = 0.0;
  int dummyCount = 0;
  double finalTotal = 0.0;

  Timer timer;
  var shippingFee = 0;
  int checkOutVariable;
  bool showCoupon = false;
  bool intFlag = false;
  final TextEditingController _textEditingController = TextEditingController();

  String showPinCode;
  getPinCode() async {
    SharedPreferences pinCodePrefs = await SharedPreferences.getInstance();
    setState(() {
      showPinCode = pinCodePrefs.getString('pinCode') ?? '';
    });
  }

  Api_Services api_services = Api_Services();

  List couponList = [];
  // List<Coupon> dummyCouponList = [];
  Future getCouponCode() async {
    couponList = await api_services.getCoupon();

    // for (int i = 0; i < couponList.length; i++) {
    //   if(couponList[i].dateExpires != null) {
    //     dummyCouponList.add(couponList[i]);
    //   }
    // }
  }

  var couponSelection;
  var couponDiscount;
  var couponTotal;
  var clearCoupon;


  @override
  void initState() {
    // print('appbar: ${widget.fromMainPage}');
    getCouponCode();
    getPinCode();
    super.initState();
  }

  shipping _character = shipping.Free_Shipping;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    List cartItem = [];
    var cartCount;

    return Consumer<CartModel>(builder: (context, cartModel, child) {
      if (cartModel.cartProducts.isEmpty) {
        return Scaffold(
          body: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(
              Icons.hourglass_empty,
              size: 30,
            ),
            Text(
              "Your Cart is empty",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ])),
        );
      } else {
        totalSubtotal = 0;
        for (dynamic it in cartModel.cartProducts) {
          cartItem.add({
            'name': it.name,
            'price': it.price,
            'images': it.image,
            'id': it.product_id,
            'quantity': it.quantity,
          });
          print('addCartProduct: ${it.quantity}');
          cartCount = 1;

          print('Quantity: ${it.quantity.runtimeType}');
          print('Quantity: ${counterArray.runtimeType}');
          counterArray.add(it.quantity);

          counter = it.quantity;
          // setState(() {
            Globals.cartCount = counter;
          // });


          // if(cartModel.addCartProduct(it.product_id, it.quantity, it.name, it.price, it.image)){
          //   print('addCartProduct: ${it.quantity}');
          // }
          // print('productID: ${it.name}');

          addtoCart.add(AddtoCart(addtoCart: 1));
          if (intFlag == false) {
            subTotals += double.parse(it.price);
            finalTotal += double.parse(it.price);
          }
          arraySize++;
          intFlag = true;
        }
        subTotals = 0;
        for (int i = 0; i < cartItem.length; i++) {
          subTotals += int.parse(cartItem[i]['price']) * counter;
        }

        Future<void> _showAlertDialog() async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Apply the Coupon'),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: Autocomplete(optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      } else {
                        //print('Coupon: ${couponList[0].code}');
                        //print('Coupon: ${couponList[1].code}');
                        List matches = [];
                        List<String> tempCoupon = [];
                        for (int i = 0; i < couponList.length; i++) {
                          //print('TtemCopon: ${couponList[i].code}');
                          tempCoupon.add(couponList[i].code);
                        }
                        print('tempCoupon: $tempCoupon');
                        matches.addAll(tempCoupon);
                        // matches.map((element) => element.addAll(tempCoupon));
                        matches.retainWhere((s) {
                          print('objectS: $s');
                          return s.toString().contains(textEditingValue.text.toString());
                        });
                        return matches;
                      }
                    }),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // TextButton(
                  //   child: const Text('Apply'),
                  //   onPressed: () {
                  //     print('CouponCode: ${_couponCodeController.text} same');
                  //
                  //     if (_couponCodeController.text == 'farmom10') {
                  //       print('CouponCode: ${_couponCodeController.text} same');
                  //
                  //       // finalTotal =
                  //
                  //     }
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                ],
              );
            },
          );
        }

        return Scaffold(
          appBar: !widget.fromMainPage
              ? AppBar(
                  title: const Text(
                    'My Cart',
                    style: TextStyle(color: Colors.black),
                  ),
                  elevation: 0,
                )
              : PreferredSize(
                  preferredSize: const Size(0, 0),
                  child: Container(),
                ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 450,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: cartItem.length,
                    itemBuilder: (context, index) {
                      checkOutVariable = index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 84,
                                    child: AspectRatio(
                                      aspectRatio: 0.88,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F6F9),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Image.network(cartItem[index]['images']),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                    height: 100,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem[index]['name'],
                                        style: TextStyle(color: Colors.black, fontSize: width * 0.04),
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 10),
                                      Text.rich(
                                        TextSpan(
                                          text: "₹${cartItem[index]['price']}",
                                          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                                          children: [
                                            TextSpan(text: " ", style: Theme.of(context).textTheme.bodyText1),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                //decrement(index);
                                                if(counter > 0 ){
                                                  setState(() {
                                                    counter--;
                                                  });
                                                }else{
                                                  setState(() {
                                                    counter = 1;
                                                  });
                                                }
                                                subTotals = 0;
                                                for (int i = 0; i < cartItem.length; i++) {
                                                  print('DecCounter: $counter');
                                                  subTotals += int.parse(cartItem[i]['price']) * counter;
                                                }
                                                finalTotal = shippingFee + subTotals;
                                              },
                                              child: const Text('-')),
                                          Text(counter.toString()), //?? counterArray[index].toString()
                                          TextButton(
                                              onPressed: () {
                                                print('cartCount: ${cartCount.toString()}');
                                                print('counterArray[cartCount]: ${counterArray[cartCount].toString()}');

                                                print('counterArray: ${counterArray[index].toString()}');
                                                // increment(index);
                                                setState(() {
                                                  counter++;
                                                });
                                                subTotals = 0;
                                                for (int i = 0; i < cartItem.length; i++) {
                                                  setState(() {
                                                    subTotals += int.parse(cartItem[i]['price']) * counter;

                                                  });
                                                }
                                                print('CounterInc: $counter => $subTotals');
                                                // setState((){
                                                  finalTotal = shippingFee + subTotals;
                                                // });
                                              },
                                              child: const Text('+')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                key: Key(cartItem[index]['id'].toString()),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Farmerica'),
                                        content: const Text('Are you sure you want to delete this item?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Ok'),
                                            onPressed: () {
                                              // print('removeCartProduct: ${cartItem[index].id.cast<String,dynamic>()}');
                                              // print('removeCartProduct: ${cartItem[index].id.runtimeType}');
                                              setState(() {
                                                cartItem.removeAt(index);
                                                cartModel.cartProducts.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  // height: 174,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, -15),
                        blurRadius: 20,
                        color: const Color(0xFFDADADA).withOpacity(0.15),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'CART TOTALS',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // for (int i = 0; i < cartItem.length; i++) {
                              //   subTotals += int.parse(cartItem[i]['price']) * counterArray[i];
                              // },
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Subtotal'),
                              ),

                              Text('₹$subTotals')
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping'),
                              Text(shipping.Free_Shipping == _character
                                  ? '₹0.00'
                                  : shipping.Early_morning_Delivery_6am_to_7am == _character
                                      ? '₹75.00'
                                      : '₹200.00'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('$_character'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Shipping to $showPinCode, India'),
                            ],
                          ),
                          Column(
                            children: [
                              RadioListTile<shipping>(
                                  title: const Text("Free shipping"),
                                  subtitle: const Text('₹0.00'),
                                  value: shipping.Free_Shipping,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0; i < cartItem.length; i++) {
                                        finalTotal += int.parse(cartItem[i]['price']) * counterArray[i];
                                      }
                                      finalTotal = 0 + finalTotal;

                                      shippingFee = 0;
                                      _character = value;
                                    });
                                  }),
                              RadioListTile<shipping>(
                                  title: const Text("Midnight Delivery 11pm to 12am"),
                                  subtitle: const Text('₹200.00'),
                                  value: shipping.Midnight_Delivery_11pm_to_12am,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0; i < cartItem.length; i++) {
                                        finalTotal += int.parse(cartItem[i]['price']) * counterArray[i];
                                      }
                                      finalTotal = 200 + finalTotal;

                                      _character = value;
                                      shippingFee = 200;
                                    });
                                  }),
                              RadioListTile<shipping>(
                                  title: const Text("Early morning Delivery 6.30am to 7am"),
                                  subtitle: const Text('₹75.00'),
                                  value: shipping.Early_morning_Delivery_6am_to_7am,
                                  groupValue: _character,
                                  onChanged: (shipping value) {
                                    setState(() {
                                      finalTotal = 0;
                                      for (int i = 0; i < cartItem.length; i++) {
                                        finalTotal += int.parse(cartItem[i]['price']) * counterArray[i];
                                      }
                                      finalTotal = 75 + finalTotal;

                                      shippingFee = 75;
                                      _character = value;
                                    });
                                  }),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('Total: '),
                              ),
                              Text('₹${finalTotal.toString()}'),
                            ],
                          ),
                        ],
                      ),
                      // Container(
                      //   color: Colors.amber,
                      //   width: 200,
                      //   child: Autocomplete(
                      //     optionsBuilder: (textEditingValue) {
                      //       if (textEditingValue.text == '') {
                      //         return const Iterable<String>.empty();
                      //       } else {
                      //         List matches = [];
                      //         List<String> tempCoupon = [];
                      //         for (int i = 0; i < couponList.length; i++) {
                      //           tempCoupon.add(couponList[i].code);
                      //         }
                      //         matches.addAll(tempCoupon);
                      //         matches.retainWhere((s) {
                      //           return s
                      //               .toString()
                      //               .contains(textEditingValue.text.toString());
                      //         });
                      //         return matches;
                      //       }
                      //     },
                      //
                      //     onSelected: (selection) {
                      //       print('You just selected $selection');
                      //     },
                      //
                      //   ),
                      // ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  showCoupon = !showCoupon;
                                });
                              },
                              child: const Text("Add a coupon")),
                          const SizedBox(width: 10),

                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _textEditingController.clear();

                                couponSelection = 0;
                                couponDiscount = 0;
                                couponTotal = 0;
                              });
                            },
                          ),

                          Container(
                            width: 100,
                            height: 50,
                            child: TextField(
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                hintText: 'Type coupon code...',
                                suffixIcon: Autocomplete<String>(
                                  optionsBuilder: (textEditingValue) {
                                    var clearCoupon = textEditingValue.text;

                                    if (textEditingValue.text == '') {
                                      couponSelection = 0;

                                      couponDiscount = 0;

                                      couponTotal = 0;

                                      print('coupons:$couponSelection');

                                      print('couponDiscounts:$couponDiscount');

                                      print('couponTotals:$couponTotal');

                                      return const Iterable<String>.empty();
                                    } else {
                                      List<String> tempCoupon = couponList.map((c) => c.code).toList();

                                      var matches = tempCoupon.where((s) {
                                        return s.toString().contains(textEditingValue.text.toString());
                                      });

                                      return matches;
                                    }
                                  },
                                  onSelected: (selection) async {
                                    var trimValue = selection.toString().substring(selection.toString().length - 2);

                                    couponSelection = selection;

                                    couponDiscount = (double.parse(trimValue) / 100) * finalTotal;

                                    couponTotal = finalTotal - couponDiscount;

                                    print('coupon:$couponSelection');

                                    print('couponDiscount:$couponDiscount');

                                    print('couponTotal:$couponTotal');
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Container(
                          //   color: Colors.amber,
                          //   width: 200,
                          //   child: Autocomplete(
                          //     optionsBuilder: (textEditingValue) {
                          //       clearCoupon = textEditingValue.text;
                          //       if (textEditingValue.text == '') {
                          //         couponSelection = 0;
                          //         couponDiscount = 0;
                          //         couponTotal = 0;
                          //
                          //         print('coupons: $couponSelection');
                          //         print('couponDiscounts: $couponDiscount');
                          //         print('couponTotals: $couponTotal');
                          //
                          //         return const Iterable<String>.empty();
                          //       } else {
                          //         List matches = [];
                          //         List<String> tempCoupon = [];
                          //         for (int i = 0; i < couponList.length; i++) {
                          //           tempCoupon.add(couponList[i].code);
                          //         }
                          //         matches.addAll(tempCoupon);
                          //         matches.retainWhere((s) {
                          //           return s.toString().contains(textEditingValue.text.toString());
                          //         });
                          //         return matches;
                          //       }
                          //     },
                          //     onSelected: (selection) async {
                          //       var trimValue = selection;
                          //       if (selection.length > 0) {
                          //         trimValue = selection.toString().substring(selection.toString().length - 2);
                          //
                          //         couponSelection = selection;
                          //         couponDiscount = (double.parse(trimValue) / 100) * finalTotal;
                          //         couponTotal = finalTotal - couponDiscount;
                          //
                          //         print('coupon: $couponSelection');
                          //         print('couponDiscount: $couponDiscount');
                          //         print('couponTotal: $couponTotal');
                          //       }
                          //       // if (selection == '') {
                          //       //   setState(() {
                          //       //     couponSelection = 0;
                          //       //     couponDiscount = 0;
                          //       //     couponTotal = 0;
                          //       //
                          //       //     print('coupon: $couponSelection');
                          //       //     print('couponDiscount: $couponDiscount');
                          //       //     print('couponTotal: $couponTotal');
                          //       //   });
                          //       // }
                          //     },
                          //   ),
                          // ),
                          // IconButton(onPressed: (){
                          //   setState(() {
                          //     clearCoupon = '';
                          //     couponSelection = 0;
                          //   });
                          // }, icon: const Icon(Icons.clear))
                        ],
                      ),
                      Text('Coupon Applied: $couponTotal'),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ))),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Proceed to Checkout", style: TextStyle(fontSize: 18)),
                              ),
                              onPressed: () {
                                print('Details: ${widget.details.firstName}');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateOrder(
                                              couponSelection: couponSelection,
                                              shippingFee: shippingFee, // couponSelection, couponDiscount, couponTotal
                                              id: cartItem[0]['id'], // widget.details.id,
                                              cartProducts: cartModel.cartProducts,
                                              product: cartItem, //cart[checkOutVariable],
                                              details: widget.details,
                                            )));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }
}

class Body extends StatefulWidget {
  final List<p.Product> demoCarts;
  Customers details;
  Body({this.demoCarts});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<p.Product> demoCarts = [p.Product()];
  int addTocart = 0;
  @override
  Widget build(BuildContext context) {
    demoCarts = widget.demoCarts;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: 0 == 1
            ? Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Icon(
                  Icons.hourglass_empty,
                  size: 30,
                ),
                Text(
                  "Your Cart is empty",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ]))
            : ListView.builder(
                itemCount: demoCarts.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                      child: Dismissible(
                        key: Key(demoCarts[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            demoCarts.removeAt(index);
                          });
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: const [
                              Spacer(),
                              // SvgPicture.asset("assets/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        child: CartCard(
                          cart: demoCarts[index],
                          product: demoCarts,
                        ),
                      ),
                      onTap: () {}),
                ),
              ));
  }
}

class CartCard extends StatefulWidget {
  const CartCard({
    Key key,
    @required this.product,
    @required this.cart,
  }) : super(key: key);
  final List<p.Product> product;
  final p.Product cart;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int addtoCart = 1;
  Widget addtoCartWi() {
    var width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: width * 0.16,
          child: ElevatedButton(
            onPressed: () => setState(() {
              addtoCart = addtoCart + 1;
            }),
            child: Text(
              "+",
              style: TextStyle(fontSize: width * 0.07),
            ),
            // color: Colors.blueAccent,
            // textColor: Colors.white,
          ),
        ),
        SizedBox(
          width: width * 0.1,
          child: const Text(
            "0",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: width * 0.16,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (addtoCart == 1) {
                } else {
                  addtoCart = addtoCart - 1;
                }
              });
            },
            child: Text(
              "-",
              style: TextStyle(fontSize: width * 0.07),
            ),
            // color: Colors.blueAccent,
            // textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(widget.cart.images[0].src),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cart.name,
                style: TextStyle(color: Colors.black, fontSize: width * 0.05),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "₹${widget.cart.price}",
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                  children: [
                    TextSpan(text: " x2", style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () => setState(() {
                  addtoCart = addtoCart + 1;
                }),
                icon: Icon(Icons.add, size: width * 0.05, color: Colors.blueAccent),
              ),
              Text(
                addtoCart == 0 ? "0" : addtoCart.toString(),
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    addtoCart == 0 ? 0 : addtoCart = addtoCart - 1;
                  });
                },
                icon: Icon(Icons.remove, size: width * 0.05, color: Colors.blueAccent),
              ),
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      product: widget.cart,
                    )));
      },
    );
  }
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  //812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

// Demo data for our cart

class CheckoutCard extends StatelessWidget {
  List<CartProducts> cartProducts = [];
  final int addTocart;
  CheckoutCard({
    this.cartProducts,
    this.addTocart,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                const Spacer(),
                const Text("Add voucher code"),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "₹337.15",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: ElevatedButton(
                    child: const Text("Check Out"),
                    onPressed: () {
                      // print('cartProducts: $cartProducts');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateOrder(
                                    cartProducts: cartProducts,
                                  )));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
