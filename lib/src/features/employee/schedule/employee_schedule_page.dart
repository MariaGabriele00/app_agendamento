import 'package:app_agendamento/src/core/ui/constants.dart';
import 'package:app_agendamento/src/features/employee/schedule/appointment_ds.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EmployeeSchedulePage extends StatelessWidget {
  const EmployeeSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          const Text(
            'Nome e sobrenome',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 44),
          Expanded(
            child: SfCalendar(
              allowViewNavigation: true,
              view: CalendarView.day,
              showNavigationArrow: true,
              todayHighlightColor: ColorsConstants.pink,
              showDatePickerButton: true,
              showTodayButton: true,
              dataSource: AppointmentDs(),
            ),
          ),
        ],
      ),
    );
  }
}
