

class MediaEvent {
  final String _eventName;
  final DateTime _dateTime;

  MediaEvent(String eventName, DateTime dateTime)
      : _eventName = eventName,
        _dateTime = dateTime;

  get eventName => _eventName;

  get dateTime => _dateTime;
}
