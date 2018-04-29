import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_player/songs.dart' as songs;

class TitleAndControls extends StatelessWidget {

  final Color color;
  final Color lightColor;
  final Color darkColor;

  TitleAndControls({
    @required this.color,
    @required this.lightColor,
    @required this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return new Material(
      shadowColor: const Color(0x44000000),
      color: color,
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),

            // Title of song and artist name.
            child: new SongNameAndArtist(
              playlist: songs.playlist,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: new Row(
              children: <Widget>[
                new Expanded(child: new Container()),

                // Go to the previous song.
                new PlaylistPreviousButton(
                  splashColor: lightColor,
                ),

                new Expanded(child: new Container()),

                // Play/pause song playback.
                new PlayPauseButton(
                  lightColor: lightColor,
                  darkColor: darkColor,
                ),

                new Expanded(child: new Container()),

                // Go to the next song.
                new PlaylistNextButton(
                  splashColor: lightColor,
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

class SongNameAndArtist extends StatelessWidget {

  final songs.Playlist playlist;

  SongNameAndArtist({
    @required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        songs.Song song = this.playlist.songs[playlist.activeIndex];

        return new RichText(
          text: new TextSpan(
              text: '',
              children: [
                new TextSpan(
                  text: '${song.songTitle.toUpperCase()}\n',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                    height: 1.5,
                  ),
                ),
                new TextSpan(
                  text: '${song.artist.toUpperCase()}',
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
        );
      },
    );
  }
}

class PlayPauseButton extends StatelessWidget {

  final Color lightColor;
  final Color darkColor;

  PlayPauseButton({
    @required this.lightColor,
    @required this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
      ],

      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon;
        Function onPressed;
        Color circleButtonColor = Colors.white;
        if (player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = player.pause;
        } else if (player.state == AudioPlayerState.paused) {
          icon = Icons.play_arrow;
          onPressed = player.play;
        } else {
          icon = Icons.audiotrack;
          circleButtonColor = lightColor;
        }

        return new RawMaterialButton(
          shape: new CircleBorder(),
          fillColor: circleButtonColor,
          splashColor: lightColor,
          highlightColor: lightColor.withAlpha(0x88),
          elevation: 10.0,
          highlightElevation: 5.0,
          onPressed: onPressed,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Icon(
              icon,
              color: darkColor,
              size: 35.0,
            ),
          ),
        );
      },
    );
  }
}

class PlaylistPreviousButton extends StatelessWidget {

  final Color splashColor;

  PlaylistPreviousButton({
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return new IconButton(
          splashColor: splashColor,
          highlightColor: Colors.transparent,
          icon: new Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.previous,
        );
      },
    );
  }
}

class PlaylistNextButton extends StatelessWidget {

  final Color splashColor;

  PlaylistNextButton({
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return new IconButton(
          splashColor: splashColor,
          highlightColor: Colors.transparent,
          icon: new Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.next,
        );
      },
    );
  }
}