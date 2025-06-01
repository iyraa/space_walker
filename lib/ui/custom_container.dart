import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final String title;
  final double minWidth;
  final double minHeight;
  final double initialWidth;
  final double initialHeight;
  final double initialX;
  final double initialY;

  const CustomContainer({
    super.key,
    required this.title,
    required this.child,
    required this.initialX,
    required this.initialY,
    this.padding = const EdgeInsets.all(16.0),
    required this.minWidth,
    required this.minHeight,
    this.initialWidth = 300,
    this.initialHeight = 200,
  });

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  late Offset position;
  late double width;
  late double height;
  bool minimized = false;

  // For resizing
  bool resizing = false;
  Offset? resizeStart;
  double? startWidth;
  double? startHeight;
  double? previousHeight;

  @override
  void initState() {
    super.initState();
    width = widget.initialWidth;
    height = widget.initialHeight;
    position = Offset(widget.initialX, widget.initialY);
  }

  void _onResize(DragUpdateDetails details) {
    setState(() {
      width = (width + details.delta.dx).clamp(
        widget.minWidth,
        double.infinity,
      );
      height = (height + details.delta.dy).clamp(
        widget.minHeight,
        double.infinity,
      );
    });
  }

  void _onDrag(details) {
    setState(() {
      position += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Draggable and resizable container
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            // onPanStart: (details) {
            //   // Only drag if not resizing and not minimized
            //   if (!resizing && !minimized) {
            //     setState(() {
            //       position = Offset(
            //         position.dx + details.localPosition.dx,
            //         position.dy + details.localPosition.dy,
            //       );
            //     });
            //   }
            // },
            onPanUpdate: _onDrag,

            child: Container(
              //duration: const Duration(milliseconds: 0),
              width: width,
              height: height, // Always use height variable
              constraints: BoxConstraints(
                minWidth: widget.minWidth,
                minHeight: minimized ? 40 : widget.minHeight,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                border: Border.all(
                  width: 1.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Title bar with minimize button and title
                  GestureDetector(
                    onPanStart: (details) {
                      resizing = false;
                    },
                    onPanUpdate: (details) {
                      if (!resizing) {
                        setState(() {
                          position += details.delta;
                        });
                      }
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(Icons.drag_handle, size: 18),
                              ),
                              AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  FlickerAnimatedText(
                                    widget.title,
                                    textStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    speed: const Duration(milliseconds: 400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              minimized ? Icons.add : Icons.remove,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                if (!minimized) {
                                  // Minimizing: save current height
                                  previousHeight = height;
                                  height = 40;
                                } else {
                                  // Maximizing: restore previous height or default
                                  height =
                                      previousHeight ?? widget.initialHeight;
                                }
                                minimized = !minimized;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!minimized)
                    Expanded(
                      child: ClipRect(
                        child: Padding(
                          padding: widget.padding,
                          child: widget.child,
                        ),
                      ),
                    ),
                  // Resize handle
                  if (!minimized)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onPanStart: (details) {
                          resizing = true;
                          resizeStart = details.globalPosition;
                          startWidth = widget.minWidth;
                          startHeight = widget.minHeight;
                        },
                        onPanUpdate: _onResize,

                        onPanEnd: (_) {
                          resizing = false;
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.open_in_full, size: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
