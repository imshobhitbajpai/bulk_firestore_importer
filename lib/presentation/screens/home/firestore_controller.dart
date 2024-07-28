import 'package:bulk_firebase_importer/presentation/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FirestoreController extends GetxController {
  RxInt totalDocsUploadedCount = 0.obs;
  RxString uploadError = ''.obs;

  void startUploadingDocs(
      PreUploadModel preUploadModel, List fields, List values) async {
    totalDocsUploadedCount.value = 0;
    uploadError.value = '';
    final db = FirebaseFirestore.instance;
    final CollectionReference collectionReference =
        db.collection(preUploadModel.collectionName);

    // Split the documents into chunks of 500
    const int batchSize = 500;
    int totalDocs = values.length;
    int numBatches = (totalDocs / batchSize).ceil();

    for (int i = 0; i < numBatches; i++) {
      WriteBatch batch = db.batch();
      int start = i * batchSize;
      int end = start + batchSize < totalDocs ? start + batchSize : totalDocs;

      for (int j = start; j < end; j++) {
        batch.set(
            collectionReference.doc(preUploadModel.documentIdValue == 0
                ? null
                : values[j][preUploadModel.documentIdValue - 1].toString()),
            getFieldsValuesMap(fields, values[j]));
      }

      try {
        await batch.commit();
        debugPrint('Batch $i write succeeded');
        totalDocsUploadedCount.value = end;
      } catch (e) {
        uploadError.value = 'Batch $i Error: $e';
        debugPrint('Batch $i write failed: $e');
        debugPrint("### startUploadingDocs: Error: ${e.toString()} ###");
      }
    }
  }
}

Map<String, dynamic> getFieldsValuesMap(List fields, List values) {
  Map<String, dynamic> map = {};
  for (int i = 0; i < fields.length; i++) {
    map[fields[i] as String] = values[i];
  }

  return map;
}
