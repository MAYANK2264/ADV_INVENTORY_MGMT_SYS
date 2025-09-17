import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/items_provider.dart';
import '../providers/stats_provider.dart';
import '../models/item.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class WarehouseMapWidget extends StatelessWidget {
  final Function(String itemId) onItemSelected;

  const WarehouseMapWidget({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ItemsProvider, StatsProvider>(
      builder: (context, itemsProvider, statsProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: AppConstants.blockNames.map((block) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildBlockSection(block, itemsProvider, statsProvider),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBlockSection(String block, ItemsProvider itemsProvider, StatsProvider statsProvider) {
    return GlassmorphismContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Block $block',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${statsProvider.getBlockOccupancyPercentage(block).toStringAsFixed(0)}% occupied',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...AppConstants.rackNames.map((rack) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildRackSection(block, rack, itemsProvider, statsProvider),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRackSection(String block, String rack, ItemsProvider itemsProvider, StatsProvider statsProvider) {
    final rackItems = itemsProvider.getItemsByLocation(block, rack, 0)
        .where((item) => item.locationBlock == block && item.locationRack == rack)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Rack $rack',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${statsProvider.getRackOccupancyPercentage(block, rack).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSlotsGrid(block, rack, rackItems, statsProvider),
      ],
    );
  }

  Widget _buildSlotsGrid(String block, String rack, List<Item> rackItems, StatsProvider statsProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: AppConstants.slotsPerRack,
      itemBuilder: (context, index) {
        final slotNumber = index + 1;
        final isOccupied = statsProvider.isSlotOccupied(block, rack, slotNumber);
        final item = rackItems.firstWhere(
          (item) => item.locationSlot == slotNumber,
          orElse: () => Item(
            id: '',
            name: '',
            manufacturer: '',
            barcode: '',
            size: '',
            weight: 0,
            arrivalDate: DateTime.now(),
            expiryDate: DateTime.now(),
            locationBlock: '',
            locationRack: '',
            locationSlot: 0,
            status: '',
            category: '',
          ),
        );

        return _buildSlotItem(block, rack, slotNumber, isOccupied, item);
      },
    );
  }

  Widget _buildSlotItem(String block, String rack, int slotNumber, bool isOccupied, Item? item) {
    return GestureDetector(
      onTap: () {
        if (isOccupied && item != null && item.id.isNotEmpty) {
          onItemSelected(item.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isOccupied 
              ? AppColors.getCategoryColor(item?.category ?? '').withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOccupied 
                ? AppColors.getCategoryColor(item?.category ?? '')
                : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isOccupied && item != null) ...[
              Icon(
                AppColors.getCategoryIcon(item.category),
                color: AppColors.getCategoryColor(item.category),
                size: 16,
              ),
              const SizedBox(height: 4),
              Text(
                'S$slotNumber',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.name.length > 8 
                    ? '${item.name.substring(0, 8)}...'
                    : item.name,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ] else ...[
              Icon(
                Icons.inventory_2_outlined,
                color: Colors.white.withOpacity(0.3),
                size: 16,
              ),
              const SizedBox(height: 4),
              Text(
                'S$slotNumber',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Empty',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 8,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
