import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_event.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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
              Row(
                children: [
                  SvgPicture.asset(CustomIcons.avatar),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          key: const Key("textUsername"),
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          "username@email.com",
                          key: const Key("textEmail"),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "Personal Information",
                key: const Key("labelPersonalInformation"),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Full name",
                key: const Key("labelFullName"),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "N/A",
                key: const Key("textFullName"),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w400
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Email Address",
                key: const Key("labelEmailAddress"),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "N/A",
                key: const Key("textEmailAddress"),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w400
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Date of Birth",
                key: const Key("labelDOB"),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "N/A",
                key: const Key("textDOB"),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w400
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Address",
                key: const Key("labelAddress"),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "N/A",
                key: const Key("textAddress"),
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w400
                ),
              ),
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