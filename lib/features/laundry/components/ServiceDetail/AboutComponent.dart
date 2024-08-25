import 'package:flutter/material.dart';
import 'package:limcad/features/dashboard/model/laundry_model.dart';
import 'package:limcad/features/laundry/model/laundry_vm.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

class AboutComponent extends StatefulWidget {
  final LaundryItem? laundry;

  const AboutComponent({Key? key, this.laundry}) : super(key: key);
  @override
  State<AboutComponent> createState() => _AboutComponentState();
}

class _AboutComponentState extends State<AboutComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  context.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Us', style: boldTextStyle()),
                  8.height,
                  Text(widget.laundry?.laundryAbout?.aboutText ?? "", style: secondaryTextStyle(), textAlign: TextAlign.start),
                  16.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Service Provider', style: primaryTextStyle()),

                          ListTile(
                            contentPadding: const EdgeInsets.only(left: 16),
                            leading:  ClipOval(

                              child: Image.asset(AssetUtil.individualAccount, height: 50, width: 50),
                            ), title: Text(widget.laundry?.name ?? "", style: boldTextStyle()),
                            subtitle: Text("Service Provider", style: secondaryTextStyle()),
                            trailing: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                        color: lightGray, shape: BoxShape.circle),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {

                                        },
                                        icon: const Icon(Icons.mail, size: 20, color: CustomColors.limcadPrimary,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8,),
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                        color: lightGray, shape: BoxShape.circle),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {

                                        },
                                        icon: const Icon(Icons.call, size: 20, color: CustomColors.limcadPrimary,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ).paddingTop(32).expand(),
                      // 16.width,
                      // Stack(
                      //   children: [
                      //     Container(
                      //       height: 100,
                      //       width: 150,
                      //       color: black.withOpacity(0.5),
                      //     ),
                      //     Container(
                      //       height: 100,
                      //       width: 150,
                      //       decoration: boxDecorationWithShadow(),
                      //       child: Text('Show Map', style: boldTextStyle()).center(),
                      //     ),
                      //   ],
                      // )
                    ],
                  ).padding(bottom: 50),
                  // 12.height,
                  // Text('Opening Hours', style: boldTextStyle()),
                  // 16.height,
                  // UL(
                  //   symbolType: SymbolType.Bullet,
                  //   children: [
                  //     Text('Monday : 08:00 AM - 08:00 PM', style: primaryTextStyle()),
                  //     Text('Tuesday : 08:00 AM - 08:00 PM', style: primaryTextStyle()),
                  //     Text('Friday : 08:00 AM - 08:00 PM', style: primaryTextStyle()),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}