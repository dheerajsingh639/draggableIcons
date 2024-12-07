import 'package:flutter/material.dart';

class IconSwitcher extends StatefulWidget {
  @override
  _IconSwitcherState createState() => _IconSwitcherState();
}

class _IconSwitcherState extends State<IconSwitcher> {
  // Sample list of icons
  List<IconData> originalIcons = [
    Icons.home,
    Icons.star,
    Icons.settings,
    Icons.phone,
    Icons.image,
  ];

  // List to hold dropped icon positions
  List<Map<String, dynamic>> droppedIcons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Icon Position Switcher Demo"),
      ),
      body: Stack(
        children: [
          // DragTarget on Scaffold to accept icons dropped anywhere
          DragTarget<IconData>(
            onAccept: (receivedData) {
              setState(() {
                // Check if the icon has already been dropped
                if (!droppedIcons.any(
                        (droppedIcon) => droppedIcon['icon'] == receivedData)) {
                  // Randomly position the dropped icon on the screen
                  droppedIcons.add({
                    'icon': receivedData,
                    'position': Offset(
                      (100 + (droppedIcons.length * 50)) % MediaQuery.of(context).size.width,
                      (100 + (droppedIcons.length * 100)) % MediaQuery.of(context).size.height,
                    ),
                  });
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container();
            },
          ),

          // Container for draggable icons at the top
          Positioned(
            left: 0,
            top: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 60,
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0x71686262),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    originalIcons.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Draggable<IconData>(
                          data: originalIcons[index],
                          feedback: Icon(
                            originalIcons[index],
                            size: 40,
                            color: Colors.black12,
                          ),
                          childWhenDragging: const SizedBox.shrink(),
                          child: Icon(
                            originalIcons[index],
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Render dropped icons in the Stack with draggable functionality
          ...droppedIcons.map((droppedIcon) {
            return Positioned(
              left: droppedIcon['position'].dx,
              top: droppedIcon['position'].dy,
              child: Draggable<IconData>(
                data: droppedIcon['icon'],
                feedback: Icon(
                  droppedIcon['icon'],
                  size: 40,
                  color: Colors.black12,
                ),
                childWhenDragging: const SizedBox.shrink(),
                onDragEnd: (details) {
                  setState(() {
                    // Update the position of the icon when it is dragged and dropped
                    droppedIcon['position'] = details.offset;
                  });
                },
                child: Icon(
                  droppedIcon['icon'],
                  size: 40,
                  color: Colors.black,
                ),
              ),
            );
          }),

          // Bin icon to delete dropped icons
          Positioned(
            left: 180,
            bottom: 20,
            child: DragTarget<IconData>(
              onAccept: (receivedData) {
                setState(() {
                  droppedIcons.removeWhere(
                          (droppedIcon) => droppedIcon['icon'] == receivedData);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
