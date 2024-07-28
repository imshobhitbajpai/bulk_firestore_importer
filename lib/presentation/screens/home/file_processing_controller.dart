import 'dart:convert';
import 'dart:io';

import 'package:bulk_firebase_importer/presentation/ui_helpers.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:toastification/toastification.dart';

class FileProcessingController extends GetxController {
  
  Future<List<List<dynamic>>?> getValuesFromCSVFile(String filepath) async {
    try {
      showProcessingDialog('Processing Your File');
      List<List<dynamic>> fields = await compute(_computeCSV, filepath);
      hideProcessingDialog();
      //debugPrint("### $fields ###");
      return fields;
    } catch (error) {
      hideProcessingDialog();
      debugPrint("### processCSVFile:Error ${error.toString()} ###");
      toastification.show(autoCloseDuration: const Duration(seconds: 3), title: Text(error.toString()), type: ToastificationType.error);
      return null;
    }
  }
}

Future<List<List<dynamic>>> _computeCSV(String path) {
  final input = File(path).openRead();
  return input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();
}
