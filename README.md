# Warehouse Inventory Management System

A comprehensive Flutter-based inventory management application with Google Sheets backend integration.

## 🚀 Features

### 📊 Dashboard Overview
- Real-time warehouse statistics (Total Items, Capacity, Occupied Slots, System Uptime)
- Visual warehouse blocks overview with capacity bars
- Recent activity feed
- Beautiful glassmorphism design with gradient backgrounds

### 🗺️ Warehouse Map Visualization
- Interactive SVG-based warehouse map
- 5 blocks (A, B, C, D, E) with 3 racks each, 8 slots per rack
- Real-time occupancy status with color coding
- Click-to-select items on the map
- Search and filter functionality
- Item details panel

### 📦 Items Management
- Complete inventory management system
- Advanced filtering (Category, Block, Search, Sort)
- Category-based color coding (Electronics, Industrial, Automotive, Medical, Food & Beverage)
- Item cards with detailed information
- Edit/Delete functionality
- Add new items capability

### 🎨 Navigation & UI
- Responsive sidebar navigation
- Mobile-friendly design
- Smooth page transitions
- Professional glassmorphism theme
- Real-time data updates

### 🔧 Backend API
- RESTful API with Google Apps Script
- Google Sheets database with 25 demo items
- CRUD operations for items
- System statistics endpoint
- Activities tracking
- Rack occupancy simulation

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Google Apps Script (JavaScript)
- **Database**: Google Sheets
- **State Management**: Provider
- **UI Framework**: Material Design 3 with custom theming

## 📱 Screenshots

### Dashboard
- Real-time statistics display
- Warehouse blocks with capacity visualization
- Recent activities list
- Auto-refresh every 10 seconds

### Warehouse Map
- Interactive grid layout (5×3×8)
- Color-coded slot status
- Tap to select items
- Search and filter controls

### Items Management
- Grid/list view toggle
- Advanced filtering options
- Search functionality
- Sort by multiple criteria
- Add/Edit/Delete operations

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / VS Code
- Google account for Google Sheets integration

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MAYANK2264/ADV_INVENTORY_MGMT_SYS.git
   cd ADV_INVENTORY_MGMT_SYS
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Google Apps Script**
   - Create a new Google Apps Script project
   - Copy the code from `google_apps_script/Code.gs`
   - Create a Google Sheet and note its ID
   - Update the `SPREADSHEET_ID` in the script
   - Deploy as web app with execute permissions
   - Update the API URL in `lib/utils/constants.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📊 Google Sheets Setup

### Required Sheets
1. **Items Sheet**: Contains all inventory items
2. **Activities Sheet**: Tracks system activities
3. **System_Stats Sheet**: Stores system statistics

### Demo Data
The app includes 25 sample items across 5 categories:
- Electronics (5 items)
- Industrial (5 items)
- Automotive (5 items)
- Medical (5 items)
- Food & Beverage (5 items)

## 🔧 Configuration

### API Endpoints
- `GET /api/items` - Get all items
- `GET /api/items/{id}` - Get specific item
- `POST /api/items` - Create new item
- `PUT /api/items/{id}` - Update item
- `DELETE /api/items/{id}` - Delete item
- `GET /api/stats` - Get system statistics
- `GET /api/activities` - Get recent activities
- `GET /api/racks` - Get rack occupancy data
- `POST /api/search` - Search items

### Environment Variables
Update the following in `lib/utils/constants.dart`:
- `baseUrl`: Your Google Apps Script deployment URL
- `SPREADSHEET_ID`: Your Google Sheets ID

## 📱 Building APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### Split APKs (Recommended)
```bash
flutter build apk --split-per-abi
```

The APK files will be generated in `build/app/outputs/flutter-apk/`

## 🎨 Design System

### Color Scheme
- **Primary**: Cyan (#22D3EE)
- **Secondary**: Emerald (#10B981)
- **Background**: Dark gradient (Slate to Purple)
- **Surface**: White with 10% opacity
- **Text**: White with various opacities

### Category Colors
- **Electronics**: Blue (#3B82F6)
- **Industrial**: Orange (#F97316)
- **Automotive**: Red (#EF4444)
- **Medical**: Green (#10B981)
- **Food & Beverage**: Yellow (#EAB308)

## 📋 Features Checklist

- [x] Dashboard with real-time statistics
- [x] Interactive warehouse map
- [x] Items management (CRUD)
- [x] Search and filtering
- [x] Category-based organization
- [x] Glassmorphism UI design
- [x] Google Sheets integration
- [x] Offline data caching
- [x] Responsive design
- [x] Error handling
- [x] Loading states
- [x] Activity tracking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Mayank**
- GitHub: [@MAYANK2264](https://github.com/MAYANK2264)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Apps Script for backend services
- Material Design for UI guidelines
- Provider package for state management

## 📞 Support

If you have any questions or need help, please:
1. Check the [Issues](https://github.com/MAYANK2264/ADV_INVENTORY_MGMT_SYS/issues) page
2. Create a new issue if your problem isn't already reported
3. Contact the maintainer

---

**Made with ❤️ using Flutter**
