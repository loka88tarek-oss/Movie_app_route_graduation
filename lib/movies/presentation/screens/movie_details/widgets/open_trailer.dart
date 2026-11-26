import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openTrailer(BuildContext context, String ytTrailerCode) async {
  final messenger = ScaffoldMessenger.of(context);

  if (ytTrailerCode.isEmpty) {
    messenger.showSnackBar(
      const SnackBar(content: Text('No trailer available for this movie')),
    );
    return;
  }

  final uri = Uri.parse('https://www.youtube.com/watch?v=$ytTrailerCode');
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

  if (!opened) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Could not open the trailer')),
    );
  }
}
