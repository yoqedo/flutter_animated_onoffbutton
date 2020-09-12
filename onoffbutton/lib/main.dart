import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter On Off Button',
      home: OnOffButton(
        onText: 'N',
        offText: 'FF',
      ),
    );
  }
}

class OnOffButton extends StatefulWidget {
  final String onText, offText;
  OnOffButton({this.offText, this.onText});

  @override
  _OnOffButtonState createState() => _OnOffButtonState();
}

class _OnOffButtonState extends State<OnOffButton>
    with TickerProviderStateMixin {
  bool reverse = false;
  bool isSelected = false;

  AnimationController _controller;
  AnimationController _controller2;
  Tween<Color> _colorTween, _colorBorderTween;
  Tween<double> _scaleTween, _widthTween;
  Animation _colorAnimation,
      _colorBorderAnimation,
      _scaleAnimation,
      _widthAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    _scaleTween = Tween<double>(begin: 1.0, end: 0.9);
    _scaleAnimation = _scaleTween.animate(_controller);
    _widthTween = Tween<double>(begin: 70.0, end: 150.0);
    _widthAnimation = _widthTween.animate(_controller);

    _controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 50))
          ..addListener(() {});
    _colorTween = ColorTween(
        begin: Color.fromRGBO(169, 169, 169, 1),
        end: Color.fromRGBO(50, 205, 50, 1));
    _colorAnimation = _colorTween.animate(_controller2);
    _colorBorderTween = ColorTween(
        begin: Color.fromRGBO(105, 105, 105, 1),
        end: Color.fromRGBO(34, 139, 34, 1));
    _colorBorderAnimation = _colorBorderTween.animate(_controller2);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void onTapUp(TapUpDetails details) {
    _controller.reverse();
    reverse ? _controller2.reverse() : _controller2.forward();
  }

  void onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTapUp: onTapUp,
              onTapDown: onTapDown,
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                  reverse = !reverse;
                });
              },
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  height: 70,
                  width: 150,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                  child: Align(
                    alignment:
                        reverse ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      height: 70,
                      width: _widthAnimation.value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        border: Border.all(
                            width: 3, color: _colorBorderAnimation.value),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3),
            Container(
              child: isSelected
                  ? Text(
                      widget.onText,
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          color: _colorAnimation.value),
                    )
                  : Text(
                      widget.offText,
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: _colorAnimation.value,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
