import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AudioWaves extends StatelessWidget {

  final List<int> fft;
  final double height;
  final Color color;

  AudioWaves({
    @required this.fft,
    @required this.height,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: height,
      child: fft != null
          ? new CustomPaint(
              painter: new AudioWavePainter(
                fft: fft,
                color: color,
                maxHeight: height,
              ),
            )
          : null,
    );
  }
}

class AudioWavePainter extends CustomPainter {

  final List<int> fft;
  final Color color;
  final double maxHeight;
  final Paint visualizerPaint;
  final Paint barPaint;

  AudioWavePainter({
    @required this.fft,
    this.color = Colors.black,
    this.maxHeight = double.infinity,
  }) : visualizerPaint = new Paint(),
        barPaint = new Paint() {
    visualizerPaint.color = color.withOpacity(0.5);
    visualizerPaint.style = PaintingStyle.fill;

    barPaint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _renderWaves(canvas, size);

//    _renderBars(canvas, size);
  }

  void _renderBars(Canvas canvas, Size size) {
    final bottomPadding = 10.0;

    final barWidth = size.width / ((fft.length - 2) / 2);

    for (int i = 1; i < fft.length / 2; ++i) {
      final barHeight = sqrt(pow(fft[i * 2], 2) + pow(fft[i * 2 + 1], 2)) / 5;
      canvas.drawRect(
        new Rect.fromLTWH(
          i * barWidth,
          size.height - bottomPadding - barHeight,
          barWidth,
          barHeight,
        ),
        barPaint,
      );
    }
  }

  void _renderWaves(Canvas canvas, Size size) {
    final histogramLow = _createHistogram(fft, 15, 2, ((fft.length - 2) / 2).floor());
    final histogramHigh = _createHistogram(fft, 15, ((fft.length - 2) / 2).floor(), fft.length);

    visualizerPaint.color = color;
    _renderHistogram(canvas, size, histogramLow);

    visualizerPaint.color = color.withOpacity(0.5);
    _renderHistogram(canvas, size, histogramHigh);
  }

  void _renderHistogram(Canvas canvas, Size size, List<int> histogram) {
    if (histogram.length == 0) {
      return;
    }

    final bottomPadding = 10.0;

    int pointsToGraph = histogram.length;
    int widthPerSample = (size.width / (pointsToGraph - 2)).floor();

    final points = new List<double>.filled(pointsToGraph * 4, 0.0);

    for (int i = 0; i < histogram.length - 1; i++) {
      points[i * 4] = (i * widthPerSample).toDouble();
      points[i * 4 + 1] = size.height - (histogram[i].toDouble() / 3.0) - bottomPadding;
      points[i * 4 + 2] = ((i + 1) * widthPerSample).toDouble();
      points[i * 4 + 3] = size.height - (histogram[i + 1].toDouble() / 3.0) - bottomPadding;
    }

    Path path = new Path();
    path.moveTo(0.0, size.height + 1); // +1 to cover tiny white sliver at bottom of painted area.
    path.lineTo(points[0], points[1]);
    for (int i = 2; i < points.length - 4; i = i + 2) {
      path.cubicTo(
          points[i - 2] + 10.0, points[i - 1],
          points[i] - 10.0, points[i + 1],
          points[i], points[i + 1]
      );
    }
    path.lineTo(size.width, size.height + 1);  // +1 to cover tiny white sliver at bottom of painted area.
    path.close();

    canvas.drawPath(path, visualizerPaint);
  }

  List<int> _createHistogram(List<int> samples, int bucketCount, [int start, int end]) {
    if (start == end) {
      return const [];
    }

    start = start ?? 0;
    end =  end ?? samples.length;// / 10;

    int samplesPerBucket = ((end - start + 1) / bucketCount).floor();
    if (samplesPerBucket == 0) {
      return const [];
    }

    int samplesTaken = ((end - start + 1) - ((end - start + 1) % samplesPerBucket) - 1).floor();
    List<int> histogram = new List<int>.filled(bucketCount, 0);
    int numInBucket = 0;
    int currBucket = 0;

    int loopStart = start;
    if (start == 0) {
      loopStart = 2;
      histogram[0] += samples[0];
    } else if (start == 1) {
      loopStart = 2;
    }
    for (int i = loopStart; i <= start + samplesTaken; i = i + 2) {
      if ((i - loopStart) % 2 == 1) {
        continue;
      }

      int bucketIndex = ((i - start) / samplesPerBucket).floor();
      numInBucket = currBucket == bucketIndex ? numInBucket + 1 : 0;
      currBucket = bucketIndex;
//                Log.d(TAG, "i: " + i + ", samples per bucket: " + samplesPerBucket + ", index: " + bucketIndex + ", numInBucket: " + numInBucket);
      histogram[bucketIndex] += samples[i];//.abs();
    }

    for (var i = 0; i < histogram.length; ++i) {
      histogram[i] = (histogram[i] / samplesPerBucket).abs().round();
      histogram[i] *= min((histogram[i] / 60.0).round(), maxHeight);
    }

    return histogram;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}