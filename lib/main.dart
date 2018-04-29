import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:music_player/songs.dart';
import 'package:music_player/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
        title: new Text(''),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.menu,
              color: Colors.grey,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: new MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => new _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        children: <Widget>[
          // Seek bar and album art
          new Expanded(
            child: new Center(
              child: new Container(
                width: 140.0,
                height: 140.0,
                child: new RadialSeekBar(
                  progress: 0.25,
                  thumbPosition: 0.25,
                  trackWidth: 3.0,
                  trackColor: const Color(0xFFDDDDDD),
                  progressWidth: 6.0,
                  progressColor: accentColor,
                  thumbColor: lightAccentColor,
                  thumbSize: 10.0,
                  innerPadding: const EdgeInsets.all(10.0),
                  child: new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor,
                    ),
                    child: new ClipOval(
                      clipper: new CircleClipper(),
                      child: new Image.network(
                        demoPlaylist.songs[0].albumArtUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  ),
                ),
              ),
            ),
          ),

          // Visualizer
          new Container(
            width: double.infinity,
            height: 125.0,
          ),

          // Song title, artist name, playback controls
          new BottomControls()
        ],
      ),
    );
  }
}

class RadialSeekBar extends StatefulWidget {

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

  RadialSeekBar({
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

class _RadialSeekBarState extends State<RadialSeekBar> {

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

class BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: new Material(
        shadowColor: const Color(0x44000000),
        color: accentColor,
        child: new Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 50.0),
          child: new Column(
            children: <Widget>[
              // Song title and artist name
              new RichText(
                text: new TextSpan(
                    text: '',
                    children: [
                      new TextSpan(
                        text: 'Song Title\n',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0,
                          height: 1.5,
                        ),
                      ),
                      new TextSpan(
                        text: 'Artist Name',
                        style: new TextStyle(
                          color: Colors.white.withAlpha(0xAA),
                          fontSize: 12.0,
                          letterSpacing: 3.0,
                          height: 1.5,
                        ),
                      ),
                    ]
                ),
                textAlign: TextAlign.center,
              ),

              new Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(child: new Container()),

                    new PreviousButton(),

                    new Expanded(child: new Container()),

                    new PlayPauseButton(),

                    new Expanded(child: new Container()),

                    new NextButton(),

                    new Expanded(child: new Container()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
      shape: new CircleBorder(),
      fillColor: Colors.white,
      splashColor: lightAccentColor,
      highlightColor: lightAccentColor.withAlpha(0x88),
      elevation: 10.0,
      highlightElevation: 5.0,
      onPressed: () {
        // TODO:
      },
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Icon(
          Icons.play_arrow,
          color: darkAccentColor,
          size: 35.0,
        ),
      ),
    );
  }
}

class PreviousButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: new Icon(
        Icons.skip_previous,
        color: Colors.white,
        size: 35.0,
      ),
      onPressed: () {
        // TODO:
      },
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: new Icon(
        Icons.skip_next,
        color: Colors.white,
        size: 35.0,
      ),
      onPressed: () {
        // TODO:
      },
    );
  }
}
