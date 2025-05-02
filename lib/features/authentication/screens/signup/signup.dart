import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice/common/widgets/login_signup/form_divider.dart';
import 'package:voice/common/widgets/login_signup/social_buttons.dart';
import 'package:voice/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/constants/text_strings.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 40.0),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              //Form
              const TSignUpForm(),
              const SizedBox(height: TSizes.spaceBtwItems),
              //Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              //SocialButtons
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
