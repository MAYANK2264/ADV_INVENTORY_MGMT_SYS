import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/items_provider.dart';
import '../models/item.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';

class ItemDetailsPanel extends StatelessWidget {
  final String itemId;
  final VoidCallback onClose;

  const ItemDetailsPanel({
    super.key,
    required this.itemId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(
      builder: (context, itemsProvider, child) {
        final item = itemsProvider.getItemById(itemId);
        
        if (item == null) {
          return _buildErrorState();
        }

        return _buildItemDetails(item);
      },
    );
  }

  Widget _buildItemDetails(Item item) {
    return GlassmorphismContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(item),
            const SizedBox(height: 16),
            _buildItemInfo(item),
            const SizedBox(height: 16),
            _buildLocationInfo(item),
            const SizedBox(height: 16),
            _buildDatesInfo(item),
            const Spacer(),
            _buildActionButtons(item),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Item item) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.getCategoryColor(item.category).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            AppColors.getCategoryIcon(item.category),
            color: AppColors.getCategoryColor(item.category),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.manufacturer,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: onClose,
        ),
      ],
    );
  }

  Widget _buildItemInfo(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Barcode', item.barcode),
        _buildInfoRow('Size', item.size),
        _buildInfoRow('Weight', '${item.weight}kg'),
        _buildInfoRow('Category', item.category),
        _buildInfoRow('Status', item.status),
      ],
    );
  }

  Widget _buildLocationInfo(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Block', item.locationBlock),
        _buildInfoRow('Rack', item.locationRack),
        _buildInfoRow('Slot', item.locationSlot.toString()),
        _buildInfoRow('Full Location', item.fullLocation),
      ],
    );
  }

  Widget _buildDatesInfo(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Arrival Date', _formatDate(item.arrivalDate)),
        _buildInfoRow('Expiry Date', _formatDate(item.expiryDate)),
        if (item.isExpired)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'EXPIRED',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else if (item.isExpiringSoon)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'EXPIRING SOON',
              style: TextStyle(
                color: AppColors.warning,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Item item) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to edit item screen
            },
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit Item'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Show delete confirmation
            },
            icon: const Icon(Icons.delete_rounded),
            label: const Text('Delete Item'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return GlassmorphismContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Item not found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The selected item could not be found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onClose,
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
