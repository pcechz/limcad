

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:limcad/features/laundry/model/about_response.dart';
import 'package:limcad/features/laundry/services/laundry_service.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/base_vm.dart';
import 'package:limcad/resources/locator.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/view_utils/view_utils.dart';

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




  init(BuildContext context, LaundryOption laundryOpt)  {
    this.context = context;
    this.laundryOption = laundryOpt;
    if(laundryOpt == LaundryOption.about){
      getLaundryAbout();

    }

  }

  void proceed() {
    isPreview = true;
    notifyListeners();
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

  Future<void> getLaundryAbout() async {
    laundryAbout = await  locator<LaundryService>().getAbout();
    notifyListeners();
  }

  void proceedToPay() {
    isLoading(true);
    print("yes");
   // isLoading(false);
  }


}