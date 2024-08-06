import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:limcad/features/laundry/model/laundry_vm.dart';
import 'package:limcad/features/order/order_details.dart';
import 'package:limcad/resources/routes.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/default_scafold.dart';
import 'package:limcad/resources/widgets/view_utils/app_widget.dart';
import 'package:limcad/resources/widgets/view_utils/view_utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stacked/stacked.dart';

class BusinessOrdersDetailsPage extends StatefulWidget {
  static const String routeName = "/BusinessOrdersDetailsPage";

  const BusinessOrdersDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BusinessOrdersDetailsPage> createState() => _BusinessOrdersDetailsPageState();
}

class _BusinessOrdersDetailsPageState extends State<BusinessOrdersDetailsPage> {
  late LaundryVM model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LaundryVM>.reactive(
      viewModelBuilder: () => LaundryVM(),
      onViewModelReady: (model) {
        this.model = model;
        model.context = context;
        model.init(context, LaundryOption.businessOrderDetails);
      },
      builder: (BuildContext context, model, child) => DefaultScaffold2(
        showAppBar: true,
        includeAppBarBackButton: true,
        title: "Order details",
        backgroundColor: CustomColors.backgroundColor,
        busy: model.loading,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [32.height,

              Container(
                  width: MediaQuery.of(context).size.width - 38,
                  decoration: boxDecorationRoundedWithShadow(
                    18,
                    backgroundColor: white,
                  ),
                  child: Column(children: [

                    ViewUtil.eachDetailOrders('Customer info', {
                      'First Name': "Funsho",
                      'Last Name': "Adeolu",
                      'Address': "0123 Aliu Olaiya Avenue, Ikeja",
                      'Phone': "+234 8012 3456 789",
                      'Email': "kyleolaiya@gmail.com",
                      'Rating':  "4.5",
                      'Verified payment':  "₦107,5000",
                    }).paddingSymmetric(vertical: 16, horizontal: 16)
                  ],) ).paddingBottom(24),



              Container(
                  width: MediaQuery.of(context).size.width - 38,
                  decoration: boxDecorationRoundedWithShadow(
                    18,
                    backgroundColor: white,
                  ),
                  child: Column(children: [

                    ViewUtil.eachDetailOrders('Order info', {
                      'Order number': "#329857",
                      'No of items': "5",
                      'Shirt x 3': "₦4,500",
                      'Jean x 1': "₦2,500",
                      'Towel x 1': "₦2,500",
                      'Gown x 5':  "₦5000",
                      'Total':  "₦14,5000",
                    }).paddingSymmetric(vertical: 16, horizontal: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order status', style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: CustomColors.grey600)),
                        Text('In progress', style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black,
                        )),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              _showBottomSheet(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: CustomColors.limcadPrimary, backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: CustomColors.limcadPrimary),
                              ),
                             // padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            ),
                            child: Text(
                              'Update',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 16, horizontal: 16)
                  ],) ).paddingBottom(16),




            ],
          ).paddingSymmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }


  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return OrderStatusBottomSheet();
      },
    );
  }


}


class OrderStatusBottomSheet extends StatefulWidget {
  @override
  _OrderStatusBottomSheetState createState() => _OrderStatusBottomSheetState();
}

class _OrderStatusBottomSheetState extends State<OrderStatusBottomSheet> {
  String _orderStatus = 'In progress';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('Pending'),
            value: 'Pending',
            groupValue: _orderStatus,
            onChanged: (String? value) {
              setState(() {
                _orderStatus = value!;
              });
            },
            activeColor: CustomColors.limcadPrimary,
          ),
          RadioListTile<String>(
            title: const Text('In progress'),
            value: 'In progress',
            groupValue: _orderStatus,
            onChanged: (String? value) {
              setState(() {
                _orderStatus = value!;
              });
            },
            activeColor: CustomColors.limcadPrimary,
          ),
          RadioListTile<String>(
            title: const Text('Completed'),
            value: 'Completed',
            groupValue: _orderStatus,
            onChanged: (String? value) {
              setState(() {
                _orderStatus = value!;
              });
            },
            activeColor: CustomColors.limcadPrimary,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.limcadPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            ),
            child: Text(
              'Update status',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}