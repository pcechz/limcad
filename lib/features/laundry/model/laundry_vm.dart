

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:limcad/features/laundry/model/about_response.dart';
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

enum LaundryOption {about, selectClothe, review, orders, order_details, businessOrder, businessOrderDetails}


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

  int? orderId;

  void init(BuildContext context, LaundryOption laundryOpt) {
    this.context = context;
    this.laundryOption = laundryOpt;
    if (laundryOpt == LaundryOption.about) {
      getLaundryAbout();
    }
    if (laundryOpt == LaundryOption.selectClothe) {
      getLaundryItems();
    }

    if (laundryOpt == LaundryOption.order_details) {
    //  getorderDetails();
    }

    if (laundryOpt == LaundryOption.orders) {
      getOrders();
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
              child: Image.asset(AssetUtil.successCheck, width: 64, height: 64, )
                  .padding(bottom: 24, top: 22),
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
        "quantity":  entry.value.toInt(),
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
    final response = await locator<LaundryService>().submitOrder(orderJson);

    if (response.status == ResponseCode.success || response.status == ResponseCode.created) {
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

}


