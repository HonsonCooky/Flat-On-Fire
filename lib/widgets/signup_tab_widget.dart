import 'dart:io';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupTabWidget extends StatefulWidget {
  final ScrollController scrollController;

  const SignupTabWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupTabWidgetState();
}

class _SignupTabWidgetState extends State<SignupTabWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

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
            onPressed: () => content.attemptAuth(UserCredAuthType.signup, context),
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

  Widget _profilePicture() {
    TextStyle? textStyle = Theme.of(context).textTheme.labelMedium;
    double fontSize = textStyle?.fontSize != null ? textStyle!.fontSize! * 3 : 20;
    return Stack(
      alignment: Alignment.center,
      children: [
        _profileImage(fontSize),
        _editProfileImage(fontSize),
      ],
    );
  }

  Widget _profileImage(double fontSize) {
    return GestureDetector(
      onTap: () {
        if (_pickedImage == null) return;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FullImageDialogWidget(
              title: "Profile Picture",
              image: Image.file(File(_pickedImage!.path)),
            );
          },
        );
      },
      child: CircleAvatar(
        radius: fontSize,
        foregroundImage: _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Icon(
          Icons.image,
          size: fontSize,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _editProfileImage(fontSize) {
    return Positioned(
      top: fontSize * 1.2,
      left: MediaQuery.of(context).size.width / 2 - 10,
      child: ElevatedButton(
        onPressed: () async {
          _pickedImage = await _picker.pickImage(source: ImageSource.gallery);
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
