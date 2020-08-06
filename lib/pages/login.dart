import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:snsmax/cloudbase.dart' hide RegExp;

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

  static Future<bool> route(BuildContext context) async {
    CloudBaseAuthState state = await CloudBase().auth.getAuthState();
    if (state.authType == CloudBaseAuthType.ANONYMOUS) {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Dialog(
          child: const LoginPage(),
        ),
      );
    }

    return true;
  }
}

class _LoginPageState extends State<LoginPage> {
  String phone;
  String code;
  bool sendingCode = false;
  Timer sentCodeTimer;
  int sentCodeCountdown = 0;

  bool get hasPhone => RegExp(r'^1[3-9]\d{9}$').hasMatch(phone.toString());
  bool get allowSendCode {
    return (sendingCode == false) && hasPhone;
  }

  @override
  void dispose() {
    sentCodeTimer?.cancel();
    super.dispose();
  }

  bool get isPhone {
    return MediaQuery.of(context).size.shortestSide < 600;
  }

  bool get isPortrait {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      buildAccount(context),
      buildCode(context),
      buildButton(context),
      const Center(
        child: const _Agreement(),
      ),
    ];

    if (!isPortrait && isPhone) {
      children = [
        Expanded(
          child: ListView(
            children: children,
          ),
        ),
      ];
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize:
            (isPhone && !isPortrait) ? MainAxisSize.max : MainAxisSize.min,
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            leading: CloseButton(
              onPressed: onClose,
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 12,
        right: 12,
      ),
      child: Row(
        children: <Widget>[
          buildWeChat(context),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FlatButton(
                shape: const StadiumBorder(),
                color: Theme.of(context).primaryColor,
                onPressed: onLogin,
                child: Text('登录'),
                colorBrightness: Brightness.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeChat(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/wechat.webp',
        fit: BoxFit.contain,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(48),
      ),
      width: 48,
      height: 48,
      margin: const EdgeInsets.only(
        right: 12,
      ),
      padding: EdgeInsets.all(8),
    );
  }

  Widget buildCode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 20,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(100)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "请输入验证码",
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  fillColor: Colors.transparent,
                  filled: true,
                  prefixIcon: const Icon(Icons.code),
                ),
                onChanged: onChangeCode,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: GestureDetector(
                child: Text(
                  sentCodeCountdown <= 0
                      ? '获取验证码'
                      : (sentCodeCountdown.toString() + 's'),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(allowSendCode ? 1 : .4),
                      ),
                ),
                onTap: onSendCode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "请输入手机号码",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(100),
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          prefixIcon: const Icon(Icons.account_circle),
        ),
        onChanged: onChangePhone,
      ),
    );
  }

  void onClose() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop<bool>(false);
  }

  void onLogin() async {
    FocusScope.of(context).unfocus();
    CancelFunc cancel = BotToast.showLoading();
    try {
      CloudBaseResponse result = await CloudBase().callFunction('sms', {
        "action": "with-code-login",
        "phone": phone,
        "code": code,
      });
      CloudBaseAuthState state =
          await CloudBase().auth.signInWithTicket(result.data.toString());
      if (state is! CloudBaseAuthState) {
        throw FormatException();
      }
      Navigator.of(context).pop<bool>(true);
    } catch (e) {
      BotToast.showText(text: '登录失败');
    } finally {
      cancel();
    }
  }

  void onChangePhone(String value) {
    setState(() {
      phone = value;
    });
  }

  void onChangeCode(String value) {
    setState(() {
      code = value;
    });
  }

  void onSendCode() {
    FocusScope.of(context).unfocus();
    if (!hasPhone || sentCodeCountdown > 0) {
      return;
    }
    final String functionName = 'sms';
    final Map<String, Object> params = {
      "action": "send-code",
      "phone": phone,
    };
    CancelFunc cancel = BotToast.showLoading();
    CloudBase()
        .callFunction(functionName, params)
        .whenComplete(() => cancel())
        .then((_) {
      BotToast.showText(text: '获取成功！');
      createTimer();
    }).catchError((_) {
      BotToast.showText(text: '获取验证码失败');
    });
  }

  void createTimer() {
    sentCodeTimer?.cancel();
    setState(() {
      sentCodeCountdown = 60;
      sentCodeTimer =
          Timer.periodic(const Duration(seconds: 1), onTimerCallback);
    });
  }

  void onTimerCallback(Timer timer) {
    if (sentCodeCountdown <= 0) {
      sentCodeTimer?.cancel();
      timer?.cancel();
    }
    setState(() {
      sentCodeCountdown -= 1;
    });
  }
}

class _Agreement extends StatelessWidget {
  const _Agreement({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 12, vertical: 12).copyWith(top: 36),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(text: '登录即代表同意《'),
            TextSpan(
              text: '用户协议',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            TextSpan(text: '》和《'),
            TextSpan(
              text: '隐私政策',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            TextSpan(text: '》'),
          ],
        ),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
