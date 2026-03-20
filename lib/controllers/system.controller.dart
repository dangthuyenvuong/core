import 'package:core/extensions/map.dart';
import 'package:core/services/system.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SystemController extends GetxController with WidgetsBindingObserver {
  final deviceId = ''.obs;
  final deviceName = ''.obs;
  final deviceVersion = ''.obs;
  final firebasePushToken = 'no-token'.obs;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final isAppVisible = true.obs;
  // final enabledCaptureScreen = false.obs;

  // final screenshotKey = GlobalKey();

  final Rx<ThemeMode> _themeMode = Rx<ThemeMode>(ThemeMode.system);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<GlobalKey<NavigatorState>> navigatorKeys = [];

  final Map<String, GlobalKey<NavigatorState>> navigatorMap = {};

  final Map<String, int> _navigatorIndexMap = {};

  SystemController(this._systemService);
  final SystemService _systemService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode.value;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode.value = await _systemService.themeMode();

    // Important! Inform listeners a change has occurred.
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode.value = newThemeMode;

    // Important! Inform listeners a change has occurred.

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _systemService.updateThemeMode(newThemeMode);
  }

  Future<void> toggleTheme() async {
    _themeMode.value =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await _systemService.updateThemeMode(_themeMode.value);
  }

  void initNavigatorKey(int count) {
    for (int i = 0; i < count; i++) {
      navigatorKeys.add(GlobalKey<NavigatorState>());
    }
  }

  GlobalKey<NavigatorState> getNavigatorKey(int index) {
    return navigatorKeys[index];
  }

  GlobalKey<NavigatorState> getNavigator(String key) {
    if (navigatorMap[key] == null) {
      // navigatorMap[key] = GlobalKey<NavigatorState>();

      // navigatorIndexMap
      navigatorMap[key] = Get.nestedKey(navigatorMap.length + 1)!;

      _navigatorIndexMap[key] = navigatorMap.length;
    }

    return navigatorMap[key]!;
  }

  void to(
      {required String id,
      Widget? page,
      String? routeName,
      Map<String, String>? arguments}) {
    // getNavigator(id).currentState.pushNamed(routeName)
    if (routeName != null) {
      getNavigator(id).currentState?.pushNamed(routeName, arguments: arguments);
    }

    if (page != null) {
      getNavigator(id).currentState?.push(MaterialPageRoute(
          builder: (context) => page,
          settings: RouteSettings(arguments: arguments)));
    }
  }

  void popToFirst(String id) {
    Get.back(id: _navigatorIndexMap[id]);
    // getNavigator(id).currentState?.pop((route) => route.isFirst);
  }

  Map<String, String?> params(BuildContext context) {
    final _params = ModalRoute.of(context)?.settings.arguments;

    return _params ?? Get.arguments ?? Get.parameters ?? {};
  }

  // void clearNavigator() {
  //   navigatorMap.clear();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isAppVisible.value = state == AppLifecycleState.resumed;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
