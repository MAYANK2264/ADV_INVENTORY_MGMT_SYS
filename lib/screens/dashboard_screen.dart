import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/items_provider.dart';
import '../providers/activities_provider.dart';
import '../providers/stats_provider.dart';
import '../widgets/stats_card.dart';
import '../widgets/warehouse_blocks_overview.dart';
import '../widgets/activity_feed.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    final statsProvider = Provider.of<StatsProvider>(context, listen: false);

    await Future.wait([
      itemsProvider.loadItems(),
      activitiesProvider.loadActivities(),
      statsProvider.loadStats(),
    ]);
  }

  Future<void> _refreshData() async {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    final statsProvider = Provider.of<StatsProvider>(context, listen: false);

    await Future.wait([
      itemsProvider.loadItems(forceRefresh: true),
      activitiesProvider.loadActivities(forceRefresh: true),
      statsProvider.loadStats(forceRefresh: true),
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
          child: RefreshIndicator(
            onRefresh: _refreshData,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                _buildStatsSection(),
                _buildWarehouseOverview(),
                _buildActivityFeed(),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100), // Bottom padding
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Warehouse Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x1A22D3EE),
                Color(0x0D10B981),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: _refreshData,
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Statistics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<StatsProvider>(
              builder: (context, statsProvider, child) {
                if (statsProvider.isLoading) {
                  return _buildStatsShimmer();
                }
                
                if (statsProvider.error.isNotEmpty) {
                  return _buildErrorCard(statsProvider.error);
                }
                
                final stats = statsProvider.stats;
                if (stats == null) {
                  return _buildNoDataCard();
                }
                
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: 'Total Items',
                            value: stats.totalItems.toString(),
                            icon: Icons.inventory_2_rounded,
                            color: AppColors.primary,
                            subtitle: 'In warehouse',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatsCard(
                            title: 'Occupied Slots',
                            value: stats.occupiedSlots.toString(),
                            icon: Icons.storage_rounded,
                            color: AppColors.secondary,
                            subtitle: '${stats.occupancyPercentage.toStringAsFixed(1)}% full',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: 'Available Slots',
                            value: stats.availableSlots.toString(),
                            icon: Icons.space_dashboard_rounded,
                            color: AppColors.success,
                            subtitle: 'Ready for use',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatsCard(
                            title: 'System Uptime',
                            value: stats.uptime,
                            icon: Icons.schedule_rounded,
                            color: AppColors.info,
                            subtitle: 'Last updated ${stats.lastUpdatedFormatted}',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsShimmer() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildShimmerCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerCard()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildShimmerCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.2),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      color: AppColors.surface.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load statistics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Card(
      color: AppColors.surface.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.inbox_rounded,
              color: AppColors.grey,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'No data available',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Pull down to refresh',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarehouseOverview() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warehouse Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            WarehouseBlocksOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityFeed() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full activity screen
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ActivityFeed(),
          ],
        ),
      ),
    );
  }
}
