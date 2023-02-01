import 'package:flutter/material.dart';

final _kFadeInTween = TweenSequence<double>([
  TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 0.1),
  TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 0.9),
]);
final _kFallingTween = TweenSequence<double>([
  TweenSequenceItem(tween: Tween<double>(begin: -20, end: 0), weight: 0.1),
  TweenSequenceItem(tween: Tween<double>(begin: 0, end: 0), weight: 0.9),
]);
final _kBouncingTweenX = TweenSequence<double>([
  TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 0.1),
  TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.5), weight: 0.1),
  TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 0.5), weight: 0.2),
  TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1), weight: 0.6),
]);
final _kBouncingTweenY = TweenSequence<double>([
  TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 0.1),
  TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0.5), weight: 0.1),
  TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.5), weight: 0.2),
  TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 1), weight: 0.6),
]);

/// This is an implicitly animated widget. Its [child] will fall down then bounce in [duration].
/// If [isRepeat] is true, the animation will be repeat after completed, else [onEnd] will be called.
class AnimatedBouncingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isRepeat;
  final Function? onEnd;

  /// Constructor.
  const AnimatedBouncingWidget({
    required this.child,
    Key? key,
    required this.duration,
    this.isRepeat = false,
    this.onEnd,
  }) : super(key: key);

  @override
  State<AnimatedBouncingWidget> createState() => _AnimatedBouncingWidgetState();
}

class _AnimatedBouncingWidgetState extends State<AnimatedBouncingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(covariant AnimatedBouncingWidget oldWidget) {
    if (widget.isRepeat) _start();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: widget.duration, value: 1);
    _controller.addListener(() async {
      if (!mounted) return;
      setState(() {});
      if (widget.isRepeat &&
          _controller.isCompleted &&
          !_controller.isDismissed) {
        _start();
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          widget.onEnd?.call();
        }
      }
    });
    _start();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    if (widget.isRepeat) {
      _controller.repeat();
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bouncingValue =
        CurveTween(curve: Curves.bounceOut).transform(_controller.value);
    final dy = _kFallingTween.transform(bouncingValue);
    final sx = _kBouncingTweenX.transform(bouncingValue);
    final sy = _kBouncingTweenY.transform(bouncingValue);
    final fadeInValue =
        CurveTween(curve: Curves.linear).transform(_controller.value);
    final opacity = _kFadeInTween.transform(fadeInValue);
    return Transform.translate(
      offset: Offset(0, dy),
      child: Transform.scale(
        child: Opacity(
          opacity: opacity,
          child: widget.child,
        ),
        scaleX: sx,
        scaleY: sy,
        alignment: Alignment.center,
      ),
    );
  }
}
