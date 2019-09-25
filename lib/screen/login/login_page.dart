import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            buildLoginButton(context),
            buildExperienceNowButton(context),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RoundedRectangleButton(
        style: Theme.of(context).textTheme.body2.copyWith(color: Colors.red),
        minWidth: 250,
        height: 40,
        title: "手机号码登录",
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return _LoginPhoneWidget();
          }));
        },
      ),
    );
  }

  Widget buildExperienceNowButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: RoundedRectangleButton(
        color: Colors.transparent,
        borderColor: Colors.white70,
        style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
        minWidth: 250,
        height: 40,
        title: "立即体验",
        onPressed: () {},
      ),
    );
  }
}

/// 圆角按钮
class RoundedRectangleButton extends StatelessWidget {
  final double height;

  final double minWidth;

  final double circular;

  final Color focusColor;

  final VoidCallback onPressed;

  final String title;

  final TextStyle style;

  final Color color;

  final Color borderColor;

  const RoundedRectangleButton({
    Key key,
    this.height,
    this.minWidth,
    this.circular,
    this.focusColor = Colors.white,
    @required this.onPressed,
    @required this.title,
    this.style,
    this.color = Colors.white,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    ShapeBorder shapeBorder;
    shapeBorder = RoundedRectangleBorder(
      side: BorderSide(color: borderColor),
      borderRadius:
          BorderRadius.circular(height != null ? height / 2 : circular ?? 20),
    );
    Widget result = FlatButton(
      color: color,
      focusColor: focusColor,
      onPressed: onPressed,
      shape: shapeBorder,
      child: Text(
        title,
        style: style ?? themeData.textTheme.caption,
      ),
    );
    if (height != null && minWidth != null) {
      result = ButtonTheme(
        height: height,
        minWidth: minWidth,
        child: result,
      );
    }
    return result;
  }
}

class _LoginPhoneWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPhoneState();
  }
}

class _LoginPhoneState extends State<_LoginPhoneWidget> {
  String _phone = "";

  String _passWorld = "";

  bool _isInputPhone = true;

  FocusNode focusNode = new FocusNode();

  bool _isOnSwitchKey = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!_isInputPhone) {
          setState(() {
            if(_isOnSwitchKey){
              return;
            }
            //返回手机号页面
            _passWorld = "";
            _isInputPhone = true;
            _switchKeyboardType();
          });
          return Future<bool>(() => false);
        }
        return Future<bool>(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("手机号登录"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHint(context),
            //输入框
            _buildInput(context),
            //按钮
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: RoundedRectangleButton(
        color: Theme.of(context).primaryColor,
        minWidth: double.infinity,
        height: 40,
        title: _isInputPhone ? "下一步" : "登录",
        style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
        onPressed: () {
          //正则校验
          _onButtonPressed(context);
        },
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: _isInputPhone ? _phone : _passWorld,
            selection: TextSelection.fromPosition(
              TextPosition(
                  affinity: TextAffinity.downstream,
                  offset: _isInputPhone ? _phone.length : _passWorld.length),
            ),
          ),
        ),
        focusNode: focusNode,
        keyboardType: _isInputPhone ? TextInputType.phone : TextInputType.text,
        autofocus: true,
        obscureText: !_isInputPhone,
        decoration: InputDecoration(
          hintText: _isInputPhone ? "请输入手机号" : "请输入密码",
        ),
        onChanged: (s) {
          if (_isInputPhone) {
            _phone = s;
          } else {
            _passWorld = s;
          }
        },
        cursorColor: Theme.of(context).textTheme.caption.color,
      ),
    );
  }

  Widget _buildHint(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: _isInputPhone
          ? Text(
              "未注册手机号登录后将自动创建账号",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption,
            )
          : Container(),
    );
  }

  void _onButtonPressed(BuildContext context) {
    if(_isOnSwitchKey){
      return;
    }
    if (!_isInputPhone) {
      //进行登录
      _onNetLogin(context);
      return;
    }
    //正则校验
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(_phone);
    if (matched) {
      ///输入密码
      setState(() {
        _isInputPhone = false;
        _switchKeyboardType();
      });
    } else {
      Toast.show("手机号码错误", context);
    }
  }
  /// 先隐藏键盘在弹出键盘,切换输入方式
  void _switchKeyboardType() {
    _isOnSwitchKey = true;
    focusNode.unfocus();
    Future.delayed(
      Duration(milliseconds: 600),
    ).then((d) {
      focusNode.requestFocus();
      _isOnSwitchKey = false;
    });
  }
  ///网络登录
  void _onNetLogin(BuildContext context) async{

  }
}
