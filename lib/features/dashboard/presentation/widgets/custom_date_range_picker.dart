import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const CustomDateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  static const Color _green = Color(0xff16A34A);

  late DateTime _displayedMonth;

  DateTime? _startDate;
  DateTime? _endDate;

  late final DateTime _today;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _today = DateTime(now.year, now.month, now.day);

    _startDate = widget.initialStartDate != null
        ? _normalize(widget.initialStartDate!)
        : null;

    _endDate = widget.initialEndDate != null
        ? _normalize(widget.initialEndDate!)
        : null;

    final initialMonth = _startDate ?? _today;

    _displayedMonth = DateTime(initialMonth.year, initialMonth.month);
  }

  // ============================================================
  // DATE SELECTION
  // ============================================================

  void _selectDate(DateTime date) {
    if (date.isAfter(_today)) {
      return;
    }

    setState(() {
      // No start date or existing range already completed.
      // Start a new selection.
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;

        return;
      }

      // We have a start date but no end date.
      if (date.isBefore(_startDate!)) {
        // If user taps an earlier date, make it the new start.
        _startDate = date;
        _endDate = null;
      } else {
        _endDate = date;
      }
    });
  }

  // ============================================================
  // MONTH NAVIGATION
  // ============================================================

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    final nextMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);

    final currentMonth = DateTime(_today.year, _today.month);

    if (nextMonth.isAfter(currentMonth)) {
      return;
    }

    setState(() {
      _displayedMonth = nextMonth;
    });
  }

  bool get _canGoNext {
    final currentMonth = DateTime(_today.year, _today.month);

    return _displayedMonth.isBefore(currentMonth);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ------------------------------------------------
              // DRAG HANDLE
              // ------------------------------------------------
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xffCBD5E1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // HEADER
              // ------------------------------------------------
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _green.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: _green,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Date Range',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0F172A),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Choose a period to analyze',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ------------------------------------------------
              // START / END DATE CARDS
              // ------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _DateCard(
                      label: 'START DATE',
                      date: _startDate,
                      active: _startDate != null && _endDate == null,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: Color(0xff64748B),
                      ),
                    ),
                  ),

                  Expanded(
                    child: _DateCard(
                      label: 'END DATE',
                      date: _endDate,
                      active: _endDate != null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ------------------------------------------------
              // MONTH HEADER
              // ------------------------------------------------
              Row(
                children: [
                  _MonthButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: _previousMonth,
                  ),

                  Expanded(
                    child: Text(
                      _monthYear(_displayedMonth),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff0F172A),
                      ),
                    ),
                  ),

                  _MonthButton(
                    icon: Icons.chevron_right_rounded,
                    enabled: _canGoNext,
                    onTap: _nextMonth,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // WEEK DAYS
              // ------------------------------------------------
              const Row(
                children: [
                  _WeekDay('S'),
                  _WeekDay('M'),
                  _WeekDay('T'),
                  _WeekDay('W'),
                  _WeekDay('T'),
                  _WeekDay('F'),
                  _WeekDay('S'),
                ],
              ),

              const SizedBox(height: 8),

              // ------------------------------------------------
              // CALENDAR
              // ------------------------------------------------
              _buildCalendar(),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // RANGE SUMMARY
              // ------------------------------------------------
              _buildRangeSummary(),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // APPLY BUTTON
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _startDate != null && _endDate != null
                      ? () {
                          Navigator.pop(
                            context,
                            DateTimeRange(start: _startDate!, end: _endDate!),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xffE2E8F0),
                    disabledForegroundColor: const Color(0xff94A3B8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _startDate != null && _endDate != null
                        ? 'Apply Date Range'
                        : 'Select End Date',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _buildCalendar() {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);

    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    // Dart weekday:
    // Monday = 1
    // Sunday = 7
    //
    // Calendar:
    // Sunday = column 0
    final startOffset = firstDay.weekday % 7;

    final totalCells = startOffset + daysInMonth;

    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (row) {
        return Row(
          children: List.generate(7, (column) {
            final index = (row * 7) + column;

            final day = index - startOffset + 1;

            if (day < 1 || day > daysInMonth) {
              return const Expanded(child: SizedBox(height: 44));
            }

            final date = DateTime(
              _displayedMonth.year,
              _displayedMonth.month,
              day,
            );

            return Expanded(child: _buildDay(date));
          }),
        );
      }),
    );
  }

  Widget _buildDay(DateTime date) {
    final isFuture = date.isAfter(_today);

    final isStart = _startDate != null && _sameDay(date, _startDate!);

    final isEnd = _endDate != null && _sameDay(date, _endDate!);

    final isToday = _sameDay(date, _today);

    final isInRange =
        _startDate != null &&
        _endDate != null &&
        date.isAfter(_startDate!) &&
        date.isBefore(_endDate!);

    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ----------------------------------------------
          // RANGE BACKGROUND
          // ----------------------------------------------
          if (isInRange)
            Positioned.fill(
              top: 5,
              bottom: 5,
              child: Container(color: _green.withValues(alpha: 0.09)),
            ),

          if (isStart && _endDate != null && !_sameDay(_startDate!, _endDate!))
            Positioned(
              right: 0,
              top: 5,
              bottom: 5,
              width: 22,
              child: Container(color: _green.withValues(alpha: 0.09)),
            ),

          if (isEnd && _startDate != null && !_sameDay(_startDate!, _endDate!))
            Positioned(
              left: 0,
              top: 5,
              bottom: 5,
              width: 22,
              child: Container(color: _green.withValues(alpha: 0.09)),
            ),

          // ----------------------------------------------
          // DAY
          // ----------------------------------------------
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isFuture
                  ? null
                  : () {
                      _selectDate(date);
                    },
              customBorder: const CircleBorder(),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isStart || isEnd ? _green : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday && !isStart && !isEnd
                      ? Border.all(color: _green, width: 1.5)
                      : null,
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isStart || isEnd || isToday
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isStart || isEnd
                        ? Colors.white
                        : isFuture
                        ? const Color(0xffCBD5E1)
                        : const Color(0xff334155),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _buildRangeSummary() {
    String text;

    if (_startDate == null) {
      text = 'Select your start date';
    } else if (_endDate == null) {
      text = '${_shortDate(_startDate!)}  →  Select end date';
    } else {
      final days = _endDate!.difference(_startDate!).inDays + 1;

      text =
          '${_shortDate(_startDate!)}  →  ${_shortDate(_endDate!)}  •  $days ${days == 1 ? 'day' : 'days'}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const Icon(Icons.date_range_rounded, size: 19, color: _green),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff166534),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  String _shortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }
}

// ================================================================
// DATE CARD
// ================================================================

class _DateCard extends StatelessWidget {
  static const Color _green = Color(0xff16A34A);

  final String label;
  final DateTime? date;
  final bool active;

  const _DateCard({
    required this.label,
    required this.date,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: active
            ? _green.withValues(alpha: 0.06)
            : const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: active ? _green : const Color(0xffE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: active ? _green : const Color(0xff94A3B8),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            date == null ? 'Select' : _formatDate(date!),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xff0F172A),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}

// ================================================================
// MONTH BUTTON
// ================================================================

class _MonthButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _MonthButton({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? const Color(0xffF1F5F9) : const Color(0xffF8FAFC),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            color: enabled ? const Color(0xff334155) : const Color(0xffCBD5E1),
          ),
        ),
      ),
    );
  }
}

// ================================================================
// WEEK DAY
// ================================================================

class _WeekDay extends StatelessWidget {
  final String value;

  const _WeekDay(this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xff94A3B8),
          ),
        ),
      ),
    );
  }
}
