import 'package:flutter/material.dart';
import 'package:flutter_bouncing_text/flutter_bouncing_text.dart';

const _kColors = [
  Color(0xff4D4DFF),
  Color(0xff2c85b7),
  Color(0xff693480),
];
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var characterDuration = Duration(seconds: 1);
  var characterDelay = Duration(seconds: 1);
  var textAlign = TextAlign.start;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Romantic Developer'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Text Align',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      children: [
                        ...TextAlign.values.map(
                          (e) => Row(
                            children: [
                              Radio<TextAlign>(
                                value: e,
                                groupValue: textAlign,
                                onChanged: (TextAlign? value) {
                                  if (value != null) {
                                    setState(() {
                                      textAlign = value;
                                    });
                                  }
                                },
                              ),
                              Text(
                                e.name,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Character Duration',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: characterDuration.inMilliseconds / 1000.0,
                      min: 1,
                      max: 3,
                      divisions: 10,
                      onChanged: (e) => setState(() {
                        characterDuration =
                            Duration(milliseconds: (e * 1000).toInt());
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Character Delay',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: characterDelay.inMilliseconds.toDouble(),
                      min: 100,
                      max: 3000,
                      divisions: 20,
                      onChanged: (e) => setState(() {
                        characterDelay = Duration(milliseconds: e.toInt());
                      }),
                    ),
                  ],
                ),
              ),
              ...BouncingTextModes.values.map(
                (e) {
                  final index = BouncingTextModes.values.indexOf(e);
                  return Column(
                    children: [
                      Text(
                        e.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        color: _kColors[index],
                        padding: const EdgeInsets.all(20.0),
                        child: AnimatedBouncingText(
                          key: ValueKey(DateTime.now()),
                          text: '($index) I am\nRomantic Developer.',
                          mode: e,
                          textAlign: textAlign,
                          characterDuration: characterDuration,
                          characterDelay: characterDelay,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          onEnd: () {
                            print('_HomeState.build.onEnd.$index');
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
