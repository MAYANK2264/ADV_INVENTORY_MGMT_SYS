# 🚀 Warehouse Inventory Management System - Setup Instructions

## 📋 Prerequisites

Before setting up the application, ensure you have the following:

- **Flutter SDK** (3.0.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Google Account** for Google Sheets integration
- **Git** for version control

## 🔧 Step-by-Step Setup

### 1. Google Apps Script Setup

#### 1.1 Create Google Apps Script Project
1. Go to [Google Apps Script](https://script.google.com/)
2. Click "New Project"
3. Delete the default `myFunction` code
4. Copy and paste the entire code from `google_apps_script/Code.gs`
5. Save the project with a meaningful name (e.g., "Warehouse Inventory API")

#### 1.2 Create Google Sheets Database
1. Go to [Google Sheets](https://sheets.google.com/)
2. Create a new spreadsheet
3. Name it "Warehouse Inventory Database"
4. Copy the **Spreadsheet ID** from the URL (the long string between `/d/` and `/edit`)
5. Update the `SPREADSHEET_ID` variable in your Google Apps Script code

#### 1.3 Deploy Google Apps Script
1. In your Google Apps Script project, click "Deploy" → "New deployment"
2. Choose "Web app" as the type
3. Set the following:
   - **Execute as**: Me
   - **Who has access**: Anyone
4. Click "Deploy"
5. Copy the **Web app URL** (this is your API endpoint)

#### 1.4 Initialize Demo Data
1. In your Google Apps Script project, run the `initializeDemoData()` function
2. This will create the required sheets and populate them with sample data

### 2. Flutter App Setup

#### 2.1 Clone and Setup
```bash
# Clone the repository
git clone https://github.com/MAYANK2264/ADV_INVENTORY_MGMT_SYS.git
cd ADV_INVENTORY_MGMT_SYS

# Install dependencies
flutter pub get
```

#### 2.2 Configure API Endpoint
1. Open `lib/utils/constants.dart`
2. Update the `baseUrl` with your Google Apps Script deployment URL:
   ```dart
   static const String baseUrl = 'YOUR_GOOGLE_APPS_SCRIPT_URL_HERE';
   ```

#### 2.3 Test the Setup
```bash
# Run the app
flutter run
```

### 3. Google Sheets Structure

The application expects the following sheets in your Google Spreadsheet:

#### 3.1 Items Sheet
| Column | Description |
|--------|-------------|
| ID | Unique identifier |
| Name | Item name |
| Manufacturer | Manufacturer name |
| Barcode | Barcode/QR code |
| Size | Item size (XS, S, M, L, XL, XXL) |
| Weight | Weight in kg |
| Arrival_Date | Date when item arrived |
| Expiry_Date | Expiration date |
| Location_Block | Warehouse block (A, B, C, D, E) |
| Location_Rack | Rack number (R1, R2, R3) |
| Location_Slot | Slot number (1-8) |
| Status | Item status |
| Category | Item category |

#### 3.2 Activities Sheet
| Column | Description |
|--------|-------------|
| ID | Unique identifier |
| Text | Activity description |
| Time | Human-readable time |
| Type | Activity type |
| Timestamp | ISO timestamp |

#### 3.3 System_Stats Sheet
| Column | Description |
|--------|-------------|
| Capacity | Total warehouse capacity |
| Items_Processed | Number of items processed |
| Uptime | System uptime percentage |
| Total_Items | Total number of items |
| Available_Slots | Number of available slots |
| Occupied_Slots | Number of occupied slots |
| Last_Updated | Last update timestamp |

## 🏗️ Building APK

### Debug APK (for testing)
```bash
flutter build apk --debug
```

### Release APK (for production)
```bash
flutter build apk --release
```

### Split APKs (recommended for smaller file size)
```bash
flutter build apk --split-per-abi
```

The APK files will be generated in `build/app/outputs/flutter-apk/`

## 🔍 Troubleshooting

### Common Issues

#### 1. "Script function not found: doGet" Error
- **Cause**: The Google Apps Script deployment is not properly configured
- **Solution**: 
  1. Ensure you've copied the complete code from `Code.gs`
  2. Redeploy the script as a web app
  3. Make sure the deployment has "Anyone" access

#### 2. "Failed to load items" Error
- **Cause**: Incorrect API URL or spreadsheet permissions
- **Solution**:
  1. Verify the API URL in `constants.dart`
  2. Check that the Google Sheet is accessible
  3. Ensure the spreadsheet ID is correct

#### 3. Empty Data in App
- **Cause**: Demo data not initialized
- **Solution**:
  1. Run the `initializeDemoData()` function in Google Apps Script
  2. Check that the sheets are created properly

#### 4. Build Errors
- **Cause**: Missing dependencies or Flutter version issues
- **Solution**:
  ```bash
  flutter clean
  flutter pub get
  flutter doctor
  ```

## 📱 Testing the App

### 1. Dashboard Test
- Verify statistics are displayed
- Check that warehouse blocks show occupancy
- Ensure activities are loading

### 2. Warehouse Map Test
- Test slot selection functionality
- Verify color coding for different categories
- Check search and filter features

### 3. Items Management Test
- Test adding new items
- Verify editing functionality
- Check delete operations
- Test search and filtering

## 🚀 Deployment Checklist

- [ ] Google Apps Script deployed and accessible
- [ ] Google Sheets created with proper structure
- [ ] Demo data initialized
- [ ] API URL updated in Flutter app
- [ ] App builds successfully
- [ ] All features tested
- [ ] APK generated
- [ ] Repository pushed to GitHub

## 📞 Support

If you encounter any issues:

1. Check the [GitHub Issues](https://github.com/MAYANK2264/ADV_INVENTORY_MGMT_SYS/issues)
2. Verify all setup steps are completed
3. Check Google Apps Script logs for errors
4. Ensure proper permissions are set

## 🎯 Next Steps

After successful setup:

1. **Customize the app** with your specific requirements
2. **Add more features** as needed
3. **Deploy to app stores** if desired
4. **Set up CI/CD** for automated builds
5. **Add user authentication** for multi-user access

---

**Happy coding! 🚀**
