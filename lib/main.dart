import 'package:bulk_firebase_importer/locator.dart';
import 'package:bulk_firebase_importer/prefs_controller.dart';
import 'package:bulk_firebase_importer/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle("Bulk CSV to Firestore Importer");
  setWindowMinSize(const Size(640, 360));
  initLocator();
  locator<MyPreferencesController>().prefs =
      await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  static const String tag = "MyHomePage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bulk CSV to Firestore Importer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const Text(
                'Steps -',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      '1. Make sure you have the field name written in the first row of your csv file.')),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    '2. Change your Firestore security rules temporary to write the documents in the desired collection.\n    allow write: if collectionName == "your_collection_name";'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    '3. You will be charged according to the Firestore pricing for writing the documents. Please check Firestore Pricing and free quota.'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('4. Enter your Firebase Project details..'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor.withAlpha(50)),
                    child: const FirebaseCredentialsEntryWidget()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
