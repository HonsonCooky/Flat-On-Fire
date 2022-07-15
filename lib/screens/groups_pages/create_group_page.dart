import 'dart:io';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  File? _currentImage;

  @override
  Widget build(BuildContext context) {
    return WrapperAppPage(
      child: _createGroupBody(),
    );
  }

  Widget _createGroupBody() {
    return Column(
      children: [
        _profilePicture(),
      ],
    );
  }

  void _updateCurrentImage(File? file) {}

  Widget _profilePicture() {
    return ProfilePicture(
      currentImage: _currentImage,
      updateCurrentImage: _updateCurrentImage,
      placeholder: const SizedBox(),
    );
  }
}
