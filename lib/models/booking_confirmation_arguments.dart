class BookingConfirmationArguments {
  final List<String> selectedServices;
  final int selectedServiceCount;
  final String selectedTimeSlot;
  final DateTime bookingDate;
  final String vehicleType;

  BookingConfirmationArguments({
    required this.selectedServices,
    required this.selectedServiceCount,
    required this.selectedTimeSlot,
    required this.bookingDate,
    required this.vehicleType,
  });
}
