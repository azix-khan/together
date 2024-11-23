import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDeveloperDialog extends StatelessWidget {
  final String developerName;
  final String developerImage;
  final String githubUrl;
  final String linkedinUrl;
  final String fiverUrl;
  final String upworkUrl;
  final String portfolioUrl;

  const AboutDeveloperDialog({
    required this.developerName,
    required this.developerImage,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.fiverUrl,
    required this.upworkUrl,
    required this.portfolioUrl,
    super.key,
  });

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
      // ignore: use_build_context_synchronously
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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slogan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'get together',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const TextSpan(
                        text: ' with ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'together',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.italianno().fontFamily,
                          fontSize: 24,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // image
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(developerImage),
            ),
            const SizedBox(height: 16),
            // name
            Text(
              developerName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            // Occupation
            Text(
              "Flutter Developer",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Buttons with fixed size
            _buildButton(
              context,
              icon: Icons.web,
              label: "Portfolio",
              onPressed: () => _launchUrl(portfolioUrl, context),
            ),
            const SizedBox(height: 8),
            _buildButton(
              context,
              icon: Icons.handshake_outlined,
              label: "Fiver",
              onPressed: () => _launchUrl(fiverUrl, context),
            ),
            const SizedBox(height: 16),
            _buildButton(
              context,
              icon: Icons.handshake_outlined,
              label: "Upwork",
              onPressed: () => _launchUrl(upworkUrl, context),
            ),
            const SizedBox(height: 8),
            _buildButton(
              context,
              icon: Icons.code,
              label: "GitHub",
              onPressed: () => _launchUrl(githubUrl, context),
            ),
            const SizedBox(height: 8),
            _buildButton(
              context,
              icon: Icons.import_contacts_sharp,
              label: "Linkedin",
              onPressed: () => _launchUrl(linkedinUrl, context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }

// Helper method to build buttons with specific height and width
  Widget _buildButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: 150,
      height: 30,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
          onPressed();
        },
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(150, 30),
        ),
      ),
    );
  }
}
