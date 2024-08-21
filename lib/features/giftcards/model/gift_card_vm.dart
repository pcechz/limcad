import 'package:flutter/material.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/base_vm.dart';
import 'package:limcad/resources/locator.dart';

enum GiftCardType { DISCOUNT, BIRTHDAY, WEDDING, GRADUATION, OTHER }

class GiftCardViewModel extends BaseVM {
  final apiService = locator<APIClient>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController recipientName = TextEditingController();
  final TextEditingController senderName = TextEditingController();
  final TextEditingController senderEmail = TextEditingController();
  final TextEditingController senderMessage = TextEditingController();
  late BuildContext context;
  init(BuildContext context) {}

  void selectRecipient(String name) {
    recipientName.text = name;
    print('Selected recipient: $name');
    notifyListeners();
  }
}
