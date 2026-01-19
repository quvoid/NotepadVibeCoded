import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderPicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final Function(DateTime?) onReminderChanged;

  const ReminderPicker({
    super.key,
    this.initialDateTime,
    required this.onReminderChanged,
  });

  @override
  State<ReminderPicker> createState() => _ReminderPickerState();
}

class _ReminderPickerState extends State<ReminderPicker> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    
    // Pick date
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;

    // Pick time
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
    );

    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() => _selectedDateTime = dateTime);
    widget.onReminderChanged(dateTime);
  }

  void _clearReminder() {
    setState(() => _selectedDateTime = null);
    widget.onReminderChanged(null);
  }

  void _setQuickReminder(Duration duration) {
    final dateTime = DateTime.now().add(duration);
    setState(() => _selectedDateTime = dateTime);
    widget.onReminderChanged(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_selectedDateTime != null) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.alarm),
              title: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime!)),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearReminder,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        ElevatedButton.icon(
          onPressed: _pickDateTime,
          icon: const Icon(Icons.calendar_today),
          label: Text(_selectedDateTime == null ? 'Set Reminder' : 'Change Reminder'),
        ),
        
        const SizedBox(height: 16),
        Text(
          'Quick Options:',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('1 hour'),
              onPressed: () => _setQuickReminder(const Duration(hours: 1)),
            ),
            ActionChip(
              label: const Text('Tomorrow'),
              onPressed: () => _setQuickReminder(const Duration(days: 1)),
            ),
            ActionChip(
              label: const Text('Next week'),
              onPressed: () => _setQuickReminder(const Duration(days: 7)),
            ),
          ],
        ),
      ],
    );
  }
}
