import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final color = isDarkMode
    //     ? Colors.white.withAlpha(15)
    //     : Theme.of(context).colorScheme.onSurface;


    final bg = getBgMode(context);

    final descriptionColor =
        Theme.of(context).colorScheme.onSurface.withAlpha(150);
    return Scaffold(
      appBar: SAppBar(
        leading: SIconBack(),
        title: Text('Danh sách góp ý và báo lỗi'),
        actions: [
          SIconButton(
            // svgPath: 'assets/images/svg/plus.svg',
            child: Icon(Icons.add),
            onTap: () {
              Get.to(() => ReportScreen(isFromList: true));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Spacing.medium, vertical: Spacing.large),
            child: Column(
              spacing: Spacing.small,
              children: List.generate(
                20,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(Spacing.small),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Spacing.small),
                    onTap: () {
                      // Get.to(() => ReportScreen());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.medium,
                        vertical: Spacing.small,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: Spacing.xSmall,
                            children: [
                              Text(
                                'Góp ý báo lỗi $index',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text('Ngày gửi: 12/01/2025',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: descriptionColor,
                                  )),
                            ],
                          )),
                          _Status(
                            status: 'Bị từ chối',
                            color: Colors.red
                          ),
                          // SvgPicture.asset(
                          //   'assets/images/svg/chevron-right.svg',
                          //   colorFilter: ColorFilter.mode(
                          //       descriptionColor, BlendMode.srcIn),
                          // ),
                        ],
                      ),
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

class _Status extends StatelessWidget {
  final String status;
  final Color color;
  const _Status({
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.small,
        vertical: Spacing.xSmall,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
