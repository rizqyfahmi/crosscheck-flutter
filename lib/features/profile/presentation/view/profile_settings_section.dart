import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_state.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileGeneralError) {
          debugPrint("listener: ${state.runtimeType} ${state.message}");
          context.read<SettingsBloc>().add(SettingsSetGeneralError(message: state.message));
          return;
        }

        if (state is ProfileLoading) {
          debugPrint("listener: ${state.runtimeType}");
          context.read<SettingsBloc>().add(SettingsSetLoading());
          return;
        }

        if (state is ProfileLoaded) {
          debugPrint("listener: ${state.runtimeType}");
          context.read<SettingsBloc>().add(SettingsFinishLoading());
          return;
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.model.fullname,
                        key: const Key("textProfileFullName"),
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        state.model.email,
                        key: const Key("textProfileEmail"),
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
              state.model.fullname,
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
              state.model.email,
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
              state.model.formattedDob,
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
              state.model.address,
              key: const Key("textAddress"),
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        );
      }
    );
  }
}