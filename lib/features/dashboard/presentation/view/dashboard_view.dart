import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/core/widgets/cloudy_card/cloudy_card.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
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
                                    style: TextStyles.poppinsRegular18.copyWith(
                                      color: CustomColors.welcome
                                    ),
                                  ),
                                  Text(
                                    state.model.username,
                                    key: const Key("usernameText"),
                                    style: TextStyles.poppinsRegular18.copyWith(
                                      color: CustomColors.primary
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                state.model.taskText,
                                key: const Key("taskText"),
                                style: TextStyles.poppinsBold24,
                              )
                            ],
                          )
                        ),
                        const SizedBox(width: 16),
                        SvgPicture.asset(CustomIcons.avatar)
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Task Summary",
                      textAlign: TextAlign.left,
                      style: TextStyles.poppinsBold16,
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
                                      style: TextStyles.poppinsBold32.copyWith(
                                        color: CustomColors.secondary
                                      ),
                                    ),
                                    Text(
                                      "Progress",
                                      style: TextStyles.poppinsMedium16.copyWith(
                                        color: CustomColors.secondary
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
                                            style: TextStyles.poppinsBold32.copyWith(
                                              color: CustomColors.secondary
                                            ),
                                          ),
                                          Text(
                                            "Upcomming",
                                            style: TextStyles.poppinsMedium16.copyWith(
                                              color: CustomColors.secondary
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
                                            style: TextStyles.poppinsBold32.copyWith(
                                              color: CustomColors.secondary
                                            ),
                                          ),
                                          Text(
                                            "Completed",
                                            style: TextStyles.poppinsMedium16.copyWith(
                                              color: CustomColors.secondary
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
                    const Text(
                      "Weekly Events",
                      textAlign: TextAlign.left,
                      style: TextStyles.poppinsBold16,
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
                    style: TextStyles.poppinsMedium14,
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