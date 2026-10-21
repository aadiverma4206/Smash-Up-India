import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/manager_dashboard_controller.dart';
import '../controllers/manager_games_controller.dart';
import '../../../data/models/slot_request_model.dart';
import '../../../data/models/game_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/utils/app_date_utils.dart';

class ManagerDashboardView extends StatefulWidget {
  const ManagerDashboardView({super.key});

  @override
  State<ManagerDashboardView> createState() => _ManagerDashboardViewState();
}

class _ManagerDashboardViewState extends State<ManagerDashboardView> {
  late final ManagerDashboardController controller;
  late final ScrollController _scrollController;
  final ValueNotifier<double> _headerProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    controller = Get.find<ManagerDashboardController>();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerProgress.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      final double pixels = notification.metrics.pixels;
      final double newProgress = (pixels / 80.0).clamp(0.0, 1.0);
      if (_headerProgress.value != newProgress) {
        _headerProgress.value = newProgress;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        if (isLandscape ||
            deviceType == DeviceType.desktop ||
            deviceType == DeviceType.tablet) {
          return _buildTabletDesktopLayout(context);
        }
        return _buildMobileLayout(context);
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, {bool showBottomNav = true}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color solidHeaderColor =
        isDark ? const Color(0xFF130722) : Theme.of(context).cardColor;
    final Color borderColor =
        isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value && controller.dashboard.value == null) {
          return _buildHomeSkeletonView(context);
        }
        final d = controller.dashboard.value;

        return Stack(
          children: [
            // 1. Scrollable Main Content Body
            NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: RefreshIndicator(
                onRefresh: controller.loadManagerData,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Integrated Header Background Image
                      _buildHeaderBackground(context),
                      const SizedBox(height: 16),

                      // Main Content Body
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Manager Main Action Pill Bar
                            _buildManagerPillBar(context),
                            const SizedBox(height: 18),

                            // Row 1 Circular Action Buttons (Court 1, Court 2, History, Players)
                            _buildPrimaryActionsGrid(context),
                            const SizedBox(height: 20),

                            // Assigned Turf Club Header Banner
                            _buildClubHeader(context, d),
                            const SizedBox(height: 16),

                            // Row 2 Circular Action Buttons (Club Games, Courts & Prices, Bookings, CCTV)
                            _buildSecondaryActionsGrid(context),
                            const SizedBox(height: 20),

                            // Manager Key Metrics Overview
                            _buildMetricsSection(context, d),
                            const SizedBox(height: 20),

                            // Pending Player Match Requests Section
                            _buildPendingPlayerGamesSection(context),
                            const SizedBox(height: 20),

                            // Pending Player Slot Requests Section
                            _buildPendingSlotRequestsSection(context),
                            const SizedBox(height: 20),

                            // Club Matches Section (TODAY, UPCOMING, ONGOING, CANCELLED)
                            _buildClubMatchesSection(context),
                            const SizedBox(height: 20),

                            // Quick Management Modules Grid
                            _buildQuickModulesGrid(context),
                            const SizedBox(height: 20),

                            // Manager Ad / Promo Banner
                            _buildReferAdBanner(context),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Seamless Morphing Header Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<double>(
                valueListenable: _headerProgress,
                builder: (context, progress, child) {
                  final Color currentBgColor = Color.lerp(
                    Colors.transparent,
                    solidHeaderColor,
                    progress,
                  )!;

                  final Color currentBorderColor = Color.lerp(
                    Colors.transparent,
                    borderColor,
                    progress,
                  )!;

                  return Container(
                    decoration: BoxDecoration(
                      color: currentBgColor,
                      border: Border(
                        bottom: BorderSide(
                          color: currentBorderColor,
                          width: 1,
                        ),
                      ),
                      boxShadow: progress > 0.05
                          ? [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.12 * progress),
                                blurRadius: 8 * progress,
                                offset: Offset(0, 2 * progress),
                              ),
                            ]
                          : null,
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // App Logo
                            _buildLogoWidget(context),

                            // Flexible Morphing Title ("Manager Control Center")
                            ClipRect(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress,
                                child: Opacity(
                                  opacity: progress,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: _buildTitleWidget(context),
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Action Icons (Refresh, Bookings, Logout Avatar)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildRefreshButton(context),
                                const SizedBox(width: 8),
                                _buildBookingsButton(context),
                                const SizedBox(width: 8),
                                _buildLogoutAvatar(context),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),

      // Bottom Navigation Bar (History added instead of Bookings)
      bottomNavigationBar: showBottomNav
          ? Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(
                      top: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFEEEEEE),
                          width: 1)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  currentIndex: controller.selectedNavIndex.value,
                  onTap: (index) {
                    controller.changeNavIndex(index);
                    if (index == 0) controller.loadManagerData();
                    if (index == 1) {
                      controller.selectCourt(0);
                      Get.toNamed('/manager/courts');
                    }
                    if (index == 2) {
                      controller.selectCourt(1);
                      Get.toNamed('/manager/courts');
                    }
                    if (index == 3) Get.toNamed('/manager/history');
                    if (index == 4) Get.toNamed('/manager/players');
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Theme.of(context).cardColor,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey.shade600,
                  selectedFontSize: 11,
                  unselectedFontSize: 11,
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
                  items: [
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          children: [
                            Container(
                              height: 3,
                              width: 20,
                              color: controller.selectedNavIndex.value == 0
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                            const SizedBox(height: 4),
                            const Icon(Icons.apps_rounded, size: 22),
                          ],
                        ),
                      ),
                      label: 'Control',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.stadium_rounded, size: 22),
                      label: 'Court 1',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.stadium_outlined, size: 22),
                      label: 'Court 2',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.history_rounded, size: 22),
                      label: 'History',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.people_alt_rounded, size: 22),
                      label: 'Players',
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildTabletDesktopLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Obx(
            () => NavigationRail(
              backgroundColor: Theme.of(context).cardColor,
              selectedIndex: controller.selectedNavIndex.value,
              onDestinationSelected: (index) {
                controller.changeNavIndex(index);
                if (index == 0) controller.loadManagerData();
                if (index == 1) {
                  controller.selectCourt(0);
                  Get.toNamed('/manager/courts');
                }
                if (index == 2) {
                  controller.selectCourt(1);
                  Get.toNamed('/manager/courts');
                }
                if (index == 3) Get.toNamed('/manager/history');
                if (index == 4) Get.toNamed('/manager/players');
              },
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: Color(0xFF00C853)),
              unselectedIconTheme: IconThemeData(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey.shade600),
              selectedLabelTextStyle: const TextStyle(
                  color: Color(0xFF00C853),
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
              unselectedLabelTextStyle: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey.shade600,
                  fontSize: 11),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.apps_rounded), label: Text('Control')),
                NavigationRailDestination(
                    icon: Icon(Icons.stadium_rounded), label: Text('Court 1')),
                NavigationRailDestination(
                    icon: Icon(Icons.stadium_outlined), label: Text('Court 2')),
                NavigationRailDestination(
                    icon: Icon(Icons.history_rounded), label: Text('History')),
                NavigationRailDestination(
                    icon: Icon(Icons.people_alt_rounded),
                    label: Text('Players')),
              ],
            ),
          ),
          VerticalDivider(
              thickness: 1,
              width: 1,
              color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE)),
          Expanded(
            child: _buildMobileLayout(context, showBottomNav: false),
          ),
        ],
      ),
    );
  }

  /// 3D Shimmer Skeleton View
  Widget _buildHomeSkeletonView(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(28)),
                child: const AppShimmer(
                  width: double.infinity,
                  height: 250,
                  borderRadius: 0,
                  enable3D: false,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const AppShimmer(
                        width: 38,
                        height: 38,
                        shape: BoxShape.circle,
                      ),
                      const SizedBox(width: 10),
                      const AppShimmer(width: 120, height: 18, borderRadius: 6),
                      const Spacer(),
                      const AppShimmer(
                        width: 38,
                        height: 38,
                        shape: BoxShape.circle,
                      ),
                      const SizedBox(width: 8),
                      const AppShimmer(
                        width: 38,
                        height: 38,
                        shape: BoxShape.circle,
                      ),
                      const SizedBox(width: 8),
                      const AppShimmer(
                        width: 38,
                        height: 38,
                        shape: BoxShape.circle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmer(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 30,
                ),
                const SizedBox(height: 20),
                Row(
                  children: List.generate(
                    4,
                    (index) => Expanded(
                      child: Column(
                        children: const [
                          AppShimmer(
                            width: 50,
                            height: 50,
                            shape: BoxShape.circle,
                          ),
                          SizedBox(height: 8),
                          AppShimmer(width: 52, height: 12, borderRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const AppShimmer(
                  width: double.infinity,
                  height: 100,
                  borderRadius: 18,
                ),
                const SizedBox(height: 18),
                Row(
                  children: List.generate(
                    4,
                    (index) => const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: AppShimmer(
                          width: double.infinity,
                          height: 65,
                          borderRadius: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const AppShimmer(
                  width: double.infinity,
                  height: 110,
                  borderRadius: 16,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Stadium Asset Background Image at Top of ScrollView
  Widget _buildHeaderBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String homeHeaderImagePath = isDark
        ? 'assets/images/Home_page/dark.png'
        : 'assets/images/Home_page/light.png';

    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.asset(
              homeHeaderImagePath,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => Container(
                color:
                    isDark ? const Color(0xFF07120E) : const Color(0xFF1E1035),
                child: const Icon(Icons.sports_soccer_rounded,
                    color: Colors.white54, size: 40),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.50),
                  Colors.black.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoWidget(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF7E57C2), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/App_Logo/smash_up_india.png',
          width: 38,
          height: 38,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF7E57C2),
            child: const Icon(Icons.stadium_rounded,
                color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      'Manager Control Center',
      style: TextStyle(
        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF2D1B69),
        fontSize: 17,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.3,
      ),
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return InkWell(
      onTap: controller.loadManagerData,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.refresh_rounded,
            color: Colors.black87,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsButton(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/manager/bookings'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.receipt_long_outlined,
            color: Colors.black87,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutAvatar(BuildContext context) {
    return InkWell(
      onTap: () => _confirmLogout(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.error, width: 1.5),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.logout_rounded,
            color: AppColors.error,
            size: 18,
          ),
        ),
      ),
    );
  }

  /// Dark Pill Manager Action Bar
  Widget _buildManagerPillBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF130722),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed('/manager/games'),
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.sports_soccer_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Manage Turf Club & Matches',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Row 1 Circular Action Buttons: Court 1, Court 2, Match History, All Players
  Widget _buildPrimaryActionsGrid(BuildContext context) {
    final row1 = [
      {
        'icon': Icons.stadium_rounded,
        'title': 'Court 1',
        'onTap': () {
          controller.selectCourt(0);
          Get.toNamed('/manager/courts');
        }
      },
      {
        'icon': Icons.stadium_outlined,
        'title': 'Court 2',
        'onTap': () {
          controller.selectCourt(1);
          Get.toNamed('/manager/courts');
        }
      },
      {
        'icon': Icons.history_rounded,
        'title': 'Match History',
        'onTap': () => Get.toNamed('/manager/history')
      },
      {
        'icon': Icons.people_alt_rounded,
        'title': 'All Players',
        'onTap': () => Get.toNamed('/manager/players')
      },
    ];

    return _buildActionRow(context, row1);
  }

  /// Row 2 Circular Action Buttons (Below Assigned Turf Club Banner): Club Games, Courts & Prices, Club Bookings, CCTV Cameras
  Widget _buildSecondaryActionsGrid(BuildContext context) {
    final row2 = [
      {
        'icon': Icons.sports_soccer_rounded,
        'title': 'Club Games',
        'onTap': () => Get.toNamed('/manager/games')
      },
      {
        'icon': Icons.stadium_rounded,
        'title': 'Courts & Prices',
        'onTap': () => Get.toNamed('/manager/courts')
      },
      {
        'icon': Icons.receipt_long_rounded,
        'title': 'Club Bookings',
        'onTap': () => Get.toNamed('/manager/bookings')
      },
      {
        'icon': Icons.videocam_rounded,
        'title': 'CCTV Cameras',
        'onTap': () => Get.toNamed('/manager/cctv')
      },
    ];

    return _buildActionRow(context, row2);
  }

  Widget _buildActionRow(
      BuildContext context, List<Map<String, dynamic>> actions) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: actions.map((item) {
        return Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item['onTap'] as VoidCallback,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkInputBg
                            : AppColors.lightBlueBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBlueBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.2 : 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          item['icon'] as IconData,
                          color: isDark
                              ? AppColors.primary
                              : const Color(0xFF130722),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        item['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF1F2937),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Assigned Club Banner Card
  Widget _buildClubHeader(BuildContext context, dynamic d) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  d?.club.name ?? 'Assigned Turf Club',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? AppColors.textPrimaryDark : Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Authorized Club',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '📍 ${d?.club.address ?? "VIP Road"}, ${d?.club.city ?? "Raipur"}',
            style: TextStyle(
                color:
                    isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Metrics Section Grid (Fixed vertical overflow & padding)
  Widget _buildMetricsSection(BuildContext context, dynamic d) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Club Metrics',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : Colors.black87),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSmallStatCard(
                context,
                'Revenue',
                '₹${d?.totalRevenue.toStringAsFixed(0) ?? "0"}',
                Icons.payments_outlined),
            _buildSmallStatCard(
                context,
                'Pending Req',
                '${controller.pendingRequests.length}',
                Icons.person_add_outlined),
            _buildSmallStatCard(context, 'Bookings', '${d?.totalBookings ?? 0}',
                Icons.stadium_outlined),
            _buildSmallStatCard(context, 'CCTV',
                '${d?.onlineCctvCount ?? 0} Online', Icons.videocam_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallStatCard(
      BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? AppColors.textPrimaryDark : Colors.black87)),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : Colors.grey.shade600),
                  maxLines: 1),
            ),
          ],
        ),
      ),
    );
  }

  /// Pending Player-Created Matches Section (Approve / Reject)
  Widget _buildPendingPlayerGamesSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.sports_soccer_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 6),
                Text('Pending Player-Created Matches',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : Colors.black87)),
              ],
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${controller.pendingPlayerGames.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.pendingPlayerGames.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFEEEEEE)),
              ),
              child: Center(
                child: Text('No pending player-created match requests',
                    style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade600,
                        fontSize: 12)),
              ),
            );
          }
          return Column(
            children: controller.pendingPlayerGames
                .map((game) => _buildPendingGameItem(context, game))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildPendingGameItem(BuildContext context, GameModel game) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  game.title,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? AppColors.textPrimaryDark : Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  game.format,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${game.courtName} • ${AppDateUtils.formatDate(game.matchDate)} (${AppDateUtils.formatTime(game.startTime)})',
            style: TextStyle(
                color:
                    isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                fontSize: 12),
          ),
          Text(
            'Roster: ${game.currentPlayers}/${game.maxPlayers} • Entry Fee: ₹${game.perPlayerFee.toStringAsFixed(0)}',
            style: TextStyle(
                color:
                    isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                fontSize: 11),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () => controller.approvePlayerGame(game.id),
                  icon: const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 16),
                  label: const Text('Approve Match',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () => _showRejectGameModal(context, game),
                  icon: const Icon(Icons.cancel_rounded,
                      color: Colors.redAccent, size: 16),
                  label: const Text('Reject Match',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRejectGameModal(BuildContext context, GameModel game) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reject Match: ${game.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter rejection reason provided to host:',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. Court slot unavailable',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.back();
              controller.rejectPlayerGame(
                  game.id, reasonController.text.trim());
            },
            child: const Text('Confirm Reject',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Pending Player Slot Requests Section
  Widget _buildPendingSlotRequestsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.pending_actions_rounded,
                    color: Colors.amber, size: 20),
                const SizedBox(width: 6),
                Text('Pending Player Slot Requests',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : Colors.black87)),
              ],
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${controller.pendingRequests.length}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.pendingRequests.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFEEEEEE)),
              ),
              child: Center(
                child: Text('No pending slot approval requests',
                    style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade600,
                        fontSize: 12)),
              ),
            );
          }
          return Column(
            children: controller.pendingRequests
                .map((req) => _buildRequestItem(context, req))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildRequestItem(BuildContext context, SlotRequestModel req) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: req.playerImage != null && req.playerImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: req.playerImage!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            _defaultAvatar(req.playerName),
                      )
                    : _defaultAvatar(req.playerName),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      req.playerName ?? 'Player',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${req.playerPosition ?? "ST"} • ELO ${req.elo} • ${req.preferredFoot ?? "RIGHT"} Foot',
                      style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : Colors.grey.shade600,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Req: ${req.position}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11),
                ),
              ),
            ],
          ),
          Divider(
              color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE),
              height: 18),
          Text(
            'Game: ${req.gameTitle ?? "Match"} (${req.format})',
            style: TextStyle(
                color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Roster: ${req.currentRosterCount ?? 0} / ${req.maxPlayers ?? 10} • Entry Fee: ₹${req.entryFee.toStringAsFixed(0)}',
            style: TextStyle(
                color:
                    isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                fontSize: 11),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (req.status == 'APPROVED') ...[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.green.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            color: Colors.green, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Approved Slot',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => _showRejectModal(context, req),
                    icon: const Icon(Icons.cancel_rounded,
                        color: Colors.redAccent, size: 16),
                    label: const Text('Revoke / Reject',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => controller.approveSlotRequest(req.id),
                    icon: const Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 16),
                    label: const Text('Approve',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => _showRejectModal(context, req),
                    icon: const Icon(Icons.cancel_rounded,
                        color: Colors.redAccent, size: 16),
                    label: const Text('Reject',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar(String? name) {
    return Container(
      width: 44,
      height: 44,
      color: AppColors.primary,
      child: Center(
        child: Text(
          name != null && name.isNotEmpty
              ? name.substring(0, 1).toUpperCase()
              : 'P',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  void _showRejectModal(BuildContext context, SlotRequestModel req) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('Reject Request: ${req.playerName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter rejection reason provided to player:',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. Requested position unavailable',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.back();
              controller.rejectSlotRequest(
                  req.id, reasonController.text.trim());
            },
            child: const Text('Confirm Reject',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Club Matches Section
  Widget _buildClubMatchesSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Club Matches Overview',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : Colors.black87)),
        const SizedBox(height: 8),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.matchTabs.map((tab) {
                final isSelected = controller.selectedMatchTab.value == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(tab,
                        style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Theme.of(context).cardColor,
                    onSelected: (selected) {
                      if (selected) controller.fetchClubMatches(tab);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.clubMatches.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFEEEEEE)),
              ),
              child: Center(
                child: Text('No matches in this category',
                    style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade600,
                        fontSize: 12)),
              ),
            );
          }
          return Column(
            children: controller.clubMatches
                .map((m) => _buildManagerMatchCard(context, m))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildManagerMatchCard(BuildContext context, GameModel game) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusUpper = game.status.toUpperCase();
    final isOngoing = statusUpper == 'ONGOING' || statusUpper == 'STARTED';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: ListTile(
        onTap: () {
          Get.find<ManagerGamesController>().selectedGame.value = game;
          Get.toNamed('/games/details');
        },
        title: Row(
          children: [
            Expanded(
              child: Text(game.title,
                  style: TextStyle(
                      color:
                          isDark ? AppColors.textPrimaryDark : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(game.courtName,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        subtitle: Text(
            '${AppDateUtils.formatDate(game.matchDate)} @ ${AppDateUtils.formatTime(game.startTime)} • ${game.format} • Roster: ${game.currentPlayers}/${game.maxPlayers}',
            style: TextStyle(
                color:
                    isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOngoing) ...[
              IconButton(
                icon: const Icon(Icons.play_circle_fill_rounded,
                    color: Colors.orange, size: 22),
                tooltip: 'Ongoing Match Control',
                onPressed: () {
                  Get.find<ManagerGamesController>().selectedGame.value = game;
                  Get.toNamed('/games/details');
                },
              ),
            ] else ...[
              IconButton(
                icon: const Icon(Icons.cancel_outlined,
                    color: Colors.redAccent, size: 20),
                tooltip: 'Cancel Match & Refund',
                onPressed: () => _confirmCancelMatch(context, game),
              ),
            ],
            const Icon(Icons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  void _confirmCancelMatch(BuildContext context, GameModel game) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancel Match: ${game.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Cancelling will trigger automatic refunds to all joined players.',
                style: TextStyle(color: Colors.redAccent, fontSize: 12)),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Reason for cancellation...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Get.back();
              Get.find<ManagerGamesController>().cancelMatchWithRefunds(
                  game.id, reasonController.text.trim());
            },
            child: const Text('Cancel & Issue Refunds',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Quick Modules Navigation Grid
  Widget _buildQuickModulesGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modules = [
      {
        'icon': Icons.sports_soccer_rounded,
        'title': 'Club Games',
        'route': '/manager/games',
        'color': AppColors.primary
      },
      {
        'icon': Icons.stadium_rounded,
        'title': 'Courts & Price',
        'route': '/manager/courts',
        'color': const Color(0xFF0288D1)
      },
      {
        'icon': Icons.receipt_long_rounded,
        'title': 'Bookings',
        'route': '/manager/bookings',
        'color': const Color(0xFF7B1FA2)
      },
      {
        'icon': Icons.videocam_rounded,
        'title': 'CCTV Cameras',
        'route': '/manager/cctv',
        'color': const Color(0xFFE65100)
      },
      {
        'icon': Icons.people_alt_rounded,
        'title': 'All Players',
        'route': '/manager/players',
        'color': const Color(0xFF2E7D32)
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Management Modules',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : Colors.black87)),
        const SizedBox(height: 10),
        Row(
          children: modules.map((item) {
            final Color color = item['color'] as Color;
            return Expanded(
              child: InkWell(
                onTap: () => Get.toNamed(item['route'] as String),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : color.withValues(alpha: 0.3)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          offset: Offset(0, 1)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(item['icon'] as IconData, color: color, size: 20),
                      const SizedBox(height: 6),
                      Text(
                        item['title'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Manager Ad / Promo Banner
  Widget _buildReferAdBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String referImagePath = isDark
        ? 'assets/images/Refer/dark.png'
        : 'assets/images/Refer/light.png';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          referImagePath,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Manager Log Out'),
        content: const Text(
            'Are you sure you want to log out of the Manager Control Center?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Get.back();
              await AuthService.to.logout();
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
