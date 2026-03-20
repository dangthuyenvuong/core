import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FieldItem {
  final String label;
  final String? hint;
  final String? type;
  final String? placeholder;
  final Widget? trailing;
  final String? icon;
  final int? maxLength;
  final List<Rule>? rules;
  final String defaultValue;
  final String name;

  FieldItem({
    required this.name,
    required this.label,
    this.hint,
    this.type,
    this.placeholder,
    this.trailing,
    this.icon,
    this.maxLength,
    this.rules,
    this.defaultValue = '',
  });
}

class FormScreen extends StatefulWidget {
  const FormScreen({
    super.key,
    required this.fields,
    this.title,
    this.onSave,
  });

  final List<FieldItem> fields;
  final String? title;
  final Future<bool?> Function(dynamic value)? onSave;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  bool enabledSave = false;
  final List<InputController> controllers = [];
  final Map<String, String> values = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      controllers.add(
          InputController(rules: field.rules ?? [], value: field.defaultValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SAppBar(
          padding: EdgeInsets.only(left: 16, right: 16),
          titleCenter: true,
          leading: OpacityTap(
            child: Text(tr("Cancel"),
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: widget.title != null
              ? Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                )
              : null,
          actions: [
            OpacityTap(
              disabled: !enabledSave,
              child: Text(tr("Save"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: enabledSave ? Constant.red : Colors.grey,
                  )),
              onTap: () async {
                if (widget.onSave != null) {
                  final isTrue = await widget.onSave?.call(values);
                  if (isTrue == null || isTrue == true) {
                    Navigator.pop(context);
                  }
                }
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(Spacing.medium),
          child: Column(
            children: List.generate(widget.fields.length, (index) {
              final field = widget.fields[index];
              return InputField(
                autofocus: index == 0,
                hintText: field.placeholder ?? field.hint ?? '',
                labelText: field.label,
                maxLength: field.maxLength,
                controller: controllers[index].controller,
                onChanged: (value) {
                  values[field.name] = value;
                  setState(() {
                    enabledSave = field.defaultValue != value;
                  });
                },
                trailing: field.trailing != null ? [field.trailing!] : null,
              );
            }),
          ),
        ));
  }
}
