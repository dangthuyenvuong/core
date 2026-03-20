import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendReportScreen extends StatefulWidget {
  const SendReportScreen({
    super.key,
    this.images,
    this.allowRemoveImage = true,
    this.allowAddImage = true,
    this.title,
    this.clearImages = true,
    this.leading,
    this.trailing,
    this.isFromList = false,
  });
  final List<Uint8List>? images;
  final bool allowRemoveImage;
  final bool allowAddImage;
  final String? title;
  final bool clearImages;
  final Widget? leading;
  final Widget? trailing;
  final bool isFromList;

  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  final reportController = Get.find<ReportController>();
  bool enabledSend = false;
  final images = <Uint8List>[];
  late InputController contentController;

  @override
  void initState() {
    super.initState();
    if (widget.images != null) {
      images.addAll(widget.images!);
    } else {
      images.addAll(reportController.images);
    }
    contentController = InputController(value: reportController.content.value);

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
        titleCenter: true,
        padding: EdgeInsets.only(left: Spacing.medium, right: Spacing.medium),
        leading: OpacityTap(
          child:
              Text("Cancel".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            if (!enabledSend) {
              _quit();
              return;
            }

            Modal.showAlertDialog(
                context: context,
                title: 'Cancel when not complete?'.tr,
                message:
                    'Your feedback helps us improve SpaceEnglish. If you leave now, your report will not be sent.'
                        .tr,
                actions: [
                  CupertinoDialogAction(
                    child: Text('Cancel report'.tr),
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      _quit();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Continue editing'.tr),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]);

            // Modal.showWarningOutPage(
            //   context: context,
            //   title: 'Thoát khi chưa hoàn tất?',
            //   message:
            //       'Ý kiến đóng góp của bạn giúp chúng tôi cải thiện SpaceEnglish. Nếu bây giờ bạn rời đi, báo cáo của bạn sẽ không được gửi.',
            //   cancelText: 'Tiếp tục chỉnh sửa',
            //   confirmText: 'Bỏ báo cáo',
            //   onConfirm: () {
            //     _quit();
            //   },
            // );
          },
        ),
        title: Text(widget.title ?? "Feedback or report".tr,
            textAlign: TextAlign.center),
        actions: [
          OpacityTap(
            disabled: !enabledSend,
            child: Text("Send".tr,
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
              Text("Content feedback or report".tr,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SInput(
                // labelText: 'Nội dung góp ý hoặc báo lỗi',
                multiline: true,
                minLine: 1,
                maxLine: 100,
                // isMultiline: true,
                autofocus: true,
                controller: contentController,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.medium,
                children: [
                  Text('Attached images'.tr,
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
                            (index) => ReportImageItem(
                                image: images[index],
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
                    "You can take a screenshot of the error screen, we will review the document you sent and process it as soon as possible."
                        .tr,
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
                      Text('Upload Image'.tr),
                    ],
                  ),
                  onTap: () {
                    // showImagePicker(context: context);
                    showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        backgroundColor: Colors.transparent,
                        // barrierColor: Colors.black.withAlpha(100),
                        builder: (context) => CupertinoActionSheet(
                              title: Text('Upload Image'.tr),
                              actions: [
                                CupertinoActionSheetAction(
                                    child: Text('Capture Screen'.tr),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      GlobalOverlay().show(context);
                                      Navigator.pop(context);
                                      if (widget.isFromList) {
                                        Navigator.pop(context);
                                      }
                                    }),
                                CupertinoActionSheetAction(
                                    child: Text('Camera'.tr), onPressed: () {}),
                                CupertinoActionSheetAction(
                                    child: Text('Gallery'.tr),
                                    onPressed: () {}),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: Text('Cancel'.tr),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ));

                    // GlobalOverlay().show(context);
                    // Navigator.pop(context);
                    // if (widget.isFromList) {
                    //   Navigator.pop(context);
                    // }
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

class ReportImageItem extends StatelessWidget {
  const ReportImageItem({
    super.key,
    this.image,
    this.imageUrl,
    this.onTap,
  });

  final Uint8List? image;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
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
              BoxShadow(color: onSurface.withAlpha(50), spreadRadius: 1),
            ],
          ),
          width: 200,
          child:
              image != null ? Image.memory(image!) : Image.network(imageUrl!),
        ),
        if (onTap != null)
          Positioned(
            right: Spacing.small,
            top: Spacing.small,
            child: SIconButton(
              bgColor: onSurface.withAlpha(50),
              onTap: onTap,
              child: Icon(Icons.close),
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
                    'Cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.to(() => SendReportScreen());
                    hide();
                    // reportController.enabledCaptureScreen.value = false;
                  },
                ),
                SButton(
                  child: Text("Capture Screen".tr),
                  onTap: () async {
                    hide();
                    Future.delayed(Duration(milliseconds: 100), () async {
                      await Get.find<ReportController>().captureScreenshot();
                      Get.to(() => SendReportScreen());
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
