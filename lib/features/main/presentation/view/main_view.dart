import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/core/widgets/plus_button/plus_button.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_bloc.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_event.dart';
import 'package:crosscheck/features/main/presentation/bloc/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainView extends StatelessWidget {

  static String routeName = "login";
  
  const MainView({Key? key}) : super(key: key);

  Widget buildMenu({
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
            color: isActive ? CustomColors.primary : CustomColors.secondary,
            height: 24,
            width: 24,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            key: Key("${stringKey}Text"),
            style: TextStyles.poppinsMedium12.copyWith(
              color: isActive ? CustomColors.primary : CustomColors.secondary,
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainInit) {
            context.read<MainBloc>().add(MainGetActiveBottomNavigation());
          }

          switch (state.model.currentPage) {
            case BottomNavigation.setting:
              return const Center(
                child: Text("Settings"),
              );
            case BottomNavigation.history:
              return const Center(
                child: Text("History"),
              );
            case BottomNavigation.event:
              return const Center(
                child: Text("Event"),
              );
            default:
              return const Center(
                child: Text("Home"),
              );
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 0.4,
                  color: Colors.black.withOpacity(0.1)
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
                      stringKey: "navHome",
                      icon: CustomIcons.home, 
                      title: "Home", 
                      isActive: state.model.currentPage == BottomNavigation.home, 
                      onPressed: () {
                        context.read<MainBloc>().add(MainSetActiveBottomNavigation(currentPage: BottomNavigation.home));
                      }
                    ),
                    buildMenu(
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
                      stringKey: "navHistory",
                      icon: CustomIcons.history,
                      title: "History",
                      isActive: state.model.currentPage == BottomNavigation.history,
                      onPressed: () {
                        context.read<MainBloc>().add(MainSetActiveBottomNavigation(currentPage: BottomNavigation.history));
                      }
                    ),
                    buildMenu(
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
      ),
    );
  }
}
