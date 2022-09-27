import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/screen_play.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenallSongs extends StatefulWidget {
  const ScreenallSongs({Key? key}) : super(key: key);

  @override
  State<ScreenallSongs> createState() => _ScreenallSongsState();
}

class _ScreenallSongsState extends State<ScreenallSongs> {
  final audioquery = OnAudioQuery();
  final AudioPlayer audioplayer = AudioPlayer();
  bool search = false;
  late List<SongModel> allSong;
  List<SongModel> foundSong = [];

  void loadAllSongList() async {
    allSong = await audioquery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
    foundSong = allSong;
  }

  void searchList(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = allSong;
    } else {
      results = allSong
          .where((element) => element.displayNameWOExt
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundSong = results;
    });
  }

  @override
  void initState() {
    requestPermission();
    loadAllSongList();
    super.initState();
  }

  void requestPermission() async {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MUSIKA'),
          centerTitle: true,
          actions: [
            search == false
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        search = true;
                      });
                    },
                    icon: const Icon(Icons.search),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        search = false;
                      });
                    },
                    icon: const Icon(Icons.close_outlined),
                  )
          ],
        ),
        body: FutureBuilder<List<SongModel>>(
          future: audioquery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (BuildContext context, item) {
            if (item.data == null) {
              return const Center(
                child: Text('No Songs Found'),
              );
            }
            if (item.data!.isEmpty) {
              return const Center(
                child: Text('No Songs Found'),
              );
            } else {
              return Column(
                children: [
                  search == true
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 20),
                          child: TextField(
                            onChanged: (value) {
                              searchList(value);
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.search_outlined),
                              hintText: 'search',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: foundSong.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                leading: QueryArtworkWidget(
                                  id: foundSong[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget:
                                      const Icon(Icons.music_note_outlined),
                                ),
                                title: Text(foundSong[index].displayNameWOExt),
                                subtitle: Text("${foundSong[index].artist}"),
                                trailing: IconButton(
                                  icon: const Icon(
                                      Icons.favorite_border_outlined),
                                  onPressed: (() {}),
                                ),
                                onTap: (() {
                                  // playSong(item.data![index].uri);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ScreenPlaySong(
                                      songName: item.data![index],
                                      audioPlayer: audioplayer,
                                    ),
                                  ));
                                }),
                              );
                            },
                            itemCount: foundSong.length,
                          )
                        : const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  playSong(String? uri) {
    try {
      audioplayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      audioplayer.play();
    } on Exception {
      log('error permission');
    }
  }
}
