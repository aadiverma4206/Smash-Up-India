import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/player_controller.dart';
import '../controllers/notifications_controller.dart';
import '../../../data/models/game_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/utils/app_date_utils.dart';

class PlayerHomeView extends StatefulWidget {
  const PlayerHomeView({super.key});

  static const String headerBgImageUrl =
      'https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&w=1200&q=80';

  @override
  State<PlayerHomeView> createState() => _PlayerHomeViewState();
}

class _PlayerHomeViewState extends State<PlayerHomeView> {
  late final PlayerController controller;
  late final ScrollController _scrollController;
  final ValueNotifier<double> _headerProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    controller = Get.find<PlayerController>();
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
      // Interpolate progress smoothly over 0 -> 80 pixels of scroll
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
        if (controller.isLoading.value) {
          return _buildHomeSkeletonView(context);
        }
        return Stack(
          children: [
            // 1. Scrollable Main Content Body
            NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: RefreshIndicator(
                onRefresh: controller.loadPlayerData,
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
                            // Join Game Pill Bar
                            _buildJoinGamePillBar(context),
                            const SizedBox(height: 18),

                            // 4 Circular Football Quick Action Buttons Grid
                            _buildCircularActionsGrid(context),
                            const SizedBox(height: 20),

                            // Match Highlight Cards (Active / Upcoming)
                            _buildMatchHighlightsSection(context),
                            const SizedBox(height: 16),

                            // Football Career Stats Overview
                            _buildStatsSection(context),
                            const SizedBox(height: 20),

                            // Quick Modules Navigation Grid
                            _buildQuickModulesGrid(context),
                            const SizedBox(height: 20),

                            // Refer & Earn Ad Banner
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

                            // Flexible Morphing Title ("All Stars Arena")
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

                            // Action Icons (Notification Bell, Wallet, Profile Avatar)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildNotificationBell(context),
                                const SizedBox(width: 8),
                                _buildWalletButton(context),
                                const SizedBox(width: 8),
                                _buildProfileAvatar(context),
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

      // Bottom Navigation Bar (Hidden in Landscape)
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
                    if (index == 0) controller.loadPlayerData();
                    if (index == 1) Get.toNamed('/games/find');
                    if (index == 2) Get.toNamed('/player/my-matches');
                    if (index == 3) Get.toNamed('/wallet');
                    if (index == 4) Get.toNamed('/player/match-history');
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
                      label: 'Arena',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.show_chart_rounded, size: 22),
                      label: 'Find Games',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          const Icon(Icons.grid_view_rounded, size: 22),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: 'Explore',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.shield_outlined, size: 22),
                      label: 'Wallet',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.history_rounded, size: 22),
                      label: 'History',
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
                if (index == 0) controller.loadPlayerData();
                if (index == 1) Get.toNamed('/games/find');
                if (index == 2) Get.toNamed('/player/my-matches');
                if (index == 3) Get.toNamed('/wallet');
                if (index == 4) Get.toNamed('/player/match-history');
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
                    icon: Icon(Icons.apps_rounded), label: Text('Arena')),
                NavigationRailDestination(
                    icon: Icon(Icons.show_chart_rounded),
                    label: Text('Find Games')),
                NavigationRailDestination(
                    icon: Icon(Icons.grid_view_rounded),
                    label: Text('Explore')),
                NavigationRailDestination(
                    icon: Icon(Icons.shield_outlined), label: Text('Wallet')),
                NavigationRailDestination(
                    icon: Icon(Icons.history_rounded), label: Text('History')),
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

  /// Modern 3D Shimmer Skeleton View
  Widget _buildHomeSkeletonView(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Integrated Header Banner Skeleton
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

          // 2. Main Body Content Skeletons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Join Game Pill Bar Skeleton
                const AppShimmer(
                  width: double.infinity,
                  height: 52,
                  borderRadius: 30,
                ),
                const SizedBox(height: 20),

                // 4 Circular Buttons Grid Skeleton
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

                // Match Highlights Card Skeleton
                const AppShimmer(
                  width: double.infinity,
                  height: 120,
                  borderRadius: 14,
                ),
                const SizedBox(height: 18),

                // Career Statistics Grid Skeleton
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

                // Quick Navigation Grid Skeleton
                Row(
                  children: List.generate(
                    4,
                    (index) => const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: AppShimmer(
                          width: double.infinity,
                          height: 60,
                          borderRadius: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // Refer Ad Banner Skeleton
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
        // Top Asset Image Background
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

        // Dark Gradient Overlay for optimal contrast
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
            child: const Icon(Icons.sports_soccer_rounded,
                color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      'Smash Up India',
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

  Widget _buildNotificationBell(BuildContext context) {
    return Obx(() {
      final notifController = Get.isRegistered<NotificationsController>()
          ? Get.find<NotificationsController>()
          : Get.put(NotificationsController());
      final unreadCount = notifController.unreadCount;

      return InkWell(
        onTap: () => Get.toNamed('/notifications'),
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildWalletButton(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/wallet'),
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
            Icons.account_balance_wallet_outlined,
            color: Colors.black87,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Obx(() {
      final p = controller.profile.value;
      return InkWell(
        onTap: () => Get.toNamed('/player/profile'),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF7E57C2), width: 1.5),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: ClipOval(
            child: (p?.avatarUrl != null && p!.avatarUrl!.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: p.avatarUrl!,
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFFEDE7F6),
                      child: const Icon(Icons.person_rounded,
                          color: Color(0xFF7E57C2), size: 20),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF7E57C2),
                      child: const Icon(Icons.person_rounded,
                          color: Colors.white, size: 20),
                    ),
                  )
                : Container(
                    color: const Color(0xFF7E57C2),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 20),
                  ),
          ),
        ),
      );
    });
  }

  /// Dark Pill Join Game Bar
  Widget _buildJoinGamePillBar(BuildContext context) {
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
          onTap: () => Get.toNamed('/games/find'),
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
                  'Join Game',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 4 Circular Football Action Buttons Grid
  Widget _buildCircularActionsGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actions = [
      {
        'icon': Icons.sports_soccer_rounded,
        'title': 'Book Pitch',
        'route': '/games/find'
      },
      {
        'icon': Icons.groups_rounded,
        'title': 'Find Matches',
        'route': '/games/find'
      },
      {
        'icon': Icons.add_circle_outline_rounded,
        'title': 'Create Game',
        'route': '/games/create'
      },
      {
        'icon': Icons.account_balance_wallet_rounded,
        'title': 'Check Wallet',
        'route': '/wallet'
      },
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: actions.map((item) {
        return Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.toNamed(item['route'] as String),
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

  /// Match Highlights Section Cards (Renders only when active/upcoming match exists)
  Widget _buildMatchHighlightsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sum = controller.summary.value;
    if (sum?.activeMatch == null &&
        sum?.upcomingMatch == null &&
        sum?.recentMatch == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Next for you',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : Colors.black87),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'New',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (sum?.activeMatch != null) ...[
          _buildHighlightCard(
              context, '🔥 ACTIVE MATCH NOW', sum!.activeMatch!, Colors.orange),
          const SizedBox(height: 10),
        ],
        if (sum?.upcomingMatch != null) ...[
          _buildHighlightCard(context, '⚽ UPCOMING MATCH', sum!.upcomingMatch!,
              AppColors.primary),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildHighlightCard(BuildContext context, String headerTitle,
      GameModel match, Color accentColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: accentColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(headerTitle,
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(match.format,
                    style: TextStyle(
                        color: accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(match.title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : Colors.black87)),
          const SizedBox(height: 2),
          Text(
              '${match.clubName} • ${AppDateUtils.formatDate(match.matchDate)} @ ${AppDateUtils.formatTime(match.startTime)}',
              style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey.shade600,
                  fontSize: 11)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              onPressed: () =>
                  Get.toNamed('/games/details', arguments: match.id),
              child: Text('View Match Details',
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  /// Football Career Statistics Section
  Widget _buildStatsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = controller.stats.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Football Statistics',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : Colors.black87),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/player/match-history'),
              child: const Text('Full History →',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSmallStatCard(context, 'Played', '${s?.matchesPlayed ?? 0}',
                Icons.sports_football),
            _buildSmallStatCard(
                context, 'Won', '${s?.matchesWon ?? 0}', Icons.emoji_events),
            _buildSmallStatCard(
                context,
                'Win %',
                '${s?.winRatePercentage.toStringAsFixed(0) ?? 0}%',
                Icons.analytics),
            _buildSmallStatCard(
                context, 'Goals', '${s?.goalsScored ?? 0}', Icons.sports_score),
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
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
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark ? AppColors.textPrimaryDark : Colors.black87)),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  /// Quick Modules Navigation Grid
  Widget _buildQuickModulesGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modules = [
      {
        'icon': Icons.search_rounded,
        'title': 'Find Games',
        'route': '/games/find',
        'color': AppColors.primary
      },
      {
        'icon': Icons.add_circle_outline_rounded,
        'title': 'Create Game',
        'route': '/games/create',
        'color': const Color(0xFF0288D1)
      },
      {
        'icon': Icons.history_rounded,
        'title': 'History',
        'route': '/player/match-history',
        'color': const Color(0xFF7B1FA2)
      },
      {
        'icon': Icons.receipt_long_rounded,
        'title': 'Payments',
        'route': '/player/payment-history',
        'color': const Color(0xFFE65100)
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Navigation',
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

  /// Refer & Earn Ad Banner (Light Mode vs Dark Mode asset)
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
}
