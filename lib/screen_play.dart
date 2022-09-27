import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlaySong extends StatefulWidget {
  const ScreenPlaySong({
    Key? key,
    required this.songName,
    required this.audioPlayer,
  }) : super(key: key);
  final SongModel songName;
  final AudioPlayer audioPlayer;

  @override
  State<ScreenPlaySong> createState() => _ScreenPlaySongState();
}

class _ScreenPlaySongState extends State<ScreenPlaySong> {
  bool isplaying = false;

  @override
  void initState() {
    playSong();
    super.initState();
  }

  void playSong() {
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.songName.uri.toString()),
          tag: MediaItem(
            id: "${widget.songName.id}",
            album: "${widget.songName.album}",
            title: widget.songName.displayNameWOExt,
            artUri: Uri.parse(
                'url: git://github.com/rmarau/flutter_cached_network_image.git'),
          ),
        ),
      );
      widget.audioPlayer.play();
      isplaying = true;
    } on Exception {
      log("cannot parse song");
    }
    widget.audioPlayer.durationStream.listen(
      (event) {
        setState(
          () {
            duration = event!;
          },
        );
      },
    );
    widget.audioPlayer.positionStream.listen(
      (event) {
        setState(
          () {
            position = event;
          },
        );
      },
    );
  }

  Duration duration = const Duration();
  Duration position = const Duration();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      child: QueryArtworkWidget(
                        artworkWidth: double.infinity,
                        artworkHeight: double.infinity,
                        id: widget.songName.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget:
                            const Icon(Icons.music_note_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.songName.displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.songName.artist.toString() == "<unknown>"
                          ? 'Unknown Artist'
                          : widget.songName.artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 230,
                    ),
                    Row(
                      children: [
                        Text(position.toString().split(".")[0]),
                        Expanded(
                          child: Slider(
                            value: position.inSeconds.toDouble(),
                            max: duration.inSeconds.toDouble(),
                            min: const Duration(microseconds: 0)
                                .inSeconds
                                .toDouble(),
                            onChanged: (value) {
                              setState(() {
                                changeSecons(
                                  value.toInt(),
                                );
                                value = value;
                              });
                            },
                          ),
                        ),
                        Text(duration.toString().split(".")[0])
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.skip_previous_outlined,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isplaying == true) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.play();
                              }
                              isplaying = !isplaying;
                            });
                          },
                          icon: Icon(
                            isplaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //     Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //   builder: (context) => Player1(name: widget.[index]['name'], url: widget.songName.data.documents[index]['url']),
                            // ));
                          },
                          icon: const Icon(
                            Icons.skip_next_outlined,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeSecons(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
