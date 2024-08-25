import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:limcad/features/auth/models/business_onboarding_request.dart';
import 'package:limcad/features/auth/models/signup_vm.dart';
import 'package:limcad/features/onboarding/get_started.dart';
import 'package:limcad/resources/models/state_model.dart';
import 'package:limcad/resources/utils/custom_colors.dart';
import 'package:limcad/resources/utils/extensions/widget_extension.dart';
import 'package:limcad/resources/utils/validation_util.dart';
import 'package:limcad/resources/widgets/default_scafold.dart';
import 'package:limcad/resources/widgets/view_utils/custom_text_field.dart';
import 'package:limcad/resources/widgets/view_utils/password_input_field.dart';
import 'package:limcad/resources/widgets/view_utils/phone_textfield.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stacked/stacked.dart';

class BusinessSignUpSecondPage extends StatefulWidget {
  static const String routeName = "/businessSignUpPageContinuation";

  final UserType theUsertype;
  final BusinessOnboardingRequest? businessRequest;
  const BusinessSignUpSecondPage(
      {Key? key, required this.theUsertype, this.businessRequest})
      : super(key: key);

  @override
  State<BusinessSignUpSecondPage> createState() =>
      _BusinessSignUpSecondPageState();
}

class _BusinessSignUpSecondPageState extends State<BusinessSignUpSecondPage> {
  late AuthVM model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => AuthVM(),
      onViewModelReady: (model) {
        this.model = model;
        model.context = context;
        model.onboardingRequest = widget.businessRequest;
        model.init(context, OnboardingPageType.signup, widget.theUsertype);
        model.fetchState();
      },
      builder: (context, viewModel, child) => DefaultScaffold(
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
                child: const Text(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Address",
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ).padding(bottom: 6),
                    GooglePlacesAutoCompleteTextFormField(
                        textEditingController: model.addressController,
                        googleAPIKey: "AIzaSyDmq2C1vmDwUr0cnIAX6djCFspyIHJ5V48",
                        decoration: InputDecoration(
                            fillColor:
                                model.addressController.text.isEmpty == true
                                    ? Colors.white
                                    : Colors.transparent,
                            hintText: "Enter Address",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            contentPadding: EdgeInsets.only(left: 27),
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
                            labelText: "Address"),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "State",
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ).padding(bottom: 6),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  height: MediaQuery.of(context).size.height * 0.5, // Adjust the height as needed
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select State",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: model.states.length,
                                          itemBuilder: (context, index) {
                                            final state = model.states[index];
                                            return ListTile(
                                              title: Text(state.stateName ?? ""),
                                              onTap: () {
                                                Navigator.pop(context); // Close the bottom sheet
                                                setState(() {
                                                  model.setStateValue(state.stateName!);
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: CustomColors.limcardFaded),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(model.selectedState?.stateName ?? "Select State"),
                                Icon(CupertinoIcons.chevron_down),
                              ],
                            ),
                          ),
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
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  height: MediaQuery.of(context).size.height * 0.5, // Adjust the height as needed
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Select LGA",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: model.lgas.length,
                                          itemBuilder: (context, index) {
                                            final lga = model.lgas[index];
                                            return ListTile(
                                              title: Text(lga.lgaName ?? ""),
                                              onTap: () {
                                                Navigator.pop(context); // Close the bottom sheet
                                                setState(() {
                                                  model.setLGAValue(lga);
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: CustomColors.limcardFaded),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(model.selectedLGA?.lgaName ?? "Select LGA"),
                                Icon(CupertinoIcons.chevron_down),
                              ],
                            ),
                          ),
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
                            prefixIcon:
                                const Icon(CupertinoIcons.person, size: 18)
                                    .padding(left: 4),
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(left: 27),
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
                          style:
                              const TextStyle(color: CustomColors.blackPrimary),
                          icon:
                              const Icon(CupertinoIcons.chevron_down, size: 18)
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
                                              color:
                                                  CustomColors.blackPrimary)),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) =>
                              ValidationUtil.validateInput(value, "Gender"),
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
                        model.createAccount();
                      },
                      child: const Text("Proceed"),
                    )
                  ],
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 20),
        ),
      ),
    );
  }

  bool _allConditionsMet() {
    return model.formKey.currentState?.validate() == true &&
        model.gender!.isNotEmpty &&
        model.selectedState != null &&
        model.addressController.text.isNotEmpty;
  }
}
