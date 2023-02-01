import 'package:flutter/material.dart';

import 'index.dart';

class AnimatedFallingBouncingText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final FallingBouncingTextModes mode;
  final Duration characterDuration;
  final Duration characterDelay;
  final Function? onEnd;
  final TextAlign textAlign;

  const AnimatedFallingBouncingText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.characterDuration = const Duration(milliseconds: 1000),
    this.characterDelay = const Duration(milliseconds: 300),
    this.mode = FallingBouncingTextModes.sequenceOneTime,
    this.onEnd,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: textStyle,
        children: createAnimatedBouncingSpans(text, textStyle, mode, characterDuration, characterDelay, onEnd),
      ),
    );
  }
}
