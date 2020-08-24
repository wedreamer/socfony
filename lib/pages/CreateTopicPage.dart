import 'dart:io';
import 'package:crypto/crypto.dart' as convert;

import 'package:bot_toast/bot_toast.dart';
import 'package:fans/cloudbase.dart' hide RegExp;
import 'package:fans/cloudbase/commands/topic/CreateTopicCommand.dart';
import 'package:fans/utils/number-extension.dart';
import 'package:fans/widgets/ToastLoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fans/models/Topic.dart';

class CreateTopicController with ChangeNotifier {
  String _name;
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  File _cover;
  File get cover => _cover;
  set cover(File value) {
    _cover = value;
    notifyListeners();
  }

  String _title;
  String get title => _title;
  set title(String newValue) {
    _title = newValue;
    notifyListeners();
  }

  String _description;
  String get description => _description;
  set description(String newValue) {
    _description = newValue;
    notifyListeners();
  }

  TopicJoinType _joinType = TopicJoinType.freely;
  TopicJoinType get joinType => _joinType;
  set joinType(TopicJoinType newJoinType) {
    _joinType = newJoinType;
    notifyListeners();
  }

  TopicPostType _postType = TopicPostType.any;
  TopicPostType get postType => _postType;
  set postType(TopicPostType newPostType) {
    _postType = newPostType;
    notifyListeners();
  }
}

class CreateTopicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _createFocusScopeHandler(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text('创建话题'),
        ),
        body: ChangeNotifierProvider(
          create: (_) => CreateTopicController(),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            children: [
              _TopicCover(),
              _TopicNameTextField(),
              _TopicTitleTextField(),
              _TopicDescField(),
              _TopicJoinType(),
              _TopicPostType(),
              _TopicSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback _createFocusScopeHandler(BuildContext context) {
    return () {
      FocusScope.of(context).unfocus();
    };
  }
}

class _TopicSubmitButton extends StatelessWidget {
  const _TopicSubmitButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        shape: StadiumBorder(),
        colorBrightness: Brightness.dark,
        onPressed: _createSubmitHandler(context),
        child: Text('创建'),
      ),
    );
  }

  VoidCallback _createSubmitHandler(BuildContext context) {
    return () async {
      CreateTopicController controller = context.read<CreateTopicController>();
      List<String> messages = [
        _TopicNameTextField.validator(controller.name),
        _TopicTitleTextField.validator(controller.title),
        _TopicDescField.validator(controller.description),
      ].where((element) => element is String).toList();
      if (messages.isNotEmpty) {
        BotToast.showText(text: messages.first);
        return;
      }
      ToastLoadingController loading = ToastLoadingController();
      CancelFunc cancelFunc = ToastLoadingWidget.show(loading);
      CreateTopicCommandController value = CreateTopicCommandController();
      try {
        value.cover = await _uploadCover(controller.cover, loading);
        value.name = controller.name;
        value.title = controller.title;
        value.description = controller.description;
        value.joinType = controller.joinType;
        value.postType = controller.postType;

        loading.text = '正在创建话题...';
        await CreateTopicCommand(value).run();

        cancelFunc();

        Navigator.of(context).pop();
        BotToast.showText(text: '话题创建成功');
      } catch (e) {
        cancelFunc();
        BotToast.showText(text: e.message ?? '创建话题失败');
      }
    };
  }

  Future<String> _uploadCover(
      File file, ToastLoadingController controller) async {
    if (file == null) {
      throw UnimplementedError('请选择话题封面');
    }

    convert.Digest digest = convert.md5.convert(file.readAsBytesSync());
    String ext = "." + file.path.toLowerCase().split('.').last;
    String cloudPath = DateFormat("yyyy/MM/dd/").format(DateTime.now()) +
        digest.toString() +
        ext;
    controller.text = '正在处理图片';

    CloudBaseStorageRes<UploadRes> result =
        await CloudBase().storage.uploadFile(
              cloudPath: cloudPath,
              filePath: file.path,
              onProcess: (int count, int total) {
                controller.progress = count / total;
                controller.text =
                    '正在上传封面...\n${controller.progress.format('##.0#%')}';
              },
            );
    controller.progress = null;
    controller.text = null;

    return result.data.fileId;
  }
}

class _TopicPostType extends StatelessWidget {
  const _TopicPostType({
    Key key,
  }) : super(key: key);

  final Map<TopicPostType, String> types = const {
    TopicPostType.any: '任何类型',
    TopicPostType.audio: '仅可发布声音',
    TopicPostType.video: '仅可发布视频',
    TopicPostType.image: '仅可发布图片',
    TopicPostType.text: '仅可发布纯文字',
  };

  @override
  Widget build(BuildContext context) {
    VoidCallback handler = _createSelectPostTypeHandler(context);
    return _TopicFieldCard(
      title: '允许发布的动态类型',
      child: ListTile(
        dense: true,
        title: _buildText(),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: handler,
      ),
    );
  }

  Widget _buildText() {
    return Selector<CreateTopicController, TopicPostType>(
      selector: (_, CreateTopicController controller) => controller.postType,
      builder: (_, TopicPostType value, __) {
        return Text(types[value]);
      },
    );
  }

  VoidCallback _createSelectPostTypeHandler(BuildContext context) {
    return () {
      showCupertinoModalPopup<TopicPostType>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            message: Text('选择允许发布的动态类型'),
            actions: types
                .map<TopicPostType, Widget>(
                  (key, value) {
                    Widget child = CupertinoActionSheetAction(
                      child: Text(value),
                      onPressed: () {
                        Navigator.of(context).pop<TopicPostType>(key);
                      },
                    );

                    return MapEntry<TopicPostType, Widget>(key, child);
                  },
                )
                .values
                .toList(),
          );
        },
      ).then((value) {
        if (value is TopicPostType) {
          context.read<CreateTopicController>().postType = value;
        }
      });
    };
  }
}

class _TopicJoinType extends StatelessWidget {
  const _TopicJoinType({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TopicFieldCard(
      title: '成员加入方式',
      child: Column(
        children: [
          radioListTileBuilder(TopicJoinType.freely, '自由加入'),
          radioListTileBuilder(TopicJoinType.examine, '需要审核'),
        ],
      ),
    );
  }

  Widget radioListTileBuilder(TopicJoinType value, String title) {
    return Selector<CreateTopicController, TopicJoinType>(
      selector: (_, CreateTopicController controller) => controller.joinType,
      builder: (BuildContext context, TopicJoinType selected, Widget child) {
        return RadioListTile<TopicJoinType>(
          value: value,
          groupValue: selected,
          title: child,
          dense: true,
          onChanged: _createRadioChangedHandler(context),
          activeColor: Theme.of(context).primaryColor,
        );
      },
      shouldRebuild: (TopicJoinType oldValue, TopicJoinType newValue) =>
          oldValue != newValue,
      child: Text(title),
    );
  }

  ValueChanged<TopicJoinType> _createRadioChangedHandler(BuildContext context) {
    return (TopicJoinType value) {
      context.read<CreateTopicController>().joinType = value;
    };
  }
}

class _TopicDescField extends StatelessWidget {
  const _TopicDescField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: Provider.of<CreateTopicController>(context, listen: false)
          .description,
      decoration: InputDecoration(
        labelText: '话题描述',
        labelStyle: Theme.of(context).textTheme.headline6,
        hintText: '简单介绍下话题吧',
        hintStyle: Theme.of(context).textTheme.caption,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 200,
      onChanged: _createFieldChangedHandler(context),
      validator: validator,
      autovalidate: true,
    );
  }

  ValueChanged<String> _createFieldChangedHandler(BuildContext context) {
    return (String value) {
      context.read<CreateTopicController>().description = value;
    };
  }

  static String validator(String value) {
    if (value == null || value.isEmpty) {
      return '请输入话题描述';
    } else if (value.length > 200) {
      return '话题描述过长';
    }

    return null;
  }
}

class _TopicTitleTextField extends StatelessWidget {
  const _TopicTitleTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '称谓',
        labelStyle: Theme.of(context).textTheme.headline6,
        hintText: '给话题的关注者起一个响亮的称谓吧',
        hintStyle: Theme.of(context).textTheme.caption,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      autovalidate: true,
      keyboardType: TextInputType.text,
      validator: validator,
      onChanged: _createFieldChangedHandler(context),
    );
  }

  ValueChanged<String> _createFieldChangedHandler(BuildContext context) {
    return (String value) {
      context.read<CreateTopicController>().title = value.trim();
    };
  }

  static String validator(String value) {
    if (value == null || value.isEmpty) {
      return '请输入称谓';
    } else if (value.length > 20) {
      return '称谓不能超过20个字符';
    } else if (!RegExp(r'^[\u4E00-\u9FA5A-Za-z0-9]+$').hasMatch(value)) {
      return '称谓不允许出现特殊符号';
    }

    return null;
  }
}

class _TopicNameTextField extends StatelessWidget {
  const _TopicNameTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '话题名称',
        labelStyle: Theme.of(context).textTheme.headline6,
        hintText: '给话题起个响亮的名字吧',
        hintStyle: Theme.of(context).textTheme.caption,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      autovalidate: true,
      keyboardType: TextInputType.text,
      validator: validator,
      onChanged: _createFieldChangedHandler(context),
    );
  }

  ValueChanged<String> _createFieldChangedHandler(BuildContext context) {
    return (String value) {
      context.read<CreateTopicController>().name = value.trim();
    };
  }

  static String validator(String value) {
    if (value == null || value.isEmpty) {
      return '请输入话题名称';
    } else if (value.length > 100) {
      return '话题名称过长，请限制在100个字符内';
    }

    return null;
  }
}

class _TopicCover extends StatelessWidget {
  const _TopicCover({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 80.0,
        height: 80.0,
        child: FlatButton(
          onPressed: _createImagePicker(context),
          color: Theme.of(context).highlightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: _coverWidgetBuilder(context),
              ),
              Positioned(
                bottom: 12.0,
                left: 0,
                right: 0,
                child: _titleBuilder(context),
              ),
            ],
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _titleBuilder(BuildContext context) {
    return Selector<CreateTopicController, File>(
      builder: (_, File cover, __) {
        Color color;
        Color backgroundColor;
        if (cover is File) {
          color = Colors.white;
          backgroundColor = Colors.black12;
        }
        return Text(
          '设置话题封面',
          style: Theme.of(context).textTheme.overline.copyWith(
                color: color,
                backgroundColor: backgroundColor,
              ),
          textAlign: TextAlign.center,
        );
      },
      selector: (_, CreateTopicController controller) => controller.cover,
    );
  }

  Widget _coverWidgetBuilder(BuildContext context) {
    return Selector<CreateTopicController, File>(
      builder: (_, File cover, Widget child) {
        if (cover is File) {
          return LayoutBuilder(builder: (_, BoxConstraints constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.file(
                cover,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            );
          });
        }
        return child;
      },
      selector: (_, CreateTopicController controller) => controller.cover,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Icon(Icons.image),
      ),
    );
  }

  VoidCallback _createImagePicker(BuildContext context) {
    final picker = ImagePicker();
    return () async {
      PickedFile pickedFile =
          await picker.getImage(source: ImageSource.gallery);
      File file = await _imageCropper(pickedFile.path);
      context.read<CreateTopicController>()..cover = file;
    };
  }

  Future<File> _imageCropper(String path) {
    return ImageCropper.cropImage(
      sourcePath: path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      aspectRatio: CropAspectRatio(ratioX: 512.0, ratioY: 512.0),
      androidUiSettings: AndroidUiSettings(
        initAspectRatio: CropAspectRatioPreset.square,
        hideBottomControls: true,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
        hidesNavigationBar: true,
        aspectRatioPickerButtonHidden: true,
        doneButtonTitle: "完成",
        cancelButtonTitle: "取消",
      ),
    );
  }
}

class _TopicFieldCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _TopicFieldCard({@required this.title, @required this.child, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                  color: CardTheme.of(context).shadowColor ??
                      Theme.of(context).secondaryHeaderColor,
                  blurRadius: 6.0,
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 12.0),
            child: child,
          ),
        ],
      ),
    );
  }
}
