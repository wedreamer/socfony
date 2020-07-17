import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetPickerTextDelegate implements TextDelegate {
  factory AssetPickerTextDelegate() => _instance;

  AssetPickerTextDelegate._internal();

  static final AssetPickerTextDelegate _instance =
      AssetPickerTextDelegate._internal();

  @override
  String confirm = '确认';

  @override
  String cancel = '取消';

  @override
  String edit = '编辑';

  @override
  String emptyPlaceHolder = '这里空空如也';

  @override
  String gifIndicator = 'GIF';

  @override
  String heicNotSupported = '尚未支持HEIC类型资源';

  @override
  String loadFailed = '加载失败';

  @override
  String original = '原图';

  @override
  String preview = '预览';

  @override
  String select = '选择';

  @override
  String unSupportedAssetType = '尚未支持的资源类型';

  @override
  String durationIndicatorBuilder(Duration duration) {
    return DefaultTextDelegate().durationIndicatorBuilder(duration);
  }
}
