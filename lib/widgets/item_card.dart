import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool isGridView;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.isGridView,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return _buildGridCard();
    } else {
      return _buildListCard();
    }
  }

  Widget _buildGridCard() {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphismContainer(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              _buildItemInfo(),
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard() {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphismContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildCategoryIcon(),
              const SizedBox(width: 12),
              Expanded(child: _buildItemInfo()),
              _buildStatusIndicator(),
              const SizedBox(width: 12),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildCategoryIcon(),
        const Spacer(),
        _buildStatusIndicator(),
      ],
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.getCategoryColor(item.category).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        AppColors.getCategoryIcon(item.category),
        color: AppColors.getCategoryColor(item.category),
        size: isGridView ? 20 : 24,
      ),
    );
  }

  Widget _buildItemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: isGridView ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.manufacturer,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (isGridView) ...[
          const SizedBox(height: 4),
          Text(
            item.category,
            style: TextStyle(
              color: AppColors.getCategoryColor(item.category),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.fullLocation,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator() {
    if (item.isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'EXPIRED',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (item.isExpiringSoon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'EXPIRING',
          style: TextStyle(
            color: AppColors.warning,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'OK',
          style: TextStyle(
            color: AppColors.success,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${item.weight}kg • ${item.size}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 18),
          onPressed: onEdit,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete_rounded, color: AppColors.error, size: 18),
          onPressed: onDelete,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
