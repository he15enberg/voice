import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/features/authentication/controllers/login_controller.dart';
import 'package:voice/features/authentication/screens/signup/signup.dart';
import 'package:voice/utils/constants/colors.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/constants/text_strings.dart';
import 'package:voice/utils/validators/validation.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            //Password
            Obx(
              () => TextFormField(
                validator: (value) => TValidator.validatePassword(value),
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                expands: false,
                decoration: InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: const Icon(Iconsax.user_edit),
                  suffixIcon: IconButton(
                    onPressed:
                        () =>
                            controller.hidePassword.value =
                                !controller.hidePassword.value,
                    icon:
                        controller.hidePassword.value
                            ? const Icon(Iconsax.eye_slash)
                            : const Icon(Iconsax.eye),
                  ),
                ),
              ),
            ),
            //Remember me andforgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged:
                            (value) =>
                                controller.rememberMe.value =
                                    !controller.rememberMe.value,
                      ),
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),
                TextButton(
                  onPressed: () => {},
                  child: Text(
                    TTexts.forgetPassword,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.apply(color: TColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            //Signin button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignin(),
                child: Text(
                  TTexts.signIn,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.apply(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            //Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => const SignUpScreen());
                },
                child: Text(
                  TTexts.createAccount,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            // const SizedBox(
            //   height: TSizes.spaceBtwSections,
            // ),
          ],
        ),
      ),
    );
  }
}
