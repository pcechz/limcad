import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:limcad/features/auth/models/signup_vm.dart';
import 'package:limcad/features/onboarding/get_started.dart';
import 'package:limcad/resources/models/state_model.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/utils/validation_util.dart';
import 'package:limcad/resources/widgets/default_scafold.dart';
import 'package:limcad/resources/widgets/view_utils/custom_text_field.dart';
import 'package:limcad/resources/widgets/view_utils/phone_textfield.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = "/signup";

  final UserType theUsertype;

  const SignupPage({Key? key, required this.theUsertype}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late AuthVM model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => AuthVM(),
        onViewModelReady: (model) {
          this.model = model;
          model.context = context;
          model.init(context, OnboardingPageType.signup, widget.theUsertype);
        },
        builder: (context, model, child) => DefaultScaffold(
              showAppBar: true,
              includeAppBarBackButton: false,
              overrideBackButton: () {
                model.exitApp(context);
              },
              title: model.title,
              busy: model.loading,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Create Account",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: CustomColors.blackPrimary,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ).padding(bottom: 8),
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          "Fill out your details before or register with your social account.",
                          style: Theme.of(context).textTheme.bodyMedium!,
                          textAlign: TextAlign.center,
                        ).padding(bottom: 20, left: 16, right: 16),
                      ),
                    ),
                    Form(
                      key: model.formKey,
                      onChanged: model.onFormKeyChanged,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          CustomTextFields(
                            controller: model.fullNameController,
                            keyboardType: TextInputType.name,
                            label: "Full Name",
                            showLabel: true,
                            labelText: "Enter your full name",
                            autocorrect: false,
                            //validate: (value) => ValidationUtil.validateLastName(value),
                            onSave: (value) =>
                                model.fullNameController.text = value,
                          ).padding(bottom: 20),

                          CustomTextFields(
                            controller: model.emailController,
                            keyboardType: TextInputType.emailAddress,
                            label: "Email Address",
                            labelText: "Enter your email address",
                            showLabel: true,
                            autocorrect: false,
                            //validate: (value) => ValidationUtil.valida(value),
                            onSave: (value) => model.email = value,
                          ).padding(bottom: 20),

                          PhoneTextField(
                            hideCountryCode: false,
                            controller: model.phoneNumberController,
                            label: "Phone Number",
                            labelText: "Enter your phone number",
                            showLabel: true,
                            // validate: (value) => ValidationUtil.validatePhoneNumber(value),
                            onSave: (value) =>
                                model.phoneNumberController.text = value ?? "",
                          ).padding(bottom: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Address",
                                style: Theme.of(context).textTheme.bodyMedium!,
                              ).padding(bottom: 6),
                              GooglePlacesAutoCompleteTextFormField(
                                  textEditingController:
                                      model.addressController,
                                  googleAPIKey:
                                      "AIzaSyDmq2C1vmDwUr0cnIAX6djCFspyIHJ5V48",
                                  decoration: InputDecoration(
                                      fillColor:
                                          model.addressController.text.isEmpty == true
                                              ? Colors.white
                                              : Colors.transparent,
                                      hintText: "Enter Address",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      contentPadding: EdgeInsets.only(left: 27),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              width: 1.0,
                                              color:
                                                  CustomColors.limcardFaded)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              width: 1.0,
                                              color:
                                                  CustomColors.limcardFaded)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide:
                                              const BorderSide(width: 1.0, color: CustomColors.limcardFaded)),
                                      labelText: "Address"),
                                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter address';
                                    }
                                    return null;
                                  },
                                  // proxyURL: _yourProxyURL,
                                  maxLines: 1,
                                  overlayContainer: (child) => Material(
                                        elevation: 1.0,
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        child: child,
                                      ),
                                  getPlaceDetailWithLatLng: (prediction) {
                                    print('placeDetails${prediction.lng}');
                                  },
                                  itmClick: (Prediction prediction) {
                                    model.addressController.text =
                                        prediction.description ?? "";
                                    model.setAddress(prediction);
                                  }).padding(bottom: 20),
                            ],
                          ),

                          // CustomTextFields(
                          //   controller: model.addressController,
                          //   keyboardType: TextInputType.name,
                          //   label: "Address",
                          //   showLabel: true,
                          //   labelText: "Enter your current address",
                          //   formatter: InputFormatter.stringOnly,
                          //   autocorrect: false,
                          //   //validate: (value) => ValidationUtil.validateLastName(value),
                          //   onSave: (value) =>
                          //   model.fullNameController.text = value,
                          // ).padding(bottom: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "State",
                                style: Theme.of(context).textTheme.bodyMedium!,
                              ).padding(bottom: 6),
                              DropdownButtonFormField<StateResponse>(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.only(left: 27),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                ),
                                style: const TextStyle(
                                    color: CustomColors.blackPrimary),
                                icon: const Icon(CupertinoIcons.chevron_down,
                                        size: 18)
                                    .padding(right: 16),
                                hint: Text(
                                    model.selectedState?.stateName ?? "State",
                                    style: TextStyle(
                                        color: CustomColors.smallTextGrey,
                                        fontSize: 14)),
                                borderRadius: BorderRadius.circular(30),
                                items: model.states
                                    .map((e) => DropdownMenuItem<StateResponse>(
                                          value: e,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(e.stateName ?? "",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: CustomColors
                                                        .blackPrimary)),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) =>
                                    ValidationUtil.validateInput(
                                        value?.stateName, "State"),
                                onSaved: (StateResponse? value) =>
                                    model.selectedState = value,
                                value: model.selectedState,
                                onChanged: (value) {
                                  Logger()
                                      .i("Selected State: ${value?.stateName}");

                                  if (value != null) {
                                    model.setStateValue(value);
                                  }
                                },
                              ).padding(bottom: 20),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "LGA",
                                style: Theme.of(context).textTheme.bodyMedium!,
                              ).padding(bottom: 6),
                              DropdownButtonFormField<LGAResponse>(
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.only(left: 27),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                ),
                                style: const TextStyle(
                                    color: CustomColors.blackPrimary),
                                icon: const Icon(CupertinoIcons.chevron_down,
                                        size: 18)
                                    .padding(right: 16),
                                hint: Text(model.selectedLGA?.lgaName ?? "LGA",
                                    style: TextStyle(
                                        color: CustomColors.smallTextGrey,
                                        fontSize: 14)),
                                borderRadius: BorderRadius.circular(30),
                                items: model.lgas
                                    .map((e) => DropdownMenuItem<LGAResponse>(
                                          value: e,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(e.lgaName ?? "",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: CustomColors
                                                        .blackPrimary)),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) =>
                                    ValidationUtil.validateInput(
                                        value?.lgaName, "LGA"),
                                onSaved: (LGAResponse? value) =>
                                    model.selectedLGA = value,
                                value: model.selectedLGA,
                                onChanged: (value) {
                                  if (value != null) {
                                    model.setLGAValue(value);
                                  }
                                },
                              ).padding(bottom: 20),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: Theme.of(context).textTheme.bodyMedium!,
                              ).padding(bottom: 6),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(CupertinoIcons.person,
                                          size: 18)
                                      .padding(left: 4),
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.only(left: 27),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: CustomColors.limcardFaded)),
                                ),
                                style: const TextStyle(
                                    color: CustomColors.blackPrimary),
                                icon: const Icon(CupertinoIcons.chevron_down,
                                        size: 18)
                                    .padding(right: 16),
                                hint: const Text("Gender",
                                    style: TextStyle(
                                        color: CustomColors.smallTextGrey,
                                        fontSize: 14)),
                                borderRadius: BorderRadius.circular(30),
                                items: model.genderList
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(e,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: CustomColors
                                                        .blackPrimary)),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) =>
                                    ValidationUtil.validateInput(
                                        value, "Gender"),
                                onSaved: (String? value) =>
                                    model.gender = value?.toUpperCase(),
                                onChanged: (value) {
                                  if (value != null) {
                                    model.setGender(value);
                                  }
                                },
                              ).padding(bottom: 20),
                            ],
                          ),

                          ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              model.formKey.currentState!.save();

                              model.proceed();
                            },
                            child: const Text("Proceed"),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        TextButton(
                            onPressed: () {
                              model.goToLogin();
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: CustomColors.rpBlue),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

// ... (Add dispose method to clean up controllers)
}
