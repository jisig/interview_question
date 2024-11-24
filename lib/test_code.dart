import 'package:flutter/material.dart';

class TestCode extends StatefulWidget {
  const TestCode({super.key});

  @override
  State<TestCode> createState() => _TestCodeState();
}

class _TestCodeState extends State<TestCode> {
  /// List of icon image paths for the dock
  List<String> images = [
    "lib/assets/icons/contact.png",
    "lib/assets/icons/message.png",
    "lib/assets/icons/dialler.png",
    "lib/assets/icons/camera.png",
    "lib/assets/icons/gallery.png",
  ];

  /// List for icons that are dragged out of the dock
  List<String> screenImages = [];

  /// Index of the icon currently being dragged
  int? _draggedIndex;

  /// Index of the target position where an icon will be dropped
  int? _targetIndex;

  /// Index of the icon the cursor is hovering over
  int? _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Used Stack Widget because I want to Use Image in Background instead of color
      body: Stack(
        children: [
          /// Background image filling the entire screen
          Positioned.fill(
            child: Image.asset(
              "lib/assets/wallpaper/poster.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// DragTarget for handling icons dragged out of the dock
          DragTarget<int>(
            onWillAcceptWithDetails: (fromIndex) => true, // Accept all drags
            onAccept: (fromIndex) {
              setState(
                () {
                  /// Move the dragged icon to the screen
                  if (fromIndex < images.length) {
                    screenImages.add(images.removeAt(fromIndex));
                  }
                },
              );
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: EdgeInsets.only(bottom: 80),
                child: Stack(
                  children: List.generate(
                    screenImages.length,

                    /// Used For to Arrange Icons in Horizontal Position
                    (index) => Positioned(
                      left: 100 + (index * 60).toDouble(),
                      top: 100,
                      child: LongPressDraggable<int>(
                        feedback: Material(
                          color: Colors.transparent,

                          /// Show Which Icon is Dragged
                          child: Image.asset(
                            screenImages[index],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: Image.asset(
                            screenImages[index],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onDragStarted: () {
                          setState(
                            () {
                              _draggedIndex = images.length + index;
                            },
                          );
                        },
                        onDragEnd: (_) {
                          setState(
                            () {
                              /// Reset Dragged Icon Index
                              _draggedIndex = null;
                            },
                          );
                        },
                        child: Image.asset(
                          screenImages[index],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          /// Used Align Widget to Align Dock container at the bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    images.length,
                    (index) {
                      /// Check is Cursor is on Icon
                      final isHovered = _hoveredIndex == index;

                      return DragTarget<int>(
                        onWillAccept: (fromIndex) {
                          /// Check Where is Dragged Icon is Gonna Drop
                          setState(
                            () {
                              _targetIndex = index;
                            },
                          );
                          return true;
                        },
                        onLeave: (_) => setState(
                          () {
                            /// Reset Index After Dragged Icon Dropped
                            _targetIndex = null;
                          },
                        ),
                        onAccept: (fromIndex) {
                          setState(
                            () {
                              if (fromIndex < images.length) {
                                /// used to Move icon within the dock
                                final image = images.removeAt(fromIndex);
                                images.insert(index, image);
                              } else {
                                /// used to Move icon from screen back to the dock
                                final screenIndex = fromIndex - images.length;
                                images.insert(
                                    index, screenImages.removeAt(screenIndex));
                              }

                              /// Reset All Icons Index After Icons Dropped
                              _draggedIndex = null;
                              _targetIndex = null;
                            },
                          );
                        },
                        builder: (context, candidateData, rejectedData) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.symmetric(
                              /// Make Space to Drop Icon
                              horizontal: _targetIndex == index ? 20.0 : 8.0,
                            ),
                            child: LongPressDraggable<int>(
                              /// Store Dragged Icon index so That Icon will Stay on Place after it get dropped
                              data: index,
                              feedback: Material(
                                color: Colors.transparent,
                                child: Image.asset(
                                  images[index],
                                  width: 60.0,
                                  height: 60.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.4,
                                child: Image.asset(
                                  images[index],
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onDragStarted: () => setState(
                                () {
                                  /// Get Dragged Icon Index
                                  _draggedIndex = index;
                                },
                              ),
                              onDragEnd: (_) => setState(
                                () {
                                  _draggedIndex = null;
                                  _targetIndex = null;
                                },
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  /// Print Clicked Icon Index
                                  print("Image $index Clicked");
                                },
                                child: MouseRegion(
                                  onEnter: (_) => setState(
                                    () {
                                      /// Assign New Index to Icon for Hover
                                      _hoveredIndex = index;
                                    },
                                  ),
                                  onExit: (_) => setState(
                                    () {
                                      /// Reset Hover Index
                                      _hoveredIndex = -1;
                                    },
                                  ),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    width: isHovered ? 70.0 : 50.0,
                                    height: isHovered ? 70.0 : 50.0,

                                    /// show which icon is Hovered
                                    child: Image.asset(
                                      images[index],
                                      width: isHovered ? 70.0 : 50.0,
                                      height: isHovered ? 70.0 : 50.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
