import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  ReportDetailScreen({super.key});

  // Mock data for demonstration
  final _reportStatus =
      "Đang xử lý"; // Có thể là: Đã nhận, Đang xử lý, Đã đóng, Đã phản hồi
  final _reportContent =
      "Ứng dụng bị lỗi khi nhấn vào nút Gửi ở màn hình đăng nhập. Mong admin xem xét và sửa lỗi này sớm.";
  final _reportImages = <String>[
    // Fake asset URLs or network urls for preview
   "https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=900",
   "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=900",
  ];
  final _submitDate = "12/01/2025 12:58"; // dd/MM/yyyy HH:mm

  // Mock timeline data
  final List<Map<String, dynamic>> _timelines = [
    {
      "label": "Báo cáo đã gửi",
      "content": "Người dùng đã gửi báo cáo.",
      "date": "12/01/2025 12:58",
      "by": "Bạn"
    },
    {
      "label": "Admin đã phản hồi",
      "content": "Chúng tôi đã tiếp nhận và đang xem xét lỗi bạn báo.",
      "date": "12/01/2025 14:15",
      "by": "Admin"
    },
    {
      "label": "Đang xử lý",
      "content": "Bộ phận kỹ thuật đang kiểm tra vấn đề.",
      "date": "12/01/2025 16:30",
      "by": "Admin"
    },
  ];

  // Nếu status là Đã đóng, mock một timeline đóng
  final Map<String, dynamic> _closeTimeline = {
    "label": "Báo cáo đã đóng",
    "content": "Yêu cầu đã được xử lý. Cám ơn bạn đã gửi phản hồi!",
    "date": "13/01/2025 09:17",
    "by": "Admin"
  };

  // Helper for status chip
  Color _statusColor(String status, BuildContext context) {
    switch (status) {
      case "Đã đóng":
        return Constant.green;
      case "Đang xử lý":
        return Constant.orange;
      case "Đã nhận":
        return Colors.blueGrey;
      case "Đã phản hồi":
        return Constant.blue;
      default:
        return Theme.of(context).colorScheme.onSurface.withAlpha(120);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isClosed = _reportStatus == "Đã đóng";
    final timelineList = List<Map<String, dynamic>>.from(_timelines)
      ..addAll(isClosed ? [_closeTimeline] : []);

    return Scaffold(
      appBar: SAppBar(
        leading: SIconBack(),
        padding: EdgeInsets.only(right: Spacing.medium),
        title: Text(
          'Chi tiết góp ý và báo lỗi',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          SChip(
            bgColor: _statusColor(_reportStatus, context),
            child: Text(_reportStatus, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(Spacing.medium),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trạng thái báo cáo
              // Row(
              //   children: [
              //     Text("Trạng thái:",
              //         style: TextStyle(color: onSurface.withAlpha(100))),
              //     SizedBox(width: 8),
              //     SChip(
              //       bgColor: _statusColor(_reportStatus, context),
              //       child: Text(_reportStatus,
              //           style: TextStyle(color: Colors.white)),
              //     ),
              //     // Chip(
              //     //   label: Text(
              //     //     _reportStatus,
              //     //     style: TextStyle(
              //     //         color: Colors.white, fontWeight: FontWeight.bold),
              //     //   ),
              //     //   backgroundColor: _statusColor(_reportStatus, context),
              //     //   visualDensity: VisualDensity.compact,
              //     // ),
              //   ],
              // ),
              // SizedBox(height: Spacing.medium),

              // Nội dung báo cáo
              Text("Nội dung báo cáo",
                  style: TextStyle(color: onSurface.withAlpha(100))),
              SizedBox(height: 4),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(Spacing.small),
                ),
                // padding: EdgeInsets.all(Spacing.small),
                child: Text(_reportContent, style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: Spacing.small),

              // Hình ảnh gửi lên
              if (_reportImages.isNotEmpty) ...[
                SizedBox(height: 8),
                Text("Hình ảnh đính kèm",
                    style: TextStyle(color: onSurface.withAlpha(100))),
                SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: Spacing.medium,
                    children: _reportImages
                        .map(
                          (img) => ReportImageItem(imageUrl: img),
                        )
                        .toList(),
                  ),
                ),
              ],
              SizedBox(height: Spacing.small),

              // Ngày gửi
              Row(
                children: [
                  Icon(Icons.send_time_extension_outlined,
                      size: 18, color: onSurface.withAlpha(120)),
                  SizedBox(width: 6),
                  Text(
                    "Ngày gửi: $_submitDate",
                    style: TextStyle(
                        fontSize: 13, color: onSurface.withAlpha(150)),
                  )
                ],
              ),
              SizedBox(height: Spacing.large),

              // Timeline phản hồi admin
              Text(
                "Phản hồi và xử lý",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              SizedBox(height: Spacing.large),
              Timeline(timelines: timelineList),
              SizedBox(height: Spacing.large),

              // Action buttons: Chỉ cho phép nếu chưa đóng
              if (!isClosed)
                Row(
                  children: [
                    Expanded(
                      child: SButton(
                        rounded: true,
                        color: ButtonColor.red,
                        child: Text("Đóng báo cáo"),
                        icon: CupertinoIcons.xmark,
                        onTap: () {
                          // Nên xác nhận trước khi đóng
                          Modal.showAlertDialog(
                              context: context,
                              title: "Xác nhận đóng báo cáo",
                              message: "Bạn chắc chắn muốn đóng báo cáo này?",
                              actions: [
                                CupertinoDialogAction(
                                  child: Text("Hủy"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoDialogAction(
                                  child: Text("Đồng ý"),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Handle close report
                                  },
                                )
                              ]);
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SButton(
                        rounded: true,
                        color: ButtonColor.grey,
                        child: Text("Thêm nội dung"),
                        onTap: () {
                          // Show bottom sheet hoặc chuyển sang màn hình thêm nội dung
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Timeline widget thể hiện các mốc thay đổi/trả lời report
class Timeline extends StatelessWidget {
  const Timeline({super.key, required this.timelines});
  final List<Map<String, dynamic>> timelines;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: List.generate(
        timelines.length,
        (idx) {
          final item = timelines[idx];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dot và line
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: idx == 0
                          ? Constant.red
                          : (item['by'] == 'Admin'
                              ? Constant.blue
                              : Constant.grey),
                      // border: Border.all(
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                  if (idx < timelines.length - 1)
                    Container(
                      width: 1,
                      height: 60,
                      color: Constant.grey.withAlpha(120),
                    ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["label"] ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      if (item["content"] != null &&
                          item["content"].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          child: Text(item["content"],
                              style: TextStyle(
                                  fontSize: 13,
                                  color: onSurface.withAlpha(170))),
                        ),
                      Row(
                        children: [
                          Text(
                            item["by"] ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Constant.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.access_time,
                              size: 12, color: onSurface.withAlpha(100)),
                          SizedBox(width: 3),
                          Text(item["date"] ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: onSurface.withAlpha(120),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
