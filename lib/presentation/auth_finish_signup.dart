import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/SignupCubit.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:image_picker/image_picker.dart';

class AuthFinishSignup extends StatefulWidget {
  const AuthFinishSignup({Key? key}) : super(key: key);

  @override
  _AuthFinishSignupState createState() => _AuthFinishSignupState();
}

class _AuthFinishSignupState extends State<AuthFinishSignup> {
  late SignupCubit _signupCubit;


  XFile? selectedImage;

  @override
  void initState() {
    _signupCubit = GetIt.I<SignupCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set up an account",style: kBoldTextStyle2,),
        actions: [
          const CloseButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/images/empty_profile.png"),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      right: 15,
                      top: 0,
                      child: InkWell(
                        onTap: () async {
                          pickImage(
                              source: ImageSource.gallery,
                              context: context);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.camera,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void pickImage({required ImageSource source, context}) async {
    final picker = ImagePicker();
    var image = await picker.pickImage(source: source);
    setState(() => selectedImage = image);

  }

}
