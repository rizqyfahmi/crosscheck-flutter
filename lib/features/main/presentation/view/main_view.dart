import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/core/widgets/loading_modal/loading_modal.dart';
import 'package:crosscheck/core/widgets/message_modal/message_modal.dart';
import 'package:crosscheck/core/widgets/plus_button/plus_button.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_event.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_state.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_event.dart';
import 'package:crosscheck/features/settings/presentation/view/settings_view.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_bloc.dart';
import 'package:crosscheck/features/task/presentation/bloc/task_event.dart';
import 'package:crosscheck/features/task/presentation/view/history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainView extends StatelessWidget {

  static String routeName = "login";
  
  const MainView({Key? key}) : super(key: key);

  Widget buildMenu({
    required BuildContext context,
    String? stringKey,
    required String icon,
    required String title,
    bool isActive = false,
    required VoidCallback onPressed
  }) {
    Key? key;

    if (stringKey != null) {
      key = Key(stringKey);
    }

    return TextButton(
      key: key,
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory
      ),
      onPressed: onPressed, 
      child: Column(
        children: [
          SvgPicture.asset(
            key: Key("${stringKey}Icon"),
            icon,
            color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
            height: 24,
            width: 24,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            key: Key("${stringKey}Text"),
            style: TextStyles.poppinsMedium12.copyWith(
              color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
            ),
          )
        ],
      )
    );
  }

  Future<void> getProfileData(BuildContext context) async {
    context.read<ProfileBloc>().add(ProfileGetData());
    return await Future.value(null);
  }

  Future<void> getHistoryData(BuildContext context) async {
    context.read<TaskBloc>().add(TaskGetHistory());
    return await Future.value(null);
  }

  Widget buildContent(BuildContext context, MainState state) {
    switch (state.model.currentPage) {
      case BottomNavigation.setting:
        return FutureBuilder(
          future: getProfileData(context),
          builder: (context, _) {
            return const Center(
              child: SettingsView(),
            );
          }
        );
      case BottomNavigation.history:
        return FutureBuilder(
          future: getHistoryData(context),
          builder: (context, _) {
            return const HistoryView();
          }
        );
      case BottomNavigation.event:
        return const Center(
          child: Text("Event"),
        );
      default:
        return const DashboardView();
    }
  }

  Widget buildNavigation(BuildContext context, MainState state) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.4,
            color: Theme.of(context).shadowColor,
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildMenu(
                context: context,
                stringKey: "navHome",
                icon: CustomIcons.home, 
                title: "Home", 
                isActive: state.model.currentPage == BottomNavigation.home, 
                onPressed: () {
                  context.read<MainBloc>().add(MainSetActiveBottomNavigation(currentPage: BottomNavigation.home));
                }
              ),
              buildMenu(
                context: context,
                stringKey: "navEvent",
                icon: CustomIcons.calendar,
                title: "Event",
                isActive: state.model.currentPage == BottomNavigation.event,
                onPressed: () {
                  context.read<MainBloc>().add(MainSetActiveBottomNavigation(currentPage: BottomNavigation.event));
                }
              ),
              const PlusButton(
                key: Key("plusButton"),
              ),
              buildMenu(
                context: context,
                stringKey: "navHistory",
                icon: CustomIcons.history,
                title: "History",
                isActive: state.model.currentPage == BottomNavigation.history,
                onPressed: () {
                  context.read<MainBloc>().add(MainSetActiveBottomNavigation(currentPage: BottomNavigation.history));
                }
              ),
              buildMenu(
                context: context,
                stringKey: "navSetting",
                icon: CustomIcons.setting,
                title: "Settings",
                isActive: state.model.currentPage == BottomNavigation.setting,
                onPressed: () {
                  context.read<MainBloc>().add(MainSetActiveBottomNavigation(currentPage: BottomNavigation.setting));
                }
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          if (state is MainInit) {
            context.read<MainBloc>().add(MainGetActiveBottomNavigation());
          }

          return LoadingModal(
            isLoading: state is MainLoading,
            child: MessageModal(
              status: MessageModalStatus.error,
              message: state is MainGeneralError ? state.message : null,
              onDismissed: () {
                context.read<MainBloc>().add(MainResetGeneralError());
              },
              child: Column(
                children: [
                  Expanded(
                    child: buildContent(context, state)
                  ),
                  buildNavigation(context, state)
                ],
              ),
            ),
          );
          
        },
      ),
    );
  }
}
