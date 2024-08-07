
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:limcad/features/auth/models/signup_request.dart';
import 'package:limcad/features/auth/models/signup_response.dart' as signupRes;
import 'package:limcad/features/auth/services/signup_service.dart';
import 'package:limcad/features/laundry/model/about_response.dart';
import 'package:limcad/features/laundry/services/laundry_service.dart';
import 'package:limcad/features/onboarding/get_started.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/base_vm.dart';
import 'package:limcad/resources/locator.dart';
import 'package:limcad/resources/models/profile.dart';
import 'package:limcad/resources/models/state_model.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/view_utils/view_utils.dart';
import 'package:logger/logger.dart';

enum ProfileOption {about, addAddress}
class ProfileVM extends BaseVM {
  final apiService = locator<APIClient>();
  late BuildContext context;
  String title = "";
  final instructionController = TextEditingController();
  final addressController = TextEditingController();
  final addressNameController = TextEditingController();

  bool isPreview = false;
  bool isButtonEnabled = false;
  AboutResponse? laundryAbout;
  ProfileOption? profileOption;
  Prediction? prediction;
  ProfileResponse? profileResponseRequest;
  signupRes.Address? address;
  List<StateResponse> states = [];
  List<LGAResponse> lgas = [];
  StateResponse? selectedState;
  LGAResponse? selectedLGA;



  init(BuildContext context, ProfileOption profileOption) {
    this.context = context;
    this.profileOption = profileOption;
  }




  Future<void> setStateValue(StateResponse value) async {
    selectedState = value;
    if (selectedState != null) {
      final response = await locator<AuthenticationService>()
          .getLGAs(selectedState?.stateId);
      Logger().i(response.data);
      if(response.data!.isNotEmpty){
        lgas.addAll(response.data?.toList() ?? []);
        Logger().i(response.data);
      }

    }
    notifyListeners();
  }

  Future<void> setLGAValue(LGAResponse value) async {
    selectedLGA = value;
    notifyListeners();
  }

  void setAddress(Prediction predict) {
    prediction = predict;
    address?.name = addressNameController.text;
    address?.additionalInfo = predict.description;
    address?.lgaId = selectedLGA?.id?.lgaId;
    address?.lga = selectedLGA?.lgaName;
    address?.stateId = selectedState?.stateId;
    address?.userType = UserType.personal.name.toUpperCase();
    final lgaReference = signupRes.LgaReference();
    lgaReference.lgaName = selectedLGA?.lgaName;
    lgaReference.id = signupRes.Id(lgaId: selectedLGA?.id?.lgaId, stateId: selectedState?.stateId);
    lgaReference.state = signupRes.State(stateId: selectedState?.stateId, stateName: selectedState?.stateName);
    address?.lgaReference = lgaReference;
    address?.genericUserId = locator<AuthenticationService>().profile?.id;
    address?.latitude = num.tryParse(predict?.lat ?? "0.0");
    address?.longitude = num.tryParse(predict?.lng ?? "0.0");
    notifyListeners();
  }

}