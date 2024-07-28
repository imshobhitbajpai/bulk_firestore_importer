import 'package:bulk_firebase_importer/locator.dart';
import 'package:bulk_firebase_importer/presentation/screens/home/firestore_controller.dart';
import 'package:bulk_firebase_importer/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FirestoreUploadingDialog extends StatefulWidget {
  final PreUploadModel preUploadModel;
  final List<dynamic> fields;
  final List<dynamic> values;
  const FirestoreUploadingDialog(
      {super.key,
      required this.preUploadModel,
      required this.fields,
      required this.values});
  static const String tag = "FirestoreUploadingDialog";

  @override
  State<FirestoreUploadingDialog> createState() =>
      _FirestoreUploadingDialogState();
}

class _FirestoreUploadingDialogState extends State<FirestoreUploadingDialog> {
  @override
  void initState() {
    super.initState();
    locator<FirestoreController>().startUploadingDocs(
        widget.preUploadModel, widget.fields, widget.values);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int totalDocsUploadedCount =
          locator<FirestoreController>().totalDocsUploadedCount.value;
      return AlertDialog(
          title: const Text('Uploading to Firestore'),
          icon: const Icon(Icons.upload_rounded),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (totalDocsUploadedCount != widget.values.length)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Total Uploaded: '),
                    Text(
                      '$totalDocsUploadedCount',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('/'),
                    Text(
                      widget.values.length.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: locator<FirestoreController>()
                        .uploadError
                        .value
                        .isNotEmpty
                    ? Text(
                        locator<FirestoreController>().uploadError.value,
                        style: const TextStyle(color: Colors.red),
                      )
                    : LinearProgressIndicator(
                        value: totalDocsUploadedCount / widget.values.length,
                      ),
              ),
              if (totalDocsUploadedCount == widget.values.length)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'All Data has been uploaded to Firestore successfully',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                          launchUrl(Uri.parse(
                              'https://github.com/imshobhitbajpai/bulk_firestore_importer'));
                        },
                        child: const Text(
                            'Thank You Shobhit (Developer), Exit Now!'))
                  ],
                )
            ],
          ));
    });
  }
}
