class DashboardModel {
  int productCount;
  int totalSale;
  int totalEarning;
  int successfulOrders;
  int totalOrders;
  int pendingOrders;
  int cancelledOrders;

  DashboardModel(
      {this.productCount,
        this.totalSale,
        this.totalEarning,
        this.successfulOrders,
        this.totalOrders,
        this.pendingOrders,
        this.cancelledOrders});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    productCount = json['product_count'];
    totalSale = json['total_sale'];
    totalEarning = json['total_earning'];
    successfulOrders = json['successful_orders'];
    totalOrders = json['total_orders'];
    pendingOrders = json['pending_orders'];
    cancelledOrders = json['cancelled_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_count'] = this.productCount;
    data['total_sale'] = this.totalSale;
    data['total_earning'] = this.totalEarning;
    data['successful_orders'] = this.successfulOrders;
    data['total_orders'] = this.totalOrders;
    data['pending_orders'] = this.pendingOrders;
    data['cancelled_orders'] = this.cancelledOrders;
    return data;
  }
}