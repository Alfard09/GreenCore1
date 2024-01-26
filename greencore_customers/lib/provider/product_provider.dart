import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  getFormData({
    String? productName,
    double? productPrice,
    int? quantity,
    String? category,
    String? description,
    DateTime? scheduleDate,
    List<String>? imageUrlList,
    bool? chargeShippping,
    int? shippingCharge,
    String? brandName,
    List<String>? sizeList,
    //dicount
    bool? discount,
    int? discountPrice,
    //specifications
    bool? isPlantSpecification,
    String? plantHeight,
    String? plantSpread,
    String? commonName,
    String? maxHeight,
    String? flowerColor,
    String? bloomTime,
    String? diffLevel,
    String? scientificName,
    //special features
    String? specialFeatures,
    String? uses,
    //plantcaretip
    bool? isCareTip,
    String? plantCaretip,
    //wishlist
    bool? isWishlist,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (quantity != null) {
      productData['quantity'] = quantity;
    }
    if (category != null) {
      productData['category'] = category;
    }
    if (description != null) {
      productData['description'] = description;
    }
    if (scheduleDate != null) {
      productData['scheduleDate'] = scheduleDate;
    }
    if (imageUrlList != null) {
      productData['imageUrlList'] = imageUrlList;
    }
    if (chargeShippping != null) {
      productData['chargeShippping'] = chargeShippping;
    }
    if (chargeShippping != null) {
      productData['chargeShippping'] = chargeShippping;
    }
    if (shippingCharge != null) {
      productData['shippingCharge'] = shippingCharge;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    if (discount != null) {
      productData['discount'] = discount;
    }
    if (discountPrice != null) {
      productData['discountPrice'] = discountPrice;
    }
    //specifications
    if (isPlantSpecification != null) {
      productData['isPlantSpecification'] = isPlantSpecification;
    }
    if (plantHeight != null) {
      productData['plantHeight'] = plantHeight;
    }
    if (plantSpread != null) {
      productData['plantSpread'] = plantSpread;
    }
    if (commonName != null) {
      productData['commonName'] = commonName;
    }
    if (maxHeight != null) {
      productData['maxHeight'] = maxHeight;
    }
    if (flowerColor != null) {
      productData['flowerColor'] = flowerColor;
    }
    if (bloomTime != null) {
      productData['bloomTime'] = bloomTime;
    }
    if (diffLevel != null) {
      productData['diffLevel'] = diffLevel;
    }
    if (scientificName != null) {
      productData['scientificName'] = scientificName;
    }
    if (specialFeatures != null) {
      productData['specialFeatures'] = specialFeatures;
    }
    if (uses != null) {
      productData['uses'] = uses;
    }
    if (isCareTip != null) {
      productData['isCareTip'] = isCareTip;
    }
    if (plantCaretip != null) {
      productData['plantCaretip'] = plantCaretip;
    }
    if (isWishlist != null) {
      productData['isWishlist'] = isWishlist;
    }

    notifyListeners();
  }

  clearData() {
    productData.clear();
    notifyListeners();
  }
}
