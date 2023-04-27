import 'dart:async';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:farmerica/ui/bundledProductPage.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/models/global.dart' as Globals;
import 'package:farmerica/models/Categories.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/ParentCategory.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/Products.dart';
import 'package:farmerica/ui/Recommendedforyou.dart';
import 'package:farmerica/ui/categories.dart';
import 'package:farmerica/ui/categoriesDetails.dart';

import 'package:farmerica/ui/gertProductfromapi.dart';
import 'package:farmerica/ui/grocery.dart';
import 'package:farmerica/ui/widgets/component.dart';
import 'package:farmerica/ui/widgets/homeScreenBoxWidget.dart';

class Dashboard extends StatefulWidget {
  List<Product> product;
  List<ParentCategory> category;
  Dashboard({this.product, this.category});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Api_Services api_services = Api_Services();
  var response;
  int selected = 0;
  List<Product> product = [];

  List<String> homeScreen = [
    'assets/images/birthday-gift-basket.jpeg',
    'assets/images/anniversary-gift-basket-1.jpeg',
    'assets/images/exotic-vegetable-a-gift-basket.jpeg',
    'assets/images/customize-fruits-basket.jpeg',
    'assets/images/healthy-food-from-our-farm-1.jpeg'
  ];

  List<Widget> carousel = [
    Image.asset('assets/images/mathers-day-banner.jpeg'),
    Image.asset('assets/images/exotic-vagetable-1.jpeg'),
    Image.asset('assets/images/fruits-basket-1.jpeg'),
    Image.asset('assets/images/Dry-fruits-banner-3.jpeg'),
  ];

  final PageController _carouselController = PageController(initialPage: 0);
  int _carouselPage = 0;
  double screenWidth;
  final double imageIconSize = 25;

  getList() {
    setState(() {
      product = widget.product;
    });
  }

  int bundledId = 3925;
  List bundledList = [];
  // Future bundledData() async {
  //   bundledList = await api_services.getBundled(bundledId);
  //   print('objectCouponList: ${bundledList.length}');
  //   print('objectCouponList: ${bundledList[0].code}');
  //   // print('objectCouponList: ${bundledList[1].code}');
  //
  //   // for (int i = 0; i < couponList.length; i++) {
  //   //   if(couponList[i].dateExpires != null) {
  //   //     dummyCouponList.add(couponList[i]);
  //   //   }
  //   // }
  // }

  String title = "Dashboard";

  bool end = false;
  final ScrollController scrollController = ScrollController();
  Timer timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_carouselController.hasClients) {
          _carouselController.animateToPage(
            _carouselPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
        _carouselPage++;
      });
    });

    product = widget.product;
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  var padding = const Padding(
    padding: EdgeInsets.all(5.0),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
//Slide
//             Carousal(
//               MediaQuery.of(context).size.width,
//             ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30))),
              width: double.infinity,
              height: 200,
              child: PageView(
                controller: _carouselController,
                children: carousel,
                onPageChanged: (int index) {
                  setState(() {
                    _carouselPage = 2;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      //width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffD7F5D8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Color(0xff214E23),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Same Day',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xff214E23),
                                fontFamily: 'OutFit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Delivery',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff214E23),
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      //width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffF5D7D7)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/Exciting-offers.png',
                              width: 27,
                              height: 27,
                              color: const Color(0xff6A1414),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Exciting',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xff6A1414),
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Discounts & Offers',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff6A1414),
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
//banner 2
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffD7DFF5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/free-delivery-icon.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Free',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xff2E4990),
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Delivery',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff2E4990),
                                fontFamily: 'Gilroy-Bold',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xffEFF5D7)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.workspace_premium_outlined,
                              color: Color(0xff758D15),
                              size: 35,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '100%',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff758D15),
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Premium Products',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff758D15),
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
//Product banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                    itemCount: homeScreen.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () async {
                            if (homeScreen[index].toString() == 'assets/images/exotic-vegetable-a-gift-basket.jpg') {
                              Globals.globalInt = 68;
                              response = await api_services.getProducts(68);
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                  builder: (context) => Grocery(
                                        product: response,
                                      )));
                            } else if (homeScreen[index].toString() == 'assets/images/healthy-food-from-our-farm-1.jpg') {
                              Globals.globalInt = 86;
                              response = await api_services.getProducts(86);
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                  builder: (context) => Grocery(
                                        product: response,
                                      )));
                            } else {
                              Globals.globalInt = 45;
                              response = await api_services.getProducts(45);
                              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                  builder: (context) => Grocery(
                                        product: response,
                                      )));
                            }
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                homeScreen[index],
                              )));
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          text: 'Best Sellers Products\n\n',
                          style: TextStyle(fontFamily: 'OutFit', fontWeight: FontWeight.w500, color: Colors.black, fontSize: 24),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    'Hand-crafted with care and attention to packaging detail makes our gift packs best seller and perfect for any occasion. Send them as a thanks or congratulations gift, our gifts are sure to please.',
                                style: TextStyle(fontFamily: 'OutFit', fontWeight: FontWeight.w300, fontSize: 18))
                          ])),
                  Center(
                    heightFactor: 2.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ab55),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        response = await api_services.getProducts(86);
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                            builder: (context) => Grocery(
                                  product: response,
                                )));
                      },
                      child: const Text('View More'),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                        text: 'Customise Fruits Basket\n\n',
                        style: TextStyle(fontFamily: 'OutFit', fontWeight: FontWeight.w500, color: Colors.black, fontSize: 24),
                        children: <TextSpan>[
                          TextSpan(text: 'Best quality fruits to create a unique combination for your gift basket', style: TextStyle(fontFamily: 'OutFit', fontWeight: FontWeight.w300, fontSize: 18))
                        ]),
                  ),
                  Center(
                    heightFactor: 2.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00ab55),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BundledProductPage(productId: 3925)));
                      },
                      child: const Text('Bundled Products'),
                    ),
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
