import 'package:bulk_firebase_importer/locator.dart';
import 'package:bulk_firebase_importer/prefs_controller.dart';
import 'package:bulk_firebase_importer/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirestorePreUploadDialog extends StatefulWidget {
  final List<List<dynamic>> values;
  const FirestorePreUploadDialog({super.key, required this.values});
  static const String tag = "FirestorePreUploadDialog";

  @override
  State<FirestorePreUploadDialog> createState() =>
      _FirestorePreUploadDialogState();
}

class _FirestorePreUploadDialogState extends State<FirestorePreUploadDialog> {
  late final TextEditingController collectionNameController;
  late final GlobalKey<FormState> collectionNameFormKey;

  @override
  void initState() {
    super.initState();
    collectionNameController = TextEditingController()
      ..text =
          locator<MyPreferencesController>().prefs!.getString('collection') ??
              '';
    collectionNameFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    collectionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List fields = widget.values.first;
    return AlertDialog(
      title: const Text('Ready to Upload'),
      icon: const Icon(Icons.upload),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  const Text('Total Documents Found: '),
                  Text(
                    '${widget.values.length - 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Fields Found: '),
                    for (int i = 0; i < fields.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                          label: Text(
                            fields[i].toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text('Document ID: '),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          final int value = locator<SelectionController>()
                              .selectedDocumentIDValue
                              .value;
                          return DropdownButton<int>(
                              value: value,
                              items: [
                                const DropdownMenuItem(
                                  value: 0,
                                  child: Text('Auto Create'),
                                ),
                                for (int i = 0; i < fields.length; i++)
                                  DropdownMenuItem(
                                    value: i + 1,
                                    child: Text(fields[i].toString()),
                                  )
                              ],
                              onChanged: (value) {
                                locator<SelectionController>()
                                    .selectedDocumentIDValue
                                    .value = value ?? 0;
                              });
                        }))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text('Collection Name: '),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: Form(
                          key: collectionNameFormKey,
                          child: TextFormField(
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? 'Please Enter the Collection Name'
                                      : value.contains('/')
                                          ? 'Can\'t contain a forward slash (/)'
                                          : null,
                              controller: collectionNameController,
                              decoration: const InputDecoration(
                                  hintText: 'users',
                                  border: OutlineInputBorder())),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: ElevatedButton.icon(
                    onPressed: () {
                      if (!(collectionNameFormKey.currentState != null &&
                          collectionNameFormKey.currentState!.validate())) {
                        return;
                      }
                      locator<MyPreferencesController>().prefs!.setString(
                          'collection', collectionNameController.text);
                      Get.back(
                          result: PreUploadModel(
                              collectionName: collectionNameController.text,
                              documentIdValue: locator<SelectionController>()
                                  .selectedDocumentIDValue
                                  .value));
                    },
                    icon: const Icon(Icons.upload_rounded),
                    label: const Text('Start Uploading')),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionController extends GetxController {
  RxInt selectedDocumentIDValue = 0.obs;
}
