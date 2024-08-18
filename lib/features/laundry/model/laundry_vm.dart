import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:limcad/features/laundry/model/about_response.dart';
import 'package:limcad/features/laundry/model/business_order_detail_response.dart';
import 'package:limcad/features/laundry/model/laundry_order_response.dart';
import 'package:limcad/features/laundry/model/laundry_orders_response.dart';
import 'package:limcad/features/laundry/model/laundry_service_response.dart';
import 'package:limcad/features/laundry/services/laundry_service.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/api/response_code.dart';
import 'package:limcad/resources/base_vm.dart';
import 'package:limcad/resources/locator.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/view_utils/view_utils.dart';
import 'package:logger/logger.dart';

enum LaundryOption {
  about,
  selectClothe,
  review,
  orders,
  order_details,
  businessOrder,
  businessOrderDetails
}

enum OrderStatus {
  PENDING,
  PAYMENT_CONFIRMED,
  ORDER_ASSIGNED,
  ORDER_DECLINED,
  ORDER_PICKED_UP,
  ORDER_DELIVERED,
  IN_PROGRESS,
  COMPLETED,
  FAILED,
  CANCELLED,
  DECLINED,
}

extension OrderStatusExtension on OrderStatus {
  String get displayValue {
    switch (this) {
      case OrderStatus.PENDING:
        return 'Pending';
      case OrderStatus.PAYMENT_CONFIRMED:
        return 'Payment Confirmed';
      case OrderStatus.ORDER_ASSIGNED:
        return 'Order Assigned';
      case OrderStatus.ORDER_DECLINED:
        return 'Order Declined';
      case OrderStatus.ORDER_PICKED_UP:
        return 'Order Picked Up';
      case OrderStatus.ORDER_DELIVERED:
        return 'Order Delivered';
      case OrderStatus.IN_PROGRESS:
        return 'In Progress';
      case OrderStatus.COMPLETED:
        return 'Completed';
      case OrderStatus.FAILED:
        return 'Failed';
      case OrderStatus.CANCELLED:
        return 'Cancelled';
      case OrderStatus.DECLINED:
        return 'Declined';
      default:
        return '';
    }
  }
}

class LaundryVM extends BaseVM {
  final apiService = locator<APIClient>();
  late BuildContext context;
  String title = "";
  final instructionController = TextEditingController();
  bool isPreview = false;
  bool isButtonEnabled = false;
  AboutResponse? laundryAbout;
  LaundryOption? laundryOption;
  List<LaundryServiceItem>? items = [];
  List<LaundryOrderItem>? laundryOrderItems = [];
  LaundryOrders? laundryOrders;
  LaundryServiceResponse? laundryServiceResponse;
  Map<LaundryServiceItem, double> selectedItems = {};
  BusinessOrderDetailResponse? businessOrderDetails;

  int? orderId;
  OrderStatus orderStatus = OrderStatus.PENDING;
  double totalPrice = 0;
   void init(BuildContext context, LaundryOption laundryOpt, [ int? id]) {

    this.context = context;
    this.laundryOption = laundryOpt;
    this.orderId = id;
    if (laundryOpt == LaundryOption.about) {
      getLaundryAbout();
    }
    if (laundryOpt == LaundryOption.selectClothe) {
      getLaundryItems();
    }

    if (laundryOpt == LaundryOption.order_details) {
      getOrderDetail(id!);
    }

    if (laundryOpt == LaundryOption.orders) {
      getOrders();
    }

    if (laundryOpt == LaundryOption.businessOrderDetails) {
      getOrderDetail(10);
    }
  }

  void updateSelectedItem(LaundryServiceItem item, double quantity) {
    if (quantity > 0) {
      selectedItems[item] = quantity;
    } else {
      selectedItems.remove(item);
    }
    notifyListeners();
  }

  void proceed() {
    isPreview = true;
    notifyListeners();
  }

  double calculateTotalPrice() {
    double total = 0.0;
    selectedItems.forEach((item, quantity) {
      total += (item.price ?? 0.0) * quantity;
    });
    return total;
  }

  void reviewOrder() {
    ViewUtil.showDynamicDialogWithButton(
        barrierDismissible: false,
        context: context,
        titlePresent: false,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.asset(
                AssetUtil.successCheck,
                width: 64,
                height: 64,
              ).padding(bottom: 24, top: 22),
            ),
            const Text(
              "Review submitted",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: CustomColors.kBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  height: 1.2),
            ).padding(bottom: 16),
            const Text(
              "Your review has been successfully submitted.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: CustomColors.kBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.2),
            ).padding(bottom: 24)
          ],
        ),
        buttonText: "Continue",
        dialogAction1: () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
  }

  Map<String, dynamic> generateOrderJson() {
    List<Map<String, dynamic>> itemsJson = selectedItems.entries.map((entry) {
      int itemId = items!.indexOf(entry.key) + 1; // 1-based index
      return {
        "itemId": itemId,
        "quantity": entry.value.toInt(),
      };
    }).toList();

    return {
      "items": itemsJson,
    };
  }

  Future<void> proceedToPay() async {
    isLoading(true);
    Map<String, dynamic> orderJson = generateOrderJson();
    print('Order JSON: $orderJson');
    final response = await locator<LaundryService>().submitOrder(orderJson, 6);

    if (response.status == ResponseCode.success ||
        response.status == ResponseCode.created) {
      Logger().i(response.data);
    }
    isLoading(false);
  }

  Future<void> getLaundryAbout() async {
    laundryAbout = await locator<LaundryService>().getAbout();
    notifyListeners();
  }

  Future<void> getLaundryItems() async {
    isLoading(true);
    final response = await locator<LaundryService>().getLaundryServiceItems();
    laundryServiceResponse = response?.data;
    if (laundryServiceResponse!.items!.isNotEmpty) {
      items?.addAll(laundryServiceResponse!.items?.toList() ?? []);
      Logger().i(response?.data);
    }
    isLoading(false);
    notifyListeners();
  }

  Future<void> getOrders() async {
    isLoading(true);
    final response = await locator<LaundryService>().getLaundryOrders();
    laundryOrders = response?.data;
    if (laundryOrders!.items!.isNotEmpty) {
      laundryOrderItems?.addAll(laundryOrders!.items?.toList() ?? []);
      Logger().i(response?.data);
    }
    isLoading(false);
    notifyListeners();
  }

  Future<void> getOrderDetail(int id) async {
    isLoading(true);
    final response = await locator<LaundryService>().getBusinessOrderDetail(id);
    businessOrderDetails = response;

    print("print: ${businessOrderDetails.toString()}");
    Logger().i(response);
    totalPrice = getTotalPrice();
    isLoading(false);
    notifyListeners();
  }

  double getTotalPrice() {
    final prices = businessOrderDetails?.orderItems?.map((e) {
          double price = e.item?.price ?? 0.0;
          print('Item price: $price');
          return price;
        }).toList() ??
        [];

    double total = prices.fold(0.0, (previousValue, currentValue) {
      double sum = previousValue + currentValue;
      print('Running total: $sum');
      return sum;
    });

    print('Final total price: $total');
    return total;
  }

  Future<void> updateStatus(OrderStatus status) async {
    final response = await locator<LaundryService>()
        .updateStatus(10, status.toString().split(".").last);
    if (response.status == 200) {
      ViewUtil.showSnackBar("Updated Successfully", false);
      businessOrderDetails = response.data;
      notifyListeners();
    }
  }

  void setStatus(OrderStatus status) {
    orderStatus = status;
  }
}
