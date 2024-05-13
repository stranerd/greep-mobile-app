import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/auth/SignupCubit.dart';
import 'package:greep/application/auth/SignupState.dart';
import 'package:greep/application/auth/request/SignupRequest.dart';
import 'package:greep/application/user/request/EditUserRequest.dart';
import 'package:greep/application/user/request/update_user_type_request.dart';
import 'package:greep/application/user/user_crud_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/splash/authentication_splash.dart';
import 'package:greep/presentation/widgets/custom_phone_field.dart';
import 'package:greep/presentation/widgets/in_app_notification_widget.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class AuthFinishSignup extends StatefulWidget {
  const AuthFinishSignup(
      {Key? key,})
      : super(key: key);

  @override
  _AuthFinishSignupState createState() => _AuthFinishSignupState();
}

class _AuthFinishSignupState extends State<AuthFinishSignup>
    with InputValidator, ScaffoldMessengerService {
  late UserCrudCubit userCrudCubit;
  String _firstName = "", _lastName = "", _userName = "";

  AppPhoneNumber? _phoneNumber;
  late TextEditingController _emailController;

  final formKey = GlobalKey<FormState>();

  XFile? selectedImage;
  XFile? selectedLicense;

  @override
  void initState() {
    userCrudCubit = getIt();
    _emailController = TextEditingController()..text = getAuthUser().email;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void pickImage({required ImageSource source, context}) async {
    final picker = ImagePicker();
    var image = await picker.pickImage(
      source: source,
    );
    setState(() => selectedImage = image);
  }

  void _signUp() async {
    if (formKey.currentState!.validate()) {
      if (selectedImage == null) {
        error = "Please upload a profile photo";
        return;
      }
      UpdateUserTypeRequest typeRequest = UpdateUserTypeRequest(
        license: File(selectedLicense!.path),
      );
      userCrudCubit.updateUserType(typeRequest);
    }
  }

  void pickLicense() async {
    final picker = ImagePicker();
    var image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() => selectedLicense = image);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userCrudCubit,
      child: BlocConsumer<UserCrudCubit, UserCrudState>(
        listenWhen: (_, __) {
          return ModalRoute.of(context)?.isCurrent ?? false;
        },
        listener: (context, state) {
          if (state is UserCrudStateFailure) {
            showInAppNotification(
              context,
              title: "Error",
              body: state.errorMessage,
              isSuccess: false
            );
          }
          if (state is UserCrudStateSuccess) {
            if (state.isEditUser) {
              g.Get.offAll(
                () => NavBarView(),
              );
            }
            if (state.isUpdateUserType) {
              var extension = selectedImage!.path.split(".").last;

              userCrudCubit.editUser(
                EditUserRequest(
                  firstName: _firstName,
                  lastName: _lastName,
                  phoneNumber: _phoneNumber!,
                  username: _userName,
                  photo: dio.MultipartFile.fromFileSync(selectedImage!.path,
                      contentType: MediaType(
                          'image', extension == "jpg" ? "jpeg" : "png")),
                ),
              );
            }
          }
        },
        builder: (context, crudState) {
          return BlocConsumer<SignupCubit, SignupState>(
            listenWhen: (_, __) {
              return ModalRoute.of(context)?.isCurrent ?? false;
            },
            listener: (context, state) {
              // if (state is SignupStateError) {
              //   error = state.errorMessage ?? "Sign up failed";
              // }
              // if (state is SignupStateSuccess) {
              //   // print("pushing to splash screen on signup success");
              //   g.Get.to(
              //           () =>
              //           AuthenticationSplashScreen(
              //             isNewUser: true,
              //             email: widget.email,
              //           ),
              //       transition: g.Transition.fadeIn);
              // }
            },
            builder: (context, signupState) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: TextWidget(
                    "Complete profile",
                    fontSize: 18.sp,
                    weight: FontWeight.w600,
                  ),
                  actions: [
                    CloseButton(
                      onPressed: (){
                        // Get.to(() => A);

                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultSpacing * 0.5),
                          width: g.Get.width,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 90.r,
                            width: 90.r,
                            child: SplashTap(
                              onTap: (){
                                pickImage(
                                  source: ImageSource.gallery,
                                  context: context,
                                );
                              },
                              child: Stack(clipBehavior: Clip.none, children: [
                                Container(
                                  height: 90.r,
                                  width: 90.r,
                                  clipBehavior: Clip.hardEdge,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: kBlackColor.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: selectedImage == null
                                      ? Image.asset(
                                          "assets/images/empty_profile.png",
                                          width: 85.r,
                                          height: 85.r,
                                        )
                                      : Image.file(
                                          File(selectedImage!.path),
                                          height: 90.r,
                                          width: 90.r,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 35.r,
                                      width: 35.r,
                                      decoration: const BoxDecoration(
                                          color: kBlackColor,
                                          shape: BoxShape.circle),
                                      child: Image.asset(
                                        "assets/icons/camera.png",
                                        width: 25.r,
                                        height: 25.r,
                                      )),
                                ),
                              ]),
                            ),
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Container(
                            padding: const EdgeInsets.all(kDefaultSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16.h,
                                ),
                                InputTextField(
                                  title: "First name",
                                  hintText: "Enter your first name",
                                  validator: emptyFieldValidator,
                                  onChanged: (String value) {
                                    _firstName = value;
                                    setState(() {});
                                  },
                                  withBorder: true,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                InputTextField(
                                  title: "Last name",
                                  hintText: "Enter your last name",
                                  validator: emptyFieldValidator,
                                  onChanged: (String value) {
                                    setState(() {
                                      _lastName = value;
                                    });
                                  },
                                  withBorder: true,
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                InputTextField(
                                  title: "Username",
                                  hintText: "Enter a unique username",
                                  validator: emptyFieldValidator,
                                  onChanged: (String v) {
                                    setState(() {
                                      _userName = v;
                                    });
                                  },
                                  withBorder: true,
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      "Phone number",
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    CustomPhoneField(
                                      initialCountry: "NG",
                                      onChanged: (phone) {
                                        setState(() {
                                          _phoneNumber = phone;
                                        });
                                      },
                                      initialValue:
                                          _phoneNumber?.fullNumber ?? "",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                InputTextField(
                                  title: "Email address",
                                  enabled: false,
                                  customController: _emailController,
                                  withBorder: true,
                                  validator: validateEmail,
                                  onChanged: (String v) {
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextWidget(
                                      "Driver's license",
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    SplashTap(
                                      onTap: () {
                                        pickLicense();
                                      },
                                      child: Container(
                                        height: selectedLicense != null
                                            ? 180.h
                                            : 48.h,
                                        width: double.infinity,
                                        // clipBehavior: Clip.hardEdge,
                                        decoration: const BoxDecoration(),
                                        child: DottedBorder(
                                          strokeWidth: 0.7,
                                          borderType: BorderType.RRect,
                                          color: AppColors.veryLightGray,
                                          strokeCap: StrokeCap.round,
                                          dashPattern: const [6, 5, 6, 5],
                                          padding: EdgeInsets.zero,
                                          radius: const Radius.circular(
                                              kDefaultSpacing * 0.5),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: selectedLicense != null
                                                  ? Image.file(
                                                      File(selectedLicense!
                                                          .path),
                                                      height: 180.h,
                                                      fit: BoxFit.cover,
                                                      width: double.maxFinite,
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/camera.svg",
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const TextWidget(
                                                          "Upload file",
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ],
                                                    )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16.0.h,
                                ),
                                SubmitButton(
                                    enabled: signupState
                                            is! SignupStateLoading &&
                                        crudState is! UserCrudStateLoading &&
                                        _firstName.isNotEmpty &&
                                        _lastName.isNotEmpty &&
                                        selectedLicense != null &&
                                        _phoneNumber != null && _userName.isNotEmpty,
                                    text: "Submit",
                                    isLoading:
                                        signupState is SignupStateLoading ||
                                            crudState is UserCrudStateLoading,
                                    onSubmit: _signUp)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
