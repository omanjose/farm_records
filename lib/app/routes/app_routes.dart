/// Route name constants for GetX navigation. Kept separate from
/// [AppPages] so views can reference route names without importing
/// the full page-binding list.
abstract class Routes {
  static const splash = '/splash';
  static const home = '/home';

  static const cropList = '/crops';
  static const cropForm = '/crops/form';
  static const cropDetail = '/crops/detail';

  static const livestockList = '/livestock';
  static const livestockForm = '/livestock/form';
  static const livestockDetail = '/livestock/detail';

  static const financeList = '/finance';
  static const financeForm = '/finance/form';

  static const taskList = '/tasks';
  static const taskForm = '/tasks/form';

  static const reports = '/reports';

  static const settings = '/settings';
  static const farmProfileForm = '/settings/farm-profile';
}
