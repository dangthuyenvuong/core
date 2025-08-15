library core;

import 'package:core/controllers/auth.controller.dart';
import 'package:core/controllers/report.controller.dart';
import 'package:core/controllers/system.controller.dart';
import 'package:core/controllers/user.controller.dart';
import 'package:core/services/system.service.dart';
import 'package:core/utils/search.dart' as search;
import 'package:core/utils/sqlite.dart' as sqlite;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';

export 'package:get/get.dart';

export 'audio_manager.dart';
export 'capture.dart';
export 'constants.dart';
export 'controllers/auth.controller.dart';
export 'controllers/report.controller.dart';
export 'controllers/system.controller.dart';
export 'controllers/user.controller.dart';
export 'extension.dart';
export 'http.dart';
export 'input_controller.dart';
export 'log.dart';
export 'utils/modal/modal.dart';
export 'models/user/model.dart';
export 'screens/dark_mode.screen.dart';
export 'screens/form.screen.dart';
export 'screens/menu.screen.dart';
export 'screens/report/report.screen.dart';
export 'screens/report/report_list.screen.dart';
export 'screens/select_language.screen.dart';
export 'screens/setting_schedule_notification.screen.dart';
export 'services/auth.service.dart';
export 'services/notification.service.dart';
export 'services/storage.service.dart';
export 'services/system.service.dart';
export 'show_image_picker.dart';
export 'utils.dart';
export 'utils/cupertino.dart';
// export 'utils/database_helper.dart';
export 'utils/get_bg_mode.dart';
export 'utils/highlight_overlay.dart';
export 'utils/permission.dart';
export 'utils/query_controller.dart';
export 'utils/search.dart';
export 'utils/show_list_account.dart';
export 'utils/sqlite.dart';
export 'utils/string.dart';
export 'widgets/ad/ad_manager.dart';
export 'widgets/ad/adaptive_banner_ad.dart';
export 'widgets/animation/bounce_effect.dart';
export 'widgets/animation/opacity_effect.dart';
export 'widgets/animation/ripple_effect.dart';
export 'widgets/animation/zoom_fade_in.dart';
export 'widgets/animation/heart_beat_effect.dart';
export 'widgets/app_bar.dart';
export 'widgets/avatar.dart';
export 'widgets/border_gradient.dart';
export 'widgets/bottom_bar_navigation.dart';
export 'widgets/button.dart';
export 'widgets/calendar.dart';
export 'widgets/checkbox.dart';
export 'widgets/chip.dart';
export 'widgets/empty.dart';
export 'widgets/enterprise/emoji_dialog.dart';
export 'widgets/future_builder.dart';
export 'widgets/grid.dart';
export 'widgets/highlight_tap.dart';
export 'widgets/horizontal_scroll.dart';
export 'widgets/icon_button.dart';
export 'widgets/input.dart';
export 'widgets/input_field.dart';
export 'widgets/input_search.dart';
export 'widgets/list_view.dart';
export 'widgets/menu.dart';
export 'widgets/menu_item.dart';
export 'widgets/opacity_tap.dart';
export 'widgets/otp_input_field.dart';
export 'widgets/page_view.dart';
export 'widgets/radio.dart';
export 'widgets/rating.dart';
export 'widgets/screen_loading.dart';
export 'widgets/skeleton.widget.dart';
export 'widgets/step.dart';
export 'widgets/switch.dart';
export 'widgets/title.dart';
export 'utils/date.dart';
export 'widgets/dropdown.dart';
export 'widgets/enterprise/color_select.dart';
export 'widgets/tab.dart';
export 'controllers/input.controller.dart';
export 'time.dart';
// print(search.Search)

Future<void> init({
  FirebaseOptions? firebaseOptions,
  List<sqlite.SqlTable> tables = const [],
  List<GetxController> controllers = const [],
}) async {
  for (var table in tables) {
    sqlite.Sqlite.addTable(table);
  }
  sqlite.Sqlite.addTable(search.SearchTable);

  WidgetsFlutterBinding.ensureInitialized();

  // MobileAds.instance.initialize();
  await Future.wait([
    if (firebaseOptions != null)
      Firebase.initializeApp(options: firebaseOptions),
    EasyLocalization.ensureInitialized(),
    GetStorage.init(),
    sqlite.Sqlite.init(),
    dotenv.load(
      fileName: String.fromEnvironment('ENV', defaultValue: 'dev') == 'dev'
          ? '.env'
          : '.env.production',
    ),
  ]);

  final systemController = SystemController(SystemService());
  final authController = AuthController();
  final userController = UserController();

  Get.put(systemController);
  Get.put(authController);
  Get.put(userController);

  Get.put(ReportController());
  for (var controller in controllers) {
    Get.put(controller);
  }

  await systemController.loadSettings();
  authController.loadToken();
  userController.loadUser();
}

void setupApp({
  required List<Locale> supportedLocales,
  Locale? fallbackLocale,
  required Widget child,
}) {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/locales',
      fallbackLocale: fallbackLocale,
      child: child,
    ));
  });
}

Locale getDefaultLocale({
  required List<Locale> supportedLocales,
  required Locale fallbackLocale,
}) {
  Locale defaultLocale =
      WidgetsBinding.instance.platformDispatcher.locales.firstWhere(
    (locale) => supportedLocales.contains(locale),
    orElse: () => fallbackLocale,
  );

  return defaultLocale;
}
