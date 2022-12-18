import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/auth/SignupCubit.dart';
import 'package:greep/application/auth/SignupState.dart';
import 'package:greep/application/auth/request/SignupRequest.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/splash/authentication_splash.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class AuthFinishSignup extends StatefulWidget {
  const AuthFinishSignup(
      {Key? key, required this.email, required this.password})
      : super(key: key);
  final String email;
  final String password;

  @override
  _AuthFinishSignupState createState() => _AuthFinishSignupState();
}

class _AuthFinishSignupState extends State<AuthFinishSignup>
    with InputValidator, ScaffoldMessengerService {
  late SignupCubit _signupCubit;
  String _firstName = "", _lastName = "", _phoneNumber = "", _userName = "";
  late TextEditingController _emailController;

  final formKey = GlobalKey<FormState>();

  XFile? selectedImage;

  @override
  void initState() {
    _signupCubit = GetIt.I<SignupCubit>();
    _emailController = TextEditingController()..text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listenWhen: (_, __) {
        return ModalRoute.of(context)?.isCurrent ?? false;
      },
      listener: (context, state) {
        if (state is SignupStateError) {
          error = state.errorMessage ?? "Sign up failed";
        }
        if (state is SignupStateSuccess) {
          // print("pushing to splash screen on signup success");
          g.Get.to(() => const AuthenticationSplashScreen(isNewUser: true,),transition: g.Transition.fadeIn);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text(
              "Set up an account",
              style: kBoldTextStyle2,
            ),
            actions: const [
              CloseButton(),
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
                      height: 100,
                      width: 100,
                      child: Stack(clipBehavior: Clip.none, children: [
                        Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kBlackColor.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: selectedImage == null
                              ? Image.asset(
                                  "assets/images/empty_profile.png",
                                  width: 90,
                                  height: 90,
                                )
                              : Image.file(
                                  File(selectedImage!.path),
                                  height: 100,
                                  width: 100,
                                ),
                        ),
                        Positioned(
                          right: -10,
                          bottom: 0,
                          child: InkWell(
                            onTap: () async {
                              pickImage(
                                  source: ImageSource.gallery,
                                  context: context,
                              );
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    color: kBlackColor, shape: BoxShape.circle),
                                child: Image.asset(
                                  "assets/icons/camera.png",
                                  width: 40,
                                  height: 40,
                                )),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Container(
                      padding: const EdgeInsets.all(kDefaultSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          LoginTextField(
                            validator: emptyFieldValidator,
                            onChanged: (String v) {
                              setState(() {
                                _userName = v;
                              });
                            },
                            withTitle: false,
                            withBorder: true,
                          ),
                          kVerticalSpaceRegular,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("First Name",
                                        style: AppTextStyles.blackSize14),
                                    kVerticalSpaceSmall,
                                    LoginTextField(
                                      validator: emptyFieldValidator,
                                      onChanged: (String value) {
                                        _firstName = value;
                                        setState(() {});
                                      },
                                      withTitle: false,
                                      withBorder: true,
                                    ),
                                  ],
                                ),
                              ),
                              kHorizontalSpaceRegular,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Last Name",
                                        style: AppTextStyles.blackSize14),
                                    kVerticalSpaceSmall,
                                    LoginTextField(
                                      validator: emptyFieldValidator,
                                      onChanged: (String value) {
                                        setState(() {
                                          _lastName = value;
                                        });
                                      },
                                      withTitle: false,
                                      withBorder: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Text("Phone Number",
                              style: AppTextStyles.blackSize14),
                          kVerticalSpaceSmall,
                          LoginTextField(
                            inputType: TextInputType.number,
                            validator: emptyFieldValidator,
                            onChanged: (String value) {
                              setState(() {
                                _phoneNumber = value;
                              });
                            },
                            withTitle: false,
                            withBorder: true,
                          ),
                          kHorizontalSpaceRegular,
                          const SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            "Email",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          LoginTextField(
                            enabled: false,
                            customController: _emailController,
                            withBorder: true,
                            validator: validateEmail,
                            onChanged: (String v) {
                              setState(() {});
                            },
                            withTitle: false,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          SubmitButton(
                            backgroundColor: kGreenColor,
                              enabled: state is! SignupStateLoading,
                              text: "Save",
                              isLoading: state is SignupStateLoading,
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
  }

  void pickImage({required ImageSource source, context}) async {
    final picker = ImagePicker();
    var image = await picker.pickImage(source: source,);
    setState(() => selectedImage = image);
  }

  void _signUp() async {

    if (formKey.currentState!.validate()) {
      if (selectedImage==null){
        error = "Please upload a profile photo";
        return;
      }
      // lookupMimeType(selectedImage!.path);
      var extenstion = selectedImage!.path.split(".").last;
      SignUpRequest request = SignUpRequest(
          email: widget.email.trim(),
          path: selectedImage!.path,
          password: widget.password,
          photo: dio.MultipartFile.fromFileSync(selectedImage!.path,contentType: MediaType('image',extenstion == "jpg"? "jpeg":"png")),
          firstName: _firstName,
          lastName: _lastName);
      _signupCubit.signUp(request);
    }
  }
}
