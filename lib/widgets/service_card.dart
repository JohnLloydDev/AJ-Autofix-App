import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ServiceCard extends StatefulWidget {
  final String serviceName;
  final String servicePrice;
  final String? imagePath;
  final bool isSelected;
  final VoidCallback onAddPressed;

  const ServiceCard({
    super.key,
    required this.serviceName,
    required this.servicePrice,
    this.imagePath,
    required this.isSelected,
    required this.onAddPressed,
  });

  @override
  ServiceCardState createState() => ServiceCardState();
}

class ServiceCardState extends State<ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;

              double imageHeight = width * 0.3;
              double imageWidth = width * 0.50;
              double fontSize = width * 0.07;
              double buttonSize = width * 0.12;

              return Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.imagePath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            widget.imagePath!,
                            height: imageHeight,
                            width: imageWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 12),
                      FittedBox(
                        child: Text(
                          widget.serviceName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        child: Text(
                          widget.servicePrice,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSize * 0.9,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            widget.onAddPressed();
                            Fluttertoast.showToast(
                              msg: widget.isSelected
                                  ? "Service removed from booking"
                                  : "Service added to booking",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: const Color.fromARGB(100, 0, 0, 0),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          icon: Icon(
                            widget.isSelected ? Icons.check_circle : Icons.add_circle,
                            color: widget.isSelected ? Colors.green : Colors.black,
                            size: buttonSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
