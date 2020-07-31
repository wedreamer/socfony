import 'dart:io';
import 'package:crypto/crypto.dart' as convert;

import 'package:bot_toast/bot_toast.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/shape/gf_icon_button_shape.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snsmax/cloudbase.dart';
import 'package:snsmax/pages/audio-recorder.dart';
import 'package:snsmax/pages/login.dart';
import 'package:snsmax/provider/auth.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({Key key}) : super(key: key);

  @override
  _PublishState createState() => _PublishState();

  /// 创建发布页面路由
  static Future<bool> route(BuildContext context) async {
    bool login = await LoginPage.route(context);
    if (login == true) {
      return await Navigator.of(context).push<bool>(routeBuilder(context));
    }

    return false;
  }

  static MaterialPageRoute<bool> routeBuilder(BuildContext context) {
    return MaterialPageRoute<bool>(
      builder: (_) => const PublishPage(),
      fullscreenDialog: true,
    );
  }
}

enum VideoMapKeys {
  cover,
  src,
}

enum AudioMapKeys {
  cover,
  src,
}

class _PublishState extends State<PublishPage> {
  List<AssetEntity> images = const <AssetEntity>[];
  Map<VideoMapKeys, String> video;
  Map<AudioMapKeys, String> audio;
  List<String> votes;
  String text;
  Position position;
  bool usingPosition = false;

  bool get allowPhoto => video == null && audio == null;
  bool get allowVideo => images.isEmpty && audio == null;
  bool get allowAudio => images.isEmpty && video == null;
  bool get allowPost => text != null && text.isNotEmpty;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    onChangePositionSwitch(true);
    super.initState();
  }

  @override
  void setState([VoidCallback fn]) {
    fn = fn ?? () {};
    mounted ? super.setState(fn) : fn();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.color,
        appBar: buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildSelectTopic(context),
            Expanded(
              child: ListView(
                shrinkWrap: false,
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: 24),
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "耳机一戴，谁都不爱！",
                      contentPadding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                    ),
                    onChanged: onTextChanged,
                  ),
                  GFListTile(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    title: Text('发布到同城'),
                    icon: Switch(
                      value: usingPosition,
                      onChanged: onChangePositionSwitch,
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  buildImagesGridView(),
                  buildVideoGridView(),
                  buildAudioCard(context),
                  buildVoteWidget(),
                ],
              ),
            ),
            buildBottomAppBar(),
          ],
        ),
      ),
    );
  }

  onChangePositionSwitch(bool value) {
    setState(() {
      usingPosition = value;
    });
    if (value && position == null) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
          .then((position) {
        setState(() {
          this.position = position;
          usingPosition = true;
        });
        if (position == null) {
          setState(() {
            usingPosition = false;
            this.position = null;
          });
          BotToast.showText(text: '获取位置信息失败');
        }
      }).catchError((e) {
        setState(() {
          usingPosition = false;
          position = null;
        });
        String message = '获取位置失败';
        if (e.code == 'PERMISSION_DENIED') {
          message = '需要开启位置权限才能发布到同城';
        }

        BotToast.showText(text: message);
      });
    }
  }

  Widget buildVoteWidget() {
    if (votes is! List<String> || votes.isEmpty) {
      return SizedBox.shrink();
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: votes.length,
      itemBuilder: (BuildContext context, int index) {
        return GFListTile(
          margin: EdgeInsets.zero.copyWith(
            bottom: 1,
          ),
          title: Center(
            child: Text(votes[index]),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          icon: GestureDetector(
            child: Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onTap: () => onRemoveVote(index),
          ),
        );
      },
    );
  }

  Widget buildAudioCard(BuildContext context) {
    if (audio == null) {
      return SizedBox.shrink();
    }
    bool hasCover = audio.containsKey(AudioMapKeys.cover);
    File cover;
    if (hasCover) {
      cover = File(audio[AudioMapKeys.cover]);
    }
    return GFCard(
      boxFit: BoxFit.cover,
      imageOverlay:
          hasCover ? FileImage(cover) : AssetImage('assets/audio-bg.jpg'),
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
      colorFilter: new ColorFilter.mode(
        Colors.black45,
        BlendMode.darken,
      ),
      content: Row(
        children: <Widget>[
          GFAvatar(
            backgroundImage: hasCover ? FileImage(cover) : null,
            child: Icon(
              hasCover ? Icons.play_circle_filled : Icons.album,
              size: hasCover ? GFSize.SMALL : GFSize.LARGE,
            ),
            size: GFSize.LARGE,
          ),
          Expanded(
            child: Center(
              child: GFButton(
                onPressed: onSelectAudioCover,
                text: '更换封面',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GFIconButton(
            icon: Icon(Icons.clear),
            iconSize: 24,
            onPressed: onRemoveAudio,
            shape: GFIconButtonShape.circle,
            color: Colors.red,
            size: GFSize.SMALL,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget buildVideoGridView() {
    if (video == null) {
      return SizedBox.shrink();
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        child: GFImageOverlay(
          image: FileImage(File(video[VideoMapKeys.cover])),
          child: UnconstrainedBox(
            child: GFButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              text: "删除视频",
              onPressed: onRemoveSelectedVideo,
              shape: GFButtonShape.pills,
              color: Colors.redAccent,
              textColor: Colors.white,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget buildImagesGridView() {
    if (images.isEmpty) {
      return SizedBox.shrink();
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemCount: images.length < 9 ? images.length + 1 : 9,
      itemBuilder: buildImagesGridViewItem,
    );
  }

  static Map<String, File> _imageFilesCache = {};

  Future<File> createImageFileFuture(AssetEntity image) async {
    if (_imageFilesCache.containsKey(image.id)) {
      return _imageFilesCache[image.id];
    }

    File file = await image.file;
    _imageFilesCache.putIfAbsent(image.id, () => file);

    return file;
  }

  Widget buildImagesGridViewItem(BuildContext context, int index) {
    if (images.length < 9 && index == images.length) {
      return buildAddPhotoGridViewItem(context);
    }
    AssetEntity image = images[index];
    if (_imageFilesCache.containsKey(image.id)) {
      return GestureDetector(
        onTap: () => onDeleteImagesItem(image),
        child: Image.file(
          _imageFilesCache[image.id],
          fit: BoxFit.cover,
          frameBuilder: (_, Widget child, __, ___) => ClipRRect(
            child: child,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }

    return FutureBuilder<File>(
      future: createImageFileFuture(image),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: const GFLoader(
                type: GFLoaderType.ios,
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => onDeleteImagesItem(image),
          child: Image.file(
            snapshot.data,
            fit: BoxFit.cover,
            frameBuilder: (_, Widget child, __, ___) => ClipRRect(
              child: child,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      },
    );
  }

  Widget buildAddPhotoGridViewItem(BuildContext context) {
    return GestureDetector(
      onTap: onTapInsertPhoto,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.add,
          size: GFSize.LARGE,
        ),
      ),
    );
  }

  Widget buildSelectTopic(BuildContext context) {
    return GFListTile(
      title: Text(
        '选择话题',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      icon: Icon(Icons.chevron_right),
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: allowPhoto ? onTapInsertPhoto : null,
          ),
          IconButton(
            icon: Icon(Icons.video_library),
            onPressed: allowVideo ? onSelectVideo : null,
          ),
          IconButton(
            icon: Icon(Icons.library_music),
            onPressed: allowAudio ? onAudioRecorder : null,
          ),
          IconButton(
            icon: Icon(Icons.assessment),
            onPressed: onVoteSetting,
          ),
          Expanded(child: SizedBox.shrink()),
          IconButton(
            icon: Icon(Icons.link),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.alternate_email),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: true,
      actions: <Widget>[
        UnconstrainedBox(
          child: GFButton(
            onPressed: allowPost ? onPostMoment : null,
            shape: GFButtonShape.pills,
            text: '发布',
            color: Theme.of(context).primaryColor,
            size: GFSize.SMALL,
          ),
        ),
        SizedBox(
          width: 12,
        ),
      ],
    );
  }

  void onDeleteImagesItem(AssetEntity item) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text('是否需要删除这张图片?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text('删除'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                images = images
                    .where((AssetEntity element) => element.id != item.id)
                    .toList();
              });
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          isDefaultAction: true,
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  FilterOptionGroup get imageFilterOptions {
    FilterOptionGroup filterOptions = FilterOptionGroup();
    filterOptions.setOption(
      AssetType.image,
      FilterOption(
        sizeConstraint: SizeConstraint(
          minWidth: 200,
          maxWidth: 9999,
          minHeight: 200,
          maxHeight: 9999,
        ),
      ),
    );

    return filterOptions;
  }

  FilterOptionGroup get videoFilterOptions {
    FilterOptionGroup filterOptions = FilterOptionGroup();
    filterOptions.setOption(
      AssetType.video,
      const FilterOption(
        durationConstraint: const DurationConstraint(
          min: const Duration(seconds: 5), // 最短视频五秒
          max: const Duration(minutes: 5), // 最长视频五分钟
        ),
      ),
    );

    return filterOptions;
  }

  Future<void> onTapInsertPhoto() async {
    final cancel = ([VoidCallback callback]) => () {
          Navigator.of(context).pop();
          if (callback is Function) {
            callback();
          }
        };
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        message: Text('选择从相册还是从相机拍摄照片'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: cancel(onCameraPhoto),
            child: Text('拍照'),
          ),
          CupertinoActionSheetAction(
            onPressed: cancel(onSelectImage),
            child: Text('相册'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: cancel(),
          child: Text('取消'),
          isDestructiveAction: true,
        ),
      ),
    );
  }

  Future<void> onCameraPhoto() async {
    try {
      PickedFile pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);
      AssetEntity entity =
          await PhotoManager.editor.saveImage(await pickedFile.readAsBytes());
      setState(() {
        images = <AssetEntity>[...images, entity];
      });
    } catch (e) {
      print(e);
    }
  }

  void onSelectImage() {
    AssetPicker.pickAssets(
      context,
      selectedAssets: images,
      themeColor: Theme.of(context).primaryColor,
      requestType: RequestType.image,
      maxAssets: 9,
      filterOptions: imageFilterOptions,
    ).then((List<AssetEntity> value) {
      if (value is List<AssetEntity>) {
        setState(() {
          images = value;
        });
      }
    });
  }

  Future<void> onSelectVideo() async {
    FocusScope.of(context).unfocus();
    try {
      // 获取视频资源
      List<AssetEntity> entities = await AssetPicker.pickAssets(
        context,
        themeColor: Theme.of(context).primaryColor,
        requestType: RequestType.video,
        maxAssets: 1,
        filterOptions: videoFilterOptions,
      );
      if (entities is! List<AssetEntity> || entities == null) {
        return;
      }

      CancelFunc cancel = BotToast.showLoading();
      AssetEntity entity = entities.last;
      File video = await entity.file;

      // 获取缩略图文件
      String thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: video.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 1280,
        maxHeight: 720,
        quality: 90,
      );

      // 裁剪缩略图
      File thumbnailFile = await ImageCropper.cropImage(
        sourcePath: thumbnailPath,
        aspectRatio: CropAspectRatio(ratioX: 1280, ratioY: 720),
        compressFormat: ImageCompressFormat.jpg,
        cropStyle: CropStyle.rectangle,
        iosUiSettings: IOSUiSettings(
          hidesNavigationBar: true,
          title: "视频封面编辑",
          showActivitySheetOnDone: false,
          showCancelConfirmationDialog: false,
          cancelButtonTitle: "放弃视频",
          doneButtonTitle: "完成",
          rotateButtonsHidden: true,
        ),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "视频封面编辑",
        ),
      );
      cancel();

      if (thumbnailFile is! File) {
        return;
      }

      setState(() {
        this.video = {
          VideoMapKeys.src: video.path,
          VideoMapKeys.cover: thumbnailFile.path,
        };
      });
    } catch (e) {
      print(e);
    }
    FocusScope.of(context).requestFocus();
  }

  Future<void> onRemoveSelectedVideo() async {
    bool confirm = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text("确认要删除已选择的视频吗?"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop<bool>(true),
            child: Text("删除"),
            isDestructiveAction: true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop<bool>(false),
          child: Text('不！我点错了'),
        ),
      ),
    );

    if (confirm == true) {
      setState(() {
        video = null;
      });
    }
  }

  onAudioRecorder() async {
    File audio = await AudioRecorderPage.route(context);
    if (audio is File) {
      setState(() {
        this.audio = {AudioMapKeys.src: audio.path};
      });
    }
  }

  onSelectAudioCover() async {
    List<AssetEntity> selected = await AssetPicker.pickAssets(
      context,
      requestType: RequestType.image,
      themeColor: Theme.of(context).primaryColor,
      maxAssets: 1,
      filterOptions: imageFilterOptions,
    );
    if (selected == null || selected.isEmpty) {
      return;
    }

    AssetEntity cover = selected.last;
    File coverFile = await cover.file;

    setState(() {
      audio = {
        ...audio,
        AudioMapKeys.cover: coverFile.path,
      };
    });
  }

  onRemoveAudio() async {
    bool hasCover = audio.containsKey(AudioMapKeys.cover);
    AudioMapKeys key = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text(hasCover ? '你需要删除音频的什么？' : '确认要删除音频吗？'),
        actions: <Widget>[
          if (hasCover)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(AudioMapKeys.cover),
              child: Text('封面'),
            ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(AudioMapKeys.src),
            child: Text(hasCover ? '全部' : '删除'),
            isDestructiveAction: hasCover ? false : true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('取消'),
          isDestructiveAction: true,
        ),
      ),
    );
    switch (key) {
      case AudioMapKeys.cover:
        setState(() {
          audio = {AudioMapKeys.src: audio[AudioMapKeys.src]};
        });
        break;
      case AudioMapKeys.src:
        setState(() {
          audio = null;
        });
        break;
    }
  }

  onVoteSetting() async {
    var value =
        await Navigator.of(context).pushNamed('vote-setter', arguments: votes);
    if (value is List<String>) {
      setState(() {
        votes = value;
      });
    }
  }

  onRemoveVote(int index) async {
    if (votes.length > 2) {
      return setState(() {
        votes.removeAt(index);
      });
    }

    bool hasRemove = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text('投票最低两个选项，当前操作将全部移除选项，是否删除投票?'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('删除'),
            isDestructiveAction: true,
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('取消'),
          isDestructiveAction: true,
        ),
      ),
    );
    if (hasRemove) {
      setState(() {
        votes = null;
      });
    }
  }

  onTextChanged(String value) {
    setState(() {
      text = value.trimLeft();
    });
  }

  Future<String> uploadFile(File file) async {
    convert.Digest digest = convert.md5.convert(file.readAsBytesSync());
    String ext = "." + file.path.toLowerCase().split('.').last;
    String cloudPath = DateFormat("yyyy/MM/dd/").format(DateTime.now()) +
        digest.toString() +
        ext;
    CloudBaseStorageRes<UploadRes> result =
        await CloudBase().storage.uploadFile(
              cloudPath: cloudPath,
              filePath: file.path,
            );

    return result.data.fileId;
  }

  onPostMoment() async {
    FocusScope.of(context).unfocus();
    CancelFunc cancel = BotToast.showLoading();
    try {
      Map<String, dynamic> doc = {
        "createdAt": ServerDate(),
        "updatedAt": ServerDate(),
      };
      doc = await senderSetter(doc);
      doc = await textSetter(doc);
      doc = await uploadImages(doc);
      doc = await uploadVideo(doc);
      doc = await uploadAudio(doc);
      doc = await createVote(doc);
      doc = await pointSetter(doc);

      DbCreateResponse response =
          await CloudBase().database.collection('moments').add(doc);
      if (response.code == null && response.id is String) {
        Navigator.of(context).pop();
        cancel();
        BotToast.showText(text: "发布成功");
        return;
      }

      throw FormatException("发布失败");
    } catch (e) {
      cancel();
      print(e);
      BotToast.showText(text: "发布失败");
    }
  }

  Future<Map<String, dynamic>> pointSetter(Map<String, dynamic> doc) async {
    Map<String, dynamic> _doc = doc != null ? doc : {};
    Map<String, dynamic> value = {};

    if (usingPosition == true && position is Position) {
      value = {
        'location': Geo().point(position.longitude, position.latitude),
      };
    }

    return {..._doc, ...value};
  }

  Future<Map<String, dynamic>> createVote(Map<String, dynamic> doc) async {
    if (votes is! List<String> || votes.isEmpty) {
      return doc;
    }
    Map<String, dynamic> _doc = doc != null ? doc : {};

    return {
      ..._doc,
      "vote": votes
          .map((e) => {
                "name": e,
              })
          .toList(),
    };
  }

  Future<Map<String, dynamic>> uploadAudio(Map<String, dynamic> doc) async {
    if (audio == null || !audio.containsKey(AudioMapKeys.src)) {
      return doc;
    }
    Map<String, dynamic> _doc = doc != null ? doc : {};
    Map<String, String> _audio = {
      "src": await uploadFile(File(audio[AudioMapKeys.src])),
    };

    if (audio.containsKey(AudioMapKeys.cover)) {
      _audio = {
        ..._audio,
        "cover": await uploadFile(File(audio[AudioMapKeys.cover])),
      };
    }

    return {..._doc, "audio": _audio};
  }

  Future<Map<String, dynamic>> uploadVideo(Map<String, dynamic> doc) async {
    if (video == null ||
        !video.containsKey(VideoMapKeys.cover) ||
        !video.containsKey(VideoMapKeys.src)) {
      return doc;
    }
    Map<String, dynamic> _doc = doc != null ? doc : {};
    Map<String, String> _video = {
      "cover": await uploadFile(File(video[VideoMapKeys.cover])),
      "src": await uploadFile(File(video[VideoMapKeys.src])),
    };

    return {..._doc, "video": _video};
  }

  Future<Map<String, dynamic>> uploadImages(Map<String, dynamic> doc) async {
    if (images is! List<AssetEntity> || images.isEmpty) {
      return doc;
    }
    Map<String, dynamic> _doc = doc != null ? doc : {};
    List<String> paths = [];
    for (AssetEntity image in images) {
      File file = await image.file;
      String fileId = await uploadFile(file);
      paths.add(fileId);
    }

    return {
      ..._doc,
      "images": paths,
    };
  }

  Future<Map<String, dynamic>> textSetter(Map<String, dynamic> doc) async {
    Map<String, dynamic> _doc = doc != null ? doc : {};
    return {
      ..._doc,
      "text": text.trim(),
    };
  }

  Future<Map<String, dynamic>> senderSetter(Map<String, dynamic> doc) async {
    final userId = AuthProvider().user;
    Map<String, dynamic> _doc = doc != null ? doc : {};
    return {
      ..._doc,
      "userId": userId,
    };
  }
}
