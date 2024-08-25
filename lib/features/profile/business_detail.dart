import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:limcad/features/laundry/components/ServiceDetail/AboutComponent.dart';
import 'package:limcad/features/laundry/components/ServiceDetail/CreateService.dart';
import 'package:limcad/features/laundry/components/ServiceDetail/ServicesComponent.dart';
import 'package:limcad/features/laundry/model/laundry_vm.dart';
import 'package:limcad/features/laundry/select_clothe.dart';
import 'package:limcad/resources/routes.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/default_scafold.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/galley_widget.dart';
import 'package:limcad/resources/widgets/view_utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stacked/stacked.dart';

class BusinessDetailScreen extends StatefulWidget {
  static String tag = '/businessDetail';

  @override
  BusinessDetailScreenState createState() => BusinessDetailScreenState();
}

class BusinessDetailScreenState extends State<BusinessDetailScreen> {
  late LaundryVM model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LaundryVM>.reactive(
      viewModelBuilder: () => LaundryVM(),
      onViewModelReady: (model) {
        this.model = model;
        model.context = context;
        model.init(context, LaundryOption.about, 0);
      },
      builder: (BuildContext context, model, child) => DefaultScaffold2(
        title: "About Us",
        busy: model.loading,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            Container(
                              height: 300,
                              child: TextField(
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                                controller: model.aboutUsController,
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: const InputDecoration(
                                  filled: true,
                                  hintText: 'About us',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 20.0, top: 20, right: 10),
                                ),
                              ),
                            ).paddingBottom(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (model.hasUsedAboutUs)
                                  SizedBox(
                                    width: 86,
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        model.editLaundryAbout(
                                            model.aboutUsController.text);
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
                                if (!model.hasUsedAboutUs)
                                  SizedBox(
                                    width: 86,
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        model.addLaundryAbout(
                                            model.aboutUsController.text);
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
                        ).paddingTop(0).expand(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  BusinessAboutComponent(model)
            


                        //  BusinessGalleryWidget(),