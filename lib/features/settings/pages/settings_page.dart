// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:together/responsive/constrained_scaffold.dart';
// import 'package:together/themes/theme_cubit.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   // BUILD UI
//   @override
//   Widget build(BuildContext context) {
//     // theme cubit
//     final themeCubit = context.watch<ThemeCubit>();

//     // is dark mode
//     bool isDarkMode = themeCubit.isDarkMode;

//     // SCAFFOLD
//     return ConstrainedScaffold(
//       appBar: AppBar(
//         title: const Text("Settings"),
//       ),
//       body: Column(
//         children: [
//           // dark mode tile
//           ListTile(
//             title: const Text("Dark Mode"),
//             trailing: CupertinoSwitch(
//               value: isDarkMode,
//               onChanged: (value) {
//                 themeCubit.toggleTheme();
//               },
//             ),
//           ),

//           // about this app
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/responsive/constrained_scaffold.dart';
import 'package:together/themes/theme_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final bool isDarkMode = themeCubit.isDarkMode;

    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
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
                      "https://media.licdn.com/dms/image/v2/D4D03AQH91hUUAuBJrw/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1710179724264?e=1737590400&v=beta&t=i7t44wPnI_BubRi3Nz8HD6OsnUZ09FLHX5uTRVqC0E4", // Replace with your image URL
                  githubUrl: "https://github.com/azix-khan",
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

class AboutDeveloperDialog extends StatelessWidget {
  final String developerName;
  final String developerImage;
  final String githubUrl;
  final String portfolioUrl;

  const AboutDeveloperDialog({
    required this.developerName,
    required this.developerImage,
    required this.githubUrl,
    required this.portfolioUrl,
    Key? key,
  }) : super(key: key);

  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("About This App"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(developerImage),
          ),
          const SizedBox(height: 16),
          Text(
            developerName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Flutter Developer",
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _launchUrl(githubUrl, context);
            },
            icon: const Icon(Icons.code),
            label: const Text("GitHub"),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _launchUrl(portfolioUrl, context);
            },
            icon: const Icon(Icons.web),
            label: const Text("Portfolio"),
            style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.teal,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
