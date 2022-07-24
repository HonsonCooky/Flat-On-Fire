import 'dart:io';
import 'dart:math';

import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// How does the user access the "select photo" screen.
/// [ProfileEditMode.icon] creates a hovering icon over the profile circle.
/// [ProfileEditMode.fullScreen] creates a button at the bottom of the alert dialog popup
enum ProfileEditMode {
  icon,
  fullScreen,
}

/// If this profile is representing an existing entity, provide the entity type "[subLoc]", and the unique identifier
/// "[uid]" of the entity to find the image from the backend or cache.
class ProfileImageRef {
  final String subLoc;
  final String uid;

  ProfileImageRef({required this.subLoc, required this.uid});
}

/// Options the can be set for each profile widget instance.
/// [profileTitles] is a list which is randomly selected from to show above the profile image.
/// [editMode], and [imageRef] can be understood via their own documentation.
class ProfileOptions {
  final List<String>? profileTitles;
  final ProfileEditMode? editMode;
  final ProfileImageRef? imageRef;

  ProfileOptions({this.profileTitles, this.editMode, this.imageRef});
}

/// A [ProfilePicture] is a widget designed to represent a circle avatar in a manner that is consistent throughout
/// the application.
/// [placeholder] is a widget that will be shown when no [currentImage] exists.
/// [currentImage] is a [File] that represents the current image. This is parsed in as the parent will likely need
/// access to the image to know what to do with it.
/// [updateCurrentImage] is a function that is called when someone selects a new image.
/// [options] are detailed in the [ProfileOptions] object.
class ProfilePicture extends StatefulWidget {
  final Widget placeholder;
  final File? currentImage;
  final void Function(File? file, bool delete, bool isNew)? updateCurrentImage;
  final ProfileOptions? options;

  const ProfilePicture({
    Key? key,
    this.currentImage,
    this.updateCurrentImage,
    this.options,
    required this.placeholder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final ImagePicker _picker = ImagePicker();
  bool _loadAttempting = false;
  bool _loadAttempted = false;

  @override
  Widget build(BuildContext context) {
    double fontSize = (Theme.of(context).textTheme.labelMedium?.fontSize ?? 20) * 3;
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _profileAvatar(fontSize, context),
          _profileFloatingEdit(fontSize),
        ],
      ),
    );
  }

  Widget _profileAvatar(double fontSize, BuildContext context) {
    return GestureDetector(
      onTap: () => _showProfileFull(),
      child: _circleAvatar(fontSize),
    );
  }

  Widget _profileFloatingEdit(double fontSize) {
    return widget.options?.editMode == null ? const SizedBox() : _editProfileButton(fontSize);
  }

  Widget _circleAvatar(double fontSize) {
    return CircleAvatar(
      radius: fontSize,
      foregroundImage: widget.currentImage != null ? FileImage(widget.currentImage!) : null,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: _attemptAvatarLoad(fontSize, context),
    );
  }

  Widget _editProfileButton(fontSize) {
    return widget.options!.editMode == ProfileEditMode.icon
        ? Positioned(
            top: fontSize * 1.3,
            left: fontSize,
            child: ElevatedButton(
              onPressed: () async {
                var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                widget.updateCurrentImage!(pickedImage?.path != null ? File(pickedImage!.path) : null, false, true);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.add_a_photo),
            ),
          )
        : Positioned(
            top: fontSize * 1.3,
            left: fontSize,
            child: ElevatedButton(
              onPressed: () => _showProfileFull(),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.add_a_photo),
            ),
          );
  }

  void _showProfileFull() {
    // If there is no image to show, OR there are no titles, then we don't want this functionality.
    if (widget.currentImage == null || widget.options?.profileTitles == null) return;

    // Find a random profile title to show
    int randomIndex = Random().nextInt(widget.options!.profileTitles!.length);
    showDialog(
      context: context,
      barrierColor: Theme.of(context).colorScheme.tertiary,
      builder: (BuildContext context) {
        return FullImageDialogWidget(
          title: widget.options!.profileTitles![randomIndex],
          image: Image.file(widget.currentImage!),
          actions: widget.options?.editMode == ProfileEditMode.fullScreen
              ? [
                  _selectNewProfileButton(),
                  _deleteCurrentProfileButton(),
                ]
              : null,
        );
      },
    );
  }

  Widget _selectNewProfileButton() {
    return TextButton(
      style: Theme.of(context).textButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.tertiary),
            foregroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.onTertiary),
          ),
      onPressed: () async {
        var pickedImage = await _picker.pickImage(source: ImageSource.gallery).then((value) {
          Navigator.pop(context);
          return value;
        });
        widget.updateCurrentImage!(pickedImage?.path != null ? File(pickedImage!.path) : null, false, true);
      },
      child: const Icon(Icons.update),
    );
  }

  Widget _deleteCurrentProfileButton() {
    return TextButton(
      style: Theme.of(context).textButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.secondary),
            foregroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.onSecondary),
          ),
      onPressed: () async {
        widget.updateCurrentImage!(null, true, true);
        Navigator.pop(context);
      },
      child: const Icon(Icons.delete),
    );
  }

  Widget _attemptAvatarLoad(double fontSize, BuildContext context) {
    // If we have already tried to load the image, or no reference is provided, or there is no means in which to
    // update the current image, then simply return the placeholder.
    if (_loadAttempted || widget.options?.imageRef == null || widget.updateCurrentImage == null) {
      return widget.placeholder;
    }

    if (!_loadAttempting) {
      // Load the image in from somewhere
      CloudStorageService()
          .getAvatarFile(
        subFolder: widget.options!.imageRef!.subLoc,
        uid: widget.options!.imageRef!.uid,
      )
          .then((value) {
        if (widget.updateCurrentImage != null) {
          widget.updateCurrentImage!(value, false, false);
        }
        setState(() {
          _loadAttempted = true;
        });
      }).catchError((_) {
        setState(() {
          _loadAttempted = true;
        });
      });
    }

    _loadAttempting = true;
    return LoadingSpinnerWidget(fontSize);
  }
}
