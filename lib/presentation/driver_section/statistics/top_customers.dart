import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class TopCustomersView extends StatefulWidget {
  const TopCustomersView({Key? key, required this.transactions})
      : super(key: key);
  final List<Transaction> transactions;

  @override
  State<TopCustomersView> createState() => _TopCustomersViewState();
}

class _TopCustomersViewState extends State<TopCustomersView> {

  @override
  Widget build(BuildContext context) {
    List<String> topCustomers = [];

    if (widget.transactions.isNotEmpty) {
      var validCustomers = widget.transactions
          .where((element) => element.data.customerName != null);

      if (validCustomers.isNotEmpty) {
        var customers = validCustomers
            .map((e) => e.data.customerName!.toLowerCase())
            .toList();

        Map<String, int> counts = {};
        customers.forEach((element) {
          if (counts[element] == null) {
            counts[element] = 1;
          } else {
            counts[element] = counts[element]! + 1;
          }
        });

        var treeMap = SplayTreeMap<String, int>.from(
            counts, (a, b) => counts[b]?.compareTo(counts[a] ?? 0) ?? 1);
        treeMap.keys.forEach((element) {
          topCustomers.add(element);
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset("assets/icons/star-gold.svg",),
              SvgPicture.asset("assets/icons/star-gold.svg"),
              SvgPicture.asset("assets/icons/star-gold.svg"),
               TextWidget(
                "Top Customers",
                fontSize: 14.sp,
                weight: FontWeight.bold,
              ),
              SvgPicture.asset("assets/icons/star-gold.svg",),
              SvgPicture.asset("assets/icons/star-gold.svg"),
              SvgPicture.asset("assets/icons/star-gold.svg"),
            ],
          ),
          SizedBox(height: 12.h,),
          topCustomers.isEmpty
              ? const TextWidget(
                  "No top customers",
            fontSize: 16,
                )
              : Wrap(
                  spacing: 20.w,
                  children: List.generate(
                      topCustomers.length > 2 ? 3 : topCustomers.length,
                      (index) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWidget(
                                "${index + 1}.",
                                fontSize: 14.sp,
                              ),
                              kHorizontalSpaceTiny,
                              TextWidget(
                                topCustomers[index].capitalizeFirst!,
                                fontSize: 14.sp,
                              ),
                            ],
                          )),
                )
        ],
      ),
    );
  }
}
