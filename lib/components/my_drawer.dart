import 'package:flutter/material.dart';
import 'package:musicplayer/pages/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(children: [
        // logo
        DrawerHeader(
            child: Center(
                child: Icon(
          Icons.my_library_music_rounded,
          size: 40,
          color: Theme.of(context).colorScheme.inversePrimary,
        ))),

        // Home tile
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 25),
          child: ListTile(
            title: const Text(
              'H O M E',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),
        ),

        // List tile
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 0),
          child: ListTile(
            title: const Text(
              'M O D E',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: const Icon(Icons.settings),
            onTap: () {
              // pop drawer
              Navigator.pop(context);

              // navigate to settings page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingPage(),
                  ));
            },
          ),
        ),
      ]),
    );
  }
}
