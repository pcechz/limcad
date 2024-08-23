import 'package:flutter/material.dart';
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
        builder: (BuildContext context, model, child) => Scaffold(
              body: DefaultTabController(
                length: 4,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        leading: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: CustomColors.limcadPrimary,
                                  size: 17,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                        pinned: true,
                        elevation: 0.5,
                        expandedHeight: 370,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding:
                              EdgeInsets.only(bottom: 66, left: 30, right: 50),
                          collapseMode: CollapseMode.parallax,
                          title: Text(
                            '',
                            style: boldTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ).hideIf(!innerBoxIsScrolled),
                          background: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  commonCacheImageWidget(
                                      AssetUtil.laundryWall, 300,
                                      width: context.width(),
                                      fit: BoxFit.cover),
                                  Container(
                                    height: 300,
                                    width: context.width(),
                                    color: black.withOpacity(0.6),
                                  ),
                                ],
                              ),
                              Text('Withdraw money into your saved card',
                                      textAlign: TextAlign.center,
                                      style: secondaryTextStyle(
                                        color: CustomColors.black900,
                                        size: 16,
                                      ))
                                  .paddingSymmetric(
                                      horizontal: 16, vertical: 16),
                            ],
                          ),
                        ),
                        bottom: TabBar(
                          labelStyle:
                              boldTextStyle(color: CustomColors.limcadPrimary),
                          labelColor: CustomColors.limcadPrimary,
                          unselectedLabelColor: black,
                          unselectedLabelStyle:
                              boldTextStyle(color: CustomColors.blackPrimary),
                          indicatorColor: CustomColors.limcadPrimary,
                          indicatorPadding:
                              EdgeInsets.only(left: 16, right: 16),
                          indicatorWeight: 3,
                          isScrollable: false,
                          tabs: [
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('About',
                                    style: primaryTextStyle(
                                        size: 14, weight: FontWeight.w500)),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Services',
                                    style: primaryTextStyle(
                                        size: 14, weight: FontWeight.w500)),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Media',
                                    style: primaryTextStyle(
                                        size: 14, weight: FontWeight.w500)),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Reviews',
                                    style: primaryTextStyle(
                                        size: 14, weight: FontWeight.w500)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ];
                  },
                  body: TabBarView(
                    children: [
                      BusinessAboutComponent(model),
                      CreateServicesComponent(model: model),
                      BusinessGalleryWidget(),
                      BusinessAboutComponent(model)
                    ],
                  ),
                ),
              ),
            ));
  }
}
