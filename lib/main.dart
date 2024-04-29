

import 'bar.dart';
import 'package:flutter/material.dart';
import 'adder.dart';
import 'my_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              primary: Colors.blueGrey,
              secondary: Colors.blueGrey),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'GraphiFY'),
          '/add': (context) => const AddWindow(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.lightBlue,
    Colors.blue,
    Colors.purple
  ];
  AnimationController? controller;
  AnimationController? colorController;
  Animation<double>? curve;
  Animation<double>? heightAnim;
  bool cycled = false;

  List<Bar> bars = [];
  Color? _current = Colors.red;
  int currentIndex = 0;
  AnimationStatusListener? listener;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    colorController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    curve = CurvedAnimation(parent: colorController!, curve: Curves.easeOut);
    heightAnim = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
    listener = (status) {
      if (status == AnimationStatus.completed) {
        controller!.reset();
        controller!.forward();
      }
    };
  }

  @override
  void dispose() {
    controller!.dispose();
    //colorController!.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: CustomPaint(
                  foregroundPainter: MyPainter(bars: bars, color: _current!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var newBars =
                    await Navigator.pushNamed(context, '/add') as List<Bar>;
                setState(() {
                  bars = newBars;
                });
              },
              child: const Text('Add Info'),
            ),
            ElevatedButton(
              onPressed: () {
                List<Tween<double>> animations = [];
                for (int i = 0; i < bars.length; i++) {
                  var heightBar = heightCalculator(MediaQuery.of(context).size.height * 0.4, bars[i].value!);
                  setState(() {
                    animations.add(Tween<double>(begin: 0, end: heightBar));
                    print("Added anim");
                  });
                }
                controller!.addListener(() {
                  setState(() {
                    for (int i = 0; i < bars.length; i++) {
                      bars[i].height = animations[i].animate(heightAnim!).value;
                    }
                  });
                });
                controller!.reset();
                controller!.forward();
              },
              child: const Text('Build Graph'),
            ),
            ElevatedButton(
              onPressed: () {
                currentIndex = (currentIndex + 1) % colors.length;
                Animation<Color?> colorAnim =
                    ColorTween(begin: _current, end: colors[currentIndex])
                        .animate(curve!);
                colorController!.addListener(() {
                  setState(() {
                    _current = colorAnim.value;
                  });
                });
                colorController!.reset();
                colorController!.forward();
              },
              child: const Text('Change colors'),
            ),
            ElevatedButton(
              onPressed: () {
                if (cycled) {
                  controller!.stop();
                  controller!.removeStatusListener(listener!);
                  cycled = false;
                } else {
                  controller!.reset();
                  controller!.forward();
                  controller!.addStatusListener(listener!);
                  cycled = true;
                }
              },
              child: const Text('Cycle rebuilding'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
