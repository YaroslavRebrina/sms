String getCurrentTime() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.day.toString().padLeft(2, '0')}:${now.month.toString().padLeft(2, '0')}:${now.year}';
}

String getCurrentTime1hAhead() {
  final now = DateTime.now();
  int adjustedHour = now.hour + 1;
  if (adjustedHour == 24) {
    adjustedHour = 0;
  }
  return '${adjustedHour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.day.toString().padLeft(2, '0')}:${now.month.toString().padLeft(2, '0')}:${now.year}';
}

String getCurrentHoursMinutes() {
  final now = DateTime.now();
  int adjustedHour = now.hour;
  if (adjustedHour == 24) {
    adjustedHour = 0;
  }
  return '${adjustedHour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
}
