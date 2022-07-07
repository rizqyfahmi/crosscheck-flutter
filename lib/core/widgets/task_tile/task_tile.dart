import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onPressed;

  const TaskTile({Key? key, required this.task, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(
            color: CustomColors.borderField
          ),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    key: const Key("TaskTileTitle"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                  )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: CustomColors.borderField,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Text(
                    task.status,
                    key: const Key("TaskTileStatus"),
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              key: const Key("TaskTileDescription"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SvgPicture.asset(
                  CustomIcons.calendar,
                  height: 16,
                  width: 16,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
                ),
                const SizedBox(width: 8),
                Text(
                  task.startDate,
                  key: const Key("TaskTileStartDate"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}