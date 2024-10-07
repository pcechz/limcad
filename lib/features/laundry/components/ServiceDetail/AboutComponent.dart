import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:collection/collection.dart';
import 'package:limcad/features/chat/chats_screen.dart';
import 'package:limcad/features/chat/message_screen.dart';
import 'package:limcad/features/dashboard/model/laundry_model.dart';
import 'package:limcad/features/laundry/model/laundry_vm.dart';
import 'package:limcad/features/onboarding/get_started.dart';
import 'package:limcad/resources/storage/base_preference.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../main.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;

class AboutComponent extends StatefulWidget {
  final LaundryItem? laundry;
  final UserType? userType;

  const AboutComponent({Key? key, this.laundry, this.userType}) : super(key: key);
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
              child:
           widget.userType == UserType.personal ? aboutUsPersonal() : aboutUsBusiness()
            ),
          ],
        ),
      ),
    );
  }


  Widget aboutUsPersonal(){

    return    Column(
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
                  subtitle: Text(widget.laundry?.email ?? "", style: secondaryTextStyle()),
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
                              child:
                              StreamBuilder<List<types.User>>(
                                stream: FirebaseChatCore.instance.users(), // Fetch the list of users as a stream
                                builder: (context, snapshot) {

                                  // Get the list of users
                                  List<types.User> users = snapshot.data ?? [];

                                  // Find the receiverUser by their email (from `widget.laundry?.email`)
                                  types.User? receiverUser = users.firstWhereOrNull((user) => user.metadata?["email"] == widget.laundry?.email);
                                  if (receiverUser == null) {
                                    return Text("Receiver not found!"); // Handle case where receiver is not found
                                  }

                                  return IconButton(
                                    onPressed: () async {
                                      BasePreference _preference = await BasePreference.getInstance();
                                      final currentUserId = _preference.getCurrentFirebaseUserID();

                                      if (currentUserId != null) {
                                        // Fetch the list of rooms the current user is in
                                        List<types.Room> rooms = await FirebaseChatCore.instance.rooms().first;

                                        // Check if a room exists between the current user and the receiver
                                        types.Room? existingRoom = rooms.firstWhereOrNull(
                                              (room) => room.type == types.RoomType.direct && room.users.contains(receiverUser),
                                        );

                                        if (existingRoom != null) {
                                          // Room exists, navigate to chat
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MessagesScreen(existingRoom),
                                            ),
                                          );
                                        } else {
                                          // Room doesn't exist, create a new room
                                          final newRoom = await FirebaseChatCore.instance.createRoom(receiverUser);

                                          // Navigate to the new chat room
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MessagesScreen(newRoom),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.mail, size: 20, color: CustomColors.limcadPrimary),
                                  );
                                },
                              )

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
    );
  }


  Widget aboutUsBusiness(){

    return    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(widget.laundry?.laundryAbout?.aboutText ?? "", style: secondaryTextStyle(), textAlign: TextAlign.start),
        16.height,

      ],
    );
  }
}