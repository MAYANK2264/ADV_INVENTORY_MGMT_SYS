# Google Apps Script Setup Guide

## Quick Setup Steps

### 1. Create Google Apps Script Project
1. Go to [script.google.com](https://script.google.com)
2. Click "New Project"
3. Delete default code
4. Copy code from `google_apps_script/Code.gs`
5. Save project as "Warehouse Inventory API"

### 2. Create Google Sheets
1. Go to [sheets.google.com](https://sheets.google.com)
2. Create new spreadsheet
3. Name it "Warehouse Inventory Database"
4. Copy the Spreadsheet ID from URL
5. Update `SPREADSHEET_ID` in the script

### 3. Deploy Script
1. Click "Deploy" → "New deployment"
2. Choose "Web app"
3. Set Execute as: "Me"
4. Set Access: "Anyone"
5. Click "Deploy"
6. Copy the Web app URL

### 4. Initialize Data
1. Run `initializeDemoData()` function
2. Check that sheets are created
3. Verify demo data is populated

### 5. Update Flutter App
1. Open `lib/utils/constants.dart`
2. Replace `baseUrl` with your deployment URL
3. Save and test the app

## Your Deployment URL
```
https://script.google.com/macros/s/AKfycbyUvCgMa3qL2yEjf7OH6YGN2LvKgfsuh4qaBSGtePjPSYYoIIoYMqmiiPCKZ-dh5J7G/exec
```

## API Endpoints Available
- `GET ?path=items` - Get all items
- `GET ?path=items&id=123` - Get specific item
- `POST ?path=items` - Create new item
- `PUT ?path=items&id=123` - Update item
- `DELETE ?path=items&id=123` - Delete item
- `GET ?path=stats` - Get system statistics
- `GET ?path=activities` - Get activities
- `GET ?path=racks` - Get rack occupancy
- `POST ?path=search` - Search items

## Testing Your API
You can test your API endpoints using:
- Postman
- curl commands
- Browser (for GET requests)

Example GET request:
```
https://your-script-url/exec?path=items
```

Example POST request:
```
https://your-script-url/exec?path=items
Content-Type: application/json

{
  "Name": "Test Item",
  "Manufacturer": "Test Corp",
  "Barcode": "TEST123",
  "Size": "M",
  "Weight": 1.5,
  "Arrival_Date": "2025-01-15",
  "Expiry_Date": "2026-01-15",
  "Location_Block": "A",
  "Location_Rack": "R1",
  "Location_Slot": 1,
  "Status": "stored",
  "Category": "Electronics"
}
```
