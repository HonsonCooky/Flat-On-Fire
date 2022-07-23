import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class EditPageButtonWidget extends StatelessWidget {
  final bool editMode;
  final void Function(bool editMode) editFn;

  const EditPageButtonWidget({Key? key, required this.editFn, required this.editMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                editFn(!editMode);
              },
              icon: editMode ? const Icon(Icons.close) : const Icon(Icons.edit),
              color: PaletteAssistant.alpha(Theme.of(context).colorScheme.onBackground),
              iconSize: Theme.of(context).textTheme.labelMedium?.fontSize,
              splashRadius: Theme.of(context).textTheme.labelMedium?.fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
