library core;

import 'dart:async';

import 'package:core/controllers/report.controller.dart';
import 'package:core/controllers/system.controller.dart';
// import 'package:core/controllers/user.controller.dart';
import 'package:core/services/system.service.dart';
import 'package:core/sqllite/sqlite.dart' as sqlite;
import 'package:core/utils/search.dart' as search;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';

export 'package:get/get.dart';

export 'audio_manager.dart';
export 'capture.dart';
export 'constants.dart';
export 'controllers/delay.controller.dart';
export 'controllers/input.controller.dart';
export 'controllers/report.controller.dart';
export 'controllers/system.controller.dart';
// export 'controllers/user.controller.dart';
export 'extension.dart';
export 'extensions/number.dart';
export 'http.dart';
export 'input_controller.dart';
export 'log.dart';
export 'mixins/mixin.dart';
export 'models/user/model.dart';
export 'screens/dark_mode.screen.dart';
export 'screens/form.screen.dart';
export 'screens/menu.screen.dart';
export 'screens/report/report_list.screen.dart';
export 'screens/report/send_report_screen.dart';
export 'screens/select_language.screen.dart';
export 'screens/setting_schedule_notification.screen.dart';
export 'services/google.service.dart';
export 'services/notification.service.dart';
export 'services/storage.service.dart';
export 'services/system.service.dart';
export 'show_image_picker.dart';
export 'sqllite/sqlite.dart';
export 'time.dart';
export 'utils.dart';
export 'utils/cupertino.dart';
export 'utils/date.dart';
export 'utils/easy_localization.dart';
// export 'utils/database_helper.dart';
export 'utils/get_bg_mode.dart';
export 'utils/highlight_overlay.dart';
export 'utils/modal/modal.dart';
export 'utils/permission.dart';
export 'utils/pick_image.dart';
export 'utils/query_controller.dart';
export 'utils/search.dart';
export 'utils/show_list_account.dart';
export 'utils/string.dart';
export 'widgets/ad/ad_manager.dart';
export 'widgets/ad/adaptive_banner_ad.dart';
export 'widgets/animation/bounce_effect.dart';
export 'widgets/animation/heart_beat_effect.dart';
export 'widgets/animation/opacity_effect.dart';
export 'widgets/animation/ripple_effect.dart';
export 'widgets/animation/text_slimmer.dart';
export 'widgets/animation/zoom_fade_in.dart';
export 'widgets/app_bar.dart';
export 'widgets/autocomple.dart';
export 'widgets/avatar.dart';
export 'widgets/border_gradient.dart';
export 'widgets/bottom_bar_navigation.dart';
export 'widgets/button.dart';
export 'widgets/calendar.dart';
export 'widgets/checkbox.dart';
export 'widgets/chip.dart';
export 'widgets/dropdown.dart';
export 'widgets/empty.dart';
export 'widgets/enterprise/enterprise.dart';
export 'widgets/future_builder.dart';
export 'widgets/grid.dart';
export 'widgets/highlight_tap.dart';
export 'widgets/horizontal_scroll.dart';
export 'widgets/icon_back.dart';
export 'widgets/icon_button.dart';
export 'widgets/input.dart';
export 'widgets/input_calendar.dart';
export 'widgets/input_field.dart';
export 'widgets/input_search.dart';
export 'widgets/input_time.dart';
export 'widgets/list_view.dart';
export 'widgets/menu.dart';
export 'widgets/menu_item.dart';
export 'widgets/opacity_tap.dart';
export 'widgets/otp_input_field.dart';
export 'widgets/page_view.dart';
export 'widgets/radio.dart';
export 'widgets/rating.dart';
export 'widgets/reorderlistview.dart';
export 'widgets/screen_loading.dart';
export 'widgets/select.dart';
export 'widgets/skeleton.widget.dart';
export 'widgets/slider.dart';
export 'widgets/step.dart';
export 'widgets/switch.dart';
export 'widgets/tab.dart';
export 'widgets/table.dart';
export 'widgets/tag.dart';
export 'widgets/title.dart';
// print(search.Search)

Future<void> init<T extends GetxController>({
  FirebaseOptions? firebaseOptions,
  List<sqlite.SqlTable> tables = const [],
  FutureOr<void> Function()? future,
  // List<GetxController Function()> controllers = const [],
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
    clearTempFile(),
    () async {
      await future?.call();
    }()
  ]);

  final systemController = SystemController(SystemService());
  // final authController = AuthController();
  // final userController = UserController();

  Get.put(systemController);
  // Get.put(authController);
  // Get.put(userController);

  Get.put(ReportController());
  // for (var controller in controllers) {
  //   // print('controller: ${controller.runtimeType}');
  //   Get.put(controller());
  // }

  await systemController.loadSettings();
  // authController.loadToken();
  // userController.loadUser();
}

void setupApp({
  required List<Locale> supportedLocales,
  Locale? fallbackLocale,
  String? locales,
  Translations? translations,
  AssetLoader? localeLoader,
  required Widget child,
  Function()? onInit,
}) {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    await onInit?.call();

    runApp(EasyLocalization(
      supportedLocales: supportedLocales,
      assetLoader: localeLoader ?? RootBundleAssetLoader(),
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

class CoreBase {
  String storageHost = "https://img.gymsocial.vn";
}

var Core = CoreBase();

// class AppTranslations extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//         'en_US': loadJson('assets/lang/en_US.json'),
//         'vi_VN': loadJson('assets/lang/vi_VN.json'),
//       };

//   Map<String, String> loadJson(String path) {
//     final jsonStr = rootBundle.loadString(path);
//     // Nhưng đây là async → Bạn cần chuyển qua GetX service để load trước
//     return {};
//   }
// }

var _tr = tr;

extension Trans on String {
  String get tr {
    return _tr(this);
  }

  String trParams(Map<String, String> namedArgs) {
    return _tr(this, namedArgs: namedArgs);
  }
}

class ValueScope<T> extends InheritedWidget {
  final T value;
  const ValueScope({super.key, required this.value, required super.child});

  @override
  bool updateShouldNotify(covariant ValueScope<T> oldWidget) {
    return oldWidget.value != value;
  }

  static ValueScope<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ValueScope<T>>();
  }
}

extension ValueScopeExtension on BuildContext {
  T? valueScope<T>() {
    return ValueScope.of<T>(this)?.value;
  }
}

Future<void> clearTempFile() async {
  final tempDir = await getTemporaryDirectory();
  final files = tempDir.listSync();

  for (var file in files) {
    if (file.path.endsWith('.m4a')) {
      await file.delete();
    }
  }
}
