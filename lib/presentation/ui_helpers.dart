import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showProcessingDialog([String? message]) {
  Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                ),
              ),
          ],
        ),
      ),
      barrierDismissible: false);
}

void hideProcessingDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}
