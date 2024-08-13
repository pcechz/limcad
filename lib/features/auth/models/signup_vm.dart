import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:limcad/features/auth/auth/business_signup.dart';
import 'package:limcad/features/auth/auth/business_signup_continuation.dart';
import 'package:limcad/features/auth/auth/login.dart';
import 'package:limcad/features/auth/auth/signup.dart';
import 'package:limcad/features/auth/models/business_onboarding_request.dart';
import 'package:limcad/features/auth/models/signup_request.dart';
import 'package:limcad/features/auth/models/signup_response.dart';
import 'package:limcad/features/auth/services/signup_service.dart';
import 'package:limcad/features/auth/auth/create_password.dart';
import 'package:limcad/features/auth/auth/signup_otp.dart';
import 'package:limcad/features/auth/auth/signup_payment_details.dart';
import 'package:limcad/features/onboarding/get_started.dart';
import 'package:limcad/features/onboarding/verify_id.dart';
import 'package:limcad/resources/api/api_client.dart';
import 'package:limcad/resources/api/base_response.dart';
import 'package:limcad/resources/api/response_code.dart';
import 'package:limcad/resources/base_vm.dart';
import 'package:limcad/resources/bottom_home.dart';
import 'package:limcad/resources/locator.dart';
import 'package:limcad/resources/models/general_response.dart';
import 'package:limcad/resources/models/state_model.dart';
import 'package:limcad/resources/routes.dart';
import 'package:limcad/resources/storage/base_preference.dart';
import 'package:limcad/resources/utils/assets/asset_util.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/widgets/view_utils/view_utils.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked_annotations.dart';

enum OnboardingPageType {
  signup,
  signupOtp,
  createPassword,
  login,
  resetPassword
}

enum IdType { document, nin }

class AuthVM extends BaseVM {
  final apiService = locator<APIClient>();
  late BuildContext context;
  SignupRequest? signupRequest = SignupRequest();
  BusinessOnboardingRequest? onboardingRequest = BusinessOnboardingRequest();
  final formKey = GlobalKey<FormState>();
  final completeFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ninController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String title = "";
  String? email;
  bool isButtonEnabled = false;
  final otpController = TextEditingController();
  final password = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  final confirmPassword = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  final profile = locator<AuthenticationService>().profile;
  late CameraController controller = CameraController(
      CameraDescription(
          name: 'camera',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 180),
      ResolutionPreset.max);
  var genderList = ["Male", "Female"];

  bool verified = false;

  final taxNumber = TextEditingController();
  final routingNumber = TextEditingController();
  final accountNumber = TextEditingController();
  final accountName = TextEditingController();
  final bankNameController = TextEditingController();
  late BasePreference _preference;
  bool showDocumentView = false;
  bool documentVerified = false;
  bool showNinView = false;
  bool ninVerified = false;
  String? otpId;
  final addressController = TextEditingController();
  String? gender;
  UserType? userType;
  List<StateResponse> states = [];
  List<LGAResponse> lgas = [];
  StateResponse? selectedState;
  LGAResponse? selectedLGA;
  Prediction? prediction;

  Future<void> init(BuildContext context,
      [OnboardingPageType? route, UserType? userT]) async {
    userType = userT;

    if (route == OnboardingPageType.signupOtp) {
      final response = await locator<AuthenticationService>()
          .requestOtp(signupRequest?.email, userType);
      Logger().i(response.data);
      //otpId = response.data?.otpId;
    }

    if (route == OnboardingPageType.signup) {
      final response = await locator<AuthenticationService>().getStates();
      states.addAll(response.data?.toList() ?? []);
      notifyListeners();
    }

    _preference = await BasePreference.getInstance();

    print("Email: ${onboardingRequest?.staffRequest?.email}");
    print("Name: ${onboardingRequest?.staffRequest?.name}");
    print("Password: ${onboardingRequest?.staffRequest?.password}");
  }

  void _initializeController() async {
    controller.initialize();
  }

  void exitApp(BuildContext context) {}

  void proceed() {
    signupRequest?.email = emailController.text;
    signupRequest?.name = fullNameController.text;
    signupRequest?.phoneNumber = phoneNumberController.text;
    signupRequest?.gender = gender?.toUpperCase();
    signupRequest?.addressRequest?.add(AddressRequest(
        additionalInfo: "{lag: ${prediction?.lat}, long: ${prediction?.lng} ",
        name: addressController.text,
        lgaRequest: LgaRequest(lgaId: 9, stateId: "LA")));
    NavigationService.pushScreen(context,
        screen: CreatePassword(request: signupRequest, userType: userType),
        withNavBar: false);
  }

  void createAccount() async {
    onboardingRequest ??= BusinessOnboardingRequest(
        staffRequest: StaffRequest(addressRequest: []),
        organizationRequest: OrganizationRequest());
    onboardingRequest!.staffRequest ??= StaffRequest(addressRequest: []);
    onboardingRequest!.staffRequest!.addressRequest ??= [];
    onboardingRequest!.organizationRequest ??= OrganizationRequest();
    onboardingRequest!.staffRequest!.addressRequest!.add(AddressRequest(
        additionalInfo: "{lag: ${prediction?.lat}, long: ${prediction?.lng} ",
        name: addressController.text,
        lgaRequest: LgaRequest(lgaId: 9, stateId: "LA")));
    onboardingRequest?.staffRequest?.addressRequest?.add(AddressRequest(
        additionalInfo: "{lag: ${prediction?.lat}, long: ${prediction?.lng} ",
        name: addressController.text,
        lgaRequest: LgaRequest(lgaId: 9, stateId: "LA")));
    onboardingRequest?.staffRequest?.gender = "MALE";
    onboardingRequest?.staffRequest?.roleEnums = ["ADMINISTRATOR"];
    onboardingRequest?.staffRequest?.userType = userType?.name.toString();
    onboardingRequest?.organizationRequest?.address = addressController.text;
    onboardingRequest?.organizationRequest?.name =
        onboardingRequest?.staffRequest?.name;
    onboardingRequest?.organizationRequest?.email =
        onboardingRequest?.staffRequest?.email;
    onboardingRequest?.organizationRequest?.location = addressController.text;
    onboardingRequest?.organizationRequest?.phoneNumber =
        onboardingRequest?.staffRequest?.phoneNumber;

    isLoading(true);
    final response = await locator<AuthenticationService>()
        .createBusinessAccount(onboardingRequest!);
    isLoading(false);

    if (response.status == 200) {
      if (context.mounted) {
        NavigationService.pushScreen(context,
            screen: const HomePage("business"), withNavBar: false);
      }
    }
  }

  void proceedToSecondPage() {
    onboardingRequest?.staffRequest ??= StaffRequest();

    onboardingRequest?.staffRequest?.email = emailController.text;
    onboardingRequest?.staffRequest?.name = fullNameController.text;
    onboardingRequest?.staffRequest?.password = password.text;
    onboardingRequest?.staffRequest?.phoneNumber = phoneNumberController.text;
    NavigationService.pushScreen(context,
        screen: BusinessSignUpSecondPage(
          theUsertype: userType!,
          businessRequest: onboardingRequest,
        ));
  }

  void proceedToVerifyEmail() async {
    onboardingRequest ??= BusinessOnboardingRequest();
    onboardingRequest?.staffRequest ??= StaffRequest();

    onboardingRequest?.staffRequest?.email = emailController.text;
    onboardingRequest?.staffRequest?.name = fullNameController.text;
    onboardingRequest?.staffRequest?.password = password.text;

    print("Email: ${onboardingRequest?.staffRequest?.email}");
    print("Name: ${onboardingRequest?.staffRequest?.name}");
    print("Password: ${onboardingRequest?.staffRequest?.password}");

    try {
      final response = await locator<AuthenticationService>()
          .requestOtp(onboardingRequest?.staffRequest?.email, userType);

      Logger().i(response.status);

      isLoading(false);

      if (response.status == 200 && context.mounted) {
        NavigationService.pushScreen(
          context,
          screen: SignupOtpPage(
            businessRequest: onboardingRequest,
            userType: userType,
            from: BusinessSignUpPage.routeName,
          ),
          withNavBar: true,
        );
      } else {
        print("Failed to request OTP or context not mounted.");
      }
    } catch (e) {
      print("Error during OTP request: $e");
      Logger().e('Error requesting OTP: $e');
    }
  }

  Future<void> sendResetPasswordCode() async {
    isLoading(true);
    final response = await locator<AuthenticationService>()
        .requestResetPasswordCode(userType, emailController.text);
    Logger().i(response.status);
    isLoading(false);
  }

  Future<void> proceedVerifyOTP() async {
    isLoading(true);
    final response = await locator<AuthenticationService>()
        .validateOtp(signupRequest?.email, otpController.text, userType!.name!);
    isLoading(false);
    if (response.status == ResponseCode.created ||
        response.status == ResponseCode.success) {
      if (response.data?.token != null) {
        _preference.saveToken(Tokens(
            token: response.data?.token,
            refreshToken: response.data?.refreshToken));
      }
      if (response.data?.user != null) {
        _preference.saveLoginDetails(response.data!.user!);
      }
      ViewUtil.showDynamicDialogWithButton(
          barrierDismissible: false,
          context: context,
          titlePresent: false,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  AssetUtil.successCheck,
                  width: 64,
                  height: 64,
                ).padding(bottom: 24, top: 22),
              ),
              const Text(
                "Email Verified",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColors.kBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    height: 1.2),
              ).padding(bottom: 16),
              const Text(
                "You have successfully verified your email address",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColors.kBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 1.2),
              ).padding(bottom: 24)
            ],
          ),
          buttonText: "Continue",
          dialogAction1: () async {
            Navigator.pop(context);
            _preference.saveLoginDetails(response.data!.user!);
            isLoading(true);
            final profileResponse =
                await locator<AuthenticationService>().getProfile();
            isLoading(false);

            if (profileResponse.status == ResponseCode.success &&
                profileResponse.data != null) {
              if (context.mounted) {
                NavigationService.pushScreen(context,
                    screen: const HomePage("PERSONAL"), withNavBar: false);
              }
            }
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => VerifyIdPage(request: signupRequest)));
          });

      notifyListeners();
    }
  }

  onFormKeyChanged() {
    isButtonEnabled = formKey.currentState!.validate();
    notifyListeners();
  }

  onCompleteFormKeyChanged() {
    isButtonEnabled = completeFormKey.currentState!.validate();
    notifyListeners();
  }

  Future<void> proceedFromVerifyOTP() async {}

  Future<void> proceedPassword() async {
    signupRequest?.password = password.text;
    isLoading(true);
    final response =
        await locator<AuthenticationService>().signUp(signupRequest);

    if (response.status == 200 || response.status == 201) {
      if (response.data != null) {
        // _preference.saveProfile(response.data!.);
        NavigationService.pushScreen(context,
            screen: SignupOtpPage(
              request: signupRequest,
              userType: userType,
              from: SignupPage.routeName,
            ),
            withNavBar: true);
      }
    } else {
      //ViewUtil.sh
    }
    isLoading(false);

    //  }
  }

  Future<void> proceedLogin(UserType? theUsertype) async {
    signupRequest?.password = password.text;
    signupRequest?.email = emailController.text;
    isLoading(true);
    final response = await locator<AuthenticationService>()
        .login(signupRequest, theUsertype);
    isLoading(false);
    if (response.status == ResponseCode.success) {
      if (response.data?.token != null) {
        final tokenJson = {
          "token": response.data?.token,
          "refreshToken": response.data?.refreshToken
        };
        _preference.saveToken(Tokens.fromJson(tokenJson));
      }
      if (response.data?.user != null) {
        _preference.saveLoginDetails(response.data!.user!);
        isLoading(true);
        final profileResponse =
            await locator<AuthenticationService>().getProfile();
        isLoading(false);

        if (profileResponse.status == ResponseCode.success &&
            profileResponse.data != null) {
          if (context.mounted) {
            NavigationService.pushScreen(context,
                screen: const HomePage("PERSONAL"), withNavBar: false);
          }
        }
      }
    } else if (response.status == ResponseCode.unauthorized) {
      NavigationService.pushScreen(context,
          screen: SignupOtpPage(
              request: signupRequest,
              userType: theUsertype,
              from: LoginPage.routeName),
          withNavBar: true);
    } else {
      ViewUtil.showSnackBar(response.message ?? "An error occurred", true);
    }
  }

  void setId(IdType idType) {
    if (idType == IdType.document) {
      showDocumentView = true;
      _initializeController();
      notifyListeners();
    } else if (idType == IdType.nin) {
      showNinView = true;
      notifyListeners();
    }
  }

  void documentVerify() {
    showDocumentView = false;
    documentVerified = true;
    notifyListeners();
  }

  void ninVerify() {
    showNinView = false;
    ninVerified = true;
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void goToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage(userType?.name);
    }));
  }

  Future<void> setStateValue(StateResponse value) async {
    selectedState = value;
    // if (selectedState != null) {
    //   final response = await locator<AuthenticationService>()
    //       .getLGAs(selectedState?.stateId);
    //   Logger().i(response.data);
    //   if(response.data!.isNotEmpty){
    //     lgas.addAll(response.data?.toList() ?? []);
    //     Logger().i(response.data);
    //   }
    //
    // }
    notifyListeners();
  }

  Future<void> setLGAValue(LGAResponse value) async {
    selectedLGA = value;
    notifyListeners();
  }

  void setAddress(Prediction predict) {
    prediction = predict;
    notifyListeners();
  }

  goToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginPage(theUsertype: userType!);
    }));
  }
}
