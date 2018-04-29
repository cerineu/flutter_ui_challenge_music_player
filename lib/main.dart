import 'dart:core';

import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:logging/logging.dart';
import 'package:music_player/radial_seek.dart';
import 'package:music_player/songs.dart' as songs;
import 'package:music_player/title_and_controls.dart';
import 'package:music_player/visualizer.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });

  runApp(new MyApp());
}

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

  Widget _buildAudioAroundContent(Widget content) {
    return new AudioPlaylist(
        playlist: songs.playlist.songs.map((songs.Song song) {
          return song.audioUrl;
        }).toList(growable: false),
        child: content,
    );
  }

  Widget _buildScaffoldAroundContent(Widget content) {
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
      body: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAudioAroundContent(
        _buildScaffoldAroundContent(
          new Column(
            children: <Widget>[
              // Top section with radial seek bar and album art.
              new Expanded(
                child: new TrackSeekWithAlbumArt(
                  playlist: songs.playlist,
                  controlColor: accentColor,
                  lightControlColor: lightAccentColor,
                ),
              ),

              // Middle section with audio visualizer waves.
              new Visualizer(
                builder: (BuildContext context, List<int> fft) {
                  return new AudioWaves(
                    fft: fft,
                    height: 125.0,
                    color: accentColor,
                  );
                },
              ),

              // Bottom section with song title, artist name, and playback controls.
              new TitleAndControls(
                color: accentColor,
                lightColor: lightAccentColor,
                darkColor: darkAccentColor,
              ),
            ],
          ),
        )
    );
  }
}
