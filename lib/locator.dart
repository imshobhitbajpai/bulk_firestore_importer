import 'package:bulk_firebase_importer/prefs_controller.dart';
import 'package:bulk_firebase_importer/presentation/firebase_dialogs/firestore_pre_upload_dialog.dart';
import 'package:bulk_firebase_importer/presentation/screens/home/file_processing_controller.dart';
import 'package:bulk_firebase_importer/presentation/screens/home/firestore_controller.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void initLocator() {
  locator.registerLazySingleton(() => FileProcessingController());
  locator.registerLazySingleton(() => MyPreferencesController());
  locator.registerLazySingleton(() => SelectionController());
  locator.registerLazySingleton(() => FirestoreController());
}
