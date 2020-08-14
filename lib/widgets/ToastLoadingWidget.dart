import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'package:bot_toast/bot_toast.dart' show CancelFunc;

class ToastLoadingController with ChangeNotifier {
  double _progress;
  double get progress => _progress;
  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  String _text;
  String get text => _text;
  set text(String newValue) {
    _text = newValue;
    notifyListeners();
  }

  ToastLoadingController({double progress, String text}) {
    _progress = progress;
    _text = text;
  }
}

class ToastLoadingWidget extends StatelessWidget {
  const ToastLoadingWidget._({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<ToastLoadingController, double>(
            builder: (BuildContext context, double progress, Widget child) {
              if (progress is double) {
                return CircularProgressIndicator(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  value: progress,
                );
              }

              return child;
            },
            selector: (_, ToastLoadingController controller) =>
                controller.progress,
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          Selector<ToastLoadingController, String>(
            builder: (BuildContext context, String text, Widget child) {
              if (text is String && text.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return child;
            },
            selector: (_, ToastLoadingController controller) => controller.text,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  static CancelFunc show([ToastLoadingController controller]) {
    return BotToast.showCustomLoading(
      toastBuilder: (_) {
        return ChangeNotifierProvider(
          create: (_) => controller ?? ToastLoadingController(),
          child: ToastLoadingWidget._(),
        );
      },
    );
  }
}
