import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player/songs.dart' as songs;

class TrackSeekWithAlbumArt extends StatefulWidget {

  final songs.Playlist playlist;
  final Color controlColor;
  final Color lightControlColor;

  TrackSeekWithAlbumArt({
    this.playlist,
    this.controlColor,
    this.lightControlColor,
  });

  @override
  TrackSeekWithAlbumArtState createState() {
    return new TrackSeekWithAlbumArtState();
  }
}

class TrackSeekWithAlbumArtState extends State<TrackSeekWithAlbumArt> with SingleTickerProviderStateMixin {

  static const double THUMB_SIZE = 10.0;

  AudioPlayer player;
  double currentPlaybackPercent = 0.0;
  PolarCoord startDragCoord;
  double startDragSeekBarPercent;
  double dragPosition; // null if not dragging
  bool isSeeking = false;
  double seekPosition;
  AnimationController thumbSizer;
  Animation<double> thumbSize;

  @override
  void initState() {
    super.initState();

    thumbSizer = new AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this
    );
    thumbSize = new Tween(
        begin: 0.0,
        end: THUMB_SIZE
    ).animate(thumbSizer);
  }

  Widget _trackSeeker(double progress, Widget centerContent) {
    return new RadialDragGestureDetector(
      onRadialDragStart: (PolarCoord coord) {
        startDragCoord = coord;
        startDragSeekBarPercent = currentPlaybackPercent;

        thumbSizer.forward();
      },
      onRadialDragUpdate: (PolarCoord coord) {
        final dragAngle = coord.angle - startDragCoord.angle;
        final dragPercent = dragAngle / (2 * pi);
        final newDragPosition = (startDragSeekBarPercent + dragPercent) % 1;

        setState(() => dragPosition = newDragPosition);
      },
      onRadialDragEnd: () {
        final newPositionInMillis = (dragPosition * player.audioLength.inMilliseconds).round();
        player.seek(new Duration(milliseconds: newPositionInMillis));

        thumbSizer.reverse();

        setState(() {
          isSeeking = true;
          seekPosition = dragPosition;
          startDragCoord = null;
          startDragSeekBarPercent = null;
          dragPosition = null;
        });
      },
      child: new Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent, // use transparent color to make area touchable
        child: new Center(
          child: new AnimatedBuilder(
            animation: thumbSizer,
            builder: (BuildContext context, Widget child) {
              double thumbPosition = currentPlaybackPercent;
              if (dragPosition != null) {
                print('Drag position: $dragPosition');
                thumbPosition = dragPosition;
              } else if (isSeeking) {
                print('Seek position: $seekPosition');
                thumbPosition = seekPosition;
              }
              print('Rendering seekbar. isSeeking: $isSeeking, dragPosition: $dragPosition, seekPosition: $seekPosition, thumbPosition: $thumbPosition');

              return new CustomPaint(
                painter: new CircleTrackPainter(
                  progress: progress,
                  trackColor: const Color(0xFFEEEEEE),
                  maxTrackWidth: 3.0,
                  progressColor: widget.controlColor,
                  maxProgressWidth: 6.0,
                  thumbPosition: thumbPosition,
                  thumbSize: thumbSize.value,
                  maxThumbSize: THUMB_SIZE,
                  thumbColor: widget.lightControlColor,
                ),
                child: child,
              );
            },
            child: new Padding(
              padding: const EdgeInsets.all(18.0),
              child: centerContent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _albumArt() {
    return new Container(
      width: 125.0,
      height: 125.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: widget.controlColor,
      ),
      child: new ClipOval(
        clipper: new CircleClipper(),
        child: new AudioPlaylistComponent(
          playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
            final String albumArtUrl = widget.playlist.songs[playlist.activeIndex].albumArtUrl;

            return new Image.network(
              albumArtUrl,
              width: 125.0,
              height: 125.0,
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.softLight,
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
        updateMe: [
          WatchableAudioProperties.audioPlayhead,
          WatchableAudioProperties.audioLength,
          WatchableAudioProperties.audioSeeking,
        ],
        playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
          print('Seekbar builder. isSeeking: ${player.isSeeking}');
          this.player = player;
          isSeeking = player.isSeeking;

          currentPlaybackPercent = 0.0;
          if (player.audioLength != null && player.position != null) {
            currentPlaybackPercent =
                player.position.inMilliseconds / player.audioLength.inMilliseconds;
          }

          return _trackSeeker(currentPlaybackPercent, _albumArt());
        }
    );
  }
}

class CircleTrackPainter extends CustomPainter {

  final double progress; // [0.0, 1.0]
  final double trackWidth;
  final double maxTrackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final double maxProgressWidth;
  final Paint progressPaint;
  final double thumbPosition; // [0.0, 1.0]
  final double thumbSize;
  final double maxThumbSize;
  final Paint thumbPaint;

  CircleTrackPainter({
    this.progress = 0.0,
    this.trackWidth = 3.0,
    this.maxTrackWidth,
    trackColor = Colors.grey,
    this.progressWidth = 5.0,
    this.maxProgressWidth,
    progressColor = Colors.black,
    this.thumbPosition,
    this.thumbSize = 10.0,
    this.maxThumbSize,
    thumbColor = Colors.black,
  }) : trackPaint = new Paint()
    ..color = trackColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = maxTrackWidth ?? trackWidth,
        progressPaint = new Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = maxProgressWidth ?? progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = new Paint()..color = thumbColor;

  @override
  void paint(Canvas canvas, Size size) {
    final widestConstraint = max(
        maxThumbSize ?? thumbSize,
        max(
            maxTrackWidth ?? trackWidth,
            maxProgressWidth ?? progressWidth
        )
    );
    final thinnestDimension = min(size.width, size.height);
    final trackRadius = (thinnestDimension - widestConstraint) / 2;
    final center = new Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(
      center,
      trackRadius,
      trackPaint,
    );

    canvas.drawArc(
      new Rect.fromCircle(
        center: center,
        radius: trackRadius,
      ),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );

    if (thumbPosition != null) {
      final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
      final x = cos(thumbAngle) * trackRadius + center.dx;
      final y = sin(thumbAngle) * trackRadius + center.dy;
      final thumbCenter = new Offset(x, y);

      canvas.drawCircle(
        thumbCenter,
        (maxThumbSize ?? thumbSize) / 2,
        thumbPaint,
      );
    }
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