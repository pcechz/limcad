import 'dart:math';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:limcad/features/dashboard/dashboard.dart';
import 'package:limcad/features/dashboard/widgets/services_widget.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/size_util.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:nb_utils/nb_utils.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  List<OSDataModel> expiringSoon = getExpiringSoon();


  final GlobalKey _fabKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();

  Set<Marker> _markers = {};
  final Random _random = Random();
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;


  LatLng _getRandomLagosLocation() {
    double minLat = 6.25;
    double maxLat = 6.7;
    double minLong = 3.15;
    double maxLong = 3.65;
    double lat = minLat + _random.nextDouble() * (maxLat - minLat);
    double lng = minLong + _random.nextDouble() * (maxLong - minLong);
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _getRandomLagosLocation(), // Start with a random Lagos location
              zoom: 12,
            ),
            mapToolbarEnabled: false,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
            },
            markers: _markers,
          ),
          Padding(
            padding: const EdgeInsets.only( top: 100, bottom: 20.0),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 280,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: context.scaffoldBackgroundColor),
                  child: AppTextField(
                    textFieldType: TextFieldType.NAME,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: white,
                      hintText: 'Search nearby laundry service ',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: grey),
                      contentPadding: EdgeInsets.only(
                          left: 24.0, bottom: 8.0, top: 8.0, right: 24.0),
                    ),
                  ),
                ),
                16.width,
                Container(
                    width: 56,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: CustomColors.limcadPrimary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Image.asset(
                          AssetUtil.filterIcon,
                          height: 20,
                          width: 20,
                          scale: 1.3,
                          color: white,
                        )))
              ],
            ).paddingSymmetric(horizontal: 16),
          ),

          // Positioned(
          //   bottom: 120.0,
          //   right: 8.0,
          //   left: 8.0,
          //   child:  SizedBox(
          //     height: 240,
          //     child: ListView.builder(
          //       itemCount: expiringSoon.length,
          //
          //       padding: EdgeInsets.all(8),
          //       itemBuilder: (_, index) {
          //         return ConstrainedBox(constraints: BoxConstraints(maxHeight: 238), child: ServiceItemWidget(expiringSoon[index]).paddingAll(8));
          //       },
          //       shrinkWrap: true,
          //       scrollDirection: Axis.horizontal,
          //     ),
          //   ),
          // ),
        ],
      ),



    );
  }


  void _showMenuAtFAB(GlobalKey fabKey) {
    final RenderBox fabRenderBox = fabKey.currentContext!.findRenderObject() as RenderBox;
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);



    showMenu(
      context: context,
      elevation: 6,
      color: Colors.white,
      position: RelativeRect.fromLTRB(
          0,
          fabOffset.dy + fabSize.height - 200, // Position below the FAB
          0,
          0
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.security, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Cosy area', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.wallet_3, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Price', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.strongbox, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Infastructure ', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),

        PopupMenuItem(
          child: Row(
            children: [
              Icon(IconsaxBold.layer, color: Colors.grey),
              SizedBox(width: 5,),
              Text('Without any layer ', style: TextStyle(color: Colors.black),),
            ],
          ),
          onTap: () {
          },
        ),
      ],

    );
  }

}