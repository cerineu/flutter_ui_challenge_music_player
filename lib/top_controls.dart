import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';
import 'package:meta/meta.dart';
import 'package:music_player/theme.dart';

class RadialSeekBar extends StatefulWidget {

  final double progress;
  final Function(double) onSeekRequested;
  final double seekPercent;
  final Widget child;

  RadialSeekBar({
    this.progress = 0.0,
    this.onSeekRequested,
    this.seekPercent,
    this.child,
  });

  @override
  RadialSeekBarState createState() {
    return new RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {

  double _progress;
  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }


  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  void _onDragStart(PolarCoord startCoord) {
    print('start drag');
    _startDragCoord = startCoord;
    _startDragPercent = _progress;
  }

  void _onDragUpdate(PolarCoord updateCoord) {
    print('update drag');
    final dragAngle = updateCoord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);

    setState(() {
      _currentDragPercent = (_startDragPercent + dragPercent) % 1.0;
    });
  }

  void _onDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }

    setState(() {
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;
    if (_currentDragPercent != null) {
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumbPosition = widget.seekPercent;
    }

    return new RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: new Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: new Center(
          child: new Container(
            width: 140.0,
            height: 140.0,
            child: new RadialProgressBar(
              progress: _progress,
              thumbPosition: thumbPosition,
              trackWidth: 3.0,
              trackColor: const Color(0xFFDDDDDD),
              progressWidth: 6.0,
              progressColor: accentColor,
              thumbColor: lightAccentColor,
              thumbSize: 10.0,
              innerPadding: const EdgeInsets.all(10.0),
              child: new ClipOval(
                clipper: new CircleClipper(),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialProgressBar extends StatefulWidget {

  final double progress; // [0.0, 1.0]
  final double thumbPosition; // [0.0, 1.0]
  final Color trackColor;
  final double trackWidth;
  final Color progressColor;
  final double progressWidth;
  final Color thumbColor;
  final double thumbSize;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final Widget child;

  RadialProgressBar({
    this.progress = 0.0,
    this.thumbPosition = 0.0,
    this.trackColor = Colors.grey,
    this.trackWidth = 5.0,
    this.progressColor = Colors.black,
    this.progressWidth = 7.0,
    this.thumbColor = Colors.black,
    this.thumbSize = 10.0,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });

  @override
  _RadialSeekBarState createState() => new _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialProgressBar> {

  EdgeInsets _insetsForPainter() {
    // Make room for the painted track, progress, and thumb. We divide by
    // 2.0 because we want to allow flush painting against the track, so we
    // only need to account for the thickness outside the track, not inside.
    final outerThickness = max(
      widget.trackWidth,
      max(
        widget.progressWidth,
        widget.thumbSize,
      ),
    ) / 2.0;
    return new EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: widget.outerPadding,
      child: new CustomPaint(
        foregroundPainter: new RadialSeekBarPainter(
          trackColor: widget.trackColor,
          trackWidth: widget.trackWidth,
          progress: widget.progress,
          progressColor: widget.progressColor,
          progressWidth: widget.progressWidth,
          thumbSize: widget.thumbSize,
          thumbPosition: widget.thumbPosition,
          thumbColor: widget.thumbColor,
        ),
        child: new Padding(
          padding: widget.innerPadding + _insetsForPainter(),
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {

  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final Paint progressPaint;
  final double progress;
  final double thumbSize;
  final double thumbPosition;
  final Paint thumbPaint;

  RadialSeekBarPainter({
    @required Color trackColor,
    @required this.trackWidth,
    @required this.progress,
    @required Color progressColor,
    @required this.progressWidth,
    @required this.thumbSize,
    @required this.thumbPosition,
    @required Color thumbColor,
  }) : trackPaint = new Paint()
    ..color = trackColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = trackWidth,
        progressPaint = new Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = new Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize = new Size(
      size.width - outerThickness,
      size.height - outerThickness,
    );

    final center = new Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width / 2, constrainedSize.height / 2);

    // Paint track.
    canvas.drawCircle(
      center,
      radius,
      trackPaint,
    );

    // Paint progress.
    final progressAngle = 2 * pi * progress;
    canvas.drawArc(
      new Rect.fromCircle(
          center: center,
          radius: radius
      ),
      -pi / 2,
      progressAngle,
      false,
      progressPaint,
    );

    // Paint thumb.
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2.0);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2.0;
    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(size.width / 2, size.height / 2),
      radius: min(size.width / 2, size.height / 2),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}