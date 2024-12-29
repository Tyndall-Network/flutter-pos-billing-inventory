import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import '../Screen/Authentication/acnoo_login_screen.dart';
import '../Screen/Widgets/Constant Data/constant.dart';
import '../Screen/Widgets/Topbar/topbar.dart';
import '../Screen/Widgets/static_string/static_string.dart';

class TopBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const TopBarWidget({super.key, this.onMenuTap});

  final void Function()? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: rf.ResponsiveValue<Widget?>(
        context,
        conditionalValues: [
          rf.Condition.largerThan(
            name: BreakpointName.MD.name,
            value: null,
          ),
        ],
        defaultValue: IconButton(
          onPressed: onMenuTap,
          icon: const Tooltip(
            message: 'Open Navigation menu',
            waitDuration: Duration(milliseconds: 350),
            child: Icon(Icons.menu),
          ),
        ),
      ).value,
      toolbarHeight: rf.ResponsiveValue<double?>(
        context,
        conditionalValues: [
          rf.Condition.largerThan(name: BreakpointName.SM.name, value: 70)
        ],
      ).value,
      surfaceTintColor: Colors.transparent,
      actions: [
        PopupMenuButton(
          icon: const Icon(
            FeatherIcons.settings,
            size: 24.0,
            color: kBlueTextColor,
          ),
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext bc) => [
            PopupMenuItem(
              child: GestureDetector(
                onTap: (() {
                  changePassword(mainContext: context, manuContext: bc);
                }),
                child: const Text(
                  'Change Password',
                ),
              ),
            ),
          ],
          onSelected: (value) {
            Navigator.pushNamed(context, '$value');
          },
        ),
        const SizedBox(width: 8.0),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: kMainColor600.withOpacity(0.1),
          ),
          child: const Icon(FeatherIcons.logOut, color: kBlueTextColor),
        ).onTap(() async {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          // const AcnooLoginScreen().launch(context, isNewTask: true);
          ///---------------push replacement--------------------
          if (context.mounted) {
            context.go('/', extra: {'replace': true});
            // Navigator.pop(context);
          }
        }),
        const SizedBox(width: 20,)
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 64);
}
