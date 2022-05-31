import 'package:flutter/material.dart';

import '../../../../../utils/constants/app_styles.dart';
import 'privacy_policy.dart';
import 'terms_and_conditions.dart';

class AboutHome extends StatelessWidget {
  const AboutHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_back_ios, size: 16)),
        title: Text(
          "About",
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color.fromRGBO(221, 226, 224, 1),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("Privacy policy", style: AppTextStyles.blackSize16),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color.fromRGBO(221, 226, 224, 1),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("Terms & Conditions",
                          style: AppTextStyles.blackSize16),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
