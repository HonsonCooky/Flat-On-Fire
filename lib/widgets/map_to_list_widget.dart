import 'package:flutter/material.dart';

class MapToListWidget extends StatelessWidget {
  final TextStyle textStyle;
  final Map<String, String?> values;

  const MapToListWidget({Key? key, required this.values, required this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        var k = values.keys.elementAt(index);
        var v = values.values.elementAt(index);
        if (v == null) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              k,
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              v,
              style: textStyle.copyWith(fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: textStyle.fontSize,
            )
          ],
        );
      },
    );
  }
}
