import 'package:flutter/material.dart';
import 'package:music_player/bottom_controls.dart';
import 'package:music_player/songs.dart';
import 'package:music_player/theme.dart';
import 'package:music_player/top_controls.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

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

  double _seekPercent;

  @override
  Widget build(BuildContext context) {
    return new Audio(
      audioUrl: demoPlaylist.songs[0].audioUrl,
      playbackState: PlaybackState.paused,
      child: new Center(
        child: new Column(
          children: <Widget>[
            // Seek bar and album art
            new Expanded(
              child: new AudioComponent(
                updateMe: [
                  WatchableAudioProperties.audioPlayhead,
                  WatchableAudioProperties.audioSeeking,
                ],
                playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
                  double playbackProgress = 0.0;
                  if (player.audioLength != null && player.position != null) {
                    playbackProgress = player.position.inMilliseconds / player.audioLength.inMilliseconds;
                  }

                  _seekPercent = player.isSeeking ? _seekPercent : null;

                  return new RadialSeekBar(
                    progress: playbackProgress,
                    seekPercent: _seekPercent,
                    onSeekRequested: (double seekPercent) {
                      setState(() => _seekPercent = seekPercent);

                      final seekMillis = (player.audioLength.inMilliseconds * seekPercent).round();
                      player.seek(new Duration(milliseconds: seekMillis));
                    },
                    child: new Container(
                      color: accentColor,
                      child: new Image.network(
                        demoPlaylist.songs[0].albumArtUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
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
      ),
    );
  }
}
