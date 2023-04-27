import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/models/ParentCategory.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/models/global.dart' as Globals;
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/CartPage.dart';

import 'package:farmerica/ui/categories.dart';
import 'package:farmerica/ui/dashboard.dart';
import 'package:farmerica/ui/profile.dart';
import 'package:flutter/cupertino.dart';

class BasePage extends StatefulWidget {
  Customers customer;
  int selected;
  String title;
  BasePage({
    this.customer,
    this.title,
    this.selected,
  });

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  List<Product> response;
  Api_Services api_services = Api_Services();

  List<ParentCategory> categories = [];
  List<Widget> list;
  int selected = 0;

  Future getList() async {
    categories = await api_services.getCategoryById(Globals.globalInt);
    response = await api_services.getProducts(Globals.globalInt);
  }

  @override
  void initState() {
    getList().then((value) {
      list = [
        Dashboard(
          product: response,
        ),
        CategoryPage(
          catergories: categories,
          product: response,
        ),
        CartScreen(
          product: response,
          details: widget.customer,
          fromMainPage: true,
        ),
        CompleteProfileScreen(
          customer: widget.customer,
          product: response,
        )
      ];
    });

    super.initState();
  }

  Customers customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00ab55),
        centerTitle: true,
        title: Image.asset(
          'assets/farmerica-logo.png',
          color: Colors.white,
        ),
      ),
      body: body(context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: selected,
        iconSize: 30,
        selectedItemColor: const Color(0xff00AA55),
        unselectedItemColor: Colors.black,
        onTap: (inx) {
          setState(() {
            selected = inx;
          });
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.category_rounded,
              ),
              label: "Category"),
          BottomNavigationBarItem(
            icon: Badge(
              badgeContent: Text(
                Globals.cartCount == null ? '0' : '${Globals.cartCount}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              badgeStyle: const BadgeStyle(badgeColor: Colors.red),
              child: const Icon(
                Icons.shopping_cart,
              ),
            ),
            label: "My Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "My Account",
          )
        ],
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  Widget body(BuildContext context) {
    List<Widget> list = [
      Dashboard(
        product: response,
        category: categories,
      ),
      CategoryPage(
        catergories: categories,
        product: response,
      ),
      CartScreen(
        product: response,
        details: widget.customer,
        fromMainPage: true,
      ),
      CompleteProfileScreen(
        customer: widget.customer,
        product: response,
      )
    ];
    return list[selected];
  }
}
