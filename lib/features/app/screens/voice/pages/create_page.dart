import 'package:flutter/material.dart';
import 'package:voice/features/app/screens/voice/widgets/create_post_form.dart';
import 'package:voice/utils/constants/sizes.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Title
        Text("Raise Voice", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: TSizes.spaceBtwSections),
        //Form
        const TCreatePostForm(),
      ],
    );
  }
}
