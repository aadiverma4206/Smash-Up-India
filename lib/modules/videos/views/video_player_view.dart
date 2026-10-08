import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_player_controller.dart';
import '../../../app/theme/app_colors.dart';

class VideoPlayerView extends GetView<VideoPlayerController> {
  const VideoPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Match CCTV Video Playback'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 220),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.isPlaying.value
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.isPlaying.value
                            ? 'Streaming S3 Match Video...'
                            : 'Tap Play to start streaming',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.togglePlay,
                  icon: Icon(controller.isPlaying.value
                      ? Icons.pause
                      : Icons.play_arrow),
                  label: Text(controller.isPlaying.value
                      ? 'Pause Stream'
                      : 'Start S3 Signed Stream'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '🔒 Playback URL is short-lived and authorized by backend.\nS3 credentials and RTSP streams are never exposed.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
