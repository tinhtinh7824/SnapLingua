import 'package:realm/realm.dart';
// TODO: Uncomment when generated files are created
// import 'package:snaplingua/app/data/models/realm/user_realm.dart';
// import 'package:snaplingua/app/data/models/realm/word_realm.dart';
// import 'package:snaplingua/app/data/models/realm/personal_word_realm.dart';
// import 'package:snaplingua/app/data/models/realm/study_session_realm.dart';
// import 'package:snaplingua/app/data/models/realm/post_realm.dart';
// import 'package:snaplingua/app/data/models/realm/group_realm.dart';

class RealmConfig {
  static const String appId = 'snaplingua-app-id'; // Replace with your App ID
  static const String baseUrl = 'https://realm.mongodb.com';
  static const bool useAtlasSync = false; // Set to true when Atlas is configured

  // Local-only configuration for offline mode
  static Configuration get localConfig {
    return Configuration.local(
      [], // TODO: Add schemas when generated files are ready
      schemaVersion: 1,
      migrationCallback: (migration, oldSchemaVersion) {
        // Handle schema migrations
      },
    );
  }

  // Sync configuration (only used when Atlas is configured)
  // static Configuration getSyncConfig(User user) {
  //   return Configuration.flexibleSync(
  //     user,
  //     [
  //       User.schema,
  //       Word.schema,
  //       PersonalWord.schema,
  //       StudySession.schema,
  //       Post.schema,
  //       Group.schema,
  //     ],
  //   );
  // }

  static Realm? _realm;

  static Realm get realm {
    if (_realm == null) {
      throw Exception('Realm not initialized. Call RealmConfig.init() first');
    }
    return _realm!;
  }

  static Future<void> init({bool offlineMode = true}) async {
    // For now, always use local/offline mode until Atlas is configured
    _realm = Realm(localConfig);

    // TODO: Implement Atlas sync when configured
    // if (!offlineMode && useAtlasSync) {
    //   if (app == null) {
    //     _app = App(AppConfiguration(appId, baseUrl: Uri.parse(baseUrl)));
    //   }
    //   // Authenticate user and create synced realm
    //   // _realm = Realm(getSyncConfig(currentUser));
    //   // await _configureSubscriptions();
    // }
  }

  // TODO: Implement subscriptions when Atlas is configured
  // static Future<void> _configureSubscriptions() async {
  //   final realm = _realm!;
  //   // Subscribe to user's data
  //   realm.subscriptions.update((mutableSubscriptions) {
  //     // User's personal words
  //     mutableSubscriptions.add(
  //       realm.query<PersonalWord>('userId == \$0', [currentUserId]),
  //       name: 'userPersonalWords',
  //     );
  //     // ... other subscriptions
  //   });
  //   await realm.subscriptions.waitForSynchronization();
  // }

  static Future<void> close() async {
    _realm?.close();
    _realm = null;
  }
}
