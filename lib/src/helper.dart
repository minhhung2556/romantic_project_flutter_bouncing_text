import 'dart:math';

import 'package:flutter/material.dart';

import 'index.dart';

const _kLineBreakMark = '֍';
const _kLineBreakChar = '\n';
const _kSpaceChar = ' ';

enum FallingBouncingTextModes {
  sequenceOneTime,
  randomlyLoop,
  randomlyOneTime,
}

List<InlineSpan> createAnimatedBouncingSpans(
  String text,
  TextStyle textStyle,
  FallingBouncingTextModes mode,
  Duration characterDuration,
  Duration characterDelay,
  Function? onEnd,
) {
  InlineSpan _buildAWord(String word, int paragraphIndex, int wordIndex, int wordsLength) {
    int i = 1;
    return WidgetSpan(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: word.characters.map(
          (e) {
            final delayDuration =
                mode == FallingBouncingTextModes.randomlyLoop || mode == FallingBouncingTextModes.randomlyOneTime
                    ? Duration(
                        milliseconds: Random.secure().nextInt(
                            characterDuration.inMilliseconds + characterDelay.inMilliseconds * (paragraphIndex + i)))
                    : Duration(milliseconds: characterDelay.inMilliseconds * (paragraphIndex + i));
            i++;
            final _onCompleted = i > word.length && wordIndex == wordsLength - 1 ? onEnd : null;
            return FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.data != 1) {
                  return SizedBox();
                } else {
                  return AnimatedFallingBouncingWidget(
                    duration: characterDuration,
                    isRepeat: mode == FallingBouncingTextModes.randomlyLoop,
                    child: Text(
                      e,
                      style: textStyle,
                    ),
                    onEnd: _onCompleted,
                  );
                }
              },
              initialData: 0,
              future: Future.delayed(delayDuration, () => 1),
            );
          },
        ).toList(growable: false),
      ),
    );
  }

  InlineSpan _buildALineBreak() => TextSpan(
        text: _kLineBreakChar,
        style: textStyle,
      );

  InlineSpan _buildSpace() => TextSpan(
        text: _kSpaceChar,
        style: textStyle,
      );

  final paragraph = text.replaceAll(_kLineBreakChar, '$_kSpaceChar$_kLineBreakMark$_kSpaceChar');
  final words = paragraph.split(_kSpaceChar);
  // final wordsWithoutLineBreak = words.where((e) => e != _kLineBreakMark);
  var spans = <InlineSpan>[];
  int paragraphIndex = 0;
  for (var i = 0; i < words.length; ++i) {
    var word = words[i];
    if (word == _kLineBreakMark) {
      spans.add(_buildALineBreak());
    } else {
      spans.add(_buildAWord(word, paragraphIndex, i, words.length));
      paragraphIndex += word.length;
      if (i < words.length - 1) spans.add(_buildSpace());
    }
  }

  return spans.toList(growable: false);
}
