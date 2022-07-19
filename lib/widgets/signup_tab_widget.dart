import 'dart:io';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupTabWidget extends StatefulWidget {
  final ScrollController scrollController;

  const SignupTabWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupTabWidgetState();
}

class _SignupTabWidgetState extends State<SignupTabWidget> {
  final List<String> _profileTitles = [
    "Dis you?",
    "Ya so handsome",
    "Felt cute...",
    "This is me!",
    "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧",
    "(◕‿◕✿)",
    "This dude! \n(☞ﾟ∀ﾟ)☞",
    "So pretty! \n(;´༎ຶД༎ຶ`)"
  ];
  File? _currentImage;

  @override
  Widget build(BuildContext context) {
    return _signupTabContents();
  }

  Widget _signupTabContents() {
    return Consumer<UserCredService>(
      builder: (BuildContext context, UserCredService content, _) => ListView(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(),
        children: [
          _profilePicture(),

          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),

          /// Email Text Box
          FofTextField(
            onTap: content.resetErrors,
            labelText: "Email",
            errorText: content.emailErr,
            controller: content.email,
          ),

          /// Name Text Box
          FofTextField(
            onTap: content.resetErrors,
            labelText: "Name",
            errorText: content.nameErr,
            controller: content.name,
          ),

          /// Password Text Box
          FofTextField(
            onTap: content.resetErrors,
            controller: content.pass,
            canObscure: true,
            labelText: 'Password',
            errorText: content.passErr,
          ),

          /// Password Text Box
          FofTextField(
            onTap: content.resetErrors,
            controller: content.conf,
            canObscure: true,
            labelText: 'Confirm Password',
            errorText: content.confErr,
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
          ),

          /// Sign In Button
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text("CREATE ACCOUNT"),
            onPressed: () => content.attemptAuth(UserCredAuthType.signup, _currentImage?.path, context),
          ),

          HorizontalOrLineWidget(
            label: "OR",
            padding: 20,
            color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
          ),

          GoogleAuthButton(
            title: "SIGNUP WITH GOOGLE",
            state: this,
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
          ),
        ],
      ),
    );
  }

  void _updateCurrentImage(File? file) {
    setState(() => _currentImage = file);
  }

  Widget _profilePicture() {
    return ProfilePicture(
      placeholder: Icon(
        Icons.image,
        color: Theme.of(context).colorScheme.onSurface,
        size: Theme.of(context).textTheme.labelMedium?.fontSize != null
            ? Theme.of(context).textTheme.labelMedium!.fontSize! * 3
            : 20,
      ),
      currentImage: _currentImage,
      updateCurrentImage: _updateCurrentImage,
      profileTitles: _profileTitles,
    );
  }
}
