import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/items_provider.dart';
import '../widgets/item_card.dart';
import '../widgets/add_item_dialog.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool _isGridView = true;
  String _sortBy = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    await itemsProvider.loadItems();
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
              _buildSortAndViewOptions(),
              Expanded(child: _buildItemsList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          const Text(
            'Items Management',
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
              Provider.of<ItemsProvider>(context, listen: false).searchItems(value);
            },
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          // Category and Block Filters
          Row(
            children: [
              Expanded(child: _buildCategoryFilter()),
              const SizedBox(width: 12),
              Expanded(child: _buildBlockFilter()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<ItemsProvider>(
      builder: (context, itemsProvider, child) {
        return DropdownButtonFormField<String>(
          value: itemsProvider.selectedCategory.isEmpty ? null : itemsProvider.selectedCategory,
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
            itemsProvider.setCategoryFilter(value ?? '');
          },
        );
      },
    );
  }

  Widget _buildBlockFilter() {
    return Consumer<ItemsProvider>(
      builder: (context, itemsProvider, child) {
        return DropdownButtonFormField<String>(
          value: itemsProvider.selectedBlock.isEmpty ? null : itemsProvider.selectedBlock,
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
            itemsProvider.setBlockFilter(value ?? '');
          },
        );
      },
    );
  }

  Widget _buildSortAndViewOptions() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(
                labelText: 'Sort by',
                prefixIcon: Icon(Icons.sort_rounded, color: AppColors.primary),
              ),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Name')),
                DropdownMenuItem(value: 'manufacturer', child: Text('Manufacturer')),
                DropdownMenuItem(value: 'category', child: Text('Category')),
                DropdownMenuItem(value: 'arrival_date', child: Text('Arrival Date')),
                DropdownMenuItem(value: 'expiry_date', child: Text('Expiry Date')),
                DropdownMenuItem(value: 'weight', child: Text('Weight')),
                DropdownMenuItem(value: 'location', child: Text('Location')),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Provider.of<ItemsProvider>(context, listen: false)
                    .setSortOptions(_sortBy, _sortAscending);
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
              Provider.of<ItemsProvider>(context, listen: false)
                  .setSortOptions(_sortBy, _sortAscending);
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              _isGridView ? Icons.list_rounded : Icons.grid_view_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Consumer<ItemsProvider>(
      builder: (context, itemsProvider, child) {
        if (itemsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (itemsProvider.error.isNotEmpty) {
          return _buildErrorState(itemsProvider.error);
        }

        if (itemsProvider.filteredItems.isEmpty) {
          return _buildEmptyState();
        }

        if (_isGridView) {
          return _buildGridView(itemsProvider.filteredItems);
        } else {
          return _buildListView(itemsProvider.filteredItems);
        }
      },
    );
  }

  Widget _buildGridView(List items) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemCard(
          item: items[index],
          isGridView: true,
          onTap: () => _showItemDetails(items[index]),
          onEdit: () => _showEditItemDialog(items[index]),
          onDelete: () => _showDeleteConfirmation(items[index]),
        );
      },
    );
  }

  Widget _buildListView(List items) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ItemCard(
            item: items[index],
            isGridView: false,
            onTap: () => _showItemDetails(items[index]),
            onEdit: () => _showEditItemDialog(items[index]),
            onDelete: () => _showDeleteConfirmation(items[index]),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load items',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.grey,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No items found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAddItemDialog,
              child: const Text('Add First Item'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddItemDialog(),
    );
  }

  void _showEditItemDialog(item) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(item: item),
    );
  }

  void _showItemDetails(item) {
    // Navigate to item details screen
  }

  void _showDeleteConfirmation(item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Item',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${item.name}"?',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await Provider.of<ItemsProvider>(context, listen: false)
                  .deleteItem(item.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item deleted successfully'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
