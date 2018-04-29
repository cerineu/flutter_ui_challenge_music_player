import 'package:flutter/material.dart';
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
            child: new Container(),
          ),

          // Visualizer
          new Container(
            width: double.infinity,
            height: 125.0,
          ),

          // Song title, artist name, playback controls
          new Container(
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
