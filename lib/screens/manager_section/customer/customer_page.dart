import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/customer_card_view.dart';
import 'customer_details.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({Key? key}) : super(key: key);

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Customers',
          style: AppTextStyles.blackSizeBold16,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/images/profile_pix.png"),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "Wizzy",
                          style: AppTextStyles.blackSizeBold12,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    Image.asset("assets/images/profile_pix.png"),
                    const SizedBox(width: 8.0),
                    Image.asset("assets/images/profile_pix.png"),
                    const SizedBox(width: 8.0),
                    Image.asset("assets/images/profile_pix.png"),
                    const SizedBox(width: 8.0),
                    Image.asset("assets/images/profile_pix.png"),
                    const SizedBox(width: 8.0),
                    Image.asset("assets/images/profile_pix.png"),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Wizzy’s customers",
                  style: AppTextStyles.blackSizeBold16,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.blue,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text("To collect", style: AppTextStyles.blackSize12),
                      ],
                    ),
                    const SizedBox(width: 48.0),
                    Row(
                      children: [
                        Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.red,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text("To pay", style: AppTextStyles.blackSize12),
                      ],
                    ),
                    const SizedBox(width: 48.0),
                    Row(
                      children: [
                        Container(
                          width: 16.0,
                          height: 16.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text("Balanced", style: AppTextStyles.blackSize12),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerDetails(),
                      ),
                    );
                  },
                  child: CustomerCardView(
                      title: "Kemi",
                      subtitle: "8\$",
                      titleStyle: AppTextStyles.blackSize16,
                      subtitleStyle: AppTextStyles.redSize16),
                ),
                const SizedBox(height: 8.0),
                CustomerCardView(
                    title: "Dammy",
                    subtitle: "0\$",
                    titleStyle: AppTextStyles.blackSize16,
                    subtitleStyle: AppTextStyles.blackSize16),
                const SizedBox(height: 8.0),
                CustomerCardView(
                    title: "Klintin",
                    subtitle: "6\$",
                    titleStyle: AppTextStyles.blackSize16,
                    subtitleStyle: AppTextStyles.blueSize16),
                const SizedBox(height: 8.0),
                CustomerCardView(
                    title: "Jesse",
                    subtitle: "8\$",
                    titleStyle: AppTextStyles.blackSize16,
                    subtitleStyle: AppTextStyles.redSize16),
                const SizedBox(height: 8.0),
                CustomerCardView(
                    title: "Winona",
                    subtitle: "0\$",
                    titleStyle: AppTextStyles.blackSize16,
                    subtitleStyle: AppTextStyles.blackSize16),
                const SizedBox(height: 8.0),
                CustomerCardView(
                    title: "Alphonso",
                    subtitle: "6\$",
                    titleStyle: AppTextStyles.blackSize16,
                    subtitleStyle: AppTextStyles.blueSize16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
