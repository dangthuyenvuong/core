import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  String value = tr('Monthly');
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isYearly = value == tr('Yearly');

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.medium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          spacing: Spacing.small,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SAvatar(url: 'https://i.pravatar.cc/300', size: 32),
                            Text(
                              'Dang Thuyen Vuong',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // IconLogo(size: 100),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        Row(
                          spacing: Spacing.small,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/svg/sparkles.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                onSurface,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              tr("Upgrade to PRO"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                // color: Constant.blue,
                              ),
                            ),
                          ],
                        ),
                        // ShaderMask(
                        //   shaderCallback: (Rect bounds) {
                        //     return LinearGradient(
                        //       colors: [Colors.blue, Colors.deepPurpleAccent, Colors.purple],
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //     ).createShader(bounds);
                        //   },
                        //   child: Text(
                        //     tr("SpaceEnglish Pro"),
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //         fontSize: 30,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.white),
                        //   ),
                        // ),
                        SizedBox(height: 10),

                        // Text(
                        //   "Đẩy nhanh quá trình học của bạn với các tính năng nâng cao, không bị làm phiền bởi quảng cáo và cá nhân hóa với AI hỗ trợ",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     color: onSurface.withAlpha(200),
                        //     fontWeight: FontWeight.w300,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        SizedBox(height: 30),

                        // SChips(
                        //   chips: ['Monthly', 'Yearly'],
                        //   activeBgColor: Constant.green,
                        // ),
                        AnimatedToggleSwitch<String>.size(
                          current: value,
                          values: [tr('Monthly'), tr('Yearly')],
                          iconOpacity: 0.5,
                          selectedIconScale: 1,
                          animationDuration: kThemeAnimationDuration,
                          height: 35,
                          indicatorSize: const Size.fromWidth(90),
                          onChanged: (i) => setState(() => value = i),
                          // styleBuilder: (i) => ToggleStyle(),
                          iconBuilder: (item) {
                            return Text(
                              '$item',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                          style: ToggleStyle(
                            // backgroundColor: Colors.black,
                            indicatorColor: isDarkMode
                                ? Colors.black
                                : Colors.white,
                            borderColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(999),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black26,
                            //     spreadRadius: 1,
                            //     blurRadius: 2,
                            //     offset: Offset(0, 1.5),
                            //   ),
                            // ],
                          ),
                          // iconList: [...], you can use iconBuilder, customIconBuilder or iconList
                          // style: ToggleStyle(...), // optional style settings
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(Spacing.medium),
                          decoration: BoxDecoration(
                            color: Constant.green.withAlpha(20),
                            border: Border.all(
                              color: Constant.green,
                              // width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(Spacing.medium),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: Spacing.medium,
                            children: [
                              Row(
                                spacing: Spacing.small,
                                children: [
                                  Text(
                                    tr("PRO"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      // color: Constant.blue,
                                    ),
                                  ),
                                  if (isYearly)
                                    SChip(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Spacing.small,
                                        vertical: 3,
                                      ),
                                      bgColor: Constant.red,
                                      textColor: Colors.white,
                                      child: Text(
                                        tr("Save 30%"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: Spacing.xSmall,
                                children: [
                                  Text(
                                    '\$',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: onSurface.withAlpha(100),
                                    ),
                                  ),
                                  Text(
                                    '${isYearly ? '25' : '3'}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      // color: Constant.blue,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      'USD/\n${isYearly ? tr('year') : tr('month')}',
                                      // textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: onSurface.withAlpha(100),
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                tr(
                                  "Learn vocabulary faster and more effectively with AI, opening the door for you to the world of English",
                                ),
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: onSurface.withAlpha(200),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              _FeatureItem(
                                text: tr("Random flashcards without limit"),
                              ),
                              _FeatureItem(text: tr("No ads")),
                              _FeatureItem(text: tr("Auto input with AI")),
                              _FeatureItem(
                                text: tr("Sync between multiple devices"),
                              ),
                              _FeatureItem(text: tr("Learn even when offline")),

                              // _FeatureItem(
                              //   text: "Trò chuyện với AI",
                              // ),
                              // _FeatureItem(
                              //   text: "Tạo và chia sẻ khóa học cho nhiều người",
                              // ),
                              // _FeatureItem(
                              //   text:
                              //       "Nội dung chuyên sâu từ các giảng viên chuyên nghiệp đã được đánh giá",
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: Spacing.medium,
                    left: Spacing.medium,
                    right: Spacing.medium,
                  ),
                  child: Column(
                    children: [
                      SButton(
                        width: double.infinity,
                        rounded: true,
                        bgGradient: LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.deepPurpleAccent,
                            Colors.purple,

                            // Color(0xFF0228B22),
                            // Color(0xFF008080)
                          ],
                        ),
                        onTap: () {},
                        size: SSize.large,
                        child: Text(tr("Upgrade to PRO")),
                      ),
                      SizedBox(height: 10),
                      Text(
                        tr("Cancel anytime"),
                        style: TextStyle(
                          fontSize: 12,
                          color: onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: Spacing.medium,
              child: SIconButton(
                child: Icon(Icons.close, color: Colors.white),
                // bgColor: onSurface.withAlpha(20),
                // svgPath: 'assets/images/svg/x.svg',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      child: Row(
        spacing: Spacing.small,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Spacing.xSmall),
            decoration: BoxDecoration(
              color: Constant.green,
              borderRadius: BorderRadius.circular(999),
            ),
            // child: SvgPicture.asset(
            //   'assets/images/svg/check.svg',
            //   width: 12,
            //   colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            // ),
            child: Icon(Icons.check, color: Colors.white, size: 12),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: onSurface,
                // fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomToggleSwitch extends StatefulWidget {
  @override
  _CustomToggleSwitchState createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true); // Lặp đi lặp lại
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: (selectedIndex * 80).toDouble(),
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple, Colors.red],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0, _controller.value, 1],
                    ),
                  ),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Option ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
