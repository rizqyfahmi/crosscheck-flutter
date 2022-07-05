import 'package:crosscheck/core/widgets/task_tile/task_tile.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late ScrollController controller;
  List<TaskModel> items = List.generate(10, (v) {
    final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v + 1));
    String startDate = "${start.day.toString().padLeft(2, "0")}-${start.month.toString().padLeft(2, "0")}-${start.year}";
    String startTime = "${start.hour.toString().padLeft(2, "0")}:${start.minute.toString().padLeft(2, "0")}";
    String endDate = "${start.add(const Duration(hours: 1)).day.toString().padLeft(2, "0")}-${start.add(const Duration(hours: 1)).month.toString().padLeft(2, "0")}-${start.add(const Duration(hours: 1)).year}";
    String endTime = "${start.add(const Duration(hours: 1)).hour.toString().padLeft(2, "0")}:${start.add(const Duration(hours: 1)).minute.toString().padLeft(2, "0")}";

    return TaskModel(
      id: v.toString(),
      title: "hello title $v",
      description: "hello description $v", 
      startDate: startDate,
      startTime: startTime,
      endDate: endDate, 
      endTime: endTime, 
      isAllDay: false, 
      alerts: const [],
      status: "active"
    );
  }).toList();

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 50) {
      setState(() {
        items.addAll(
          List.generate(10, (v) {
            final start = DateTime.parse("2022-07-03 00:00:00").add(Duration(hours: v + 1));
            String startDate = "${start.day.toString().padLeft(2, "0")}-${start.month.toString().padLeft(2, "0")}-${start.year}";
            String startTime = "${start.hour.toString().padLeft(2, "0")}:${start.minute.toString().padLeft(2, "0")}";
            String endDate = "${start.add(const Duration(hours: 1)).day.toString().padLeft(2, "0")}-${start.add(const Duration(hours: 1)).month.toString().padLeft(2, "0")}-${start.add(const Duration(hours: 1)).year}";
            String endTime = "${start.add(const Duration(hours: 1)).hour.toString().padLeft(2, "0")}:${start.add(const Duration(hours: 1)).minute.toString().padLeft(2, "0")}";

            return TaskModel(
              id: v.toString(),
              title: "hello title $v",
              description: "hello description $v", 
              startDate: startDate,
              startTime: startTime,
              endDate: endDate, 
              endTime: endTime, 
              isAllDay: false, 
              alerts: const [],
              status: "active"
            );
          }).toList()
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "History",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2?.copyWith(
            color: Theme.of(context).colorScheme.onBackground
          ),
        ),
        
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.black.withOpacity(0.4),
      ),
      body: ListView.builder(
        itemCount: items.length,
        controller: controller,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Column(
            children: [
              TaskTile(task: items[index]),
              const SizedBox(height: 16)
            ],
          );
        },
      ),
    );
  }
}