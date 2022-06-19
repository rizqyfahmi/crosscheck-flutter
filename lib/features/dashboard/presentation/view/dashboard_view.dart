import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/core/widgets/cloudy_card/cloudy_card.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:crosscheck/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = context.watch<AuthenticationBloc>();
    final token = authenticationBloc.state.token;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {

          if (state is DashboardLoading) {
            context.read<MainBloc>().add(MainShowLoading());
            return;
          }

          if (state is DashboardGeneralError) {
            context.read<MainBloc>().add(MainSetGeneralError(message: state.message));
            return;
          }

          context.read<MainBloc>().add(MainHideLoading());
        },
        builder: (context, state) {
          
          if (state is DashboardInit) {
            context.read<DashboardBloc>().add(DashboardGetData(token: token));
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
                                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                      color: Theme.of(context).colorScheme.surfaceTint,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    state.model.username,
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
                        SvgPicture.asset(CustomIcons.avatar)
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Task Summary",
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