import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:greep/application/user/utils/get_current_user.dart';

import 'package:get_it/get_it.dart';
import 'package:greep/application/user/request/EditUserRequest.dart';
import 'package:greep/application/user/user_crud_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with InputValidator, ScaffoldMessengerService {
  late UserCrudCubit _userCrudCubit;
  String _firstName = "", _lastName = "";
  late TextEditingController _firstNameController, _lastNameController;
  late User user;

  final formKey = GlobalKey<FormState>();
  bool hasPicked = false;

  XFile? selectedImage;

  @override
  void initState() {
    _userCrudCubit = GetIt.I<UserCrudCubit>();
    user = currentUser();
    _firstNameController = TextEditingController()..text = user.firstName;
    _lastNameController = TextEditingController()..text = user.lastName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userCrudCubit,
      child: Builder(builder: (context) {
        return BlocConsumer<UserCrudCubit, UserCrudState>(
            listener: (context, state) {
          if (state is UserCrudStateFailure) {
            error = state.errorMessage;
          }
          if (state is UserCrudStateSuccess) {
            success = "Profile edited successfully";
            Future.delayed(const Duration(seconds: 2), () => Get.back());
          }
        }, builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                ),
              ),
              title: Text(
                "Edit Account",
                style: AppTextStyles.blackSizeBold14,
              ),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultSpacing * 0.5),
                    width: Get.width,
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
                          child: !hasPicked
                              ? CachedNetworkImage(
                                  imageUrl: user.photoUrl,
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
                                  context: context);
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
                                      customController: _firstNameController,
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
                                      customController: _lastNameController,
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
                          SubmitButton(
                            backgroundColor: kGreenColor,
                              enabled: (_firstNameController.text.isNotEmpty &&
                                  _lastNameController.text.isNotEmpty),
                              text: "Save",
                              isLoading: state is UserCrudStateLoading,
                              onSubmit: _editUser)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  void pickImage({required ImageSource source, context}) async {
    final picker = ImagePicker();
    var image = await picker.pickImage(
      source: source,
    );
    if (image != null) {
      setState(() {
        hasPicked = true;
      });
    }
    setState(() => selectedImage = image);
  }

  void _editUser() async {
    if (formKey.currentState!.validate()) {
      var extenstion =
          selectedImage == null ? null : selectedImage!.path.split(".").last;
      EditUserRequest request = EditUserRequest(
          photo: selectedImage == null
              ? null
              : dio.MultipartFile.fromFileSync(selectedImage!.path,
                  contentType:
                      MediaType('image', extenstion == "jpg" ? "jpeg" : "png")),
          firstName: _firstNameController.text,
          lastName: _lastNameController.text);
      _userCrudCubit.editUser(request);
    }
  }
}
