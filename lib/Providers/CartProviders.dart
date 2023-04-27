import 'package:flutter/cupertino.dart';

import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:farmerica/ui/CartPage.dart';
import 'package:farmerica/models/global.dart' as Globals;


class CartModel extends ChangeNotifier {
  List<CartProducts> cartProducts = [];
  Api_Services api_services = Api_Services();

  addCartProduct(int id, int quantity, String name, String price, String images) {
    bool alreadyExist = cartProducts.any((element) => element.product_id == id);
    CartProducts cartProduct = CartProducts(
      product_id: id,
      quantity: quantity,
      price: price,
      name: name,
      image: images,
    );
    print('CarProducts INIT: $id');

    Globals.cartCount = quantity;
    print('CarProducts Globals: ${Globals.cartCount}');
    alreadyExist ? updateQuantity(id, quantity = 1) : cartProducts.add(cartProduct);
    print('cartModel: ${cartProducts[0].product_id}');

    notifyListeners();
  }

  removeCartProduct(int id) {
    final cart = cartProducts.firstWhere((element) => element.product_id == id);
    cartProducts.remove(cart);
    notifyListeners();
  }

  updateQuantity(int id, int quantity) {
    print("up");
    CartProducts mm = cartProducts.firstWhere((element) => element.product_id == id);
    print(mm);
    final cart = cartProducts.firstWhere((element) => element.product_id == id);
    cart.quantity = quantity + cart.quantity;
    print(cart.quantity);
    // cartProducts.add(cart);
    notifyListeners();
  }

  clearCart() {
    cartProducts.clear();
    notifyListeners();
  }
}
