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

class ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
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
              double height = width * 0.80;

              double imageHeight = height * 0.40;
              double imageWidth = width * 0.45;
              double fontSize = width * 0.07;
              double buttonSize = width * 0.13;

              return Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      const SizedBox(height: 8),
                      Text(
                        widget.serviceName.replaceAllMapped(
                          RegExp(
                              r'(Power Window Motor Installation|Power Window Cable Replacement|Powerlock \(1pc\) Installation|Powerlock Set Installation|Door Lock Replacement|Door Handle Replacement|Door Handle Repair Service|Door Lock Repair Service|Coolant Flush Service|Engine Oil Change Service|Spark Plug Replacement|Air Filter Replacement|Fuel Injector Cleaning Service|Timing Belt Replacement|Tire Replacement Service|Wheel Alignment Service|Brake Pad Set Replacement|Brake Fluid Replacement|Alternator Repair Service|Fuse Replacement Service|Car Alarm Installation|Battery Replacement Service|Headlight Bulb Replacement|Power Window Switch Replacement)'),
                          (match) {
                            switch (match.group(0)) {
                              case 'Power Window Motor Installation':
                                return 'Power Window Motor\nInstallation';
                              case 'Power Window Cable Replacement':
                                return 'Power Window\nCable Replacement';
                              case 'Powerlock (1pc) Installation':
                                return 'Powerlock (1pc)\nInstallation';
                              case 'Powerlock Set Installation':
                                return 'Powerlock Set\nInstallation';
                              case 'Door Lock Replacement':
                                return 'Door Lock\nReplacement';
                              case 'Door Handle Replacement':
                                return 'Door Handle\nReplacement';
                              case 'Door Handle Repair Service':
                                return 'Door Handle\nRepair Service';
                              case 'Door Lock Repair Service':
                                return 'Door Lock\nRepair Service';
                              case 'Coolant Flush Service':
                                return 'Coolant\nFlush Service';
                              case 'Engine Oil Change Service':
                                return 'Engine Oil Change\nService';
                              case 'Spark Plug Replacement':
                                return 'Spark Plug\nReplacement';
                              case 'Air Filter Replacement':
                                return 'Air Filter\nReplacement';
                              case 'Fuel Injector Cleaning Service':
                                return 'Fuel Injector\nCleaning Service';
                              case 'Timing Belt Replacement':
                                return 'Timing Belt\nReplacement';
                              case 'Tire Replacement Service':
                                return 'Tire Replacement\nService';
                              case 'Wheel Alignment Service':
                                return 'Wheel Alignment\nService';
                              case 'Brake Pad Set Replacement':
                                return 'Brake Pad Set\nReplacement';
                              case 'Brake Fluid Replacement':
                                return 'Brake Fluid\nReplacement';
                              case 'Alternator Repair Service':
                                return 'Alternator Repair\nService';
                              case 'Fuse Replacement Service':
                                return 'Fuse Replacement\nService';
                              case 'Car Alarm Installation':
                                return 'Car Alarm\nInstallation';
                              case 'Battery Replacement Service':
                                return 'Battery Replacement\nService';
                              case 'Headlight Bulb Replacement':
                                return 'Headlight Bulb\nReplacement';
                              case 'Power Window Switch Replacement':
                                return 'Power Window Switch\nReplacement';
                              default:
                                return match.group(0)!;
                            }
                          },
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                              backgroundColor:
                                  const Color.fromARGB(100, 0, 0, 0),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          icon: Icon(
                            widget.isSelected
                                ? Icons.check_circle
                                : Icons.add_circle,
                            color:
                                widget.isSelected ? Colors.green : Colors.black,
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
