// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/responsive/constrained_scaffold.dart';
import 'package:together/themes/theme_cubit.dart';
import '../components/about_developer_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final bool isDarkMode = themeCubit.isDarkMode;

    return ConstrainedScaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      // BODY
      body: Column(
        children: [
          // TILES
          ListTile(
            title: const Text("Dark Mode"),
            trailing: CupertinoSwitch(
              value: isDarkMode,
              onChanged: (value) {
                themeCubit.toggleTheme();
              },
            ),
          ),
          const Spacer(),
          const Divider(),

          // ABOUT
          ListTile(
            title: const Text("About This App"),
            subtitle: const Text("Learn more about the developer"),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AboutDeveloperDialog(
                  developerName: "Aziz Ur Rahman",
                  developerImage:
                      "https://media.licdn.com/dms/image/v2/D4D03AQH91hUUAuBJrw/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1710179724264?e=1737590400&v=beta&t=i7t44wPnI_BubRi3Nz8HD6OsnUZ09FLHX5uTRVqC0E4",
                  githubUrl: "https://github.com/azix-khan",
                  linkedinUrl: "https://www.linkedin.com/in/azixkhan",
                  fiverUrl: "https://www.fiverr.com/azix_khan",
                  upworkUrl:
                      "https://www.upwork.com/freelancers/~01880e43610e27bbd4",
                  portfolioUrl: "https://azix-khan.github.io",
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
