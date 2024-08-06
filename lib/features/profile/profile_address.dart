import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/size_util.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/default_scafold.dart';
import 'package:limcad/resources/widgets/view_utils/custom_text_field.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileAddressPage extends StatefulWidget {
  @override
  _ProfileAddressPageState createState() => _ProfileAddressPageState();
}

class _ProfileAddressPageState extends State<ProfileAddressPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold2(
      showAppBar: true,
      title: 'Address',
      backgroundColor: white,
      body: SingleChildScrollView(
        // If content might overflow
        child: Column(
          children: [
            CustomTextArea(
              controller: TextEditingController(),
              keyboardType: TextInputType.name,
              label: "",
              icon: Icon(IconsaxBold.location),
              labelText: "Add new address",
              showLabel: true,
              //labelText: "Please type instruction here, if there is any...",
              formatter: InputFormatter.stringOnly,
              maxLines: 1,
              autocorrect: false,
              //validate: (value) => ValidationUtil.validateLastName(value),
              // onSave: (value) =>
              // model.instructionController.text = value,
            ).padding(bottom: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "48, Jane Doe Avenue",
                  style: TextStyle(
                      fontSize: 16,
                      color: black,
                      fontWeight: FontWeight.w500),
                ).padding(top: 8),

                Container(decoration: BoxDecoration(shape: BoxShape.circle, color: CustomColors.limcadPrimaryLight.withOpacity(0.2)), width: 42, height: 42, child: Center(child: Icon(Icons.delete_outline, color: Colors.red, size: 24, ),),)
              ],
            )
          ],
        ).paddingSymmetric(vertical: 40, horizontal: 16),
      ),
    );
  }

  // Helper to build sections
  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              ...items,
            ],
          ),
        )
      ],
    );
  }
}
