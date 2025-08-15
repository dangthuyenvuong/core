import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:love_journal/src/models/reaction/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<Emoji>> _loadEmoji() async {
  final emojiJson = await rootBundle.loadString('assets/json/emoji.json');
  final emojis = jsonDecode(emojiJson);
  return emojis.map<Emoji>((e) => Emoji.fromJson(e)).toList();
}

class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    this.onSend,
    this.replyUser,
    this.replyMessage,
    this.onCloseReply,
    this.bg,
  });
  final Function(String)? onSend;
  final String? replyUser;
  final String? replyMessage;
  final Function()? onCloseReply;
  final Color? bg;

  @override
  State<MessageInput> createState() => MessageInputState();

  // 👉 Static helper
  static MessageInputState? of(BuildContext context) {
    return context.findAncestorStateOfType<MessageInputState>();
  }
}

class MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isShow = true;
  bool _isShowEmoji = false;
  bool _isAudio = false;
  // List<dynamic> _emoji = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isShow = !_focusNode.hasFocus;
      });
    });
    // _loadEmoji().then((value) {
    //   setState(() {
    //     _emoji = value;
    //   });
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void unfocus() {
    _focusNode.unfocus();
    setState(() {
      _isShowEmoji = false;
      _isAudio = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final bg = this.widget.bg ?? Theme.of(context).appBarTheme.backgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: Offset(0, -10),
          ),
        ],
        // borderRadius: BorderRadius.circular(999),
      ),
      child: Column(
        children: [
          if (widget.replyUser != null && widget.replyMessage != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: Spacing.small,
                top: Spacing.small,
                bottom: Spacing.small,
              ),
              // decoration: BoxDecoration(color: onSurface.withAlpha(20)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Đang trả lời "),
                              TextSpan(
                                text: widget.replyUser!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            widget.replyMessage!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SIconButton(
                    onTap: widget.onCloseReply,
                    child: Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.only(top: Spacing.xSmall),
            decoration: BoxDecoration(
              // color: onSurface.withAlpha(20),
              // borderRadius: BorderRadius.circular(Spacing.small),
            ),
            // padding: EdgeInsets.only(left: Spacing.medium),
            child: Column(
              children: [
                Row(
                  children: [
                    SIconButton(
                      onTap: () {
                        unfocus();
                        setState(() {
                          _isShowEmoji = !_isShowEmoji;
                        });
                      },
                      child: Icon(
                        CupertinoIcons.smiley,
                        size: 20,
                        color: onSurface.withAlpha(100),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 100),
                              width: width,
                              padding: EdgeInsets.symmetric(
                                horizontal: Spacing.small,
                              ),
                              decoration: BoxDecoration(
                                color: onSurface.withAlpha(20),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _controller,
                                minLines: 1,
                                maxLines: 5,
                                cursorHeight: 14,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Nhập tin nhắn",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: onSurface.withAlpha(100),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // FloatingAction(
                    //   onPressed: () {},
                    //   child: Icon(
                    //     CupertinoIcons.heart_fill,
                    //     size: 20,
                    //     color: onSurface.withAlpha(100),
                    //   ),
                    // ),
                    if (_isShow) ...[
                      SIconButton(
                        onTap: () {},
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          size: 20,
                          color: onSurface.withAlpha(100),
                        ),
                      ),
                      SIconButton(
                        onTap: () {},
                        child: Icon(
                          CupertinoIcons.camera,
                          size: 20,
                          color: onSurface.withAlpha(100),
                        ),
                      ),
                      SIconButton(
                        onTap: () {},
                        child: Icon(
                          CupertinoIcons.photo,
                          size: 20,
                          color: onSurface.withAlpha(100),
                        ),
                      ),
                      SIconButton(
                        onTap: () {
                          unfocus();
                          setState(() {
                            _isAudio = !_isAudio;
                          });
                        },
                        child: Icon(
                          CupertinoIcons.mic,
                          size: 20,
                          color: onSurface.withAlpha(100),
                        ),
                      ),
                    ] else
                      SIconButton(
                        onTap: () {},
                        child: Icon(
                          CupertinoIcons.paperplane,
                          size: 20,
                          color: onSurface.withAlpha(100),
                        ),
                      ),
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: _isShowEmoji ? 400 : 0,
                  // decoration: BoxDecoration(color: onSurface.withAlpha(100)),
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: Spacing.small,
                  //   vertical: Spacing.xSmall,
                  // ),
                  child: _EmojiSelect(),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  height: _isAudio ? 230 : 0,
                  child: SingleChildScrollView(
                    child: ClipRect(
                      child: Align(
                        heightFactor: _isAudio ? 1 : 0,
                        alignment: Alignment.topCenter,
                        child: AnimatedOpacity(
                          opacity: _isAudio ? 1 : 0,
                          duration: kThemeAnimationDuration,
                          child: _isAudio ? _AudioSelect() : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiSelect extends StatefulWidget {
  const _EmojiSelect({super.key});

  @override
  State<_EmojiSelect> createState() => _EmojiSelectState();
}

class _EmojiSelectState extends State<_EmojiSelect> {
  List<Emoji> _emojis = [];

  @override
  void initState() {
    super.initState();
    _loadEmoji().then((value) {
      setState(() {
        _emojis = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final width = MediaQuery.of(context).size.width / 60;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.small,
            vertical: Spacing.xSmall,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Spacing.small),
            decoration: BoxDecoration(
              color: onSurface.withAlpha(20),
              borderRadius: BorderRadius.circular(999),
            ),
            child: TextField(
              cursorHeight: 12,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Tìm kiếm",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: onSurface.withAlpha(100),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: Spacing.small),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width.round(),
            ),
            itemBuilder: (context, index) => HighlightTap(
              onTap: () {},
              borderRadius: BorderRadius.circular(Spacing.small),
              child: FittedBox(
                child: Text(
                  _emojis[index].emoji,
                  style: TextStyle(fontSize: 150),
                ),
              ),
            ),
            itemCount: _emojis.length,
          ),
        ),
        // SingleChildScrollView(
        //   padding: EdgeInsets.only(
        //     left: Spacing.small,
        //     right: Spacing.small,
        //     top: Spacing.xSmall,
        //   ),
        //   child: Row(
        //     spacing: Spacing.xSmall,
        //     children: [
        //       Icon(CupertinoIcons.smiley, size: 20),
        //       Icon(CupertinoIcons.person, size: 20),
        //       Icon(Icons.animal, size: 20),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class _AudioSelect extends StatefulWidget {
  const _AudioSelect({super.key});

  @override
  State<_AudioSelect> createState() => _AudioSelectState();
}

class _AudioSelectState extends State<_AudioSelect>
    with TickerProviderStateMixin {
  bool isRecording = false;
  late final RecorderController recorderController;
  late final AnimationController _micAnimationController;
  Timer? timer;
  int duration = 0;
  String? path;
  bool isPause = false;

  @override
  void initState() {
    super.initState();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final micStatus = await Permission.microphone.request();

    PermissionStatus? storageStatus;

    if (Platform.isAndroid) {
      storageStatus = await Permission.storage.request();
    }

    final isMicGranted = micStatus.isGranted;
    final isStorageGranted =
        Platform.isIOS || (storageStatus?.isGranted ?? true);

    if (isMicGranted && isStorageGranted) {
      setState(() {
        // ✅ Đã cấp quyền micro & storage (hoặc không cần)
      });
    } else if (micStatus.isPermanentlyDenied ||
        (Platform.isAndroid && storageStatus?.isPermanentlyDenied == true)) {
      // ❌ Quyền bị từ chối vĩnh viễn
      // await openAppSettings();
    } else {
      setState(() {
        // ⚠️ Người dùng từ chối tạm thời
      });
    }
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a";
  }

  Future<void> _startRecording() async {
    path = await _getFilePath();
    await recorderController.record(path: path!);
    setState(() {
      isRecording = true;
      duration = 0;
      isPause = false;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        duration++;
      });
    });
  }

  Future<void> _stopRecording() async {
    await recorderController.stop();
    debugPrint("Đã lưu ghi âm tại: $path");
    setState(() {
      isRecording = false;
    });
    timer?.cancel();
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    _micAnimationController.dispose();
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.large,
        vertical: Spacing.medium,
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            // padding: EdgeInsets.symmetric(horizontal: Spacing.large),
            child: isRecording
                ? Row(
                    spacing: Spacing.small,
                    children: [
                      if (!isPause)
                        SIconButton(
                          bgColor: Colors.white.withAlpha(20),
                          onTap: () {
                            setState(() {
                              isPause = true;
                            });
                          },
                          child: Icon(
                            CupertinoIcons.pause_solid,
                            size: 20,
                            color: Colors.white,
                          ),
                        )
                      else
                        SIconButton(
                          bgColor: Colors.red.withAlpha(20),
                          onTap: () {
                            _stopRecording();
                          },
                          child: Icon(
                            CupertinoIcons.trash,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                            horizontal: Spacing.medium,
                          ),
                          decoration: isRecording
                              ? BoxDecoration(
                                  color: Colors.blue.withAlpha(20),
                                  borderRadius: BorderRadius.circular(999),
                                )
                              : null,
                          child: Row(
                            children: [
                              Expanded(
                                child: AudioWaveforms(
                                  // backgroundColor: Colors.red,
                                  recorderController: recorderController,
                                  // enableGesture: false,
                                  // backgroundColor: Colors.red,
                                  waveStyle: const WaveStyle(
                                    waveColor: Colors.blue,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                    // waveThickness: 3,
                                    // waveCap: StrokeCap.round,
                                    scaleFactor: 1.8,
                                  ),
                                  size: Size(
                                    MediaQuery.of(context).size.width,
                                    50,
                                  ),
                                ),
                              ),
                              Text(
                                _formatDuration(duration),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          SizedBox(height: Spacing.medium),
          Text(
            "Bấm hoặc bấm giữ để ghi âm",
            style: TextStyle(fontSize: 14, color: onSurface.withAlpha(100)),
          ),
          SizedBox(height: Spacing.large),
          SIconButton(
            paddingX: Spacing.medium,
            paddingY: Spacing.medium,
            bgColor: Colors.blue,
            onTap: () {
              if (isRecording) {
                _stopRecording();
              } else {
                _startRecording();
              }
            },
            child: Icon(CupertinoIcons.mic_fill, size: 50, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
