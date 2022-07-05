import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_styles.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = TextEditingController();
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
          "Contact Us",
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                minLines: 4,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  hintText: "Send us a message",

                  hintStyle: AppTextStyles.blackSize14,
                  filled: true,
                  fillColor: kLightGrayColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              SubmitButton(text: "Send", onSubmit: (){}, backgroundColor: kGreenColor,),
            ],
          ),
        ),
      ),
    );
  }
}
