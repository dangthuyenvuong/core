import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';

class LangOpt {
  String title;
  String code;

  LangOpt({required this.title, required this.code});
}

class ScreenSelectLanguage extends StatefulWidget {
  const ScreenSelectLanguage(
      {super.key,
      required this.languages,
      required this.defaultLanguage,
      this.onChanged});
  final List<LangOpt> languages;
  final String defaultLanguage;

  final Function(LangOpt value)? onChanged;

  @override
  State<ScreenSelectLanguage> createState() => _ScreenSelectLanguageState();
}

class _ScreenSelectLanguageState extends State<ScreenSelectLanguage> {
  late String selectedLanguage;
  bool enabledSave = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedLanguage = Get.locale?.languageCode ?? widget.defaultLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Constant.red;
    return Scaffold(
      appBar: SAppBar(
        borderBottom: true,
        padding: EdgeInsets.only(left: 16, right: 16),
        leading: OpacityTap(
          child:
              Text(tr("Cancel"), style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          OpacityTap(
            disabled: !enabledSave,
            child: Text(tr("Done"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: enabledSave ? Constant.red : Colors.grey,
                )),
            onTap: () async {
              // final newLocale = selectedLanguage == 'English'
              //     ? Locale('en', 'US')
              //     : Locale('vi', 'VN');
              await context.setLocale(Locale(selectedLanguage));
              Get.updateLocale(Locale(selectedLanguage));
              Navigator.pop(context);
              widget.onChanged?.call(widget.languages.firstWhere((element) => element.code == selectedLanguage));
            },
          )
        ],
        title: Text(tr('Select Language'), textAlign: TextAlign.center),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: List.generate(
              widget.languages.length,
              (index) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          Theme.of(context).colorScheme.onSurface.withAlpha(10),
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = widget.languages[index].code;
                      enabledSave = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.medium,
                      vertical: Spacing.medium,
                    ),
                    child: Row(
                      spacing: Spacing.small,
                      children: [
                        Expanded(
                          child: Text(
                            widget.languages[index].title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SRadio(
                          checked:
                              selectedLanguage == widget.languages[index].code,
                          // borderColor: selectedLanguage == _languages[index]
                          //     ? primaryColor
                          //     : isDarkMode
                          //         ? Colors.white.withAlpha(100)
                          //         : Colors.black.withAlpha(100),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
