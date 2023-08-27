class Slot {
  final int year;
  final int month;
  final int day;
  final int slotNumber;
  final int dosesRemaining;

  Slot({
    required this.slotNumber,
    required this.day,
    this.dosesRemaining = 10,
    this.year = 2023,
    this.month = 11,
  });

  factory Slot.fromSlotId(String slotId, {int dosesRemaining = 0}) {
    return Slot(
      slotNumber: int.parse(slotId.substring(8)),
      day: int.parse(slotId.substring(6, 8)),
      month: int.parse(slotId.substring(4, 6)),
      year: int.parse(slotId.substring(0, 4)),
      dosesRemaining: dosesRemaining,
    );
  }

  bool isEditable() {
    final today = DateTime.now();
    final slotDate = DateTime(year, month, day);
    slotDate.subtract(const Duration(days: 1));
    return slotDate.isAfter(today);
  }

  bool isElapsed() {
    final today = DateTime.now();
    final slotDate = DateTime(year, month, day);
    return slotDate.isBefore(today);
  }

  bool isFull() => dosesRemaining <= 0;

  DateTime getStartTime() {
    final hour = 10 + ((slotNumber - 1) / 2).floor();
    final minute = (slotNumber - 1).remainder(2) == 1 ? 30 : 0;
    return DateTime(year, month, day, hour, minute);
  }

  DateTime getEndTime() {
    final hour = 10 + ((slotNumber - 1) / 2).ceil();
    final minute = (slotNumber - 1).remainder(2) == 1 ? 0 : 30;
    return DateTime(year, month, day, hour, minute);
  }

  /// generates a slot id in format
  /// YYYYMMDDSL, where YYYY denotes year
  ///             MM denotes month
  ///             DD denotes day
  ///             SL denotes slot number for the day
  ///
  int getSlotId() {
    return year * 1000000 + month * 10000 + day * 100 + slotNumber;
  }
}
