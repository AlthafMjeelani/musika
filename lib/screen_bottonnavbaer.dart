import 'package:flutter/material.dart';
import 'package:musicplayer/screean_playlist.dart';
import 'package:musicplayer/screen_settings.dart';
import 'package:musicplayer/screen_allsongs.dart';
import 'package:musicplayer/screen_search.dart';

class ScreenBottomNavbar extends StatefulWidget {
  const ScreenBottomNavbar({Key? key}) : super(key: key);

  @override
  State<ScreenBottomNavbar> createState() => _ScreenBottomNavbarState();
}

class _ScreenBottomNavbarState extends State<ScreenBottomNavbar> {
  int currentPageIndex = 0;

  List screens = [
    const ScreenallSongs(),
    // const ScreenSearch(),
    // const ScreenPlaylist(),
    const ScreenSettings()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentPageIndex != 0) {
          setState(() {
            currentPageIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: screens[currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 61, 53, 53),
          selectedItemColor: const Color.fromARGB(255, 12, 133, 255),
          unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          currentIndex: currentPageIndex,
          onTap: (newIndex) {
            setState(
              () {
                currentPageIndex = newIndex;
              },
            );
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_outlined),
              label: 'Songs',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.favorite_border,
            //   ),
            //   label: 'Favorite',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.playlist_add,
            //   ),
            //   label: 'Playlist',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
