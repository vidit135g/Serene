import '../WorkManagerService.dart';
import 'HabitLastRunDataProvider.dart';
import 'HabitMasterProvider.dart';
import 'HabitRunDataProvider.dart';
import 'NotificationProvider.dart';
import 'ServiceLastRunProvider.dart';
import 'SettingsProvider.dart';
import 'WorkManagerProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProviderFactory {
  //
  static var habitMasterProvider = HabitMasterProvider();
  static var habitRunDataProvider = HabitRunDataProvider();
  static var habitLastRunDataProvider = HabitLastRunDataProvider();
  static var serviceLastRunProvider = ServiceLastRunProvider();
  static var settingsProvider = SettingsProvider();
  static var notificationProvider = NotificationProvider();
  static var workManagerService = WorkManagerService();
  static var workManagerProvider = WorkManagerProvider();

  static Future<bool> init() async {
    await initDB();

    await workManagerProvider.init();
    await settingsProvider.init();

    // await MockDataFactory.create(
    //   daysToMock: 30,
    //   motivation: 0.75,
    // );

    return Future<bool>(() => true);
  }

  static Future<bool> initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();

    String path1 = join(documentsDirectory.path, 'clean_habits-1.db');
    await habitMasterProvider.open(path1);

    String path2 = join(documentsDirectory.path, 'clean_habits-2.db');
    await habitRunDataProvider.open(path2);

    String path3 = join(documentsDirectory.path, 'clean_habits-3.db');
    await habitLastRunDataProvider.open(path3);

    String path4 = join(documentsDirectory.path, 'clean_habits-4.db');
    await serviceLastRunProvider.open(path4);

    return Future<bool>(() => true);
  }

  static Future<bool> close() async {
    await habitMasterProvider.close();
    await habitRunDataProvider.close();
    await habitLastRunDataProvider.close();
    await serviceLastRunProvider.close();

    return Future<bool>(() => true);
  }
}
