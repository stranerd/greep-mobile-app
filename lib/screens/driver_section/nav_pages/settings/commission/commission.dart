import 'package:flutter/material.dart';

import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_styles.dart';

class CommissionHome extends StatelessWidget {
  const CommissionHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_ios, size: 16)),
          title: Text(
            "Commission",
            style: AppTextStyles.blackSizeBold14,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: AppColors.black)),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    labelColor: Colors.white,
                    labelStyle: AppTextStyles.whiteSize12,
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle: AppTextStyles.blackSize12,
                    tabs: const [
                      Tab(
                        text: 'Daily',
                      ),
                      Tab(
                        text: 'Monthly',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: TabBarView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Commission percentage",
                            style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromRGBO(221, 226, 224, 1),
                              width: 1.0,
                            ),
                          ),
                          child: Text("30%", style: AppTextStyles.blackSize16),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text("Today", style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromRGBO(221, 226, 224, 1),
                              width: 1.0,
                            ),
                          ),
                          child: Text("\$49", style: AppTextStyles.greenSize16),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text("Yesterday", style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromRGBO(221, 226, 224, 1),
                              width: 1.0,
                            ),
                          ),
                          child: Text("\$58", style: AppTextStyles.greenSize16),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text("Sat, 2 Apr 2022",
                            style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromRGBO(221, 226, 224, 1),
                              width: 1.0,
                            ),
                          ),
                          child: Text("\$64", style: AppTextStyles.greenSize16),
                        ),
                      ],
                    ),
                    Column(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
