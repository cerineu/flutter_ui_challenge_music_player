import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

const Color accentColor = const Color(0xFFf08f8f);
const Color lightAccentColor = const Color(0xFFFFAFAF);
const Color darkAccentColor = const Color(0xFFD06F6F);

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
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.grey,
          onPressed: () {
            // TODO:
          },
        ),
        title: new Text(''),
        actions: [
          new IconButton(
            icon: new Icon(
              Icons.menu,
            ),
            color: Colors.grey,
            onPressed: () {
              // TODO:
            },
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Center(
              child: new TrackSeekWithAlbumArt(),
            ),
          ),

          new AudioWaves(),

          new TitleAndControls(),
        ],
      ),
    );
  }
}

class TrackSeekWithAlbumArt extends StatelessWidget {

  Widget _trackSeeker(Widget centerContent) {
    return new Container(
      child: new CustomPaint(
        painter: new CircleTrackPainter(
          progress: 0.17,
          trackColor: const Color(0xFFEEEEEE),
          trackWidth: 3.0,
          progressColor: accentColor,
          progressWidth: 6.0,
        ),
        child: new Padding(
          padding: const EdgeInsets.all(18.0),
          child: _albumArt(),
        ),
      ),
    );
  }

  Widget _albumArt() {
    return new Container(
      width: 125.0,
      height: 125.0,
      child: new ClipOval(
        clipper: new CircleClipper(),
        child: new Image.network(
          'https://i1.sndcdn.com/artworks-000165346750-e36z3a-t500x500.jpg',
          width: 125.0,
          height: 125.0,
          colorBlendMode: BlendMode.softLight,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _trackSeeker(_albumArt());
  }
}

class CircleTrackPainter extends CustomPainter {

  final double progress; // [0.0, 1.0]
  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final Paint progressPaint;
  final double thumbSize;
  final Paint thumbPaint;

  CircleTrackPainter({
    this.progress = 0.0,
    this.trackWidth = 3.0,
    trackColor = Colors.grey,
    this.progressWidth = 5.0,
    progressColor = Colors.black,
    this.thumbSize = 10.0,
    thumbColor = Colors.black,
  }) : trackPaint = new Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth,
       progressPaint = new Paint()
         ..color = progressColor
         ..style = PaintingStyle.stroke
         ..strokeWidth = progressWidth
         ..strokeCap = StrokeCap.round,
       thumbPaint = new Paint()..color = thumbColor;

  @override
  void paint(Canvas canvas, Size size) {
    final widestConstraint = max(thumbSize, max(trackWidth, progressWidth));
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    print('Size: $size');
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

class AudioWaves extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: 125.0,
    );
  }
}


class AlbumArtCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}


class TitleAndControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      shadowColor: const Color(0x44000000),
      color: accentColor,
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
            child: new RichText(
              text: new TextSpan(
                text: '',
                children: [
                  new TextSpan(
                    text: 'IN MY REMAINS\n',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                      height: 1.5,
                    ),
                  ),
                  new TextSpan(
                    text: 'LINKIN PARK',
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
          ),
          new Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: new Row(
              children: <Widget>[
                new Expanded(child: new Container()),
                new IconButton(
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
                ),
                new Expanded(child: new Container()),
                new RawMaterialButton(
                  shape: new CircleBorder(),
                  fillColor: Colors.white,
                  splashColor: lightAccentColor,
                  highlightColor: lightAccentColor.withAlpha(0x88),
                  elevation: 10.0,
                  highlightElevation: 5.0,
                  child: new Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new IconButton(
                      icon: new Icon(
                        Icons.play_arrow,
                        color: darkAccentColor,
                        size: 35.0,
                      ),
                      onPressed: () {
                        // TODO:
                      },
                    ),
                  ),
                  onPressed: () {
                    // TODO:
                  },
                ),
                new Expanded(child: new Container()),
                new IconButton(
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
                ),
                new Expanded(child: new Container()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
