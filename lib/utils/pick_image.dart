import 'dart:io';

import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:video_compress/video_compress.dart';

final ImagePicker _picker = ImagePicker();

void _onSelected(
  ImageSource source,
  Function(File) onUpload,
) async {
  final pickedFile = await _picker.pickImage(source: source);
  if (pickedFile != null) {
    final file = File(pickedFile.path);
    final xFile = await resizeImage(file, width: 800);
    final _file = File(xFile.path);
    final value = onUpload.call(_file);
    if (value is Future<void>) {
      await value;
    }
  } else {
    // print("No image selected.");
    // widget.onUpload?.call(null);
  }
}

class FileUtils {
  static void _selectMultiFile(
    Function(List<File>) onUpload,
  ) async {
    final pickedFile = await _picker.pickMultipleMedia();
    final files = pickedFile.map((e) => File(e.path)).toList();

    if (pickedFile.isNotEmpty) {
      final files = pickedFile.map((e) => File(e.path)).toList();
      final xFiles =
          await Future.wait(files.map((file) => resizeImage(file, width: 800)));
      final _files = xFiles.map((file) => File(file.path)).toList();
      final value = onUpload.call(_files);
      if (value is Future<void>) {
        await value;
      }
    } else {
      // print("No image selected.");
      // widget.onUpload?.call(null);
    }
  }

  static Future<File?> pickVideo(ImageSource source,
      {VideoQuality? quality}) async {
    final pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (quality != null) {
        return await file.compressVideo(quality: quality);
      }
      return file;
    }
    return null;
  }

  static Future<List<File>> pickMultiVideo({VideoQuality? quality}) async {
    final pickedFile = await _picker.pickMultiVideo();
    var files = pickedFile.map((e) => File(e.path)).toList();

    if (quality != null) {
      for (var i = 0; i < files.length; i++) {
        files[i] = (await files[i].compressVideo(quality: quality))!;
      }

      files = files.whereType<File>().toList();

      // return (await Future.wait(
      //         files.map((file) => file.compressVideo(quality: quality))))
      //     .whereType<File>()
      //     .toList();
    }
    return files;
  }

  static Future<File?> pickImage(ImageSource source,
      {int? width, int? height}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (width != null || height != null) {
        final xFile = await resizeImage(file, width: width, height: height);
        return File(xFile.path);
      }
      return file;
    }
    return null;
  }

  static Future<List<File>> pickMultiImage({int? width, int? height}) async {
    final pickedFile = await _picker.pickMultiImage();
    final files = pickedFile.map((e) => File(e.path)).toList();

    if (width != null || height != null) {
      final xFiles = await Future.wait(
          files.map((file) => resizeImage(file, width: width, height: height)));
      return xFiles.map((file) => File(file.path)).toList();
    }

    return files;
  }

  static Future<File?> pickMedia(
      {int? width, int? height, VideoQuality? quality}) async {
    final pickedFile = await _picker.pickMedia(imageQuality: 80);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (detectVideo(pickedFile.path)) {
        if (quality != null) {
          return await file.compressVideo(quality: quality);
        }
        return file;
      }

      if (width != null || height != null) {
        final xFile = await resizeImage(file, width: width, height: height);
        return File(xFile.path);
      }
      return file;
    }
    return null;
  }

  static Future<List<File>> pickMultiMedia(
      {int? width, int? height, VideoQuality? quality}) async {
    final pickedFile = await _picker.pickMultipleMedia();
    final files = <File>[];

    var videos = pickedFile.where((e) => detectVideo(e.path)).toList();
    var images = pickedFile.where((e) => detectImage(e.path)).toList();
    await Future.wait([
      () async {
        for (var i = 0; i < videos.length; i++) {
          final _video =
              await File(videos[i].path).compressVideo(quality: quality);
          if (_video != null) {
            files.add(_video);
          }
        }
      }(),
      () async {
        await Future.wait(images.map((xfile) async {
          var file = File(xfile.path);
          // if (detectVideo(xfile.path)) {
          //   if (quality != null) {
          //     final newFile = await file.compressVideo(quality: quality);
          //     if (newFile != null) {
          //       file = newFile;
          //     }
          //   }
          //   files.add(file);
          // } else {
          if (width != null || height != null) {
            final xFile = await resizeImage(file, width: width, height: height);
            files.add(File(xFile.path));
          } else {
            files.add(file);
          }
          // }
        }));
      }(),
    ]);
    return files;
  }

  static pick({
    // required BuildContext context,
    required Function(List<File> files) onUpload,
    String? title,
    bool isMulti = false,
    bool isVideo = false,
    bool isMedia = false,
    bool isImage = true,
    int? width,
    int? height,
    VideoQuality? quality,
  }) {
    showModalBottomSheet(
      context: Get.context!,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CupertinoActionSheet(
        title: Text(title ?? tr("Image picker")),
        actions: [
          CupertinoActionSheetAction(
            child: Text(tr("Camera")),
            onPressed: () async {
              Navigator.pop(context);
              File? file;
              if (isVideo) {
                file = await pickVideo(ImageSource.camera);
              } else {
                file = await pickImage(ImageSource.camera);
              }
              if (file != null) {
                onUpload.call([file]);
              }
            },
          ),
          CupertinoActionSheetAction(
            child: Text(tr("Select from library")),
            onPressed: () async {
              Navigator.pop(context);
              List<File> files = [];
              if (isMulti) {
                if (isMedia) {
                  files = await pickMultiMedia(
                      width: width, height: height, quality: quality);
                } else if (isVideo) {
                  files = await pickMultiVideo(quality: quality);
                } else {
                  files = await pickMultiImage(width: width, height: height);
                }
              } else {
                if (isMedia) {
                  final file = await pickMedia(
                      width: width, height: height, quality: quality);
                  if (file != null) {
                    files = [file];
                  }
                } else if (isVideo) {
                  final file =
                      await pickVideo(ImageSource.gallery, quality: quality);
                  if (file != null) {
                    files = [file];
                  }
                } else {
                  final file = await pickImage(ImageSource.gallery,
                      width: width, height: height);
                  if (file != null) {
                    files = [file];
                  }
                }
              }

              onUpload.call(files);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(tr("Cancel")),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

Future<void> pickImage({
  required BuildContext context,
  required Function(File) onUpload,
  String? title,
}) async {
  showModalBottomSheet(
    context: Get.context!,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CupertinoActionSheet(
      title: Text(title ?? tr("Image picker")),
      actions: [
        CupertinoActionSheetAction(
          child: Text(tr("Camera")),
          onPressed: () {
            Navigator.pop(context);
            _onSelected(ImageSource.camera, onUpload);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(tr("Select from library")),
          onPressed: () {
            Navigator.pop(context);
            _onSelected(ImageSource.gallery, onUpload);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(tr("Cancel")),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}

extension FileX on File {
  String get nameWithoutExtension => path.split('/').last.split('.').first;
  String get extension => path.split('/').last.split('.').last;
  String get name => path.split('/').last;
  String get pathWithoutName {
    final list = path.split("/");
    list.removeLast();
    return list.join("/");
  }

  Future<XFile> resizeImage(File file,
      {int? width, int? height, int quality = 85}) async {
    final dir = await getTemporaryDirectory();

    final targetPath = p.join(
      dir.path,
      "compressed_${file.nameWithoutExtension}.${file.extension}",
    );

    late XFile? result;

    if (width != null) {
      result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality, // 0–100
        minWidth: width,
        format: CompressFormat.jpeg,
      );
    } else if (height != null) {
      result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality, // 0–100
        minHeight: height,
        format: CompressFormat.jpeg,
      );
    } else {
      assert(false, "Width or height must be provided");
    }

    return result!;
  }

  Future<File?> compressVideo({VideoQuality? quality}) async {
    final result = await VideoCompress.compressVideo(
      path,
      quality: quality ?? VideoQuality.MediumQuality,
      deleteOrigin: false,
    );

    return result?.file;
  }
}

Future<XFile> resizeImage(File file,
    {int? width, int? height, int quality = 85}) async {
  final dir = await getTemporaryDirectory();

  final targetPath = p.join(
    dir.path,
    "compressed_${file.nameWithoutExtension}.${file.extension}",
  );

  late XFile? result;

  if (width != null) {
    result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality, // 0–100
      minWidth: width,
      format:
          file.extension == "png" ? CompressFormat.png : CompressFormat.jpeg,
    );
  } else if (height != null) {
    result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality, // 0–100
      minHeight: height,
      format:
          file.extension == "png" ? CompressFormat.png : CompressFormat.jpeg,
    );
  } else {
    assert(false, "Width or height must be provided");
  }

  return result!;
}

bool detectVideo(String path) {
  final mimeType = lookupMimeType(path);

  if (mimeType == null) {
    print('Unknown type');
    return false;
  }

  return mimeType.startsWith('video/');

  // if (mimeType.startsWith('image/')) {
  //   print('This is IMAGE');
  // } else if (mimeType.startsWith('video/')) {
  //   print('This is VIDEO');
  // } else if (mimeType.startsWith('audio/')) {
  //   print('This is AUDIO');
  // } else {
  //   print('Other file type');
  // }
}

bool detectImage(String path) {
  final mimeType = lookupMimeType(path);

  if (mimeType == null) {
    print('Unknown type');
    return false;
  }

  return mimeType.startsWith('image/');

  // if (mimeType.startsWith('image/')) {
  //   print('This is IMAGE');
  // } else if (mimeType.startsWith('video/')) {
  //   print('This is VIDEO');
  // } else if (mimeType.startsWith('audio/')) {
  //   print('This is AUDIO');
  // } else {
  //   print('Other file type');
  // }
}
