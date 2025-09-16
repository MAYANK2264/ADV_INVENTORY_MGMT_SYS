    // Google Apps Script for Warehouse Inventory Management
    // Replace the spreadsheet ID with your actual Google Sheets ID

    const SPREADSHEET_ID = 'YOUR_SPREADSHEET_ID_HERE'; // Replace with your actual spreadsheet ID
    const ITEMS_SHEET = 'Items';
    const ACTIVITIES_SHEET = 'Activities';
    const SYSTEM_STATS_SHEET = 'System_Stats';

// Main entry point for GET requests
function doGet(e) {
  // Handle case where e is undefined
  if (!e) {
    e = { parameter: {} };
  }
  
  const path = e.parameter.path || '';
  const action = e.parameter.action || '';
  
  try {
    switch (path) {
      case 'items':
        return handleItemsRequest(e, action);
      case 'stats':
        return handleStatsRequest();
      case 'activities':
        return handleActivitiesRequest();
      case 'racks':
        return handleRacksRequest();
      case 'search':
        return handleSearchRequest(e);
      default:
        return createResponse({ error: 'Invalid endpoint. Available endpoints: items, stats, activities, racks, search' }, 404);
    }
  } catch (error) {
    return createResponse({ error: error.toString() }, 500);
  }
}

// Main entry point for POST requests
function doPost(e) {
  // Handle case where e is undefined
  if (!e) {
    e = { parameter: {} };
  }
  
  const path = e.parameter.path || '';
  const action = e.parameter.action || '';
  
  try {
    switch (path) {
      case 'items':
        return handleItemsRequest(e, action);
      case 'search':
        return handleSearchRequest(e);
      default:
        return createResponse({ error: 'Invalid endpoint. Available endpoints: items, search' }, 404);
    }
  } catch (error) {
    return createResponse({ error: error.toString() }, 500);
  }
}

    // Handle items-related requests
    function handleItemsRequest(e, action) {
    const method = e.parameter.method || 'GET';
    const id = e.parameter.id;
    
    switch (method) {
        case 'GET':
        if (id) {
            return getItemById(id);
        } else {
            return getAllItems();
        }
        case 'POST':
        return createItem(e);
        case 'PUT':
        return updateItem(id, e);
        case 'DELETE':
        return deleteItem(id);
        default:
        return createResponse({ error: 'Invalid method' }, 405);
    }
    }

    // Get all items
    function getAllItems() {
    try {
        const sheet = getSheet(ITEMS_SHEET);
        const data = sheet.getDataRange().getValues();
        const headers = data[0];
        const items = [];
        
        for (let i = 1; i < data.length; i++) {
        const row = data[i];
        const item = {};
        headers.forEach((header, index) => {
            item[header] = row[index];
        });
        items.push(item);
        }
        
        return createResponse(items);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

    // Get item by ID
    function getItemById(id) {
    try {
        const sheet = getSheet(ITEMS_SHEET);
        const data = sheet.getDataRange().getValues();
        const headers = data[0];
        
        for (let i = 1; i < data.length; i++) {
        const row = data[i];
        if (row[0] == id) { // Assuming ID is in first column
            const item = {};
            headers.forEach((header, index) => {
            item[header] = row[index];
            });
            return createResponse(item);
        }
        }
        
        return createResponse({ error: 'Item not found' }, 404);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

    // Create new item
    function createItem(e) {
    try {
        const data = JSON.parse(e.postData.contents);
        const sheet = getSheet(ITEMS_SHEET);
        
        // Generate new ID
        const newId = Date.now().toString();
        data.ID = newId;
        
        // Add to sheet
        const headers = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
        const row = headers.map(header => data[header] || '');
        sheet.appendRow(row);
        
        // Log activity
        logActivity(`New item "${data.Name}" added to ${data.Location_Block}-${data.Location_Rack}-${data.Location_Slot}`, 'arrival');
        
        return createResponse(data, 201);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

    // Update item
    function updateItem(id, e) {
    try {
        const data = JSON.parse(e.postData.contents);
        const sheet = getSheet(ITEMS_SHEET);
        const dataRange = sheet.getDataRange().getValues();
        const headers = dataRange[0];
        
        for (let i = 1; i < dataRange.length; i++) {
        if (dataRange[i][0] == id) {
            const row = headers.map(header => data[header] || '');
            sheet.getRange(i + 1, 1, 1, row.length).setValues([row]);
            
            // Log activity
            logActivity(`Item "${data.Name}" updated`, 'inventory');
            
            return createResponse(data);
        }
        }
        
        return createResponse({ error: 'Item not found' }, 404);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

    // Delete item
    function deleteItem(id) {
    try {
        const sheet = getSheet(ITEMS_SHEET);
        const dataRange = sheet.getDataRange().getValues();
        
        for (let i = 1; i < dataRange.length; i++) {
        if (dataRange[i][0] == id) {
            const itemName = dataRange[i][1]; // Assuming name is in second column
            sheet.deleteRow(i + 1);
            
            // Log activity
            logActivity(`Item "${itemName}" deleted`, 'inventory');
            
            return createResponse({ message: 'Item deleted successfully' });
        }
        }
        
        return createResponse({ error: 'Item not found' }, 404);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

    // Get system statistics
    function handleStatsRequest() {
    try {
        const sheet = getSheet(SYSTEM_STATS_SHEET);
        const data = sheet.getDataRange().getValues();
        const headers = data[0];
        const stats = {};
        
        if (data.length > 1) {
        const row = data[1];
        headers.forEach((header, index) => {
            stats[header] = row[index];
        });
        } else {
        // Return default stats if no data
        stats.Capacity = 120;
        stats.Items_Processed = 0;
        stats.Uptime = '99.9%';
        stats.Total_Items = 0;
        stats.Available_Slots = 120;
        stats.Occupied_Slots = 0;
        stats.Last_Updated = new Date().toISOString();
        }
        
        return createResponse(stats);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

    // Get activities
    function handleActivitiesRequest() {
    try {
        const sheet = getSheet(ACTIVITIES_SHEET);
        const data = sheet.getDataRange().getValues();
        const headers = data[0];
        const activities = [];
        
        for (let i = 1; i < data.length; i++) {
        const row = data[i];
        const activity = {};
        headers.forEach((header, index) => {
            activity[header] = row[index];
        });
        activities.push(activity);
        }
        
        return createResponse(activities);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

    // Get rack occupancy data
    function handleRacksRequest() {
    try {
        const items = getAllItems().getContent();
        const occupancy = {};
        
        // Initialize blocks
        ['A', 'B', 'C', 'D', 'E'].forEach(block => {
        occupancy[block] = {};
        ['R1', 'R2', 'R3'].forEach(rack => {
            occupancy[block][rack] = {
            slots: {}
            };
            for (let slot = 1; slot <= 8; slot++) {
            occupancy[block][rack].slots[slot] = false;
            }
        });
        });
        
        // Mark occupied slots
        if (Array.isArray(items)) {
        items.forEach(item => {
            if (item.Location_Block && item.Location_Rack && item.Location_Slot) {
            occupancy[item.Location_Block][item.Location_Rack].slots[item.Location_Slot] = true;
            }
        });
        }
        
        return createResponse(occupancy);
    } catch (error) {
        return createResponse({ error: error.toString() }, 500);
    }
    }

// Handle search requests
function handleSearchRequest(e) {
  try {
    let query = '';
    
    // Try to get query from different sources
    if (e.parameter && e.parameter.query) {
      query = e.parameter.query;
    } else if (e.postData && e.postData.contents) {
      const postData = JSON.parse(e.postData.contents);
      query = postData.query || '';
    }
    
    if (!query) {
      return createResponse({ error: 'Query parameter is required' }, 400);
    }
    
    const sheet = getSheet(ITEMS_SHEET);
    const data = sheet.getDataRange().getValues();
    const headers = data[0];
    const results = [];
    
    for (let i = 1; i < data.length; i++) {
      const row = data[i];
      const item = {};
      headers.forEach((header, index) => {
        item[header] = row[index];
      });
      
      // Search in name, manufacturer, barcode, and category
      const searchText = `${item.Name} ${item.Manufacturer} ${item.Barcode} ${item.Category}`.toLowerCase();
      if (searchText.includes(query.toLowerCase())) {
        results.push(item);
      }
    }
    
    return createResponse(results);
  } catch (error) {
    return createResponse({ error: error.toString() }, 500);
  }
}

    // Helper function to get sheet
    function getSheet(sheetName) {
    const spreadsheet = SpreadsheetApp.openById(SPREADSHEET_ID);
    let sheet = spreadsheet.getSheetByName(sheetName);
    
    if (!sheet) {
        sheet = spreadsheet.insertSheet(sheetName);
        initializeSheet(sheet, sheetName);
    }
    
    return sheet;
    }

    // Initialize sheet with headers
    function initializeSheet(sheet, sheetName) {
    switch (sheetName) {
        case ITEMS_SHEET:
        sheet.getRange(1, 1, 1, 13).setValues([[
            'ID', 'Name', 'Manufacturer', 'Barcode', 'Size', 'Weight', 
            'Arrival_Date', 'Expiry_Date', 'Location_Block', 'Location_Rack', 
            'Location_Slot', 'Status', 'Category'
        ]]);
        break;
        case ACTIVITIES_SHEET:
        sheet.getRange(1, 1, 1, 5).setValues([[
            'ID', 'Text', 'Time', 'Type', 'Timestamp'
        ]]);
        break;
        case SYSTEM_STATS_SHEET:
        sheet.getRange(1, 1, 1, 7).setValues([[
            'Capacity', 'Items_Processed', 'Uptime', 'Total_Items', 
            'Available_Slots', 'Occupied_Slots', 'Last_Updated'
        ]]);
        break;
    }
    }

    // Log activity
    function logActivity(text, type) {
    try {
        const sheet = getSheet(ACTIVITIES_SHEET);
        const id = Date.now().toString();
        const time = new Date().toLocaleString();
        const timestamp = new Date().toISOString();
        
        sheet.appendRow([id, text, time, type, timestamp]);
    } catch (error) {
        console.error('Failed to log activity:', error);
    }
    }

    // Create response object
    function createResponse(data, statusCode = 200) {
    return ContentService
        .createTextOutput(JSON.stringify(data))
        .setMimeType(ContentService.MimeType.JSON);
    }

// Test function to verify setup
function testSetup() {
  try {
    // Test if we can access the spreadsheet
    const spreadsheet = SpreadsheetApp.openById(SPREADSHEET_ID);
    const sheetNames = spreadsheet.getSheets().map(sheet => sheet.getName());
    
    return {
      success: true,
      message: 'Setup test successful',
      spreadsheetId: SPREADSHEET_ID,
      availableSheets: sheetNames,
      timestamp: new Date().toISOString()
    };
  } catch (error) {
    return {
      success: false,
      error: error.toString(),
      message: 'Setup test failed. Please check your SPREADSHEET_ID',
      timestamp: new Date().toISOString()
    };
  }
}

// Initialize demo data
function initializeDemoData() {
    const demoItems = [
        // Electronics
        ['1', 'iPhone 15 Pro Max', 'Apple', 'APPLE001234567', 'L', 0.24, '2025-01-15', '2027-01-15', 'A', 'R1', 1, 'stored', 'Electronics'],
        ['2', 'Samsung Galaxy S24', 'Samsung', 'SAMS001234567', 'L', 0.23, '2025-01-16', '2027-01-16', 'A', 'R1', 2, 'stored', 'Electronics'],
        ['3', 'MacBook Pro 16"', 'Apple', 'APPLE001234568', 'XL', 2.1, '2025-01-17', '2027-01-17', 'A', 'R2', 1, 'stored', 'Electronics'],
        ['4', 'Dell XPS 15', 'Dell', 'DELL001234567', 'XL', 1.8, '2025-01-18', '2027-01-18', 'A', 'R2', 2, 'stored', 'Electronics'],
        ['5', 'AirPods Pro', 'Apple', 'APPLE001234569', 'S', 0.06, '2025-01-19', '2027-01-19', 'A', 'R3', 1, 'stored', 'Electronics'],
        
        // Industrial
        ['6', 'Hydraulic Pump Unit', 'Caterpillar', 'CAT001234567', 'XL', 45.2, '2025-01-20', '2026-12-31', 'B', 'R1', 1, 'stored', 'Industrial'],
        ['7', 'Steel Bearing Set', 'SKF', 'SKF001234567', 'M', 2.3, '2025-01-21', '2026-12-31', 'B', 'R1', 2, 'stored', 'Industrial'],
        ['8', 'Industrial Sensor', 'Honeywell', 'HONE001234567', 'S', 0.8, '2025-01-22', '2026-12-31', 'B', 'R2', 1, 'stored', 'Industrial'],
        ['9', 'Control Valve', 'Emerson', 'EMER001234567', 'L', 5.7, '2025-01-23', '2026-12-31', 'B', 'R2', 2, 'stored', 'Industrial'],
        ['10', 'Motor Assembly', 'Siemens', 'SIEM001234567', 'XL', 28.4, '2025-01-24', '2026-12-31', 'B', 'R3', 1, 'stored', 'Industrial'],
        
        // Automotive
        ['11', 'Brake Pad Set', 'Brembo', 'BREM001234567', 'M', 1.2, '2025-01-25', '2026-12-31', 'C', 'R1', 1, 'stored', 'Automotive'],
        ['12', 'Oil Filter', 'Mann-Filter', 'MANN001234567', 'S', 0.3, '2025-01-26', '2026-12-31', 'C', 'R1', 2, 'stored', 'Automotive'],
        ['13', 'Spark Plug Set', 'NGK', 'NGK001234567', 'S', 0.2, '2025-01-27', '2026-12-31', 'C', 'R2', 1, 'stored', 'Automotive'],
        ['14', 'Timing Belt', 'Gates', 'GATE001234567', 'M', 0.9, '2025-01-28', '2026-12-31', 'C', 'R2', 2, 'stored', 'Automotive'],
        ['15', 'Air Filter', 'K&N', 'KN001234567', 'M', 0.4, '2025-01-29', '2026-12-31', 'C', 'R3', 1, 'stored', 'Automotive'],
        
        // Medical
        ['16', 'Surgical Gloves (Box)', 'Medline', 'MEDL001234567', 'M', 0.5, '2025-01-30', '2026-06-30', 'D', 'R1', 1, 'stored', 'Medical'],
        ['17', 'Bandage Roll', 'Johnson & Johnson', 'JNJ001234567', 'S', 0.1, '2025-01-31', '2026-12-31', 'D', 'R1', 2, 'stored', 'Medical'],
        ['18', 'Thermometer Digital', 'Omron', 'OMRO001234567', 'S', 0.15, '2025-02-01', '2027-02-01', 'D', 'R2', 1, 'stored', 'Medical'],
        ['19', 'Syringe 10ml', 'BD', 'BD001234567', 'S', 0.05, '2025-02-02', '2026-12-31', 'D', 'R2', 2, 'stored', 'Medical'],
        ['20', 'Face Mask (Box)', '3M', '3M001234567', 'M', 0.8, '2025-02-03', '2026-12-31', 'D', 'R3', 1, 'stored', 'Medical'],
        
        // Food & Beverage
        ['21', 'Energy Drink (Case)', 'Red Bull', 'REDB001234567', 'L', 8.5, '2025-02-04', '2025-08-04', 'E', 'R1', 1, 'stored', 'Food & Beverage'],
        ['22', 'Protein Bar (Box)', 'Quest', 'QUES001234567', 'M', 2.1, '2025-02-05', '2025-11-05', 'E', 'R1', 2, 'stored', 'Food & Beverage'],
        ['23', 'Coffee Beans (Bag)', 'Starbucks', 'STAR001234567', 'L', 2.3, '2025-02-06', '2025-12-06', 'E', 'R2', 1, 'stored', 'Food & Beverage'],
        ['24', 'Water Bottle (Case)', 'Fiji', 'FIJI001234567', 'L', 12.0, '2025-02-07', '2026-02-07', 'E', 'R2', 2, 'stored', 'Food & Beverage'],
        ['25', 'Snack Mix (Box)', 'Trail Mix Co', 'TRAI001234567', 'M', 1.8, '2025-02-08', '2025-10-08', 'E', 'R3', 1, 'stored', 'Food & Beverage']
    ];
    
    const demoActivities = [
        ['1', 'iPhone 15 Pro Max moved to Block A, Rack R1, Slot 1', '2 minutes ago', 'move', new Date(Date.now() - 2 * 60 * 1000).toISOString()],
        ['2', 'Hydraulic Pump Unit processed for dispatch', '5 minutes ago', 'dispatch', new Date(Date.now() - 5 * 60 * 1000).toISOString()],
        ['3', 'New electronics shipment arrived - 15 items', '12 minutes ago', 'arrival', new Date(Date.now() - 12 * 60 * 1000).toISOString()],
        ['4', 'System maintenance completed - All systems operational', '1 hour ago', 'system', new Date(Date.now() - 60 * 60 * 1000).toISOString()],
        ['5', 'Medical supplies inventory updated', '2 hours ago', 'inventory', new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString()]
    ];
    
    const demoStats = [
        ['Capacity', 'Items_Processed', 'Uptime', 'Total_Items', 'Available_Slots', 'Occupied_Slots', 'Last_Updated'],
        [120, 25, '99.9%', 25, 95, 25, new Date().toISOString()]
    ];
    
    // Clear existing data and add demo data
    const itemsSheet = getSheet(ITEMS_SHEET);
    itemsSheet.clear();
    itemsSheet.getRange(1, 1, 1, 13).setValues([[
        'ID', 'Name', 'Manufacturer', 'Barcode', 'Size', 'Weight', 
        'Arrival_Date', 'Expiry_Date', 'Location_Block', 'Location_Rack', 
        'Location_Slot', 'Status', 'Category'
    ]]);
    itemsSheet.getRange(2, 1, demoItems.length, 13).setValues(demoItems);
    
    const activitiesSheet = getSheet(ACTIVITIES_SHEET);
    activitiesSheet.clear();
    activitiesSheet.getRange(1, 1, 1, 5).setValues([[
        'ID', 'Text', 'Time', 'Type', 'Timestamp'
    ]]);
    activitiesSheet.getRange(2, 1, demoActivities.length, 5).setValues(demoActivities);
    
    const statsSheet = getSheet(SYSTEM_STATS_SHEET);
    statsSheet.clear();
    statsSheet.getRange(1, 1, 2, 7).setValues(demoStats);
    
    console.log('Demo data initialized successfully');
    }
