import 'package:flutter/material.dart';
import 'package:limcad/features/laundry/model/laundry_vm.dart';
import 'package:limcad/features/laundry/select_clothe.dart';
import 'package:limcad/resources/routes.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/widgets/view_utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class CreateServicesComponent extends StatefulWidget {
  static String tag = '/CServicesComponent';
  final LaundryVM model;

  CreateServicesComponent({super.key, required this.model});
  @override
  CreateServicesComponentState createState() => CreateServicesComponentState();
}

class CreateServicesComponentState extends State<CreateServicesComponent> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
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
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final name = _nameController.text;
                final description = _descriptionController.text;
                final price = _priceController.text;

                print('Name: $name');
                print('Description: $description');
                print('Price: $price');
                await widget.model
                    .createServiceItem(name, description, price.toInt());
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 16, vertical: 32));
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
