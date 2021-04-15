import 'package:animated_widgets/animated_widgets.dart';
import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:communication/helpers/api_service.dart';
import 'package:communication/helpers/images.dart';
import 'package:communication/helpers/shop_details.dart';
import 'package:communication/widgets/Messages.dart';
import 'package:communication/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool viewLogin = false;

  @override
  Widget build(BuildContext context) {
    Messages.setContext(context);
    return Scaffold(
      body: BackgroundImage(
        image: image1,
        child: Stack(
          children: [
            Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(),
                  Name(),
                  LoginBtn(
                    onPressed: () {
                      setState(() {
                        viewLogin = true;
                      });
                    },
                  ),
                  LoginBtn(
                    onPressed: () {
                      _initPrinter();
                    },
                    color: Colors.green,
                    text: 'Printer Test',
                  ),
                ],
              ),
            ),
            viewLogin
                ? Login(
                    onClosed: _hideLoginView,
                  )
                : Container(),
            // Positioned(
            //   child: Container(
            //     height: 50,
            //     child: MyAppBar(
            //       backgroundColor: Colors.transparent,
            //       appBar: AppBar(),
            //       title: '',
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _initPrinter() async {
    ApiService.shared.testPrinter().then((value) {
      if (value['success']) {
        Messages.simpleMessage(
            head: 'Success!', body: "Printer initialized successfully");
      } else {
        Messages.simpleMessage(
            head: 'Failed!',
            body: "Please run printer.bat file in C:/printer_node");
      }
    });
  }

  _hideLoginView() {
    setState(() {
      viewLogin = false;
    });
  }
}

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget(
      enabled: true,
      values: [0, 1],
      delay: Duration(milliseconds: 200),
      duration: Duration(seconds: 1),
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 5)),
        child: Center(
          child: Image.asset(logo),
        ),
      ),
    );
  }
}

class Name extends StatelessWidget {
  const Name({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TranslationAnimatedWidget(
      enabled: true,
      curve: Curves.easeOut,
      duration: Duration(seconds: 1),
      values: [Offset(0, 500), Offset(0, 0)],
      child: Container(
        width: 400,
        margin: EdgeInsets.only(top: 10),
        child: Center(
          child: Text(
            shopName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black, offset: Offset(1, 1), blurRadius: 8)
                ]),
          ),
        ),
      ),
    );
  }
}

class LoginBtn extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  const LoginBtn(
      {Key key,
      @required this.onPressed,
      this.color = Colors.blue,
      this.text = 'LOGIN'})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget(
      enabled: true,
      curve: Curves.easeIn,
      delay: Duration(milliseconds: 800),
      duration: Duration(milliseconds: 500),
      values: [0, 1],
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: 300,
        height: 50,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
