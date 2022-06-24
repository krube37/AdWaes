class MediaData {
  String mediaName;
  int availableSlots;
  List<String> slots;

  MediaData(
      {required this.mediaName,
      this.availableSlots = 0,
      this.slots = const []});
}
