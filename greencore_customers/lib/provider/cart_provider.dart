import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greencore_1/models/cart_attribute.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.0;

    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrl,
    int quantity,
    int productQuantity,
    double price,
    String vendorId,
    String? productSize,
    Timestamp scheduleDate,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingcart) => CartAttr(
                productName: existingcart.productName,
                productId: existingcart.productId,
                imageUrl: existingcart.imageUrl,
                quantity: existingcart.quantity + 1,
                productQuantity: existingcart.productQuantity,
                price: existingcart.price,
                vendorId: existingcart.vendorId,
                productSize: existingcart.productSize,
                scheduleDate: existingcart.scheduleDate,
              ));
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
                productName: productName,
                productId: productId,
                imageUrl: imageUrl,
                quantity: quantity,
                productQuantity: productQuantity,
                price: price,
                vendorId: vendorId,
                scheduleDate: scheduleDate,
                productSize: productSize,
              ));
      notifyListeners();
    }
  }

  void increment(CartAttr cartAttr) {
    cartAttr.increase();
    notifyListeners();
  }

  void decrement(CartAttr cartAttr) {
    cartAttr.decrease();
    notifyListeners();
  }

  removeItem(productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();
    notifyListeners();
  }
}
