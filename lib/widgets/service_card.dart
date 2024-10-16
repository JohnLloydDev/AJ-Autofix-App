import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ServiceCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        // Responsive sizes based on width of the container
        double imageHeight = width * 0.4; // 40% of container width for image height
        double imageWidth = width * 0.55; // 55% of container width for image width
        double fontSize = width * 0.07; // 5% of container width for font size
        double buttonSize = width * 0.12; // 12% of container width for button size

        return Card(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Take up only the minimum space
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imagePath!,
                      height: imageHeight,
                      width: imageWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8),
                FittedBox(
                  child: Text(
                    serviceName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize, // Adjust font size based on container width
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  child: Text(
                    servicePrice,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize * 0.9, // Slightly smaller for price
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      onAddPressed();
                      Fluttertoast.showToast(
                        msg: isSelected
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
                      isSelected ? Icons.check_circle : Icons.add_circle,
                      color: isSelected ? Colors.green : Colors.black,
                      size: buttonSize, // Adjust button size based on container width
                    ),
                  ),
                ),
              
              ],
            ),
          ),
        );
      },
    );
  }
}
