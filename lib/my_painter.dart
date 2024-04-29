import 'package:flutter/material.dart';
import 'bar.dart';

class MyPainter extends CustomPainter {
  List<Bar> bars;
  final Color color;
  Animation<double>? heightAnim;
  double barHeight = 0;

  MyPainter({required this.bars, this.color = Colors.blue, this.heightAnim});

  int maxHeight() {
    int max = 0;
    for (int i = 0; i < bars.length; i++) {
      if (bars[i].value! > max) {
        max = bars[i].value!;
      }
    }
    return max;
  }

  double heightCalculator(double height, int value) {
    return height * value / maxHeight();
  }

  @override
  void paint(Canvas canvas, Size size) {
    const double arrows = 5;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    //drawing coordinates
    canvas.drawLine(const Offset(5, 0), Offset(5, size.height - 5), paint);
    canvas.drawLine(
        Offset(5, size.height - 5), Offset(size.width, size.height - 5), paint);
    canvas.drawLine(const Offset(0, 5), const Offset(5, 0), paint);
    canvas.drawLine(const Offset(5, 0), const Offset(10, 5), paint);
    canvas.drawLine(Offset(size.width - 5, size.height - 10),
        Offset(size.width, size.height - 5), paint);
    canvas.drawLine(Offset(size.width, size.height - 5),
        Offset(size.width - 5, size.height), paint);

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 35 / bars.length,
    );

    //drawing bars
    for (Bar bar in bars) {
      if (bar.value == null) {
        bar.value == 0;
      }
      double barWidth = size.width / (bars.length * 2);
      double barHeight = bar.height!;

      double x = bars.indexOf(bar) * barWidth * 2 + barWidth;
      double y = size.height - (barHeight / 2) - arrows - 1;
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(x, y), width: barWidth, height: barHeight),
          paint2);

      var textSpan = TextSpan(
        text: bar.name,
        style: textStyle,
      );
      var textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: barWidth,
      );
      if (barHeight > textPainter.height * 2) {
        textPainter.paint(canvas,
            Offset((x - textPainter.width / 2), (y - textPainter.height / 2)));
      }

      var textSpan2 = TextSpan(
        text: bar.value.toString(),
        style: textStyle,
      );
      textPainter = TextPainter(
        text: textSpan2,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: barWidth,
      );

      if (barHeight > textPainter.height * 2) {
        textPainter.paint(
            canvas,
            Offset((x - textPainter.width / 2),
                (y - textPainter.height / 2) + textPainter.height + 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
