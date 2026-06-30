abstract class AppConstants {
  // DB
  static const dbName = 'dfrms.db';
  static const dbVersion = 1;

  // Tables
  static const tblUsers = 'users';
  static const tblFarms = 'farms';
  static const tblCrops = 'crop_records';
  static const tblLivestock = 'livestock_records';
  static const tblExpenses = 'expenses';

  // Prefs keys
  static const prefUserId = 'user_id';
  static const prefUsername = 'username';
  static const prefFullName = 'full_name';
  static const prefRole = 'role';
  static const prefFarmId = 'farm_id';

  // Roles
  static const roleAdmin = 'admin';
  static const roleManager = 'manager';
  static const roleSupervisor = 'supervisor';

  // Crop types
  static const cropTypes = [
    'Maize', 'Cassava', 'Yam', 'Rice', 'Soybean',
    'Cowpea', 'Groundnut', 'Sorghum', 'Millet', 'Tomato',
    'Pepper', 'Okra', 'Plantain', 'Banana', 'Other',
  ];

  // Seasons
  static const seasons = ['Wet Season', 'Dry Season', 'Year-round'];

  // Crop status
  static const cropStatuses = ['Planted', 'Growing', 'Harvested', 'Failed'];

  // Livestock types
  static const animalTypes = [
    'Cattle', 'Goat', 'Sheep', 'Pig', 'Chicken',
    'Duck', 'Turkey', 'Fish', 'Rabbit', 'Other',
  ];

  // Health statuses
  static const healthStatuses = ['Healthy', 'Sick', 'Under Treatment', 'Quarantined', 'Deceased'];

  // Expense categories
  static const expenseCategories = [
    'Labour', 'Fertilizer', 'Seeds', 'Pesticides',
    'Equipment', 'Fuel', 'Feed', 'Veterinary',
    'Transport', 'Irrigation', 'Land Preparation', 'Other',
  ];

  // Transaction types
  static const transactionTypes = ['Expense', 'Income'];

  // Income sources
  static const incomeCategories = [
    'Crop Sales', 'Livestock Sales', 'Dairy', 'Eggs',
    'Government Grant', 'Loan', 'Investment', 'Other Income',
  ];

  // Default admin credentials
  static const defaultAdminUsername = 'admin';
  // SHA-256 of 'admin123'
  static const defaultAdminPasswordHash =
      '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9';
}
