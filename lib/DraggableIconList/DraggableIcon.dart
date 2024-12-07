import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../IconSwitcher/IconSwitcher.dart';

class DraggableIconList extends StatefulWidget {
  const DraggableIconList({super.key});

  @override
  _DraggableIconListState createState() => _DraggableIconListState();
}

class _DraggableIconListState extends State<DraggableIconList> {
  // Sample list of icons as image paths
  final List<String> originalIconImages = [
    '../assets/Finder.png',
    '../assets/Normallpad.png',
    '../assets/music.png',
    '../assets/chrome.png',
    '../assets/applestore.png',
    '../assets/Safari.png',
    '../assets/calendar.png',
  ];

  // List to store the scale factor for each icon
  List<double> iconScales = List.generate(7, (index) => 1.0);

  // Button elevation state
  double _buttonElevation = 5.0;

  // Function to handle the item drop
  void onItemDropped(int oldIndex, int newIndex) {
    setState(() {
      final item = originalIconImages.removeAt(oldIndex);
      originalIconImages.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            height: 1550,
            width: 3500,
            child: Image.asset(
              '../assets/pxfuel.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Draggable container with icons
          Column(
            children: [
              const SizedBox(height: 420),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _buttonElevation = 10.0; // Increase elevation on hover
                  });
                },
                onExit: (_) {
                  setState(() {
                    _buttonElevation = 5.0; // Reset elevation when not hovering
                  });
                },
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(IconSwitcher());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0x69FFFFFF), // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
                    shape: RoundedRectangleBorder( // Button shape
                      borderRadius: BorderRadius.circular(40), // Rounded corners
                    ),
                    elevation: _buttonElevation, // Dynamic elevation
                  ),
                  child: const Text(
                    "Please Tap Me For Demo",
                    style: TextStyle(
                      fontSize: 18, // Text size
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text weight
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  const SizedBox(width: 220),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: Container(
                      height: 70,
                      width: 680,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0x94686262),
                      ),
                      child: Stack(
                        children: List.generate(
                          originalIconImages.length,
                              (index) {
                            return Positioned(
                              top: 12,
                              left: 90.0 * index,  // Adjust position for icons horizontally
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Draggable<String>(
                                  data: originalIconImages[index],
                                  feedback: Image.asset(
                                    originalIconImages[index],
                                    width: 55,
                                    height: 55,
                                  ),
                                  childWhenDragging: const SizedBox.shrink(),
                                  child: DragTarget<String>(
                                    onAccept: (receivedData) {
                                      if (receivedData != originalIconImages[index]) {
                                        int oldIndex = originalIconImages.indexOf(receivedData);
                                        onItemDropped(oldIndex, index);
                                      }
                                    },
                                    builder: (context, candidateData, rejectedData) {
                                      return MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            iconScales[index] = 1.2; // Increase scale when hovered
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            iconScales[index] = 1.0; // Reset scale when hover ends
                                          });
                                        },
                                        child: AnimatedScale(
                                          scale: iconScales[index],
                                          duration: const Duration(milliseconds: 200),
                                          child: Image.asset(
                                            originalIconImages[index],
                                            width: 55,
                                            height: 55,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
