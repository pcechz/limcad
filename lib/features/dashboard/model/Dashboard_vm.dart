import 'dart:math';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:limcad/features/auth/auth/business_signup.dart';
import 'package:limcad/features/auth/auth/business_signup_continuation.dart';
import 'package:limcad/features/auth/auth/login.dart';
import 'package:limcad/features/auth/auth/signup.dart';
import 'package:limcad/features/auth/models/business_onboarding_request.dart';
import 'package:limcad/features/auth/models/login_response.dart';
import 'package:limcad/features/auth/models/signup_request.dart';
import 'package:limcad/features/auth/models/signup_response.dart';
import 'package:limcad/features/auth/services/signup_service.dart';
import 'package:limcad/features/auth/auth/create_password.dart';
import 'package:limcad/features/auth/auth/signup_otp.dart';
import 'package:limcad/features/auth/auth/signup_payment_details.dart';
import 'package:limcad/features/dashboard/dashboard_service.dart';
import 'package:limcad/features/dashboard/model/laundry_model.dart';
import 'package:limcad/features/onboarding/get_started.dart';
import 'package:limcad/features/onboarding/verify_id.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/api/base_response.dart';
import 'package:limcad/resources/api/response_code.dart';
import 'package:limcad/resources/base_vm.dart';
import 'package:limcad/resources/bottom_home.dart';
import 'package:limcad/resources/locator.dart';
import 'package:limcad/resources/models/change_profile_response.dart';
import 'package:limcad/resources/models/general_response.dart';
import 'package:limcad/resources/models/profile.dart';
import 'package:limcad/resources/models/state_model.dart';
import 'package:limcad/resources/routes.dart';
import 'package:limcad/resources/storage/base_preference.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/view_utils/view_utils.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:nb_utils/nb_utils.dart';
import 'package:stacked/stacked_annotations.dart';



class DashboardVM extends BaseVM {
  final apiService = locator<APIClient>();
  late BuildContext context;

  String title = "";
  String? email;
  bool isButtonEnabled = false;

  final profile = locator<AuthenticationService>().profile;
  late CameraController controller = CameraController(
      CameraDescription(
          name: 'camera',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 180),
      ResolutionPreset.max);
  var genderList = ["Male", "Female"];

  bool verified = false;


  late BasePreference _preference;
  String? otpId;
  final addressController = TextEditingController();
  String? gender;
  UserType? userType;
  List<LaundryItem>? laundryOrganisations = [];
  LaundryItem? selectedOrganisation;

  bool otpSent = false;

  void init(BuildContext context,
      [ UserType? userT]) async {
    userType = userT;

      if(userT == UserType.personal){
        fetchOrganisations();
      }



    _preference = await BasePreference.getInstance();
  }


  void fetchOrganisations() async {
    try {
      isLoading(true);
      notifyListeners();

      final response = await locator<DashboardService>().getLaundryServices();
      Logger().i("Response received: $response");

      if (response?.data?.items != null && response!.data!.items!.isNotEmpty) {
        laundryOrganisations = response.data!.items!.reversed.toList();
      } else {
        laundryOrganisations = [];
      }
    } catch (e) {
      Logger().e("Error fetching laundry organisations: $e");
    } finally {
      isLoading(false);
      notifyListeners();
    }
  }


}
