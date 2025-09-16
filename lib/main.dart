import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/items_provider.dart';
import 'providers/activities_provider.dart';
import 'providers/stats_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/warehouse_map_screen.dart';
import 'screens/items_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const WarehouseInventoryApp());
}

class WarehouseInventoryApp extends StatelessWidget {
  const WarehouseInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemsProvider()),
        ChangeNotifierProvider(create: (_) => ActivitiesProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
      ],
      child: MaterialApp(
        title: 'Warehouse Inventory',
        theme: AppTheme.darkTheme,
        home: const MainNavigationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const WarehouseMapScreen(),
    const ItemsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.purple.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded),
                label: 'Warehouse Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_rounded),
                label: 'Items',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
