import 'package:flutter/material.dart';
import 'package:voice/features/app/screens/voice/pages/create_page.dart';
import 'package:voice/utils/constants/sizes.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 40.0),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: CreatePage(),
        ),
      ),
    );
  }
}
