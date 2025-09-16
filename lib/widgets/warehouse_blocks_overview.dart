import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class WarehouseBlocksOverview extends StatelessWidget {
  const WarehouseBlocksOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsProvider>(
      builder: (context, statsProvider, child) {
        if (statsProvider.isLoading) {
          return _buildLoadingState();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppConstants.blockNames.map((block) {
              final occupancyPercentage = statsProvider.getBlockOccupancyPercentage(block);
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildBlockCard(block, occupancyPercentage),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBlockCard(String block, double occupancyPercentage) {
    return GlassmorphismContainer(
      width: 120,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Block $block',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.warehouse_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${occupancyPercentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Occupied',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 6),
            _buildCapacityBar(occupancyPercentage),
            const SizedBox(height: 6),
            Text(
              '${(AppConstants.racksPerBlock * AppConstants.slotsPerRack * occupancyPercentage / 100).round()}/${AppConstants.racksPerBlock * AppConstants.slotsPerRack}',
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.6),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityBar(double percentage) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage / 100,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getCapacityColors(percentage),
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  List<Color> _getCapacityColors(double percentage) {
    if (percentage < 30) {
      return [AppColors.success, AppColors.success.withOpacity(0.8)];
    } else if (percentage < 70) {
      return [AppColors.warning, AppColors.warning.withOpacity(0.8)];
    } else {
      return [AppColors.error, AppColors.error.withOpacity(0.8)];
    }
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AppConstants.blockNames.map((block) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildShimmerCard(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
