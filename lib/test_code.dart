import 'package:flutter/material.dart';

class TestCode extends StatefulWidget {
  const TestCode({super.key});

  @override
  State<TestCode> createState() => _TestCodeState();
}

class _TestCodeState extends State<TestCode> {
  /// List of icon icon paths for the dock

  List<IconData> icons = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  /// List for icons that are dragged out of the dock
  List<IconData> screenicons = [];

  /// Index of the icon currently being dragged
  int? _draggedIndex;

  /// Index of the target position where an icon will be dropped
  int? _targetIndex;

  /// Index of the icon the cursor is hovering over
  int? _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,

      /// Used Stack Widget for dock alignment at center
      body: Stack(
        children: [
          /// DragTarget for handling icons dragged out of the dock
          DragTarget<int>(
            onWillAcceptWithDetails: (fromIndex) => true, // Accept all drags
            onAccept: (fromIndex) {
              setState(
                () {
                  /// Move the dragged icon to the screen
                  if (fromIndex < icons.length) {
                    screenicons.add(icons.removeAt(fromIndex));
                  }
                },
              );
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: EdgeInsets.only(bottom: 80),
                child: Stack(
                  children: List.generate(
                    screenicons.length,

                    /// Used For to Arrange Icons in Horizontal Position
                    (index) => Positioned(
                      left: 100 + (index * 60).toDouble(),
                      top: 100,
                      child: LongPressDraggable<int>(
                        data: icons.length + index,
                        feedback: Material(
                          color: Colors.transparent,

                          /// Show Which Icon is Dragged
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 70,
                            width: 70,
                            child: Icon(
                              screenicons[index],
                              color: Colors.white,
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 60,
                            width: 60,
                            child: Icon(
                              screenicons[index],
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onDragStarted: () {
                          setState(
                            () {
                              _draggedIndex = icons.length + index;
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 60,
                          height: 60,
                          child: Icon(
                            screenicons[index],
                            size: 30.0,
                            color: Colors.white,
                          ),
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
                    icons.length,
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
                              if (fromIndex < icons.length) {
                                /// used to Move icon within the dock
                                final icon = icons.removeAt(fromIndex);
                                icons.insert(index, icon);
                              } else {
                                /// used to Move icon from screen back to the dock
                                final screenIndex = fromIndex - icons.length;
                                icons.insert(
                                    index, screenicons.removeAt(screenIndex));
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
                                color: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    icons[index],
                                    size: isHovered ? 70.0 : 30.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    icons[index],
                                    size: isHovered ? 70.0 : 30.0,
                                    color: Colors.white,
                                  ),
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
                                  print("icon $index Clicked");
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: isHovered ? 70.0 : 50.0,
                                      height: isHovered ? 70.0 : 50.0,
                                      child: Icon(
                                        icons[index],
                                        size: isHovered ? 50.0 : 30.0,
                                        color: Colors.white,
                                      ),
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
