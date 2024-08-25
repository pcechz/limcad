import 'package:flutter/material.dart';
import 'package:limcad/features/laundry/model/laundry_service_response.dart';
import 'package:limcad/features/laundry/model/laundry_vm.dart';
import 'package:limcad/features/laundry/select_clothe.dart';
import 'package:limcad/features/laundry/services/laundry_service.dart';
import 'package:limcad/resources/routes.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/widgets/default_scafold.dart';
import 'package:limcad/resources/widgets/view_utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stacked/stacked.dart';

class CreateServicesComponent extends StatefulWidget {
  static String tag = '/CServicesComponent';

  CreateServicesComponent({
    super.key,
  });
  @override
  CreateServicesComponentState createState() => CreateServicesComponentState();
}

class CreateServicesComponentState extends State<CreateServicesComponent> {
  final _formKey = GlobalKey<FormState>();
  late LaundryVM model;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LaundryVM(),
        onViewModelReady: (model) {
          this.model = model;
          model.init(context, LaundryOption.services, 0);
        },
        builder: (BuildContext context, model, child) {
          return DefaultScaffold2(
              busy: model.loading,
              title: "Services",
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _showAddServiceBottomSheet(context);
                  },
                ),
              ],
              body: model.laundryServiceItems != null &&
                      model.laundryServiceItems!.isNotEmpty
                  ? ListView.builder(
                      itemCount: model.laundryServiceItems!.length,
                      itemBuilder: (context, index) {
                        final item = model.laundryServiceItems![index];
                        return ItemDetailsCard(item: item);
                      },
                    ).paddingSymmetric(vertical: 35, horizontal: 16)
                  : Center(
                      child: Text('No laundry service items available'),
                    ));
        });
  }

  void _showAddServiceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the product description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the product price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final name = _nameController.text;
                              final description = _descriptionController.text;
                              final price = _priceController.text;

                              await model.createServiceItem(
                                  name, description, int.parse(price));
                              _nameController.clear();
                              _descriptionController.clear();
                              _priceController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ItemDetailsCard extends StatelessWidget {
  final LaundryServiceItem item;

  const ItemDetailsCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.itemName ?? "",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              item.itemDescription ?? "",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Price: \₦${item.price?.toStringAsFixed(2) ?? 0}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.limcadPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).paddingBottom(10);
  }
}

class ServiceModel {
  final String img;
  final String title;
  final Function onTap;
  final Color iconBack;

  ServiceModel(
      {required this.img,
      required this.title,
      required this.onTap,
      required this.iconBack});
}
