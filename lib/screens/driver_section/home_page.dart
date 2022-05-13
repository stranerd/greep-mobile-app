import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_styles.dart';
import 'customer/customer_page.dart';
import 'records/record_expense.dart';
import 'records/record_trip.dart';
import 'records/view_records.dart';
import 'widgets/add_record_card.dart';
import 'widgets/customer_record_card.dart';
import 'widgets/record_card.dart';
import 'widgets/transaction_list_card.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Grip',
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
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    title: Text(
                      "Mon, Apr 11",
                      style: AppTextStyles.blackSize12,
                    ),
                    subtitle:
                        Text("Hi Wizzy", style: AppTextStyles.blackSizeBold16),
                    trailing: Image.asset("assets/images/account_pix.png"),
                  ),
                  const SizedBox(height: 17.0),
                  Text("Add a record", style: AppTextStyles.blackSizeBold12),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RecordTrip()),
                          );
                        },
                        child: AddRecord(
                          color: AppColors.black,
                          icon: "assets/icons/local_taxi.svg",
                          title: "Taxi",
                          textStyle: AppTextStyles.blackSize14,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RecordExpense()),
                          );
                        },
                        child: AddRecord(
                          color: AppColors.red,
                          icon: "assets/icons/handyman.svg",
                          title: "Expenses",
                          textStyle: AppTextStyles.redSize14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    title: Text("Today", style: AppTextStyles.blackSizeBold12),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewAllRecords()),
                        );
                      },
                      child: Text("view all", style: AppTextStyles.blackSize12),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RecordCard(
                        title: "\$164",
                        subtitle: "Income",
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.greenSize16,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      RecordCard(
                        title: "07",
                        subtitle: "Trips",
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.blackSize16,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      RecordCard(
                        title: "01",
                        subtitle: "Expenses",
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.blackSize16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    title:
                        Text("Yesterday", style: AppTextStyles.blackSizeBold12),
                    trailing:
                        Text("view all", style: AppTextStyles.blackSize12),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RecordCard(
                        title: "\$198",
                        subtitle: "Income",
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.greenSize16,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      RecordCard(
                        title: "11",
                        subtitle: "Trips",
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.blackSize16,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      RecordCard(
                        title: "02",
                        subtitle: "Expenses",
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.blackSize16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    title:
                        Text("Customers", style: AppTextStyles.blackSizeBold12),
                    trailing: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomerView()),
                          );
                        },
                        child:
                            Text("view all", style: AppTextStyles.blackSize12)),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomerRecordCard(
                        title: "\$8",
                        subtitle: "To pay",
                        subtextTitle: "Kemi",
                        subtextTitleStyle: AppTextStyles.blackSize12,
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.greenSize16,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      CustomerRecordCard(
                        title: "\$0",
                        subtitle: "Balanced",
                        subtextTitle: "Dammy",
                        subtextTitleStyle: AppTextStyles.blackSize12,
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.blackSize16,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      CustomerRecordCard(
                        title: "\$6",
                        subtitle: "To collect",
                        subtextTitle: "Klintin",
                        subtextTitleStyle: AppTextStyles.blackSize12,
                        subtitleStyle: AppTextStyles.blackSize12,
                        titleStyle: AppTextStyles.blueSize16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    title: Text("Transaction history",
                        style: AppTextStyles.blackSizeBold12),
                    trailing:
                        Text("view all", style: AppTextStyles.blackSize12),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Column(
                    children: [
                      TransactionListCard(
                        title: "Kemi",
                        subtitle: "Mar 19 . 10:54 AM",
                        trailing: "+20\$",
                        titleStyle: AppTextStyles.blackSize14,
                        subtitleStyle: AppTextStyles.blackSize12,
                        trailingStyle: AppTextStyles.greenSize14,
                      ),
                      const SizedBox(height: 16.0),
                      TransactionListCard(
                        title: "Fuel",
                        subtitle: "Mar 18 . 6:24 PM",
                        trailing: "-17\$",
                        titleStyle: AppTextStyles.blackSize14,
                        subtitleStyle: AppTextStyles.blackSize12,
                        trailingStyle: AppTextStyles.redSize14,
                      ),
                      const SizedBox(height: 16.0),
                      TransactionListCard(
                        title: "Kemi",
                        subtitle: "Mar 19 . 10:54 AM",
                        trailing: "+20\$",
                        titleStyle: AppTextStyles.blackSize14,
                        subtitleStyle: AppTextStyles.blackSize12,
                        trailingStyle: AppTextStyles.greenSize14,
                      ),
                      const SizedBox(height: 16.0),
                      TransactionListCard(
                        title: "Fuel",
                        subtitle: "Mar 18 . 6:24 PM",
                        trailing: "-17\$",
                        titleStyle: AppTextStyles.blackSize14,
                        subtitleStyle: AppTextStyles.blackSize12,
                        trailingStyle: AppTextStyles.redSize14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
