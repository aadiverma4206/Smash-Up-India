import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import 'app_exception.dart';
import 'error_mapper.dart';

class ErrorHandler {
  /// Extracts a clean, human-readable error message from ANY error object
  static String getErrorMessage(dynamic error) {
    if (error == null) return 'An unexpected error occurred. Please try again.';

    if (error is AppException) {
      return error.message;
    }

    if (error is DioException) {
      if (error.error is AppException) {
        return (error.error as AppException).message;
      }
      return ErrorMapper.mapDioError(error).message;
    }

    if (error is SocketException ||
        error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network connection and try again.';
    }

    if (error is TimeoutException) {
      return 'Connection timed out. Please check your internet connection and try again.';
    }

    if (error is FormatException) {
      return 'Internal server error. Invalid data format received.';
    }

    if (error is TypeError) {
      return 'Internal server error. Unexpected data format received.';
    }

    final String raw = error.toString().trim();
    if (raw.startsWith('Exception: ')) {
      return raw.substring(11).trim();
    }

    // Clean any remaining raw exception tags or stack traces
    final clean = raw
        .replaceAll(
            RegExp(
                r'^(?:DioException\s*\[.*?\]:?\s*null\s*Error:\s*AppException:\s*|AppException:\s*|DioException\s*\[.*?\]:\s*)'),
            '')
        .trim();

    return clean.isNotEmpty
        ? clean
        : 'An unexpected error occurred. Please try again.';
  }

  /// Displays a standardized error snackbar
  static void showErrorSnackBar(String title, dynamic error,
      {Duration? duration}) {
    final message = getErrorMessage(error);
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: duration ?? const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
    );
  }

  /// Displays a standardized success snackbar
  static void showSuccessSnackBar(String title, String message,
      {Duration? duration}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      duration: duration ?? const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
    );
  }
}
