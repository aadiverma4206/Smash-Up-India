import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/games_repository.dart';
import '../../../data/models/game_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/errors/error_handler.dart';

class FindGamesController extends GetxController {
  final GamesRepository repository = Get.find<GamesRepository>();

  final RxList<GameModel> gamesList = <GameModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final searchQuery = ''.obs;
  final selectedCity = ''.obs;
  final selectedFormat = '11v11'.obs;
  final selectedSkill = ''.obs;
  final selectedPrivacy = ''.obs;
  final maxFee = 1000.0.obs;

  final skills = ['', 'BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'PRO', 'ANY'];

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  List<GameModel> get filteredGames {
    if (searchQuery.value.trim().isEmpty) return gamesList;
    final q = searchQuery.value.trim().toLowerCase();
    return gamesList.where((g) {
      return g.title.toLowerCase().contains(q) ||
          g.clubName.toLowerCase().contains(q) ||
          g.courtName.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> fetchGames() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await repository.getGames(
        city: selectedCity.value,
        format: selectedFormat.value,
        skill: selectedSkill.value,
        maxEntryFee: maxFee.value,
        status: 'OPEN_FOR_JOINING',
        privacy: selectedPrivacy.value,
      );
      gamesList.value = list;
    } catch (e) {
      final msg = ErrorHandler.getErrorMessage(e);
      errorMessage.value = msg;
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedFormat.value = '11v11';
    selectedSkill.value = '';
    selectedPrivacy.value = '';
    fetchGames();
  }
}

class FindGamesView extends StatefulWidget {
  const FindGamesView({super.key});

  @override
  State<FindGamesView> createState() => _FindGamesViewState();
}

class _FindGamesViewState extends State<FindGamesView> {
  late final FindGamesController controller;
  late final ScrollController _scrollController;
  final ValueNotifier<double> _headerProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<FindGamesController>()
        ? Get.find<FindGamesController>()
        : Get.put(FindGamesController());
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
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return _buildMobileLayout(context);
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color solidHeaderColor =
        isDark ? const Color(0xFF130722) : Theme.of(context).cardColor;
    final Color borderColor =
        isDark ? AppColors.darkBorder : const Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildFindGamesSkeletonView(context);
        }

        return Stack(
          children: [
            // 1. Scrollable Main Content Body
            NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.fetchGames,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Stadium Asset Background Image Banner (find_Games/dark.png & light.png)
                      _buildHeaderBackground(context),
                      const SizedBox(height: 16),

                      // Search & Filters Header Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            _buildSearchAndFiltersHeader(context, controller),
                      ),
                      const SizedBox(height: 16),

                      // Open Matches List or Error State
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildGamesListSection(context),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Seamless Morphing Floating Top App Bar
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
                            // Back Button
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 20),
                              color: progress > 0.5
                                  ? (isDark
                                      ? AppColors.textPrimaryDark
                                      : Colors.black87)
                                  : Colors.white,
                              onPressed: () => Get.back(),
                            ),
                            const SizedBox(width: 4),

                            // Header Title ("Find Games")
                            Text(
                              'Find Games',
                              style: TextStyle(
                                color: progress > 0.5
                                    ? (isDark
                                        ? AppColors.textPrimaryDark
                                        : const Color(0xFF2D1B69))
                                    : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),

                            const Spacer(),

                            // Refresh Button
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded),
                              color: progress > 0.5
                                  ? (isDark
                                      ? AppColors.textPrimaryDark
                                      : Colors.black87)
                                  : Colors.white,
                              tooltip: 'Refresh Matches',
                              onPressed: controller.fetchGames,
                            ),

                            // Host / Create Game Button
                            IconButton(
                              icon: const Icon(Icons.add_circle_rounded,
                                  color: AppColors.primary, size: 28),
                              tooltip: 'Create Game',
                              onPressed: () async {
                                final result =
                                    await Get.toNamed('/games/create');
                                if (result == true) controller.fetchGames();
                              },
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
    );
  }

  /// Blink Loading Skeleton View (Shimmer)
  Widget _buildFindGamesSkeletonView(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Integrated Header Banner Skeleton
          Stack(
            children: [
              const ClipRRect(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
                child: AppShimmer(
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
                    children: const [
                      AppShimmer(
                        width: 36,
                        height: 36,
                        shape: BoxShape.circle,
                      ),
                      SizedBox(width: 10),
                      AppShimmer(width: 110, height: 18, borderRadius: 6),
                      Spacer(),
                      AppShimmer(
                        width: 36,
                        height: 36,
                        shape: BoxShape.circle,
                      ),
                      SizedBox(width: 8),
                      AppShimmer(
                        width: 36,
                        height: 36,
                        shape: BoxShape.circle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Search & Filter Bar Skeletons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmer(
                  width: double.infinity,
                  height: 50,
                  borderRadius: 14,
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    AppShimmer(width: 100, height: 32, borderRadius: 10),
                    SizedBox(width: 8),
                    AppShimmer(width: 90, height: 32, borderRadius: 10),
                    SizedBox(width: 8),
                    AppShimmer(width: 80, height: 32, borderRadius: 10),
                  ],
                ),
                const SizedBox(height: 20),

                // 3 Game Cards Skeleton List
                ...List.generate(
                  3,
                  (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: AppShimmer(
                      width: double.infinity,
                      height: 170,
                      borderRadius: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Stadium Asset Background Image at Top of ScrollView (find_Games/dark.png & light.png)
  Widget _buildHeaderBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String findGamesHeaderImagePath = isDark
        ? 'assets/images/find_Games/dark.png'
        : 'assets/images/find_Games/light.png';

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
              findGamesHeaderImagePath,
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

  Widget _buildSearchAndFiltersHeader(
      BuildContext context, FindGamesController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          // Search Input
          TextField(
            style: TextStyle(color: context.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search by title, club or pitch...',
              hintStyle: TextStyle(color: context.textSecondary, fontSize: 13),
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: Obx(
                () => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => controller.searchQuery.value = '',
                      )
                    : const SizedBox.shrink(),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              filled: true,
              fillColor: context.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            onChanged: (val) => controller.searchQuery.value = val,
          ),
          const SizedBox(height: 12),

          // Scrollable Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Skill Chip Dropdown
                Obx(() {
                  final currentSkill = controller.selectedSkill.value;
                  return _buildFilterChipDropdown<String>(
                    context: context,
                    icon: Icons.star_rounded,
                    label: currentSkill.isEmpty ? 'Skill Level' : currentSkill,
                    isSelected: currentSkill.isNotEmpty,
                    items: controller.skills.map((s) {
                      return DropdownMenuItem<String>(
                        value: s,
                        child: Text(s.isEmpty ? 'All Skill Levels' : s,
                            style: TextStyle(
                                fontSize: 12, color: context.textPrimary)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedSkill.value = val;
                        controller.fetchGames();
                      }
                    },
                  );
                }),
                const SizedBox(width: 8),

                // Privacy Filter Chip (Public / Private / All)
                Obx(() {
                  final privacy = controller.selectedPrivacy.value;
                  final isSelected = privacy.isNotEmpty;

                  return FilterChip(
                    avatar: Icon(
                      privacy == 'PUBLIC'
                          ? Icons.public_rounded
                          : (privacy == 'PRIVATE'
                              ? Icons.lock_rounded
                              : Icons.tune_rounded),
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                    label: Text(
                      privacy.isEmpty ? 'Privacy' : privacy,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : context.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: context.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : context.borderColor,
                      ),
                    ),
                    onSelected: (_) {
                      if (privacy.isEmpty) {
                        controller.selectedPrivacy.value = 'PUBLIC';
                      } else if (privacy == 'PUBLIC') {
                        controller.selectedPrivacy.value = 'PRIVATE';
                      } else {
                        controller.selectedPrivacy.value = '';
                      }
                      controller.fetchGames();
                    },
                  );
                }),

                // Reset Filters Button if any filter active
                Obx(() {
                  final hasActiveFilter =
                      controller.selectedSkill.value.isNotEmpty ||
                          controller.selectedPrivacy.value.isNotEmpty ||
                          controller.searchQuery.value.isNotEmpty;

                  if (!hasActiveFilter) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.clear_all_rounded,
                          size: 16, color: AppColors.error),
                      label: const Text(
                        'Reset',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error),
                      ),
                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      onPressed: controller.resetFilters,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChipDropdown<T>({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : context.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primary : context.borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16, color: isSelected ? Colors.white : AppColors.primary),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isDense: true,
              dropdownColor: context.cardColor,
              icon: Icon(Icons.arrow_drop_down_rounded,
                  color: isSelected ? Colors.white : context.textSecondary),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : context.textPrimary,
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesListSection(BuildContext context) {
    if (controller.errorMessage.value.isNotEmpty &&
        controller.gamesList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: AppErrorWidget(
          message: controller.errorMessage.value,
          onRetry: controller.fetchGames,
        ),
      );
    }

    final list = controller.filteredGames;

    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmptyStateWidget(
              title: 'No Matches Found',
              subtitle:
                  'No open matches fit your criteria. Try resetting filters or host a new match!',
              darkImagePath: 'assets/images/find_Games/dark.png',
              lightImagePath: 'assets/images/find_Games/light.png',
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: context.borderColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.resetFilters,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reset Filters'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Get.toNamed('/games/create'),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Host 11v11 Match',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final game = list[index];
        return _buildGameCard(context, game);
      },
    );
  }

  Widget _buildGameCard(BuildContext context, GameModel game) {
    final filled = game.currentPlayers;
    final total = game.maxPlayers;
    final available = total - filled;
    final isFull = available <= 0;

    final formattedDate = AppDateUtils.formatDate(game.matchDate);
    final timeDisplay =
        AppDateUtils.formatTimeRange(game.startTime, game.endTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Get.toNamed('/games/details', arguments: game.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badges Row
                Row(
                  children: [
                    // Format Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        game.format, // e.g. 11v11
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Skill Level Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.amber.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        game.skillRequirement,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Creator / Host Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: game.createdByPlayer
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : Colors.blue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: game.createdByPlayer
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            game.createdByPlayer
                                ? Icons.person_rounded
                                : Icons.business_rounded,
                            size: 12,
                            color: game.createdByPlayer
                                ? AppColors.primary
                                : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            game.createdByPlayer ? 'Player Host' : 'Club Match',
                            style: TextStyle(
                              color: game.createdByPlayer
                                  ? AppColors.primary
                                  : Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Match Title
                Text(
                  game.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Pitch & Venue Row
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 15, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${game.clubName} • ${game.courtName}',
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Date & Time Banner Box
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          size: 15, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '•',
                        style: TextStyle(color: context.textSecondary),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time_rounded,
                          size: 15, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          timeDisplay,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Slots & Pricing Row
                Row(
                  children: [
                    // Slots Progress & Count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Slots Filled',
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                isFull ? 'FULL' : '$available open',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isFull
                                      ? AppColors.error
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total > 0 ? (filled / total) : 0,
                              minHeight: 6,
                              backgroundColor:
                                  context.borderColor.withValues(alpha: 0.5),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isFull ? AppColors.error : AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$filled / $total Players Joined',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Price & CTA Button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Entry Fee',
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '₹${game.perPlayerFee.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isFull
                                ? context.borderColor
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isFull ? 'View Details' : 'Join Match',
                            style: TextStyle(
                              color:
                                  isFull ? context.textSecondary : Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
