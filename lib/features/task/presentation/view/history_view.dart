import 'package:crosscheck/core/widgets/dialog/dialog.dart';
import 'package:crosscheck/core/widgets/task_tile/task_tile.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_event.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late ScrollController controller;

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
    if (controller.position.extentAfter == 0) {
      context.read<TaskBloc>().add(TaskGetMoreHistory());
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
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          
          if (state is TaskGeneralError) {
            Navigator.of(context, rootNavigator: true).pop();
            showResponseDialog(
              context: context,
              status: ResponseDialogStatus.error,
              title: state.title,
              message: state.message
            );
            return;
          }

          if (state is TaskLoading) {
            showLoadingDialog(context: context);
            return;
          }

          if (state is! TaskLoaded) return;
          Navigator.of(context).pop();
        }, builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TaskBloc>().add(TaskGetRefreshHistory());
            },
            child: ListView.builder(
              itemCount: state.models.length,
              controller: controller,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final id = state.models[index].id;
                return Column(
                  children: [
                    TaskTile(key: Key("TaskTile$id"), task: state.models[index]),
                    const SizedBox(height: 16)
                  ],
                );
              },
            ),
          );
        }
      ),
    );
  }
}
