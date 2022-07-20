import 'dart:io';
import 'dart:math';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  final List<String>? profileTitles;
  final File? currentImage;
  final void Function(File? file)? updateCurrentImage;

  final Widget placeholder;
  final String? subLoc;
  final String? uid;

  const ProfilePicture({
    Key? key,
    required this.placeholder,
    this.profileTitles,
    this.currentImage,
    this.updateCurrentImage,
    this.subLoc,
    this.uid,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final ImagePicker _picker = ImagePicker();
  bool _loadAttempted = false;

  @override
  Widget build(BuildContext context) {
    double fontSize = (Theme.of(context).textTheme.labelMedium?.fontSize ?? 20) * 3;
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _profileAvatar(fontSize, context),
          _editProfileButton(fontSize, context),
        ],
      ),
    );
  }

  Widget _profileAvatar(double fontSize, BuildContext context) {
    return GestureDetector(
      onTap: () => _showProfileFull(context),
      child: _circleAvatar(fontSize, context),
    );
  }

  void _showProfileFull(BuildContext context) {
    if (widget.currentImage == null || widget.profileTitles == null) return;
    int randomIndex = Random().nextInt(widget.profileTitles!.length);
    showDialog(
      context: context,
      barrierColor: Theme.of(context).colorScheme.tertiary,
      builder: (BuildContext context) {
        return FullImageDialogWidget(
          title: widget.profileTitles![randomIndex],
          image: Image.file(widget.currentImage!),
        );
      },
    );
  }

  Widget _circleAvatar(double fontSize, BuildContext context) {
    return CircleAvatar(
      radius: fontSize,
      foregroundImage: widget.currentImage != null ? FileImage(widget.currentImage!) : null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: _loadCachedAvatar(fontSize, context),
    );
  }

  Widget _loadCachedAvatar(double fontSize, BuildContext context) {
    if (_loadAttempted || widget.subLoc == null || widget.uid == null) return _placeholder(fontSize, context);

    CloudStorageService().getAvatarFile(subFolder: widget.subLoc!, uid: widget.uid!, cacheOnly: true).then((value) {
      if (widget.updateCurrentImage != null) {
        widget.updateCurrentImage!(value);
      } else {
        setState(() {});
      }
    }).catchError((_) {
      setState(() {});
    });

    _loadAttempted = true;
    return LoadingSpinnerWidget(fontSize);
  }

  Widget _placeholder(double fontSize, BuildContext context) {
    return widget.placeholder;
  }

  Widget _editProfileButton(fontSize, BuildContext context) {
    return widget.updateCurrentImage != null
        ? Positioned(
            top: fontSize * 1.3,
            left: fontSize,
            child: ElevatedButton(
              onPressed: () async {
                var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                widget.updateCurrentImage!(pickedImage?.path != null ? File(pickedImage!.path) : null);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.add_a_photo),
            ),
          )
        : const SizedBox();
  }
}
