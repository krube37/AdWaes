part of 'calendar.dart';

const double cellHeight = 60.0;

/// Abstract class: should not be imported!
class _CalendarPickerWidget extends StatefulWidget {
  final DateTime initialDateTime;
  final double? width;
  final Function(bool shouldShowHorsPage, DateTime dateTime)? onModeChanged;
  final MediaData? mediaData;
  bool isDialogView;

  _CalendarPickerWidget(
      {Key? key,
      required this.initialDateTime,
      this.mediaData,
      this.onModeChanged,
      this.isDialogView = false,
      this.width})
      : super(key: key);

  @override
  State<_CalendarPickerWidget> createState() => _CalendarPickerWidgetState();
}

enum _PickerMode { date, month, year }

class _CalendarPickerWidgetState extends State<_CalendarPickerWidget> with TickerProviderStateMixin {
  late ValueNotifier<DateTime> _dateTime;
  final GlobalKey<_CalendarWrapperState> _calendarKey = GlobalKey();

  late final AnimationController _inAnimationController;

  _PickerMode _pickerMode = _PickerMode.date;

  late final Animation<double> _opacity, _scale;

  @override
  void initState() {
    super.initState();

    _inAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _inAnimationController,
        curve: Curves.ease,
      ),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 0.75,
    ).animate(
      CurvedAnimation(
        parent: _inAnimationController,
        curve: Curves.ease,
      ),
    );

    _dateTime = ValueNotifier(widget.initialDateTime);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = widget.width ?? size.width / 2;

    return Align(
      alignment: widget.isDialogView ? Alignment.center : Alignment.topCenter,
      child: Wrap(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 0.0,
                  ),
                  child: _DateTimeTitle(
                    _dateTime,
                    onMonthTapped: () => _changeTo(_PickerMode.month),
                    onYearTapped: () => _changeTo(_PickerMode.year),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: width,
                        child: AnimatedBuilder(
                          animation: _inAnimationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _opacity.value,
                              child: Transform.scale(
                                scale: _scale.value,
                                child: child!,
                              ),
                            );
                          },
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            child: Builder(builder: (context) {
                              Widget child;
                              switch (_pickerMode) {
                                case _PickerMode.date:
                                  child = _CalendarWrapper(
                                      key: _calendarKey,
                                      width: width,
                                      month: _dateTime.value.month,
                                      selectedDateTime: _dateTime.value,
                                      year: _dateTime.value.year,
                                      showMonthInHeader: true,
                                      showMonthActionButtons: true,
                                      onDatePicked: _onDatePicked,
                                      isDialogView: widget.isDialogView,
                                      mediaData: widget.mediaData);
                                  break;
                                case _PickerMode.month:
                                  child = _MonthPicker(
                                    onMonthPicked: (month, year) {
                                      _dateTime.value = _dateTime.value.copyWith(month: month, year: year);
                                      _changeTo(_PickerMode.date);
                                    },
                                    selectedMonth: _dateTime.value.month,
                                    selectedYear: _dateTime.value.year,
                                  );
                                  break;
                                case _PickerMode.year:
                                  child = _YearPicker(
                                      selectedYear: _dateTime.value.year,
                                      onYearPicked: (year) {
                                        _dateTime.value = _dateTime.value.copyWith(year: year);
                                        _changeTo(_PickerMode.date);
                                      });
                                  break;
                              }
                              return child;
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      widget.isDialogView
                          ? Container(
                              padding: const EdgeInsets.only(
                                bottom: 15.0,
                                right: 15.0,
                                top: 0.0,
                              ),
                              child: _FooterButton(
                                onOKTapped: () => Navigator.pop(context, _dateTime.value),
                                onCancelTapped: () => Navigator.pop(context),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeTo(_PickerMode mode) async {
    if (_pickerMode == mode) return;

    await _inAnimationController.forward(from: 0.0);
    setState(() => _pickerMode = mode);
    await _inAnimationController.reverse(from: 1.0);
  }

  void _onDatePicked(DateTime pickedDate) {
    _dateTime.value = pickedDate;
    widget.onModeChanged?.call(true, pickedDate);
  }
}

class _YearPicker extends StatelessWidget {
  final int selectedYear;
  final void Function(int year) onYearPicked;

  final PageController _pageController = PageController(
    initialPage: 100,
    keepPage: true,
  );

  _YearPicker({
    Key? key,
    required this.onYearPicked,
    required this.selectedYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int startingYear = selectedYear - (selectedYear % 16) + 1;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: _widgetControllerHeight + (isPortrait ? 20 : -10) + (4 * cellHeight + (isPortrait ? 0 : -10.0)),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  int pageIndex = index - 100;
                  int fromYear = startingYear + (pageIndex * 4 * 4);
                  int toYear = fromYear + 15;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: _widgetControllerHeight,
                        child: Center(
                          child: Text(
                            "$fromYear - $toYear",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          mainAxisExtent: cellHeight + (isPortrait ? 0 : -10.0),
                        ),
                        itemBuilder: (context, index) {
                          int year = fromYear + index;
                          return InkWell(
                            onTap: () => onYearPicked.call(year),
                            child: Container(
                              decoration: (year == selectedYear)
                                  ? const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                      border: Border.symmetric(
                                        vertical: BorderSide(color: Colors.grey, width: 1.0),
                                        horizontal: BorderSide(color: Colors.grey, width: 1.0),
                                      ),
                                    )
                                  : null,
                              child: Center(
                                child: Text(
                                  "$year",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: 4 * 4,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                      )
                    ],
                  );
                },
              ),
              _PageControllerButtons(
                buttonSize: _widgetControllerHeight,
                onBackwardButtonTap: () => _pageController.previousPage(
                  duration: _pageTransitionDuration,
                  curve: Curves.ease,
                ),
                onForwardButtonTap: () => _pageController.nextPage(
                  duration: _pageTransitionDuration,
                  curve: Curves.ease,
                ),
                backgroundColor: Colors.black45,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthPicker extends StatelessWidget {
  final List<String> months = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  final void Function(int month, int year) onMonthPicked;
  final int selectedMonth;
  final int selectedYear;

  static const int _pageOffset = 1000;

  final PageController _pageController = PageController(
    initialPage: _pageOffset,
    keepPage: true,
  );

  _MonthPicker({
    Key? key,
    required this.onMonthPicked,
    required this.selectedMonth,
    required this.selectedYear,
  }) : super(key: key);

  int _getCurrentYear(int index) => selectedYear + (index - _pageOffset);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: _widgetControllerHeight + 25 + (3 * cellHeight),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: _widgetControllerHeight,
                    child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          int year = _getCurrentYear(index);

                          return Center(
                            child: Text(
                              "$year",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: 25.0),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      mainAxisExtent: cellHeight,
                    ),
                    itemBuilder: (context, index) {
                      int month = index + 1;
                      return InkWell(
                        onTap: () {
                          int currentPageIndex = _pageController.page!.toInt();
                          onMonthPicked.call(month, _getCurrentYear(currentPageIndex));
                        },
                        child: Container(
                          decoration: (month == selectedMonth)
                              ? const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  border: Border.symmetric(
                                    vertical: BorderSide(color: Colors.grey, width: 1.0),
                                    horizontal: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                )
                              : null,
                          child: Center(
                            child: Text(
                              months[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 3 * 4,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              _PageControllerButtons(
                buttonSize: _widgetControllerHeight,
                onBackwardButtonTap: () => _pageController.previousPage(
                  duration: _pageTransitionDuration,
                  curve: Curves.ease,
                ),
                onForwardButtonTap: () => _pageController.nextPage(
                  duration: _pageTransitionDuration,
                  curve: Curves.ease,
                ),
                backgroundColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final void Function() onOKTapped;
  final void Function() onCancelTapped;

  const _FooterButton({
    Key? key,
    required this.onCancelTapped,
    required this.onOKTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            side: BorderSide(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
          color: Colors.transparent,
          child: InkWell(
            onTap: onCancelTapped,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Material(
          color: Colors.grey,
          child: InkWell(
            onTap: onOKTapped,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
