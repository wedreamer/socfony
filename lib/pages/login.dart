import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:fans/cloudbase/function/TcbSmsCommand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fans/provider/AppAuthProvider.dart';

import '../cloudbase.dart' hide RegExp;

class LoginController with ChangeNotifier {
  String _phone;
  String get phone => _phone;
  set phone(String newValue) {
    _phone = newValue;
    notifyListeners();
  }

  String _code;
  String get code => _code;
  set code(String newValue) {
    _code = newValue;
    notifyListeners();
  }

  bool _showSending = false;
  bool get showSending => _showSending;
  set showSending(bool newValue) {
    _showSending = newValue;
    notifyListeners();
  }

  bool _showTimer = false;
  bool get showTimer => _showTimer;
  set showTimer(bool newValue) {
    if (newValue == true) {
      createTimer();
    } else {
      timer?.cancel();
      _showTimer = false;
      notifyListeners();
    }
  }

  Timer _timer;
  Timer get timer => _timer;

  int _countdown = 0;
  int get countdown => _countdown;

  createTimer() {
    _timer?.cancel();
    _countdown = 60;
    _showTimer = true;
    _timer = Timer.periodic(Duration(seconds: 1), _onTimerCallback);
    notifyListeners();
  }

  void _onTimerCallback(Timer timer) {
    if (countdown <= 1) {
      showTimer = false;
    } else {
      _countdown -= 1;
      notifyListeners();
    }
  }
}

class LoginPage extends StatelessWidget {
  static Future<bool> route(BuildContext context) async {
    CloudBaseAuthState state = await CloudBase().auth.getAuthState();
    if (state.authType == CloudBaseAuthType.ANONYMOUS ||
        state.authType == CloudBaseAuthType.EMPTY ||
        state == null) {
      return Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
          fullscreenDialog: true,
        ),
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.color,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('登录'),
      ),
      body: GestureDetector(
        child: ChangeNotifierProvider(
          create: (_) => LoginController(),
          child: ListView(
            children: [
              _LoginPageLogo(),
              _LoginAccount(),
              _LoginPhoneCode(),
              _LoginButton(),
            ],
          ),
        ),
        onTap: _createFocusUnHandler(context),
      ),
    );
  }

  VoidCallback _createFocusUnHandler(BuildContext context) {
    return () {
      FocusScope.of(context).unfocus();
    };
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0).copyWith(top: 36.0),
      child: FlatButton(
        onPressed: _createLoginHandler(context),
        child: Text('登录'),
        shape: StadiumBorder(),
        color: Theme.of(context).primaryColor,
        colorBrightness: Brightness.dark,
        padding: EdgeInsets.symmetric(vertical: 12.0),
      ),
    );
  }

  VoidCallback _createLoginHandler(BuildContext context) {
    return () async {
      LoginController controller = context.read<LoginController>();
      CancelFunc cancel = BotToast.showLoading();
      try {
        // create login ticket.
        String ticket = await TcbSmsCommand.createLoginTicket(
            controller.phone, controller.code);

        // using ticket login.
        await CloudBase().auth.signInWithTicket(ticket);

        // fetch state and user.
        await context.read<AppAuthProvider>().fetch();

        cancel();
        Navigator.of(context).pop(true);
        BotToast.showText(text: '登录成功');
      } on UnimplementedError catch (e) {
        print(e);
        cancel();
        BotToast.showText(text: e.message);
      } catch (e) {
        print(e);
        cancel();
        BotToast.showText(text: '登录失败');
      }
    };
  }
}

class _LoginPhoneCode extends StatelessWidget {
  const _LoginPhoneCode({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12).copyWith(top: 24),
      child: TextField(
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "请输入验证码",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(36.0),
          ),
          contentPadding: EdgeInsets.all(12.0),
          fillColor: Theme.of(context).splashColor,
          filled: true,
          prefixIcon: const Icon(Icons.code),
          suffixIcon: UnconstrainedBox(
            child: _LoginPhoneCodeActionButton(),
          ),
        ),
        onChanged: _createCodeChangedHandler(context),
      ),
    );
  }

  ValueChanged<String> _createCodeChangedHandler(BuildContext context) {
    return (String value) {
      context.read<LoginController>().code = value.trim();
    };
  }
}

class _LoginPhoneCodeActionButton extends StatelessWidget {
  const _LoginPhoneCodeActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 24.0),
          child: Text(
            textBuilder(context),
            style: TextStyle(
              color: textColorBuilder(context),
            ),
          ),
        ),
      ),
      onTap: _createSendCodeHandler(context),
    );
  }

  VoidCallback _createSendCodeHandler(BuildContext context) {
    return () {
      LoginController controller = context.read<LoginController>();
      controller.showSending = true;
      TcbSmsCommand.sendCode(controller.phone).then((_) {
        BotToast.showText(text: '验证码发送成功');
        controller.showTimer = true;
      }).catchError((error) {
        print(error);
        String message = '发送验证码失败';
        if (error is UnimplementedError) {
          message = error.message;
        }
        BotToast.showText(text: message);
      }).whenComplete(() {
        controller.showSending = false;
      });
    };
  }

  bool hasPhone(String value) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(value.toString());
  }

  Color textColorBuilder(BuildContext context) {
    LoginController controller = context.watch<LoginController>();
    Color color = Theme.of(context).primaryColor;
    if (controller.showTimer ||
        controller.showSending ||
        !hasPhone(controller.phone)) {
      return color.withOpacity(0.4);
    }

    return color;
  }

  String textBuilder(BuildContext context) {
    LoginController controller = context.watch<LoginController>();
    if (controller.showSending) {
      return '获取中...';
    } else if (controller.showTimer) {
      return controller.countdown.toString();
    }
    return '获取验证码';
  }
}

class _LoginAccount extends StatelessWidget {
  const _LoginAccount({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12).copyWith(top: 24),
      child: TextField(
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "请输入手机号码",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(36.0),
          ),
          contentPadding: EdgeInsets.all(12.0),
          fillColor: Theme.of(context).splashColor,
          filled: true,
          prefixIcon: const Icon(Icons.account_circle),
        ),
        onChanged: _createAccountChangedHandler(context),
      ),
    );
  }

  ValueChanged<String> _createAccountChangedHandler(BuildContext context) {
    return (String value) {
      context.read<LoginController>().phone = value.trim();
    };
  }
}

class _LoginPageLogo extends StatelessWidget {
  const _LoginPageLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRRect(
          child: Image.asset(
            'assets/ios_launcher.png',
            height: 96.0,
          ),
          borderRadius: BorderRadius.circular(96.0),
        ),
      ),
    );
  }
}

// class _Agreement extends StatelessWidget {
//   const _Agreement({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//           EdgeInsets.symmetric(horizontal: 12, vertical: 12).copyWith(top: 36),
//       child: Text.rich(
//         TextSpan(
//           children: <TextSpan>[
//             TextSpan(text: '登录即代表同意《'),
//             TextSpan(
//               text: '用户协议',
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             TextSpan(text: '》和《'),
//             TextSpan(
//               text: '隐私政策',
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             TextSpan(text: '》'),
//           ],
//         ),
//         style: Theme.of(context).textTheme.caption,
//       ),
//     );
//   }
// }
