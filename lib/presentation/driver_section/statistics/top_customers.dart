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
  List<String> topCustomers = [];
  @override
  void initState() {
    print("initialized");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("All transactions ${widget.transactions.length}");

    if (widget.transactions.isNotEmpty){

      print("transactions not empty");

    var validCustomers = widget.transactions
        .where((element) => element.data.customerName != null);

    print("valid customers ${validCustomers}");
    if (validCustomers.isNotEmpty){
      print("Valid customers not empty");
    var customers = validCustomers
        .map((e) => e.data.customerName!.toLowerCase())
        .toList();

    print("customer names ${customers}");
    Map<String, int> counts = {};
    customers.forEach((element) {
      print("checking customers $element");
      print("counts $counts");
      if (counts[element] == null) {
        print("count is null");
        counts[element] = 1;
      } else {
        print("count is not null ${counts[element]}");

        counts[element] = counts[element]! + 1;
      }
    });

    print("customer counts ${counts}");

    var treeMap = SplayTreeMap<String, int>.from(
        counts, (a, b) => counts[b]?.compareTo(counts[a] ?? 0) ?? 1);
    print("Top customers ${treeMap}");
    treeMap.keys.forEach((element) {
      topCustomers.add(element);
    });
    }

    print("Top customers $topCustomers");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultSpacing),
      decoration: BoxDecoration(
        color: Color.fromRGBO(24, 93, 231, 0.1),
        borderRadius: BorderRadius.circular(kDefaultSpacing * 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/icons/star.svg"),
                  kHorizontalSpaceTiny,
                  SvgPicture.asset("assets/icons/star.svg"),
                  kHorizontalSpaceTiny,

                  SvgPicture.asset("assets/icons/star.svg"),
                ],
              ),
              kHorizontalSpaceRegular,
              TextWidget(
                "Top Customers",
                fontSize: 20,
                weight: FontWeight.bold,
              ),
            ],
          ),
          kVerticalSpaceRegular,
          topCustomers.isEmpty
              ? const TextWidget(
                  "No top customers",
                )
              : Wrap(
            spacing: 20.w,
            children: List.generate(topCustomers.length > 2 ? 3 : topCustomers.length, (index) => Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextWidget("${index+1}.",fontSize: 16,),
                kHorizontalSpaceTiny,
                TextWidget(topCustomers[index].capitalizeFirst!,fontSize: 16,),
              ],
            )),
          )
        ],
      ),
    );
  }
}
