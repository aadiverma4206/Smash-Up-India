import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_game_controller.dart';
import '../../../data/models/football_game_type.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/responsive/responsive_builder.dart';

class CreateGameView extends StatelessWidget {
  const CreateGameView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateGameController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Create Game',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          final isTabletOrDesktop = deviceType == DeviceType.desktop ||
              deviceType == DeviceType.tablet;
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          final maxContainerWidth =
              (isTabletOrDesktop || isLandscape) ? 680.0 : double.infinity;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContainerWidth),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.only(
                    left: 18,
                    right: 18,
                    top: 18,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🏟️ Section 1: Club & Pitch Info
                        _buildSectionHeader(
                          context,
                          title: 'Club & Pitch Info',
                          icon: Icons.stadium_rounded,
                        ),
                        const SizedBox(height: 10),
                        _buildVenueSelectionCard(context, controller),
                        const SizedBox(height: 20),

                        // 📝 Section 2: Match Overview & Pricing
                        _buildSectionHeader(
                          context,
                          title: 'Match Details & Entry Fee',
                          icon: Icons.sports_soccer_rounded,
                        ),
                        const SizedBox(height: 10),
                        _buildMatchDetailsCard(context, controller),
                        const SizedBox(height: 20),

                        // 📅 Section 3: Schedule & Time
                        _buildSectionHeader(
                          context,
                          title: 'Match Date & Timing',
                          icon: Icons.calendar_month_rounded,
                        ),
                        const SizedBox(height: 10),
                        _buildScheduleCard(context, controller),
                        const SizedBox(height: 20),

                        // 📜 Section 4: Rules & Guidelines
                        _buildSectionHeader(
                          context,
                          title: 'Guidelines & Description',
                          icon: Icons.description_rounded,
                        ),
                        const SizedBox(height: 10),
                        _buildRulesCard(context, controller),
                        const SizedBox(height: 24),

                        // ⚡ Summary & Submit CTA
                        _buildSummaryAndSubmitButton(context, controller),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildVenueSelectionCard(
      BuildContext context, CreateGameController controller) {
    return Obx(() {
      final courts = controller.availableCourts;
      final selectedCourt = controller.selectedCourt.value;

      final List<Widget> courtButtons = courts.map<Widget>((court) {
        final isSelected =
            selectedCourt?.id == court.id || selectedCourt?.name == court.name;
        return InkWell(
          onTap: () {
            controller.selectedCourt.value = court;
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color: isSelected ? AppColors.primary : context.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  court.name,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : context.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Club Name Field (Read-only modern rectangular style)
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Club Name *',
              prefixIcon:
                  const Icon(Icons.business_rounded, color: AppColors.primary),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderColor, width: 1.2),
              ),
            ),
            child: Text(
              controller.selectedClub.value.name.isNotEmpty
                  ? controller.selectedClub.value.name
                  : 'All Stars Turf Raipur',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Select Pitch / Court Header
          Text(
            'Select Pitch / Court *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 6),

          // Clean Radio Options Centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < courtButtons.length; i++) ...[
                if (i > 0) const SizedBox(width: 32),
                courtButtons[i],
              ],
            ],
          ),
        ],
      );
    });
  }

  Widget _buildMatchDetailsCard(
      BuildContext context, CreateGameController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Category Selection
          Text(
            'Game Category *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  final isIndoor =
                      controller.selectedCategory.value == GameCategory.indoor;
                  return ChoiceChip(
                    label: Center(
                      child: Text('Indoor',
                          style: TextStyle(
                              color: isIndoor
                                  ? Colors.white
                                  : context.textSecondary,
                              fontWeight: FontWeight.bold)),
                    ),
                    selected: isIndoor,
                    selectedColor: AppColors.primary,
                    backgroundColor: context.cardColor,
                    onSelected: (selected) {
                      if (selected)
                        controller.onCategoryChanged(GameCategory.indoor);
                    },
                  );
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() {
                  final isOutdoor =
                      controller.selectedCategory.value == GameCategory.outdoor;
                  return ChoiceChip(
                    label: Center(
                      child: Text('Outdoor',
                          style: TextStyle(
                              color: isOutdoor
                                  ? Colors.white
                                  : context.textSecondary,
                              fontWeight: FontWeight.bold)),
                    ),
                    selected: isOutdoor,
                    selectedColor: AppColors.primary,
                    backgroundColor: context.cardColor,
                    onSelected: (selected) {
                      if (selected)
                        controller.onCategoryChanged(GameCategory.outdoor);
                    },
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Game Type Selection
          Obx(() {
            final category = controller.selectedCategory.value;
            final isEnabled = category != null;
            final labelText = category == null
                ? 'Game Type *'
                : 'Select ${category == GameCategory.indoor ? 'Indoor' : 'Outdoor'} Game *';

            return DropdownButtonFormField<FootballGameType>(
              key: ValueKey(category),
              // ignore: deprecated_member_use
              value: controller.selectedGameType.value,
              decoration: InputDecoration(
                labelText: labelText,
                prefixIcon: const Icon(Icons.sports_soccer_rounded,
                    color: AppColors.primary),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: context.borderColor, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.8),
                ),
              ),
              dropdownColor: context.cardColor,
              items: controller.availableGameTypes.map((game) {
                return DropdownMenuItem<FootballGameType>(
                  value: game,
                  child: Text(game.name,
                      style: TextStyle(color: context.textPrimary)),
                );
              }).toList(),
              onChanged: isEnabled ? controller.onGameTypeChanged : null,
              validator: (val) =>
                  val == null ? 'Please select a game type' : null,
            );
          }),
          const SizedBox(height: 16),

          // Derived Format Selection (Disabled/Read-only)
          Obx(() => InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Game Format',
                  prefixIcon: const Icon(Icons.groups_rounded,
                      color: AppColors.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: context.borderColor, width: 1.2),
                  ),
                  fillColor: context.theme.disabledColor.withAlpha(20),
                  filled: true,
                ),
                child: Text(
                  controller.selectedFormat.value.isEmpty
                      ? 'Automatically determined'
                      : controller.selectedFormat.value,
                  style: TextStyle(
                    color: controller.selectedFormat.value.isEmpty
                        ? context.textSecondary
                        : context.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          const SizedBox(height: 16),

          // Match Title
          TextFormField(
            controller: controller.titleController,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: context.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Match Title *',
              hintText: 'e.g. Sunday Football Showdown',
              prefixIcon:
                  const Icon(Icons.title_rounded, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderColor, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.8),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Match title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Entry Fee
          TextFormField(
            controller: controller.entryFeeController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: context.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Entry Fee Per Player (₹) *',
              hintText: 'e.g. 200',
              prefixIcon:
                  const Icon(Icons.currency_rupee, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderColor, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.8),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Entry fee is required';
              }
              final fee = double.tryParse(val.trim());
              if (fee == null || fee < 0) {
                return 'Enter a valid non-negative entry fee';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Reserve Players Count Input
          TextFormField(
            controller: controller.reservePlayersController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: context.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'Extra Reserve / Substitute Players Count *',
              hintText: 'e.g. 2',
              prefixIcon: const Icon(Icons.person_add_alt_1_rounded,
                  color: AppColors.primary),
              helperText:
                  'Extra players on reserve bench (e.g. 2 reserves = 24 total capacity)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.borderColor, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.8),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Reserve count is required';
              }
              final count = int.tryParse(val.trim());
              if (count == null || count < 0 || count > 10) {
                return 'Enter a valid count (0 to 10)';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Skill Requirement Dropdown
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: controller.skillRequirement.value,
              hint: Text('Select Skill Level',
                  style: TextStyle(color: context.textSecondary, fontSize: 14)),
              dropdownColor: context.cardColor,
              style: TextStyle(color: context.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Required Skill Level *',
                prefixIcon:
                    const Icon(Icons.star_rounded, color: AppColors.primary),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: context.borderColor, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.8),
                ),
              ),
              items: controller.skills.map((s) {
                return DropdownMenuItem<String>(
                  value: s,
                  child: Text(s),
                );
              }).toList(),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please select required skill level';
                }
                return null;
              },
              onChanged: (val) {
                if (val != null) controller.skillRequirement.value = val;
              },
            ),
          ),
          const SizedBox(height: 14),

          // Match Privacy Choice
          Text('Match Privacy',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  final isPublic = controller.privacy.value == 'PUBLIC';
                  return ChoiceChip(
                    label: Center(
                      child: Text('Public Lobby',
                          style: TextStyle(
                              color: isPublic
                                  ? Colors.white
                                  : context.textSecondary,
                              fontWeight: FontWeight.bold)),
                    ),
                    selected: isPublic,
                    selectedColor: AppColors.primary,
                    backgroundColor: context.cardColor,
                    onSelected: (selected) {
                      if (selected) controller.privacy.value = 'PUBLIC';
                    },
                  );
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() {
                  final isPrivate = controller.privacy.value == 'PRIVATE';
                  return ChoiceChip(
                    label: Center(
                      child: Text('Private Match',
                          style: TextStyle(
                              color: isPrivate
                                  ? Colors.white
                                  : context.textSecondary,
                              fontWeight: FontWeight.bold)),
                    ),
                    selected: isPrivate,
                    selectedColor: AppColors.primary,
                    backgroundColor: context.cardColor,
                    onSelected: (selected) {
                      if (selected) controller.privacy.value = 'PRIVATE';
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(
      BuildContext context, CreateGameController controller) {
    return Obx(() {
      final selectedDate = controller.selectedDate.value;
      final startTime = controller.startTime.value;
      final endTime = controller.endTime.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          children: [
            // Date Picker Tile
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_month_rounded,
                    color: AppColors.primary),
              ),
              title: Text('Match Date *',
                  style: TextStyle(color: context.textSecondary, fontSize: 12)),
              subtitle: Text(
                selectedDate != null
                    ? AppDateUtils.formatDate(selectedDate,
                        format: 'EEEE, dd MMMM yyyy')
                    : 'Tap to select match date',
                style: TextStyle(
                    color: selectedDate != null
                        ? context.textPrimary
                        : context.textSecondary,
                    fontWeight: selectedDate != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 15),
              ),
              trailing: Icon(Icons.chevron_right_rounded,
                  color: context.textSecondary),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null) controller.updateDate(picked);
              },
            ),
            Divider(color: context.borderColor),

            // Start & End Time Pickers
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time_rounded,
                        color: AppColors.primary, size: 20),
                    title: Text('Start Time *',
                        style: TextStyle(
                            color: context.textSecondary, fontSize: 11)),
                    subtitle: Text(
                      startTime != null
                          ? AppDateUtils.formatTime(startTime)
                          : 'Select Start',
                      style: TextStyle(
                          color: startTime != null
                              ? context.textPrimary
                              : context.textSecondary,
                          fontWeight: startTime != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) controller.updateStartTime(picked);
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time_filled_rounded,
                        color: AppColors.primary, size: 20),
                    title: Text('End Time *',
                        style: TextStyle(
                            color: context.textSecondary, fontSize: 11)),
                    subtitle: Text(
                      endTime != null
                          ? AppDateUtils.formatTime(endTime)
                          : 'Select End',
                      style: TextStyle(
                          color: endTime != null
                              ? context.textPrimary
                              : context.textSecondary,
                          fontWeight: endTime != null
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) controller.updateEndTime(picked);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRulesCard(
      BuildContext context, CreateGameController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: TextFormField(
        controller: controller.descriptionController,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        style: TextStyle(color: context.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          labelText: 'Match Rules & Extra Details (Optional)',
          hintText: 'e.g. Bring necessary equipment. Standard rules apply.',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.borderColor, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryAndSubmitButton(
      BuildContext context, CreateGameController controller) {
    return Obx(() {
      final fee = controller.entryFeeRx.value.isEmpty
          ? '0'
          : controller.entryFeeRx.value;
      final reserves = controller.reserveCountRx.value.isEmpty
          ? '0'
          : controller.reserveCountRx.value;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.groups_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.selectedFormat.value} (${controller.maxPlayers.value} Main + $reserves Subs)',
                      style: TextStyle(
                          color: context.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  '₹$fee / player',
                  style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: AppButton(
              text:
                  'Create ${controller.selectedGameType.value?.name ?? 'Game'}',
              isLoading: controller.isLoading.value,
              onPressed: controller.proceedToCheckout,
            ),
          ),
        ],
      );
    });
  }
}
