# MOUAU Agro Farm 🌾

**Digital Record Keeping as a Transformative Tool for Future Farm Management**

A clean, offline-first Flutter mobile app for smallholder and institutional farm
record keeping — crops, livestock, income/expenses, and farm activities — built
with **GetX** (state management, dependency injection, routing) and **sqflite**
(local relational storage).

---

## ✨ Features

- **Dashboard** — at-a-glance summary of crop records, livestock headcount,
  income, expenses, net profit, and upcoming farm activities.
- **Crop Records** — log plantings with variety, farm size, planting/harvest
  dates, status tracking (Planned → Planted → Growing → Harvested/Failed),
  and notes. Filter by status.
- **Livestock Records** — track type, breed, quantity, acquisition date, and
  health status (Healthy, Under Observation, Sick, Deceased).
- **Farm Finance** — separate income and expense ledgers with categorized
  entries, running totals, and net profit calculation.
- **Farm Activities** — schedule and track tasks (planting, weeding,
  vaccination, feeding, maintenance, etc.) with completion checkboxes.
- **Reports** — visual breakdown of expenses by category and income by
  source via pie charts, plus overall financial summary.
- **100% offline** — all data is persisted locally on-device with `sqflite`;
  no internet connection or account required.

---

## 🏗️ Architecture

The project follows a **feature-first, GetX-idiomatic** structure:

```
lib/
├── main.dart                     # App entry point
└── app/
    ├── data/
    │   ├── models/                # Plain Dart data classes (toMap/fromMap)
    │   ├── providers/
    │   │   └── database_provider.dart   # sqflite schema + singleton DB handle
    │   └── repositories/          # CRUD + aggregation queries per table
    ├── modules/                   # One folder per feature (screen)
    │   ├── splash/
    │   ├── main_nav/              # Bottom-nav shell hosting the 5 tabs
    │   ├── dashboard/
    │   ├── crops/
    │   ├── livestock/
    │   ├── finance/               # Income + Expense tabs
    │   ├── activities/
    │   └── reports/
    │       each module has: *_controller.dart, *_binding.dart, *_view.dart
    ├── routes/
    │   ├── app_routes.dart        # Route name constants
    │   └── app_pages.dart         # GetPage definitions + bindings
    ├── theme/
    │   ├── app_colors.dart
    │   └── app_theme.dart
    ├── widgets/                   # Shared reusable widgets
    └── utils/                     # Constants, validators, date/currency formatting
```

**Why this structure?**
- **Separation of concerns**: models never know about SQL; repositories never
  know about widgets; controllers never touch the database directly.
- **Testability**: repositories and controllers can be unit tested without a
  widget tree.
- **Scalability**: adding a new record type (e.g. Equipment, Weather Log) is
  a matter of adding one model, one repository, and one module folder —
  nothing else needs to change.

---

## 🗄️ Database Schema (sqflite)

| Table        | Key Columns                                                                 |
|--------------|------------------------------------------------------------------------------|
| `crops`      | id, name, variety, farmSizeHectares, plantingDate, expectedHarvestDate, status, notes |
| `livestock`  | id, type, breed, quantity, dateAcquired, healthStatus, notes                 |
| `expenses`   | id, category, description, amount, date                                      |
| `income`     | id, source, description, amount, date                                        |
| `activities` | id, title, category, description, date, completed                           |

Indexes are created on the `date` columns of `expenses`, `income`, and
`activities` for fast chronological queries and reporting.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.19 (Dart ≥ 3.0)
- Android Studio / Xcode for platform emulators, or a physical device

### Setup

1. **Copy this `lib/` folder and `pubspec.yaml`** into a fresh Flutter
   project (recommended, since platform folders aren't included here):

   ```bash
   flutter create mouau_agro_farm
   cd mouau_agro_farm
   # replace the generated lib/ and pubspec.yaml with the ones from this package
   ```

   > This package ships only `lib/`, `pubspec.yaml`, and `analysis_options.yaml`
   > — the Dart/Flutter source — since `android/`, `ios/`, `web/` platform
   > scaffolding is machine-generated boilerplate that `flutter create` builds
   > for your specific Flutter/toolchain version.

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   flutter run
   ```

### Key Dependencies

| Package        | Purpose                                    |
|----------------|---------------------------------------------|
| `get`          | State management, DI, and routing           |
| `sqflite`      | Local relational database                   |
| `path` / `path_provider` | Resolving the on-device DB file path |
| `intl`         | Date and currency formatting                 |
| `fl_chart`     | Pie charts on the Reports screen             |
| `uuid`         | Generating unique record IDs                 |
| `google_fonts` | Typography (Inter)                           |

---

## 📱 Navigation Flow

```
Splash → Main (Bottom Nav Shell)
           ├── Dashboard  → Reports (pushed)
           ├── Crops      → Crop Form (add/edit)
           ├── Livestock  → Livestock Form (add/edit)
           ├── Finance    → Income Form / Expense Form
           └── Activities → Activity Form
```

---

## 🔮 Suggested Next Steps

- Add data export (CSV/PDF) for extension officers or bank loan applications.
- Add photo attachments to crop/livestock records using `image_picker`.
- Add multi-farm / multi-user support with a `farms` table and profile switch.
- Add push/local notifications for upcoming activities (`flutter_local_notifications`).
- Add cloud backup/sync (e.g. Firebase or Supabase) for multi-device access.

---

## 📄 License

Built as an educational/demonstration project for MOUAU (Michael Okpara
University of Agriculture, Umudike) — adapt freely for coursework, research,
or extension use.
