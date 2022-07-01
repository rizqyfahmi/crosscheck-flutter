import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/widgets/cloudy_card/cloudy_card.dart';
import 'package:crosscheck/core/widgets/dialog/dialog.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {

          if (state is DashboardLoading) {
            showLoadingDialog(context: context);
            return;
          }

          if (state is DashboardGeneralError) {
            Navigator.of(context, rootNavigator: true).pop();
            showResponseDialog(
              context: context,
              status: ResponseDialogStatus.error,
              message: state.message
            );
            return;
          }

          if (state is DashboardSuccess) {
            Navigator.of(context, rootNavigator: true).pop();
          }

        },
        builder: (context, state) {
          
          if (state is DashboardInit) {
            context.read<DashboardBloc>().add(DashboardGetData());
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Welcome back, ",
                                    key: const Key("labelWelcomeBack"),
                                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                      color: Theme.of(context).colorScheme.surfaceTint,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    state.model.fullname,
                                    key: const Key("usernameText"),
                                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.model.taskText,
                                key: const Key("taskText"),
                                style: Theme.of(context).textTheme.headline1?.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground
                                ),
                              )
                            ],
                          )
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32)
                          ),
                          height: 64,
                          width: 64,
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            state.model.photoUrl,
                            key: const Key("imageProfile"),
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Task Summary",
                      key: const Key("labelTaskSummary"),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                    ),
                    const SizedBox(height: 16),
                    CloudyCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      state.model.progress,
                                      key: const Key("progressText"),
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onBackground
                                      ),
                                    ),
                                    Text(
                                      "Progress",
                                      key: const Key("labelProgress"),
                                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                        color: Theme.of(context).colorScheme.onBackground,
                                        fontWeight: FontWeight.w500
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CloudyCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            state.model.upcoming.toString(),
                                            key: const Key("upcomingText"),
                                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                              color: Theme.of(context).colorScheme.onBackground
                                            ),
                                          ),
                                          Text(
                                            "Upcomming",
                                            key: const Key("labelUpcomming"),
                                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                              color: Theme.of(context).colorScheme.onBackground,
                                              fontWeight: FontWeight.w500
                                            )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CloudyCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            state.model.completed.toString(),
                                            key: const Key("completedText"),
                                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                              color: Theme.of(context).colorScheme.onBackground
                                            ),
                                          ),
                                          Text(
                                            "Completed",
                                            key: const Key("labelCompleted"),
                                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                              color: Theme.of(context).colorScheme.onBackground,
                                              fontWeight: FontWeight.w500
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Weekly Events",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildChart(context, state),  
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
          );
        }
      ),
    );
  }
  
  Widget buildChart(BuildContext context, DashboardState state) {
    return SizedBox(
      height: 160,
      child: Row(
        children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].asMap().entries.map((entry) {
          return Expanded(
            child: Container(
               margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: CustomColors.placeholderText.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            key: const Key("bar"),
                            height: state.model.activities[entry.key].heightBar,
                            decoration: BoxDecoration(
                              color: state.model.activities[entry.key].isActive ? CustomColors.primary : CustomColors.placeholderText.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(6),
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.value,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      )
    );
  }

  
}