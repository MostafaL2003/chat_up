import 'package:chat_up/features/auth/cubit/auth_cubit.dart';
import 'package:chat_up/features/auth/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback? onProfileSettings;
  final VoidCallback? onSecondAction;
  final VoidCallback? onLogout;

  const MyDrawer({
    super.key,
    this.onProfileSettings,
    this.onSecondAction,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          String username = "User";
          String imageUrl = "";
          if (state is AuthSuccess) {
            username = state.userModel.username;
            imageUrl = state.userModel.imageUrl;
          }

          return Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      child:
                          imageUrl.isEmpty
                              ? Icon(
                                Icons.person,
                                size: 48.0,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                              )
                              : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  "Profile Settings",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: onProfileSettings,
              ),
              ListTile(
                leading: Icon(
                  Icons.group,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  "Manage Friends",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: onSecondAction,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    "Logout",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: onLogout,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
