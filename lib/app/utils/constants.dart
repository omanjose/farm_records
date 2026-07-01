/// App-wide constant values: strings, enums, dropdown options, and
/// database table/column names used across models and repositories.
library;

class AppStrings {
  static const String appName = 'MOUAU Agro Farm';
  static const String appTagline =
      'Digital Record Keeping for Future Farm Management';
}

/// Database table names
class DBTables {
  static const String farmProfile = 'farm_profile';
  static const String crops = 'crops';
  static const String livestock = 'livestock';
  static const String transactions = 'transactions';
  static const String tasks = 'tasks';
}

/// Crop lifecycle status
class CropStatus {
  static const String planted = 'Planted';
  static const String growing = 'Growing';
  static const String harvested = 'Harvested';
  static const String failed = 'Failed';

  static const List<String> all = [planted, growing, harvested, failed];
}

/// Livestock health status
class HealthStatus {
  static const String healthy = 'Healthy';
  static const String sick = 'Sick';
  static const String underObservation = 'Under Observation';
  static const String deceased = 'Deceased';

  static const List<String> all = [
    healthy,
    sick,
    underObservation,
    deceased,
  ];
}

/// Transaction types
class TransactionType {
  static const String income = 'Income';
  static const String expense = 'Expense';

  static const List<String> all = [income, expense];
}

class IncomeCategories {
  static const List<String> all = [
    'Crop Sales',
    'Livestock Sales',
    'Dairy / Eggs',
    'Government Grant',
    'Other Income',
  ];
}

class ExpenseCategories {
  static const List<String> all = [
    'Seeds & Seedlings',
    'Fertilizer',
    'Pesticides',
    'Feed',
    'Veterinary',
    'Labour',
    'Equipment',
    'Fuel',
    'Irrigation',
    'Rent',
    'Transport',
    'Other Expense',
  ];
}

/// Task priority levels
class TaskPriority {
  static const String low = 'Low';
  static const String medium = 'Medium';
  static const String high = 'High';

  static const List<String> all = [low, medium, high];
}

/// Task status
class TaskStatus {
  static const String pending = 'Pending';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';

  static const List<String> all = [pending, inProgress, completed];
}

class TaskCategories {
  static const List<String> all = [
    'Planting',
    'Irrigation',
    'Fertilizing',
    'Pest Control',
    'Harvesting',
    'Feeding',
    'Vaccination',
    'Maintenance',
    'Marketing',
    'Other',
  ];
}

class CropCategories {
  static const List<String> commonCrops = [
    'Maize',
    'Cassava',
    'Rice',
    'Yam',
    'Cocoyam',
    'Vegetables',
    'Plantain',
    'Groundnut',
    'Cowpea',
    'Oil Palm',
    'Other',
  ];
}

class LivestockCategories {
  static const List<String> commonAnimals = [
    'Poultry',
    'Goat',
    'Sheep',
    'Cattle',
    'Pig',
    'Rabbit',
    'Fish',
    'Other',
  ];
}
