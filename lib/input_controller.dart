import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class Rule {
  String? validate(String value);
}

class InputController {
  late TextEditingController controller;
  final GlobalKey targetKey = GlobalKey();
  List<Rule> rules;
  late ValueNotifier<String?> error;
  // String value = '';
  bool isError = false;

  String get text => controller.text;
  // String? get error => _error.value;

  set text(String value) => controller.text = value;
  set value(String value) => controller.text = value;
  String get value => controller.text;

  InputController({this.rules = const [], value = ''}) {
    error = ValueNotifier(null);
    controller = TextEditingController(text: value);
  }

  void dispose() {
    error.dispose();
    controller.dispose();
  }

  void clear() {
    controller.clear();
  }

  bool validate() {
    var check = true;
    error.value = null;

    for (var rule in rules) {
      final err = rule.validate(value);
      if (err != null) {
        error.value = err;
        check = false;
        break;
      }
    }
    isError = check;
    return check;
  }

  void setError(String? error) {
    this.error.value = error;
  }

  String? getError() {
    return error.value;
  }

  void clearError() {
    error.value = null;
  }

  void setValue(String value) {
    // controller.text = value;
    this.value = value;
  }

  String getValue() {
    return value;
  }
}

class RequiredRule implements Rule {
  @override
  String? validate(String value) {
    return value.trim().isEmpty ? tr('This field is required') : null;
  }
}

class EmailRule implements Rule {
  @override
  String? validate(String value) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return !regex.hasMatch(value) ? tr('Email is invalid') : null;
  }
}

class FormController {
  Map<String, InputController> controllers;
  Function(Map<String, String> values)? onChanged;

  FormController({required this.controllers, this.onChanged}) {
    for (var controller in controllers.values) {
      controller.controller.addListener(() {
        onChanged
            ?.call(controllers.map((key, value) => MapEntry(key, value.text)));
      });
    }
  }

  bool validate({bool scrollToError = false}) {
    bool check = true;
    for (var controller in controllers.values) {
      if (!controller.validate()) {
        if (scrollToError) {
          Scrollable.ensureVisible(
            controller.targetKey.currentContext!,
            duration: kThemeAnimationDuration,
            curve: Curves.easeInOut,
          );
        }
        check = false;
      }
    }
    return check;
  }

  InputController get(String key) {
    return controllers[key]!;
  }
}
