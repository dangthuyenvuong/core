import 'package:core/constants.dart';
import 'package:core/utils/modal/modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const colors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.brown,
  Colors.amber,
  Colors.cyan,
  Colors.deepPurple,
  Colors.deepOrange,
  Colors.indigo,
  Colors.lime,
  Colors.teal,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.yellowAccent,
  Colors.purpleAccent,
  Colors.orangeAccent,
  Colors.pinkAccent,
];

void showColorSelect({
  required BuildContext context,
  required Function(Color?) onSelect,
}) {
  Modal.showBottomSheet(
    context: context,
    builder: (context, controller) => ColorSelect(onSelect: onSelect),
  );
}

class ColorSelect extends StatelessWidget {
  const ColorSelect({super.key, required this.onSelect});
  final Function(Color?) onSelect;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
        padding: EdgeInsets.all(Spacing.medium),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: onSurface.withAlpha(100),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Choose Color",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            SizedBox(height: Spacing.large),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                GestureDetector(
                  onTap: () {
                    onSelect(null);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: onSurface.withAlpha(10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 20,
                      color: onSurface,
                    ),
                  ),
                ),
                ...List.generate(
                  colors.length,
                  (index) => GestureDetector(
                    onTap: () {
                      onSelect(colors[index]);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colors[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // onSelect(colors[index]);
                    // Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: onSurface.withAlpha(10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.paintbrush,
                      size: 20,
                      color: onSurface,
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
