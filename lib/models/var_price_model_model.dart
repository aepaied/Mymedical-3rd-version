class VarPriceModel {
  int productId;
  int variantProduct;
  String variant;
  int price;
  bool inStock;
  int stockQuantity;

  VarPriceModel(
      {this.productId,
      this.variantProduct,
      this.variant,
      this.price,
      this.inStock,
      this.stockQuantity});

  VarPriceModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    variantProduct = json['variant_product'];
    variant = json['variant'];
    price = json['price'];
    inStock = json['in_stock'];
    stockQuantity = json['stockQuantity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['variant_product'] = variantProduct;
    data['variant'] = variant;
    data['price'] = price;
    data['in_stock'] = inStock;
    data['stockQuantity'] = stockQuantity;
    return data;
  }
}
