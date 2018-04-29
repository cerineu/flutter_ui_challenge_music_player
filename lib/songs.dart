import 'package:meta/meta.dart';

final playlist = new Playlist(
  songs: [
    new Song(
      audioUrl: 'https://api.soundcloud.com/tracks/434370309/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      albumArtUrl: 'https://i1.sndcdn.com/avatars-000312484264-af28qp-t200x200.jpg',
      songTitle: 'Perfect Saxophone',
      artist: 'Simon More',
    ),
    new Song(
      audioUrl: 'https://api.soundcloud.com/tracks/402538329/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      albumArtUrl: 'https://i1.sndcdn.com/avatars-000344712337-f6po4d-t120x120.jpg',
      songTitle: 'Simply',
      artist: 'Kumbor',
    ),
    new Song(
      audioUrl: 'https://api.soundcloud.com/tracks/266891990/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      albumArtUrl: 'https://i1.sndcdn.com/artworks-000165346750-e36z3a-t500x500.jpg',
      songTitle: 'Electro Monotony',
      artist: 'Nights & Weekends',
    ),
    new Song(
      audioUrl: 'https://api.soundcloud.com/tracks/260578593/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      albumArtUrl: 'https://i1.sndcdn.com/artworks-000165346750-e36z3a-t500x500.jpg',
      songTitle: 'Debut Trance',
      artist: 'Nights & Weekends',
    ),
    new Song(
      audioUrl: 'https://api.soundcloud.com/tracks/258735531/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      albumArtUrl: 'https://i1.sndcdn.com/artworks-000165346750-e36z3a-t500x500.jpg',
      songTitle: 'Debut',
      artist: 'Nights & Weekends',
    ),
    new Song(
      audioUrl: 'https://api.soundcloud.com/tracks/9540352/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      albumArtUrl: 'https://i1.sndcdn.com/avatars-000215855222-tic5d8-t120x120.jpg',
      songTitle: 'Assn1-tribal-beat',
      artist: 'Matt',
    ),
  ],
);

class Playlist {

  final List<Song> songs;

  Playlist({
    @required this.songs,
  });

}

class Song {

  final String audioUrl;
  final String albumArtUrl;
  final String songTitle;
  final String artist;

  Song({
    @required this.audioUrl,
    @required this.albumArtUrl,
    @required this.songTitle,
    @required this.artist,
  });

}