import 'package:flutter/material.dart';

import 'index.dart';

/// A Romantic Bouncing Text
/// Ideally it is a [RichText] to control the paragraph easier.
/// The helper method [createAnimatedBouncingSpans] is used to create its child spans.
/// [mode] : determine how does the animation act.
/// [text] : each character will be convert to [AnimatedBouncingWidget].
/// [textStyle] : see [Text.style].
/// [characterDuration] : duration to animate a character, it will be used as [AnimatedBouncingWidget.duration].
/// [characterDelay] : duration to delay before animating a character.
/// [onEnd] : see [AnimatedBouncingWidget.onEnd].
/// [textAlign] : see [RichText.textAlign].
class AnimatedBouncingText extends StatelessWidget {
  final BouncingTextModes mode;
  final String text;
  final TextStyle textStyle;
  final Duration characterDuration;
  final Duration characterDelay;
  final Function? onEnd;
  final TextAlign textAlign;

  /// Constructor.
  const AnimatedBouncingText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.characterDuration = const Duration(milliseconds: 1000),
    this.characterDelay = const Duration(milliseconds: 300),
    this.mode = BouncingTextModes.sequenceOneTime,
    this.onEnd,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: textStyle,
        children: createAnimatedBouncingSpans(
          text: text,
          textStyle: textStyle,
          mode: mode,
          characterDuration: characterDuration,
          characterDelay: characterDelay,
          onEnd: onEnd,
        ),
      ),
    );
  }
}
