// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bulk_firebase_importer/locator.dart';
import 'package:bulk_firebase_importer/prefs_controller.dart';
import 'package:bulk_firebase_importer/presentation/firebase_dialogs/firestore_pre_upload_dialog.dart';
import 'package:bulk_firebase_importer/presentation/firebase_dialogs/firestore_uploading_dialog.dart';
import 'package:bulk_firebase_importer/presentation/screens/home/file_processing_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseCredentialsEntryWidget extends StatefulWidget {
  const FirebaseCredentialsEntryWidget({super.key});
  static const String tag = "FirebaseCredentialsEntryWidget";

  @override
  State<FirebaseCredentialsEntryWidget> createState() =>
      _FirebaseCredentialsEntryWidgetState();
}

class _FirebaseCredentialsEntryWidgetState
    extends State<FirebaseCredentialsEntryWidget> {
  late final GlobalKey<FormState> formKey;

  late final TextEditingController apiKeyTextController;
  late final TextEditingController appIdTextController;
  late final TextEditingController messagingSenderIdTextController;
  late final TextEditingController projectIdTextController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();

    apiKeyTextController = TextEditingController()
      ..text =
          locator<MyPreferencesController>().prefs!.getString('api_key') ?? '';
    appIdTextController = TextEditingController();
    messagingSenderIdTextController = TextEditingController();
    projectIdTextController = TextEditingController()
      ..text =
          locator<MyPreferencesController>().prefs!.getString('project_id') ??
              '';
  }

  @override
  void dispose() {
    apiKeyTextController.dispose();
    appIdTextController.dispose();
    messagingSenderIdTextController.dispose();
    projectIdTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                    width: 100,
                    child: Text(
                      'API Key:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'XXXxxXxxXxxXxxxXxxxXxxxXxxxXxxxXxxxXXX',
                          border: OutlineInputBorder()),
                      controller: apiKeyTextController,
                      validator: (value) => (value != null && value.isEmpty)
                          ? 'Please Enter the Value.'
                          : null,
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(
                    width: 100,
                    child: Text(
                      'Project ID:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'xxxx-xxxx', border: OutlineInputBorder()),
                      controller: projectIdTextController,
                      validator: (value) => (value != null && value.isEmpty)
                          ? 'Please Enter the Value.'
                          : null,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  //validate form
                  if (!(formKey.currentState == null
                      ? false
                      : formKey.currentState!.validate())) {
                    return;
                  }

                  locator<MyPreferencesController>()
                      .prefs!
                      .setString('api_key', apiKeyTextController.text);
                  locator<MyPreferencesController>()
                      .prefs!
                      .setString('project_id', projectIdTextController.text);

                  //initial firebase
                  await Firebase.initializeApp(
                      options: FirebaseOptions(
                    apiKey: apiKeyTextController.text,
                    appId: '0:0:X:0',
                    messagingSenderId: '',
                    projectId: projectIdTextController.text,
                  ));

                  //pick file now
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv'],
                  );

                  final String? path = result?.paths.first;
                  if (path != null) {
                    if (path.endsWith('.csv')) {
                      final List<List<dynamic>>? values =
                          await locator<FileProcessingController>()
                              .getValuesFromCSVFile(path);
                      if (values != null && values.isNotEmpty) {
                        final PreUploadModel? preUploadModel = await Get.dialog(
                            FirestorePreUploadDialog(values: values));
                        if (preUploadModel != null) {
                          Get.dialog(FirestoreUploadingDialog(
                            preUploadModel: preUploadModel,
                            fields: values.first,
                            values: values.sublist(1),
                          ), barrierDismissible: false);
                        }
                      }
                    }
                  }
                },
                label: const Text('Select CSV File'))
          ],
        ),
      ),
    );
  }
}

class PreUploadModel {
  final String collectionName;
  final int documentIdValue;

  PreUploadModel({required this.collectionName, required this.documentIdValue});

  @override
  String toString() =>
      'PreUploadModel( collectionName: $collectionName, documentIdValue: $documentIdValue)';
}
