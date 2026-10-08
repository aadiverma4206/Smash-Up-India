import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/player_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/responsive/responsive_builder.dart';
import '../../../app/theme/app_colors.dart';

class EditProfileView extends GetView<PlayerController> {
  EditProfileView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final RxString selectedPosition = 'ST'.obs;
  final RxString selectedSecondaryPosition = 'CAM'.obs;
  final RxString selectedFoot = 'RIGHT'.obs;
  final RxString selectedSkill = 'AMATEUR'.obs;
  final Rxn<DateTime> selectedDob = Rxn<DateTime>();

  static const allowedPositions = [
    'GK',
    'CB',
    'LB',
    'RB',
    'CDM',
    'CM',
    'CAM',
    'ST',
    'LW',
    'RW'
  ];

  static const allowedSecondaryPositions = [
    'GK',
    'CB',
    'LB',
    'RB',
    'CDM',
    'CM',
    'CAM',
    'ST',
    'LW',
    'RW',
    'NONE'
  ];

  static const allowedFeet = ['RIGHT', 'LEFT', 'BOTH'];

  static const allowedSkills = ['AMATEUR', 'SEMI_PRO', 'PRO'];

  String _normalize(String? val, List<String> allowed, String fallback) {
    if (val == null || val.trim().isEmpty) return fallback;
    final upper = val.trim().toUpperCase();
    if (allowed.contains(upper)) return upper;

    if (upper.contains('RIGHT')) {
      return allowed.contains('RIGHT') ? 'RIGHT' : fallback;
    }
    if (upper.contains('LEFT')) {
      return allowed.contains('LEFT') ? 'LEFT' : fallback;
    }
    if (upper.contains('BOTH') || upper.contains('AMBI')) {
      return allowed.contains('BOTH') ? 'BOTH' : fallback;
    }

    if (upper.contains('AMATEUR') || upper.contains('BEGINNER')) {
      return allowed.contains('AMATEUR') ? 'AMATEUR' : fallback;
    }
    if (upper.contains('SEMI') || upper.contains('INTERMEDIATE')) {
      return allowed.contains('SEMI_PRO') ? 'SEMI_PRO' : fallback;
    }
    if (upper.contains('PRO') || upper.contains('ADVANCED')) {
      return allowed.contains('PRO') ? 'PRO' : fallback;
    }

    return fallback;
  }

  void _initProfileData() {
    final p = controller.profile.value;
    if (p != null) {
      if (nameController.text.isEmpty) nameController.text = p.name;
      if (bioController.text.isEmpty) bioController.text = p.bio ?? '';
      if (cityController.text.isEmpty) cityController.text = p.city;

      selectedPosition.value = _normalize(p.position, allowedPositions, 'ST');
      selectedSecondaryPosition.value =
          _normalize(p.secondaryPosition, allowedSecondaryPositions, 'NONE');
      selectedFoot.value = _normalize(p.preferredFoot, allowedFeet, 'RIGHT');
      selectedSkill.value = _normalize(p.skillLevel, allowedSkills, 'AMATEUR');

      if (selectedDob.value == null &&
          p.dateOfBirth != null &&
          p.dateOfBirth!.isNotEmpty) {
        selectedDob.value = AppDateUtils.parseDate(p.dateOfBirth!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initProfileData();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit Football Passport',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          final isDesktop = deviceType == DeviceType.desktop;
          final maxContainerWidth = isDesktop ? 600.0 : double.infinity;

          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxContainerWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Container for Personal Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Full Name
                          AppTextField(
                            label: 'Full Name',
                            controller: nameController,
                            prefixIcon: const Icon(Icons.person_outline,
                                color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),

                          // City
                          AppTextField(
                            label: 'City',
                            controller: cityController,
                            prefixIcon: const Icon(Icons.location_city_outlined,
                                color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),

                          // Player Bio
                          AppTextField(
                            label: 'Player Bio',
                            hint: 'Write a short bio...',
                            controller: bioController,
                            prefixIcon: const Icon(Icons.notes_outlined,
                                color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),

                          // Date of Birth Picker
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.cake_outlined,
                                color: AppColors.primary),
                            title: Text('Date of Birth',
                                style: TextStyle(
                                    color: context.textSecondary,
                                    fontSize: 13)),
                            subtitle: Obx(
                              () => Text(
                                selectedDob.value != null
                                    ? AppDateUtils.formatIsoDate(
                                        selectedDob.value!)
                                    : 'Select Date of Birth',
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            trailing: Icon(Icons.calendar_today_rounded,
                                size: 18, color: context.textSecondary),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    selectedDob.value ?? DateTime(2000, 1, 1),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) selectedDob.value = picked;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card Container for Pitch Attribute & Attributes
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Player Attributes',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Primary Position Dropdown
                          Text(
                            'Primary Position',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: context.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () {
                              final currentVal = _normalize(
                                  selectedPosition.value,
                                  allowedPositions,
                                  'ST');
                              return DropdownButtonFormField<String>(
                                initialValue: currentVal,
                                isExpanded: true,
                                dropdownColor: context.cardColor,
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.stadium_outlined,
                                      color: AppColors.primary),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                ),
                                items: allowedPositions
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) selectedPosition.value = val;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Secondary Position Dropdown
                          Text(
                            'Secondary Position',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: context.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () {
                              final currentVal = _normalize(
                                  selectedSecondaryPosition.value,
                                  allowedSecondaryPositions,
                                  'NONE');
                              return DropdownButtonFormField<String>(
                                initialValue: currentVal,
                                isExpanded: true,
                                dropdownColor: context.cardColor,
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                      Icons.sports_soccer_outlined,
                                      color: AppColors.primary),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                ),
                                items: allowedSecondaryPositions
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e == 'NONE'
                                            ? 'None (Single Position)'
                                            : e)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    selectedSecondaryPosition.value = val;
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Preferred Foot Dropdown
                          Text(
                            'Preferred Foot',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: context.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () {
                              final currentVal = _normalize(
                                  selectedFoot.value, allowedFeet, 'RIGHT');
                              return DropdownButtonFormField<String>(
                                initialValue: currentVal,
                                isExpanded: true,
                                dropdownColor: context.cardColor,
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.sports_football,
                                      color: AppColors.primary),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'RIGHT',
                                      child: Text('Right Footed')),
                                  DropdownMenuItem(
                                      value: 'LEFT',
                                      child: Text('Left Footed')),
                                  DropdownMenuItem(
                                      value: 'BOTH',
                                      child: Text('Both Feet (Ambidextrous)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) selectedFoot.value = val;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Skill Level Dropdown
                          Text(
                            'Skill Level',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: context.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () {
                              final currentVal = _normalize(selectedSkill.value,
                                  allowedSkills, 'AMATEUR');
                              return DropdownButtonFormField<String>(
                                initialValue: currentVal,
                                isExpanded: true,
                                dropdownColor: context.cardColor,
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                      Icons.military_tech_outlined,
                                      color: AppColors.primary),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: context.borderColor)),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'AMATEUR',
                                      child: Text('Amateur / Grassroots')),
                                  DropdownMenuItem(
                                      value: 'SEMI_PRO',
                                      child: Text('Semi-Pro / Competitive')),
                                  DropdownMenuItem(
                                      value: 'PRO',
                                      child: Text('Professional / Elite')),
                                ],
                                onChanged: (val) {
                                  if (val != null) selectedSkill.value = val;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    Obx(
                      () => AppButton(
                        text: 'Save Passport Changes',
                        showArrow: true,
                        isLoading: controller.isLoading.value,
                        onPressed: () {
                          controller.updateProfile(
                            name: nameController.text.trim(),
                            bio: bioController.text.trim(),
                            city: cityController.text.trim(),
                            dateOfBirth: selectedDob.value != null
                                ? AppDateUtils.formatIsoDate(selectedDob.value!)
                                : null,
                            position: selectedPosition.value,
                            secondaryPosition:
                                selectedSecondaryPosition.value == 'NONE'
                                    ? null
                                    : selectedSecondaryPosition.value,
                            preferredFoot: selectedFoot.value,
                            skillLevel: selectedSkill.value,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
