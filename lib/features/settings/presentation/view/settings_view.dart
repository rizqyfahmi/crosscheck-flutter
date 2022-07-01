import 'package:crosscheck/features/profile/presentation/view/profile_settings_section.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_event.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Settings",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2?.copyWith(
            color: Theme.of(context).colorScheme.onBackground
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileSettingsSection(),
              const SizedBox(height: 32),
              Text(
                "Others",
                key: const Key("labelOthers"),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {},
                key: const Key("textButtonChangePassword"),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  minimumSize: Size.zero
                ),
                child: Text(
                  "Change Password",
                  key: const Key("textChangePassword"),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w400,
                    height: 1
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Dark Mode",
                      key: const Key("textDarkMode"),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                        height: 1
                      ),
                    ),
                  ),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return Switch(
                        key: const Key("switchDarkMode"),
                        value: state.model.themeMode == Brightness.dark,
                        activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (value) {
                          final isDark = (state.model.themeMode == Brightness.dark);
                          context.read<SettingsBloc>().add(SettingsChangeTheme(themeMode: isDark ? Brightness.light : Brightness.dark));
                        }
                      );
                    }
                  )
                ],
              ),
              TextButton(
                onPressed: () {}, 
                key: const Key("textButtonAbout"),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  minimumSize: Size.zero
                ),
                child: Text(
                  "About",
                  key: const Key("textAbout"),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w400,
                    height: 1
                  ),
                ),
              ),
              TextButton(
                onPressed: () {}, 
                key: const Key("textButtonLogout"),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  minimumSize: Size.zero
                ),
                child: Text(
                  "Logout",
                  key: const Key("textLogout"),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w400,
                    height: 1
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}