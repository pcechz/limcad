import 'package:flutter/material.dart';
import 'package:limcad/features/laundry/model/laundry_vm.dart';
import 'package:limcad/resources/storage/base_preference.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:textfields/textfields.dart';

import '../../../../main.dart';

class BusinessAboutComponent extends StatefulWidget {
  const BusinessAboutComponent(this.model, {Key? key}) : super(key: key);
  final LaundryVM model;
  @override
  State<BusinessAboutComponent> createState() => _BusinessAboutComponentState();
}

class _BusinessAboutComponentState extends State<BusinessAboutComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(widget.model.laundryAbout?.aboutText ?? "",
                  //     style: secondaryTextStyle(), textAlign: TextAlign.start),
                  16.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 220,
                              child: TextField(
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                                controller: widget.model.aboutUsController,
                                maxLines: null,
                                expands: true,
                                decoration: const InputDecoration(
                                  filled: true,
                                  hintText: 'About us',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 8.0),
                                ),
                              ).paddingBottom(20)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (widget.model.hasUsedAboutUs)
                                SizedBox(
                                  width: 86,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.model.editLaundryAbout(
                                          widget.model.aboutUsController.text);
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 16,
                                        ),
                                        Text("Edit")
                                      ],
                                    ),
                                  ),
                                ),
                              if (!widget.model.hasUsedAboutUs)
                                SizedBox(
                                  width: 86,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      widget.model.addLaundryAbout(
                                          widget.model.aboutUsController.text);
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 16,
                                        ),
                                        Text("Add")
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ).paddingTop(1).expand(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
