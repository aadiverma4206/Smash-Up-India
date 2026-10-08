import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cctv_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../app/theme/app_colors.dart';

class CctvGameSectionWidget extends StatefulWidget {
  final String gameId;

  const CctvGameSectionWidget({super.key, required this.gameId});

  @override
  State<CctvGameSectionWidget> createState() => _CctvGameSectionWidgetState();
}

class _CctvGameSectionWidgetState extends State<CctvGameSectionWidget> {
  late final CctvController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CctvController>();
    controller.fetchGameRecording(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rec = controller.currentRecording.value;
      if (rec == null) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.videocam_off_outlined, color: Colors.grey),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No CCTV recording associated with this match.',
                    style: TextStyle(color: Colors.grey),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final isPostMatch = rec.recordingStatus == 'POST_MATCH';
      final remainingSecs = controller.remainingCountdownSeconds.value;
      final minutes = (remainingSecs / 60).floor();
      final seconds = remainingSecs % 60;

      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isPostMatch ? AppColors.secondary : AppColors.primary,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.videocam, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'CCTV Match Recording Status',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          isPostMatch ? AppColors.secondary : AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      rec.recordingStatus,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isPostMatch) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⏰ Post-Match Recording Active (+15 min deadline)',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Auto-stop visual countdown: ${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'STOP RECORDING NOW',
                        onPressed: () => _confirmStopRecording(context, rec.id),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_alarm,
                          color: AppColors.secondary),
                      tooltip: 'Extend +15m',
                      onPressed: () => controller.extendRecording(rec.id, 15),
                    ),
                  ],
                ),
              ],
              if (rec.recordingStatus == 'STOPPED_MANUALLY' ||
                  rec.recordingStatus == 'COMPLETED') ...[
                const SizedBox(height: 8),
                const Text(
                  '✅ CCTV recording finalized and uploaded to S3 private storage.',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  void _confirmStopRecording(BuildContext context, String recordingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Stop CCTV Recording Now?'),
        content: const Text(
          'This will gracefully stop FFmpeg RTSP stream capture and finalize the match recording for S3 playback.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.stopRecordingNow(recordingId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Confirm Stop'),
          ),
        ],
      ),
    );
  }
}
