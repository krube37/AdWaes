import 'package:ad/media/media_event.dart';

class MediaData {
  String mediaName;
  int availableSlots;
  List<MediaEvent> slots;

  MediaData(
      {required this.mediaName,
      this.availableSlots = 0,
      this.slots = const []});
}
