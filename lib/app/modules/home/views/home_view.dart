import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../crops/views/crops_list_view.dart';
import '../../finance/views/finance_list_view.dart';
import '../../livestock/views/livestock_list_view.dart';
import '../../tasks/views/tasks_list_view.dart';
import '../controllers/home_controller.dart';
import 'dashboard_tab.dart';

/// The main app shell hosting the bottom-navigation tabs. Each tab
/// keeps its state alive via [IndexedStack] and permanent bindings.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const _tabs = [
    DashboardTab(),
    CropsListView(),
    LivestockListView(),
    FinanceListView(),
    TasksListView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.tabIndex.value,
          children: _tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
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
              icon: Icon(Icons.checklist_outlined),
              activeIcon: Icon(Icons.checklist_rounded),
              label: 'Tasks',
            ),
          ],
        ),
      ),
    );
  }
}
