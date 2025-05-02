import 'package:flutter/material.dart';
import 'package:voice/common/styles/spacing_styles.dart';
import 'package:voice/common/widgets/login_signup/form_divider.dart';
import 'package:voice/common/widgets/login_signup/social_buttons.dart';
import 'package:voice/features/authentication/screens/login/widgets/login_form.dart';
import 'package:voice/features/authentication/screens/login/widgets/login_header.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: TSpacingStyles.paddingWithAppBarHieght,
          child: Column(
            children: [
              //Logo Titel and subtitle
              const TLoginHeader(),
              // //Form
              const TLoginForm(),
              //Divider
              TFormDivider(dividerText: TTexts.orSignInWith),
              const SizedBox(height: TSizes.spaceBtwItems),
              //Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
