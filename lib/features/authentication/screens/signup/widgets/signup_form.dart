import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:voice/features/authentication/controllers/signup_contoller.dart';
import 'package:voice/features/authentication/screens/signup/widgets/terms_and_condtions.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/constants/text_strings.dart';
import 'package:voice/utils/validators/validation.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
      key: controller.signUpFormKey,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: controller.role.value,
            items:
                ['Admin', 'Student'].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,

                    child: Text(role),
                  );
                }).toList(),
            onChanged: (value) {
              controller.role.value =
                  value ?? "Student"; // Ensure default value is valid
            },
            decoration: const InputDecoration(
              labelText: 'User Role',
              prefixIcon: Icon(Iconsax.user_octagon),
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Please select a role'
                        : null,
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),
          //UserName
          TextFormField(
            expands: false,
            controller: controller.userName,
            validator:
                (value) => TValidator.validateEmptyText("UserName", value),
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Phone Number
          TextFormField(
            validator: (value) => TValidator.validatePhoneNumber(value),
            controller: controller.phoneNumber,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Passwoord
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
          const SizedBox(height: TSizes.spaceBtwSections),
          //Terms andConitions checkbox
          const TTermsAndConditionsCheckBox(),
          const SizedBox(height: TSizes.spaceBtwItems),
          //Signup button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: Text(
                TTexts.createAccount,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.apply(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
