class ProductModel {
  int? productId;
  String? productName;
  String? productCategory;
  String? productPrice;
  int? productQuantity;
  String? productState;
  String? productDescription;
  int? sellerId;
  String? productImageUrl;

  ProductModel(
      {this.productId,
      this.productName,
      this.productCategory,
      this.productPrice,
      this.productQuantity,
      this.productState,
      this.productDescription,
      this.sellerId,
      this.productImageUrl});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productCategory = json['product_category'];
    productPrice = json['product_price'];
    productQuantity = json['product_quantity'];
    productState = json['product_state'];
    productDescription = json['product_description'];
    sellerId = json['seller_id'];
    productImageUrl = json['product_image_url'];
  }

  Map<String, dynamic> toJson() {
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['product_id'] = this.productId;
    // data['product_name'] = this.productName;
    // data['product_category'] = this.productCategory;
    // data['product_price'] = this.productPrice;
    // data['product_quantity'] = this.productQuantity;
    // data['product_state'] = this.productState;
    // data['product_description'] = this.productDescription;
    // data['seller_id'] = this.sellerId;
    // data['product_image_url'] = this.productImageUrl;
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_category'] = productCategory;
    data['product_price'] = productPrice;
    data['product_quantity'] = productQuantity;
    data['product_state'] = productState;
    data['product_description'] = productDescription;
    data['seller_id'] = sellerId;
    data['product_image_url'] = productImageUrl;
    return data;
  }
}
