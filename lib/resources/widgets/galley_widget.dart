import 'package:flutter/material.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/view_utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class GalleryWidget extends StatefulWidget {
  static String tag = '/GalleryWidget';

  @override
  GalleryWidgetState createState() => GalleryWidgetState();
}

class GalleryWidgetState extends State<GalleryWidget> {
  List<GuideLinesModel> imgList = [];
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    selectedIndex = 0;
    imgList = getGalleryImgList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Container(
        width: context.width() * 0.8,
        alignment: Alignment.center,
        child: Column(
          children: [
            32.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text:  TextSpan(
                    children: [
                      TextSpan(text: 'Gallery ',   style: boldTextStyle(color: CustomColors.blackPrimary, size: 14, fontFamily: "Josefin Sans")),
                      TextSpan(
                        text: '(22)',
                        style: boldTextStyle(color: CustomColors.limcadPrimary, size: 14, fontFamily: "Josefin Sans"), // Change color here
                      ),
                    ],
                  ),
                ),



                Text('See All',
                    style: secondaryTextStyle(color: CustomColors.limcadPrimary, size: 14))

              ],
            ).padding(bottom: 8, left: 16, right: 16),


            Expanded(
              child: GridView.builder(
                itemCount: imgList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16, // Spacing between columns
                  mainAxisSpacing: 16, // Spacing between rows
                  childAspectRatio:
                  1, // Aspect ratio of each grid item (square in this case)
                ),
                padding: const EdgeInsets.all(8),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      selectedIndex = index;
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: commonCachedNetworkImage(imgList[index].img!, height: 176, width: 176, fit: BoxFit.cover).cornerRadiusWithClipRRect(10),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class GuideLinesModel {
  String? img;
  String? name;
  String? type;
  String? detail;

  GuideLinesModel({this.img, this.name, this.type, this.detail});
}

List<GuideLinesModel> getGalleryImgList() {
  List<GuideLinesModel> list = [];

  GuideLinesModel model1 = GuideLinesModel();
  model1.img = "assets/images/placeholder.jpg";
  list.add(model1);

  GuideLinesModel model2 = GuideLinesModel();
  model2.img = "assets/images/placeholder.jpg";
  list.add(model2);

  GuideLinesModel model3 = GuideLinesModel();
  model3.img = "assets/images/placeholder.jpg";
  list.add(model3);

  GuideLinesModel model4 = GuideLinesModel();
  model4.img = "assets/images/placeholder.jpg";
  list.add(model4);

  GuideLinesModel model5 = GuideLinesModel();
  model5.img = "assets/images/placeholder.jpg";
  list.add(model5);

  GuideLinesModel model6 = GuideLinesModel();
  model6.img = "assets/images/placeholder.jpg";
  list.add(model6);

  return list;
}