import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/ui/widgets/widgets.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/bloc/message/message.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    Key? key,
    this.onSend,
  }) : super(key: key);

  final void Function(String val, List<Photo> photos, MessageType type)? onSend;

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with TickerProviderStateMixin {
  bool showCamera = true;
  TextEditingController? _controller;
  final List<Photo> _attachedImages = [];
  Timer? _timer;
  double _right = 0;
  bool blip = false;
  bool canRecord = false;
  bool isRecord = false;
  int recordTime = 0;
  bool discardRecord = false;
  bool _recorderInited = false;
  late FlutterSoundRecorder? _recorder;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()
      ..addListener(() {
        if (showCamera && _controller!.value.text.isNotEmpty) {
          showCamera = false;
          setState(() {});
        }
        if (!showCamera && _controller!.value.text.isEmpty) {
          showCamera = true;
          setState(() {});
        }
      });

    // initialize audio recorder
    _recorder = FlutterSoundRecorder()
      ..openAudioSession().then((value) {
        setState(() {
          _recorderInited = true;
        });
      });
  }

  Future _startRecord() async {
    try {
      if (!_recorderInited) {
        return;
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        blip = !blip;
        recordTime++;
        setState(() {});
      });

      await _recorder!.startRecorder(
        toFile: DateTime.now().millisecondsSinceEpoch.toString(),
        codec: Codec.aacADTS,
      );
      setState(() {
        isRecord = true;
      });
      log('startRecord');
    } catch (e) {
      log('startRecord: fail');
    }
  }

  Future _stopRecord() async {
    try {
      _timer?.cancel();
      recordTime = 0;
      final audioPath = await _recorder!.stopRecorder();
      log('stopRecord: $audioPath');
      setState(() {
        isRecord = false;
      });
      if (!discardRecord) {
        final audioFile = File(audioPath!);

        widget.onSend!('', [Photo(file: audioFile, source: PhotoSource.File)],
            MessageType.Audio);
      }
    } catch (e) {
      log('stopRecord: fail');
      setState(() {
        isRecord = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller!.dispose();
    _recorder!.closeAudioSession();
    _recorder = null;
    super.dispose();
  }

  Future getImage(ImageSource source) async {
    final imgPicker = ImagePicker();
    final pickedFile =
        await imgPicker.getImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _attachedImages.add(Photo(
          file: File(pickedFile.path),
          source: PhotoSource.File,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageLoadSuccess) {
          _attachedImages.clear();
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ...List.generate(
              _attachedImages.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AttachedImages(
                  photo: _attachedImages[index],
                  onRemove: () {
                    _attachedImages.removeAt(index);
                    setState(() {});
                  },
                ),
              ),
            ),
            const Divider(
              height: 0,
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: canRecord,
                      child: Row(
                        children: [
                          Icon(
                            Icons.mic_rounded,
                            color: blip ? Colors.red : AppColors.WHITE4,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('00:${recordTime.toString().padLeft(2, "0")}'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[900]!,
                              highlightColor: Colors.grey[100]!,
                              child: const Text(
                                'Swipe to discard',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      autofocus: true,
                      showCursor: !canRecord,
                      controller: _controller,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          prefixIconConstraints: const BoxConstraints(
                            minHeight: 18,
                            minWidth: 18,
                          ),
                          hintText: !canRecord ? 'Write a message...' : '',
                          hintStyle: AppFonts.MEDIUM_WHITE3_12,
                          contentPadding: const EdgeInsets.all(10),
                          prefixIcon: canRecord
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await getImage(ImageSource.gallery);
                                      },
                                      child: SvgPicture.asset(
                                          'assets/forum/attach.svg'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if (showCamera)
                                      GestureDetector(
                                        onTap: () async {
                                          await getImage(ImageSource.camera);
                                        },
                                        child: const Icon(Icons.photo_camera,
                                            size: 24, color: AppColors.WHITE2),
                                      ),
                                    if (showCamera)
                                      const SizedBox(
                                        width: 10,
                                      ),
                                  ],
                                )),
                    ),
                  ),
                  Positioned(
                    right: _right,
                    child: GestureDetector(
                      onTapUp: (d) async {
                        log('tap up: send the recording');
                        // finger released
                        // send the recording
                        canRecord = false;
                        discardRecord = false;
                        if (isRecord) {
                          await _stopRecord();
                        }
                      },
                      onTapDown: (d) async {
                        // Return early if
                        // textController has text or images are loaded
                        if (_controller!.value.text.isNotEmpty ||
                            _attachedImages.isNotEmpty) {
                          return;
                        }

                        log('tap down: start the recording');
                        // start record
                        canRecord = true;
                        discardRecord = false;
                        if (await Permission.microphone.request().isGranted) {
                          if (!isRecord) {
                            await _startRecord();
                          }
                        }
                      },
                      onPanEnd: (details) {
                        if (!canRecord) {
                          return;
                        }
                        // 0 < _right < w/3
                        if (_right >= 0 && _right < screenWidth(context) / 3) {
                          _right = 0;
                          canRecord = false;
                          _stopRecord();
                          // send the record
                          log('pan end: send the recording');
                        }
                      },
                      onPanUpdate: (details) {
                        if (!canRecord) {
                          return;
                        }
                        if ((_right - details.delta.dx) < 0) {
                          return;
                        }
                        _right -= details.delta.dx;

                        // _right > w/3 -> remove the record
                        if (_right > screenWidth(context) / 3) {
                          log('_right threshold: $_right');
                          discardRecord = true;
                          canRecord = false;
                          _right = 0;
                          _stopRecord();

                          log('pan update: threshold achieved: '
                              'removing the recording');
                          return;
                        }

                        setState(() {});
                      },
                      onTap: () {
                        final _txt = _controller!.value.text.trim();

                        if (_txt.isNotEmpty || _attachedImages.isNotEmpty) {
                          widget.onSend!(
                              _txt, _attachedImages, MessageType.Text);
                        }

                        _controller!.clear();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: const BoxDecoration(
                          color: AppColors.DEFAULT,
                          shape: BoxShape.circle,
                        ),
                        padding: canRecord
                            ? const EdgeInsets.all(20)
                            : const EdgeInsets.all(10),
                        child: Icon(
                          // send -> !record && !showCamera && !images.notEmpty
                          // mic -> record == true
                          canRecord || !showCamera || _attachedImages.isNotEmpty
                              ? Icons.send_rounded
                              : Icons.mic_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
