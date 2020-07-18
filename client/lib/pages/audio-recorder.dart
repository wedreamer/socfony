import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderPage extends StatefulWidget {
  @override
  _AudioRecorderPageState createState() => _AudioRecorderPageState();

  static Future<File> route(BuildContext context) async {
    return await showModalBottomSheet<File>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) => AudioRecorderPage(),
    );
  }
}

class _AudioRecorderPageState extends State<AudioRecorderPage> {
  FlutterAudioRecorder recorder;
  Recording recording;
  Timer recordingTimer;
  AssetsAudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildAppBar(context),
            buildButtons(context),
          ],
        ),
      ),
    );
  }

  Padding buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildPlayButton(context),
          buildStartAndPauseButton(context),
          buildDoneButton(context),
        ],
      ),
    );
  }

  Widget buildDoneButton(BuildContext context) {
    if (recording is Recording && recording.status != RecordingStatus.Recording)
      return FloatingActionButton(
        onPressed: onOver,
        mini: true,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.done),
      );
    return SizedBox.shrink();
  }

  Widget buildPlayButton(BuildContext context) {
    if (recording is Recording && recording.status != RecordingStatus.Recording)
      return FloatingActionButton(
        onPressed:
            audioPlayer is AssetsAudioPlayer ? onStopAudioPlay : onPlayAudio,
        child: Icon(
            audioPlayer is AssetsAudioPlayer ? Icons.pause : Icons.play_arrow),
        tooltip: "播放",
        mini: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      );
    return SizedBox.shrink();
  }

  Padding buildStartAndPauseButton(BuildContext context) {
    bool hasRecording = recording?.status == RecordingStatus.Recording;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: FloatingActionButton(
        onPressed: hasRecording ? onPauseRecording : onStartRecode,
        child: Icon(hasRecording ? Icons.stop : Icons.mic),
        tooltip: hasRecording ? "结束录制" : "开始录制",
        mini: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  String twoDigits(int n) {
    if (n >= 10) return n.toString();
    return "0${n.toString()}";
  }

  Widget buildAudioTime(BuildContext context) {
    if (audioPlayer is AssetsAudioPlayer) {
      return audioPlayer.builderCurrentPosition(
        builder: (BuildContext context, Duration position) {
          String inMinutes = twoDigits(position.inMinutes);
          String inSeconds = twoDigits(
              position.inSeconds.remainder(Duration.secondsPerMinute));

          return Text(
            "$inMinutes:$inSeconds",
            style: Theme.of(context).textTheme.headline5,
          );
        },
      );
//      return StreamBuilder<Playing>(
//        stream: audioPlayer.builderCurrentPosition(builder: null),
//        builder: (BuildContext context, AsyncSnapshot<Playing> snapshot) {
//          print(snapshot.data.audio.)
//          return AudioWidget.file(child: null, path: null);
//        },
//      );
    }

    Duration duration = (recording?.duration) ?? Duration();
    String inMinutes = twoDigits(duration.inMinutes);
    String inSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));

    return Text(
      "$inMinutes:$inSeconds",
      style: Theme.of(context).textTheme.headline5,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: CloseButton(
        onPressed: onClose,
      ),
      centerTitle: true,
      title: buildAudioTime(context),
    );
  }

  onPlayAudio() async {
    await this.audioPlayer?.stop();
    this.audioPlayer?.dispose();
    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();
    await audioPlayer.open(
      Audio.file(recorder.recording.path),
      autoStart: true,
      loopMode: LoopMode.single,
    );
    audioPlayer.play();
    setState(() {
      this.audioPlayer = audioPlayer;
    });
  }

  onStopAudioPlay() async {
    await audioPlayer.stop();
    audioPlayer.dispose();
    setState(() {
      audioPlayer = null;
    });
  }

  onOver() async {
    if (recording.duration.inSeconds < 5) {
      return BotToast.showText(text: '录制时长不能小于5秒哦');
    }

    await audioPlayer?.stop();
    audioPlayer?.dispose();

    File audio = File(recording.path);
    if (audio.existsSync()) {
      return Navigator.of(context).pop(audio);
    }

    Navigator.pop(context);
    BotToast.showText(text: '录制失败，请重试');
  }

  Future<void> onStartRecode() async {
    try {
      bool hasPermission = await FlutterAudioRecorder.hasPermissions;
      if (hasPermission != true) {
        BotToast.showText(text: '需要您授权使用麦克风权限才能录制');
        return;
      }

      // 创建文件
      String path = (await getTemporaryDirectory()).path + "/audio.m4a";
      File file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }

      // 创建临时语音文件
      setState(() {
        recorder = FlutterAudioRecorder(
          path,
          sampleRate: 16000,
        );
      });

      await recorder.initialized;
      await recorder.start();

      onSetRecordingTimer();
    } catch (e) {
      print(e);
    }
  }

  onPauseRecording() async {
    await recorder?.pause();
    await recorder?.stop();
    Recording current = await recorder.current();
    recordingTimer?.cancel();
    setState(() {
      recording = current;
    });
  }

  onSetRecordingTimer() {
    recordingTimer?.cancel();
    setState(() {
      recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
        Recording current = await recorder.current();
        setState(() {
          recording = current;
        });
      });
    });
  }

  onClose() async {
    recordingTimer?.cancel();

    if (recorder == null) {
      return Navigator.pop(context);
    }

    await recorder?.pause();
    bool quit = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: UnconstrainedBox(
          child: Center(
            child: Text('你要放弃语音内容吗?'),
          ),
        ),
        actions: <Widget>[
          GFButton(
            onPressed: () => Navigator.of(context).pop(false),
            text: "我点错了",
            shape: GFButtonShape.pills,
            type: GFButtonType.outline,
            color: Theme.of(context).primaryColor,
          ),
          GFButton(
            onPressed: () => Navigator.of(context).pop(true),
            text: "放弃",
            shape: GFButtonShape.pills,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
    if (quit == true) {
      await recorder?.stop();

      await audioPlayer?.stop();
      audioPlayer?.dispose();

      return Navigator.of(context).pop();
    }

    onSetRecordingTimer();
  }
}
