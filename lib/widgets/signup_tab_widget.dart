import 'dart:io';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupTabWidget extends AuthenticationTab {
  const SignupTabWidget({
    Key? key,
    required super.scrollController,
    required super.email,
    required super.password,
    required super.resetErrors,
    required super.attemptAuthCallback,
    super.emailErrMsg,
    super.passwordErrMsg,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupTabWidgetState();
}

class _SignupTabWidgetState extends State<SignupTabWidget> with ToastMixin {
  final _name = TextEditingController();
  final _confirmPassword = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _nameErrMsg;
  String? _confirmErrMsg;
  XFile? _pickedImage;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool preFlightCheck() {
    setState(() {
      _nameErrMsg = _name.text.isEmpty ? "No Name Provided" : null;
      _confirmErrMsg = _confirmPassword.text.isEmpty
          ? "No Password Provided"
          : _confirmPassword.text != widget.password.text
              ? "Passwords do not match"
              : null;
    });
    return _nameErrMsg == null && _confirmErrMsg == null;
  }

  void resetErrors() {
    setState(() {
      _nameErrMsg = null;
      _confirmErrMsg = null;
    });
    widget.resetErrors();
  }

  @override
  Widget build(BuildContext context) {
    return _signupTabContents();
  }

  Widget _signupTabContents() {
    return ListView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      children: [
        _profilePicture(),

        const SizedBox(
          height: 10,
        ),

        /// Email Text Box
        FofTextField(
          onTap: resetErrors,
          labelText: "Email",
          errorText: widget.emailErrMsg,
          controller: widget.email,
        ),

        /// Name Text Box
        FofTextField(
          onTap: resetErrors,
          labelText: "Name",
          errorText: _nameErrMsg,
          controller: _name,
        ),

        /// Password Text Box
        FofTextField(
          onTap: resetErrors,
          controller: widget.password,
          canObscure: true,
          labelText: 'Password',
          errorText: widget.passwordErrMsg,
        ),

        /// Password Text Box
        FofTextField(
          onTap: resetErrors,
          controller: _confirmPassword,
          canObscure: true,
          labelText: 'Confirm Password',
          errorText: _confirmErrMsg,
        ),

        const SizedBox(
          height: 50,
        ),

        /// Sign In Button
        ElevatedButton.icon(
          icon: const Icon(Icons.person_add),
          label: const Text("CREATE ACCOUNT"),
          onPressed: () => widget.attemptAuthCallback(
              authActionCallback: () => context.read<AuthService>().signup(
                  email: widget.email.text,
                  name: _name.text,
                  password: widget.password.text,
                  avatarLocalFilePath: _pickedImage?.path),
              optionalCheck: preFlightCheck),
        ),

        HorizontalOrLineWidget(
          label: "OR",
          padding: 20,
          color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
        ),

        GoogleAuthButton(
          title: "SIGNUP WITH GOOGLE",
          attemptAuthCallback: widget.attemptAuthCallback,
        ),

        const SizedBox(
          height: 50,
        ),
      ],
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
