import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key,
    this.images,
    this.allowRemoveImage = true,
    this.allowAddImage = true,
    this.title = 'Góp ý và báo lỗi',
    this.clearImages = true,
    this.leading,
    this.trailing,
    this.isFromList = false,
  });
  final List<Uint8List>? images;
  final bool allowRemoveImage;
  final bool allowAddImage;
  final String title;
  final bool clearImages;
  final Widget? leading;
  final Widget? trailing;
  final bool isFromList;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final reportController = Get.find<ReportController>();
  bool enabledSend = false;
  final images = <Uint8List>[];
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    if (widget.images != null) {
      images.addAll(widget.images!);
    } else {
      images.addAll(reportController.images);
    }
    contentController =
        TextEditingController(text: reportController.content.value);

    contentController.addListener(() {
      reportController.content.value = contentController.text;
      _checkEnabledSend();
    });

    _checkEnabledSend();
  }

  void _checkEnabledSend() {
    enabledSend = contentController.text.isNotEmpty || images.isNotEmpty;
    setState(() {});
  }

  void _quit() {
    reportController.clearForm();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: SAppBar(
        borderBottom: true,
        padding: EdgeInsets.only(left: Spacing.medium, right: Spacing.medium),
        leading: OpacityTap(
          child: Text("Hủy", style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            if (!enabledSend) {
              _quit();
              return;
            }

            Modal.showWarningOutPage(
              context: context,
              title: 'Thoát khi chưa hoàn tất?',
              message:
                  'Ý kiến đóng góp của bạn giúp chúng tôi cải thiện SpaceEnglish. Nếu bây giờ bạn rời đi, báo cáo của bạn sẽ không được gửi.',
              cancelText: 'Tiếp tục chỉnh sửa',
              confirmText: 'Bỏ báo cáo',
              onConfirm: () {
                _quit();
              },
            );
          },
        ),
        title: Text(widget.title, textAlign: TextAlign.center),
        actions: [
          OpacityTap(
            disabled: !enabledSend,
            child: Text("Gửi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: enabledSend ? Constant.red : Colors.grey,
                )),
            onTap: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.transparent,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: EdgeInsets.all(Spacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.leading != null)
                Padding(
                  padding: EdgeInsets.only(bottom: Spacing.small),
                  child: widget.leading!,
                ),
              InputField(
                labelText: 'Nội dung góp ý hoặc báo lỗi',
                isMultiline: true,
                autofocus: true,
                controller: contentController,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.medium,
                children: [
                  Text('Hình ảnh đính kèm',
                      style: TextStyle(
                        // fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  if (images.length > 0)
                    Padding(
                      padding: EdgeInsets.only(bottom: Spacing.medium),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: Spacing.medium,
                          children: List.generate(
                            images!.length,
                            (index) => _ImageItem(
                                image: images![index],
                                onTap: widget.allowRemoveImage
                                    ? () {
                                        images.removeAt(index);
                                        reportController.removeImage(index);
                                        _checkEnabledSend();
                                        setState(() {});
                                      }
                                    : null),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
                
              if (widget.allowAddImage)
                Text(
                    "Bạn có thể chụp ảnh màn hình bị lỗi, chúng tôi sẽ xem xét tài liệu bạn gửi và xử lý sớm nhất có thể.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                    )),
              if (widget.allowAddImage) ...[
                SizedBox(height: Spacing.medium),
                SButton(
                  width: double.infinity,
                  color: ButtonColor.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Icon(Icons.camera),
                      Text('Chụp ảnh màn hình'),
                    ],
                  ),
                  onTap: () {
                    // reportController.enabledCaptureScreen.value = true;
                    // Navigator.pop(context);
                    // if (widget.isFromList) {
                    //   Navigator.pop(context);
                    // }
                
                    GlobalOverlay().show(context);
                    Navigator.pop(context);
                    if (widget.isFromList) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
              if (widget.trailing != null) widget.trailing!,
              // SButton(
              //   child: Text('Gửi'),
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  const _ImageItem({
    super.key,
    required this.image,
    this.onTap,
  });

  final Uint8List image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(1),
          clipBehavior: Clip.hardEdge,
          // height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Spacing.large),
            // border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.surface,
                  spreadRadius: 1),
            ],
          ),
          width: 200,
          child: Image.memory(image),
        ),
        if (onTap != null)
          Positioned(
            right: Spacing.small,
            top: Spacing.small,
            child: SIconButton(
              bgColor: Theme.of(context).colorScheme.onSurface.withAlpha(50),
              svgPath: 'assets/images/svg/x.svg',
              onTap: onTap,
            ),
          )
      ],
    );
  }
}

class GlobalOverlay {
  static final GlobalOverlay _instance = GlobalOverlay._internal();
  factory GlobalOverlay() => _instance;
  GlobalOverlay._internal();

  OverlayEntry? _entry;

  void show(BuildContext context) {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 100,
        left: Spacing.medium,
        right: Spacing.medium,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(Spacing.medium),
            // width: 200,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(200),
              borderRadius: BorderRadius.circular(Spacing.small),
            ),
            // height: 100,
            child: Row(
              spacing: Spacing.medium,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SButton(
                  color: ButtonColor.grey,
                  child: Text(
                    'Hủy',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.to(() => ReportScreen());
                    hide();
                    // reportController.enabledCaptureScreen.value = false;
                  },
                ),
                SButton(
                  child: Text('Chụp ảnh màn hình'),
                  onTap: () async {
                    hide();
                    Future.delayed(Duration(milliseconds: 100), () async {
                      await Get.find<ReportController>().captureScreenshot();
                      Get.to(() => ReportScreen());
                    });

                    // reportController.enabledCaptureScreen.value = false;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }
}
