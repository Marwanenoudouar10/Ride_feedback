import 'package:daily_expression_face/widgets/paint_face.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpressionFaceScreen extends StatefulWidget {
  const ExpressionFaceScreen({super.key});

  @override
  State<ExpressionFaceScreen> createState() => _ExpressionFaceScreenState();
}

class _ExpressionFaceScreenState extends State<ExpressionFaceScreen>
    with SingleTickerProviderStateMixin {
  double value = 1;
  static const double minValue = 1;
  static const double maxValue = 3;
  Color endColor = const Color(0xffffdada);
  Color startColor = const Color(0xffdaffdb);
  late AnimationController controller;
  late Animation<double> okAnimation;
  late Animation<double> badAnimation;
  late Animation<double> goodAnimation;
  late Animation<double> okEyeBall;
  late Animation<double> badEyeBall;
  late Animation<double> goodEyeBall;
  late Animation containerColor;
  late Animation backgroundColor;

  String getExpression(double value) {
    if (value < 2) {
      return "Bad ride";
    } else if (value < 3) {
      return "Perfect one";
    } else {
      return "Not bad";
    }
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    okAnimation = Tween<double>(begin: 0.4, end: 0.7).animate(controller);
    badAnimation = Tween<double>(begin: 0.7, end: 0.5).animate(controller);
    goodAnimation = Tween<double>(begin: 0.5, end: 0.9).animate(controller);
    okEyeBall = Tween<double>(begin: 0.05, end: 0.02)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    badEyeBall = Tween<double>(begin: 0, end: 10)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    goodEyeBall = Tween<double>(begin: -10, end: -0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    containerColor =
        ColorTween(begin: startColor, end: endColor).animate(controller);
    backgroundColor =
        ColorTween(begin: startColor, end: const Color(0xfffa9999))
            .animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateColorTween(double value) {
    if (value < 2) {
      containerColor = ColorTween(begin: const Color(0xffdaffdb), end: endColor)
          .animate(controller);
      backgroundColor = ColorTween(
              begin: const Color(0xffdaffdb), end: const Color(0xfffa9999))
          .animate(controller);
    } else if (value < 3) {
      containerColor =
          ColorTween(begin: endColor, end: startColor).animate(controller);
      backgroundColor = ColorTween(
              begin: const Color(0xfffa9999), end: const Color(0xff9dfca1))
          .animate(controller);
    } else if (value < 4) {
      containerColor =
          ColorTween(begin: startColor, end: const Color(0xffffffd9))
              .animate(controller);
      backgroundColor = ColorTween(
              begin: const Color(0xffffffd9), end: const Color(0xfffaf98b))
          .animate(controller);
    }
    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Center(
            child: Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  color: backgroundColor.value,
                ),
                Positioned(
                    top: 40,
                    left: size.width / 2 - 72,
                    child: Text(
                      "Ride Finished",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: ContainerClipper(),
                    child: Container(
                      height: size.height * 0.9,
                      decoration: BoxDecoration(
                        color: containerColor.value,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height / 6,
                  left: size.width * 0.1,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "How was \nyour ride ?",
                          style: GoogleFonts.poppins(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        getExpression(value),
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: CustomPaint(
                          painter: FacePainter(
                              okeyeball: okEyeBall.value,
                              goodeyeball: goodEyeBall.value,
                              badeyeball: badEyeBall.value,
                              expressionValue: value,
                              okvalue: okAnimation.value,
                              badvalue: badAnimation.value,
                              goodvalue: goodAnimation.value),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Slider(
                          thumbColor: Colors.white,
                          inactiveColor: Colors.black38,
                          value: value,
                          min: minValue,
                          max: maxValue,
                          divisions: 2,
                          onChanged: (double newValue) {
                            setState(() {
                              value = newValue;
                              updateColorTween(value);
                            });
                            if (value < 2) {
                              controller.reset();
                              controller.forward();
                            } else if (value < 3) {
                              controller.reset();
                              controller.forward();
                            } else if (value < 4) {
                              controller.reset();
                              controller.forward();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.10,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icon.png",
                            height: 30,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Add a comment",
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CupertinoButton(
                          color: Colors.black,
                          child: const Text("Done"),
                          onPressed: () {})
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    ));
  }
}
