import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:farmerica/Providers/CartProviders.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/productDetails.dart';
import 'package:provider/provider.dart';

class GridViewList extends StatefulWidget {
  List<Product> product;

  GridViewList({this.product});

  @override
  State<GridViewList> createState() => _GridViewListState();
}

class _GridViewListState extends State<GridViewList> {
  int addtoCart = 0;

  Api_Services api_services = Api_Services();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: widget.product.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int id) {
          var width = MediaQuery.of(context).size.width;
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: Stack(
                    children: <Widget>[
//Product Image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                              widget.product[id].images[0].src,
                            ),
                          ),
                        ),
                      ),
// Product Desc
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)),
                              color: Colors.white.withOpacity(0.75)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product[id].name,
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontFamily: 'OutFit',
                                      fontWeight: FontWeight.w500,
                                      fontSize: width * 0.045,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "₹${widget.product[id].price}",
                                  style: TextStyle(
                                      fontFamily: 'OutFit',
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.05,
                                      color: const Color(0xff3a9046)),
                                ),

                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      addtoCart = 1;
                                    });
                                    Provider.of<CartModel>(context,
                                        listen: false)
                                        .addCartProduct(
                                        widget.product[id].id,
                                        1,
                                        widget.product[id].name,
                                        widget.product[id].price,
                                        widget.product[id].images[0].src);
                                    // .addCartProduct(widget.product);
                                    Fluttertoast.showToast(
                                        msg:
                                        "${widget.product[id].name} successfully added to cart",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  },
                                  child: const Text("add to cart"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                            product: widget.product[id],
                          )));
            },
          );
        });

    ///
//     return GridView.builder(
//       physics: ScrollPhysics(),
//       itemCount: widget.product.length,
//       shrinkWrap: true,
//       itemBuilder: (BuildContext context, int id) {
//         var width = MediaQuery.of(context).size.width;
//         return GestureDetector(
//             child: Container(
//               // height: 500,
//               color: Colors.white,
//               child: Card(
//                   child: Stack(
//                 children: <Widget>[
//                   Container(
//                      // height: 150,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fitWidth,
//                           image: NetworkImage(
//                             widget.product[id].images[0].src,
//                           )),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(
//                         width: 200,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                             colors: [Colors.black, Colors.transparent],
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Text(
//                               //   widget.product[id].name,
//                               //   // maxLines: 10,
//                               //   // softWrap: true,
//                               //   style: new TextStyle(
//                               //       fontSize: width * 0.045, color: Colors.white),
//                               // ),
//                               Text(
//                                 "₹" + widget.product[id].price,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: width * 0.05,
//                                     color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//             ),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProductDetail(
//                             product: widget.product[id],
//                           )));
//             });
//       },
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9),
//     );
  }
}
