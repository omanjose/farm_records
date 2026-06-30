import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard/dashboard_view.dart';
import '../crops/crop_list_view.dart';
import '../livestock/livestock_list_view.dart';
import '../finance/finance_list_view.dart';
import '../reports/reports_view.dart';
import 'main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  static const _tabs = [
    DashboardView(),
    CropListView(),
    LivestockListView(),
    FinanceListView(),
    ReportsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: _tabs,
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grass_outlined),
              activeIcon: Icon(Icons.grass_rounded),
              label: 'Crops',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets_outlined),
              activeIcon: Icon(Icons.pets_rounded),
              label: 'Livestock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Finance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: 'Reports',
            ),
          ],
        ),
      ),
    );
  }
}
