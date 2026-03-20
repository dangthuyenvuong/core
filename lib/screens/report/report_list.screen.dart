import 'package:core/core.dart';
import 'package:core/screens/report/report_detail_screen.dart';
import 'package:flutter/material.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SAppBar(
        leading: SIconBack(),
        titleCenter: true,
        title: Text("Feedback and bug reporting".tr),
        actions: [
          SIconButton(
            // svgPath: 'assets/images/svg/plus.svg',
            child: Icon(Icons.add),
            onTap: () {
              Get.to(() => SendReportScreen(isFromList: true));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: Spacing.medium,
          right: Spacing.medium,
          bottom: Spacing.medium + MediaQuery.of(context).padding.bottom,
        ),
        children: List.generate(
          1,
          (index) => ReportItem(),
        ),
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  const ReportItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bg = getBgMode(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return OpacityTap(
      onTap: () {
        Core.to(ReportDetailScreen(), gestureWidthRatio: 0.8);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Spacing.small),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(Spacing.small),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: Spacing.medium,
            right: Spacing.small,
            top: Spacing.small,
            bottom: Spacing.small,
          ),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.xSmall,
                children: [
                  Text(
                    'Report title',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('Sent date: 12/01/2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: onSurface.withAlpha(100),
                      )),
                ],
              )),
              _Status(status: 'Processing', color: Colors.green),
              Icon(Icons.chevron_right, color: onSurface.withAlpha(100)),
              // SvgPicture.asset(
              //   'assets/images/svg/chevron-right.svg',
              //   colorFilter: ColorFilter.mode(
              //       descriptionColor, BlendMode.srcIn),
              // ),
            ],
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
