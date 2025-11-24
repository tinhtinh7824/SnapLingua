import 'package:flutter_test/flutter_test.dart';
import 'package:snaplingua/app/data/services/realm_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Realm service initializes without throwing', () async {
    await RealmService.init();
  });
}
