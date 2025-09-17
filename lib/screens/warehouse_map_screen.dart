import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/items_provider.dart';
import '../providers/stats_provider.dart';
import '../widgets/warehouse_map_widget.dart';
import '../widgets/item_details_panel.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class WarehouseMapScreen extends StatefulWidget {
  const WarehouseMapScreen({super.key});

  @override
  State<WarehouseMapScreen> createState() => _WarehouseMapScreenState();
}

class _WarehouseMapScreenState extends State<WarehouseMapScreen> {
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedBlock = '';
  String? _selectedItemId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final statsProvider = Provider.of<StatsProvider>(context, listen: false);

    await Future.wait([
      itemsProvider.loadItems(),
      statsProvider.loadStats(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchAndFilters(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildWarehouseMap(),
                    ),
                    if (_selectedItemId != null)
                      Expanded(
                        flex: 1,
                        child: _buildItemDetailsPanel(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          const Text(
            'Warehouse Map',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              Provider.of<ItemsProvider>(context, listen: false).searchItems(value);
            },
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: AppColors.grey),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                        Provider.of<ItemsProvider>(context, listen: false).searchItems('');
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          // Filters
          Row(
            children: [
              Expanded(
                child: _buildCategoryFilter(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBlockFilter(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category_rounded, color: AppColors.primary),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: '',
          child: Text('All Categories'),
        ),
        ...AppConstants.categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Row(
              children: [
                Icon(
                  AppColors.getCategoryIcon(category),
                  color: AppColors.getCategoryColor(category),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(category),
              ],
            ),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCategory = value ?? '';
        });
        Provider.of<ItemsProvider>(context, listen: false).setCategoryFilter(_selectedCategory);
      },
    );
  }

  Widget _buildBlockFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedBlock.isEmpty ? null : _selectedBlock,
      decoration: const InputDecoration(
        labelText: 'Block',
        prefixIcon: Icon(Icons.warehouse_rounded, color: AppColors.primary),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: '',
          child: Text('All Blocks'),
        ),
        ...AppConstants.blockNames.map((block) {
          return DropdownMenuItem<String>(
            value: block,
            child: Text('Block $block'),
          );
        }),
      ],
      onChanged: (value) {
        setState(() {
          _selectedBlock = value ?? '';
        });
        Provider.of<ItemsProvider>(context, listen: false).setBlockFilter(_selectedBlock);
      },
    );
  }

  Widget _buildWarehouseMap() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Consumer2<ItemsProvider, StatsProvider>(
        builder: (context, itemsProvider, statsProvider, child) {
          if (itemsProvider.isLoading || statsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          return WarehouseMapWidget(
            onItemSelected: (itemId) {
              setState(() {
                _selectedItemId = itemId;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildItemDetailsPanel() {
    if (_selectedItemId == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(
        right: AppConstants.defaultPadding,
        bottom: AppConstants.defaultPadding,
      ),
      child: ItemDetailsPanel(
        itemId: _selectedItemId!,
        onClose: () {
          setState(() {
            _selectedItemId = null;
          });
        },
      ),
    );
  }
}
