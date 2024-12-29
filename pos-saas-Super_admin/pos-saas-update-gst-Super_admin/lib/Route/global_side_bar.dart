import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:collection/collection.dart';
import 'package:salespro_saas_admin/Route/sidebar_item_model.dart';
import 'package:salespro_saas_admin/Screen/Widgets/Constant%20Data/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../Screen/Widgets/static_string/static_string.dart'; // Import necessary package

class GlobalSideBar extends StatelessWidget {
  const GlobalSideBar({
    super.key,
    required this.rootScaffoldKey,
    this.iconOnly = false,
  });

  final GlobalKey<ScaffoldState> rootScaffoldKey;
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      clipBehavior: Clip.none,
      width: iconOnly
          ? 80
          : ResponsiveValue<double?>(
        context,
        conditionalValues: [
          Condition.largerThan(
            name: BreakpointName.SM.name,
            value: 290,
          ),
        ],
      ).value,
      shape: const BeveledRectangleBorder(),
      child: SafeArea(
        child: ResponsiveRowColumn(
          layout: ResponsiveRowColumnType.COLUMN,
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildHeader(context, iconOnly: iconOnly),
              ),
            ),

            // Navigation Items
            ResponsiveRowColumnItem(
              columnFit: FlexFit.tight,
              child: SingleChildScrollView(
                child: ResponsiveRowColumn(
                  layout: ResponsiveRowColumnType.COLUMN,
                  columnCrossAxisAlignment: CrossAxisAlignment.start,
                  columnPadding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Top Menus
                    ...topMenus.map((menu) {
                      final _selectedInfo = _isSelected(context, menu);
                      return ResponsiveRowColumnItem(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SidebarMenuItem(
                            iconOnly: iconOnly,
                            menuTile: menu,
                            groupName: menu.name,
                            isSelected: _selectedInfo.isSelectedMenu,
                            selectedSubmenu: _selectedInfo.selectedSubmenu,
                            onTap: () => _handleNavigation(context, menu),
                            onSubmenuTap: (value) => _handleNavigation(
                              context,
                              menu,
                              submenu: value,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {bool iconOnly = false}) {
    final _theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      height: ResponsiveValue<double?>(
        context,
        conditionalValues: [
          Condition.largerThan(
            name: BreakpointName.SM.name,
            value: 70,
          ),
        ],
      ).value,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: kNutral300,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment:
        iconOnly ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          // Logo
          // Container(
          //   constraints: BoxConstraints.tight(const Size.square(32)),
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: kNutral300,
          //   ),
          // ),
          Image.asset(appsLogo,height: 38,width: 33,),
          if (!iconOnly)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Pos Saas',
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  _SelectionInfo _isSelected(BuildContext context, SidebarItemModel menu) {
    final isSubmenu = menu.sidebarItemType == SidebarItemType.submenu;
    final currentRoute = GoRouter.of(context)
        .routeInformationProvider
        .value
        .uri
        .toString()
        .toLowerCase()
        .trim();

    final isSelectedMenu =
        currentRoute == menu.navigationPath?.toLowerCase().trim();

    if (isSubmenu) {
      final routeSegments = currentRoute
          .split('/')
          .where((segment) => segment.isNotEmpty)
          .toList();

      if (routeSegments.length > 1) {
        final selectedSubMenu = menu.submenus?.firstWhereOrNull(
              (submenu) =>
          submenu.navigationPath?.split('/').last == routeSegments.last,
        );
        if (selectedSubMenu != null) {
          return _SelectionInfo(true, selectedSubMenu);
        }
      }
    }

    return _SelectionInfo(isSelectedMenu, null);
  }

  void _handleNavigation(
      BuildContext ctx,
      SidebarItemModel menu, {
        SidebarSubmenuModel? submenu,
      }) {
    rootScaffoldKey.currentState?.closeDrawer();
    String? _route;

    if (menu.sidebarItemType == SidebarItemType.tile) {
      _route = menu.navigationPath;
    } else if (menu.sidebarItemType == SidebarItemType.submenu) {
      final _mainRoute = menu.navigationPath;
      final _submenuRoute = submenu?.navigationPath;
      if (_mainRoute != null && _submenuRoute != null) {
        _route = _mainRoute + _submenuRoute;
      }
    }

    if (_route == null || _route.isEmpty) {
      ScaffoldMessenger.of(rootScaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Unknown Route')),
      );
      return;
    }

    ctx.go(_route);
  }
}

class _SelectionInfo {
  final bool isSelectedMenu;
  final SidebarSubmenuModel? selectedSubmenu;

  _SelectionInfo(this.isSelectedMenu, this.selectedSubmenu);
}

class SidebarMenuItem extends StatelessWidget {
  const SidebarMenuItem({
    super.key,
    this.iconOnly = false,
    required this.menuTile,
    this.isSelected = false,
    this.selectedSubmenu,
    this.onSubmenuTap,
    this.onTap,
    this.groupName,
  });

  final bool iconOnly;
  final SidebarItemModel menuTile;
  final bool isSelected;
  final SidebarSubmenuModel? selectedSubmenu;
  final void Function(SidebarSubmenuModel? value)? onSubmenuTap;
  final void Function()? onTap;
  final String? groupName;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    if (menuTile.sidebarItemType == SidebarItemType.submenu) {
      if (iconOnly) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: PopupMenuButton<SidebarSubmenuModel?>(
            offset: const Offset(80 - 16, 0),
            shape: const BeveledRectangleBorder(),
            clipBehavior: Clip.antiAlias,
            tooltip: menuTile.name,
            color: _theme.colorScheme.primaryContainer,
            itemBuilder: (context) => [
              // Group Name
              if (groupName != null)
                _CustomIconOnlySubmenu(
                  enabled: false,
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          groupName!,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(MdiIcons.chevronDown),
                      ],
                    ),
                  ),
                ),

              // Submenus
              ...?menuTile.submenus?.map(
                    (submenu) {
                  return _CustomIconOnlySubmenu<SidebarSubmenuModel>(
                    value: submenu,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildSubmenu(
                        context,
                        submenu,
                        onChanged: (value) {
                          Navigator.pop(context, value);
                          onSubmenuTap?.call(value);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
            child: _buildMenu(context, onTap: null),
          ),
        );
      }
      return ExpansionWidget(
        titleBuilder: (aV, eIV, iE, tF) => _buildMenu(
          context,
          onTap: () => tF(animated: true),
          isExpanded: iE,
        ),
        initiallyExpanded: isSelected,
        content: Padding(
          padding: const EdgeInsets.only(top: 8, left: 36),
          child: Column(
            children: [
              ...?menuTile.submenus?.map(
                    (submenu) => _buildSubmenu(
                  context,
                  submenu,
                  onChanged: onSubmenuTap,
                ),
              )
            ],
          ),
        ),
      );
    }

    if (iconOnly) {
      return Tooltip(
        message: menuTile.name,
        child: _buildMenu(context, onTap: onTap),
      );
    }
    return _buildMenu(context, onTap: onTap);
  }

  Widget _buildMenu(
      BuildContext context, {
        required void Function()? onTap,
        bool isExpanded = false,
      }) {
    final _theme = Theme.of(context);

    const _selectedPrimaryColor = Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: BoxConstraints.tight(const Size.fromHeight(48)),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: isSelected ? kMainColor600 : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: EdgeInsets.only(left: iconOnly ? 8 : 16, right: 8),
        child: Row(
          mainAxisAlignment:
          iconOnly ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            // Icon
            // SvgPicture.asset(
            //   menuTile.iconPath,
            //   colorFilter: ColorFilter.mode(
            //     isSelected
            //         ? _selectedPrimaryColor
            //         : _theme.textTheme.bodyLarge!.color!,
            //     BlendMode.srcIn,
            //   ),
            // ),
            Icon(
              menuTile.icon,
              color:
                isSelected
                    ? _selectedPrimaryColor
                    : Colors.white,
            ),

            if (!iconOnly)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu title
                      Text(
                        menuTile.name,
                        style: _theme.textTheme.bodyLarge?.copyWith(
                          color: isSelected ? _selectedPrimaryColor : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Trailing Icon
                      Icon(
                        isExpanded ? MdiIcons.chevronDown : Icons.chevron_right,
                        color: isSelected ? _selectedPrimaryColor : null,
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmenu(
      BuildContext context,
      SidebarSubmenuModel submenu, {
        void Function(SidebarSubmenuModel? value)? onChanged,
      }) {
    final _theme = Theme.of(context);
    final _isSelectedSubmenu = selectedSubmenu == submenu;

    final _selectedPrimaryColor = _theme.primaryColor;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () => onChanged?.call(submenu),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor:
        _isSelectedSubmenu ? _selectedPrimaryColor.withOpacity(0.20) : null,
        title: Text(submenu.name),
        leading: Radio<SidebarSubmenuModel?>(
          value: submenu,
          groupValue: selectedSubmenu,
          onChanged: onChanged,
        ),
        titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
          color: _isSelectedSubmenu ? _selectedPrimaryColor : null,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.only(left: iconOnly ? 8 : 16, right: 8),
        trailing: const Icon(Icons.chevron_right),
        iconColor: _isSelectedSubmenu ? _selectedPrimaryColor : null,
      ),
    );
  }
}

class _CustomIconOnlySubmenu<T> extends StatefulWidget
    implements PopupMenuEntry<T> {
  const _CustomIconOnlySubmenu({
    super.key,
    this.enabled = true,
    this.value,
    required this.child,
  });
  final bool enabled;
  final T? value;
  final Widget child;

  @override
  State<_CustomIconOnlySubmenu> createState() => _CustomIconOnlySubmenuState();

  @override
  double get height => 0;

  @override
  bool represents(value) => value == this.value;
}

class _CustomIconOnlySubmenuState<T> extends State<_CustomIconOnlySubmenu> {
  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: widget.enabled ? handleTap : null,
      child: widget.child,
    );
  }
}

// class GlobalSideBar extends StatelessWidget {
//   const GlobalSideBar({
//     super.key,
//     required this.rootScaffoldKey,
//     this.iconOnly = false,
//   });
//
//   final GlobalKey<ScaffoldState> rootScaffoldKey;
//   final bool iconOnly;
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       clipBehavior: Clip.none,
//       width: iconOnly
//           ? 80
//           : rf.ResponsiveValue<double?>(
//         context,
//         conditionalValues: [
//           rf.Condition.largerThan(
//             name: BreakpointName.SM.name,
//             value: 300,
//           ),
//         ],
//       ).value,
//       shape: const BeveledRectangleBorder(),
//       child: SafeArea(
//         child: rf.ResponsiveRowColumn(
//           layout: rf.ResponsiveRowColumnType.COLUMN,
//           columnCrossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Drawer Header
//             rf.ResponsiveRowColumnItem(
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: _buildHeader(context, iconOnly: iconOnly),
//               ),
//             ),
//
//             // Navigation Items
//             rf.ResponsiveRowColumnItem(
//               columnFit: FlexFit.tight,
//               child: SingleChildScrollView(
//                 child: rf.ResponsiveRowColumn(
//                   layout: rf.ResponsiveRowColumnType.COLUMN,
//                   columnCrossAxisAlignment: CrossAxisAlignment.start,
//                   columnPadding: const EdgeInsets.symmetric(horizontal: 16),
//                   children: [
//                     // Top Menus
//                     ...topMenus.map(
//                           (menu) {
//                         final _selectedInfo = _isSelected(context, menu);
//                         return rf.ResponsiveRowColumnItem(
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: SidebarMenuItem(
//                               iconOnly: iconOnly,
//                               menuTile: menu,
//                               groupName: menu.name,
//                               isSelected: _selectedInfo.$1,
//                               selectedSubmenu: _selectedInfo.$2,
//                               onTap: () => _handleNavigation(context, menu),
//                               onSubmenuTap: (value) => _handleNavigation(
//                                 context,
//                                 menu,
//                                 submenu: value,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(
//       BuildContext context, {
//         bool iconOnly = false,
//       }) {
//     final _theme = Theme.of(context);
//     return Container(
//       padding: const EdgeInsets.all(16),
//       height: rf.ResponsiveValue<double?>(
//         context,
//         conditionalValues: [
//           rf.Condition.largerThan(
//             name: BreakpointName.SM.name,
//             value: 70,
//           )
//         ],
//       ).value,
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             width: 1,
//             color: kNutral300,
//           ),
//         ),
//       ),
//       alignment: Alignment.center,
//       child: Row(
//         mainAxisAlignment:
//         iconOnly ? MainAxisAlignment.center : MainAxisAlignment.start,
//         children: [
//           // Logo
//           Container(
//             constraints: BoxConstraints.tight(const Size.square(32)),
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: kNutral300,
//             ),
//           ),
//
//           if (!iconOnly)
//             Flexible(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Text(
//                   'Logo',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: _theme.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
//
//   (bool isSelectedMenu, SidebarSubmenuModel? selectedSubMenu) _isSelected(
//       BuildContext context,
//       SidebarItemModel menu,
//       ) {
//     final isSubmenu = menu.sidebarItemType == SidebarItemType.submenu;
//     final currentRoute = GoRouter.of(context)
//         .routeInformationProvider
//         .value
//         .uri
//         .toString()
//         .toLowerCase()
//         .trim();
//
//     final isSelectedMenu =
//         currentRoute == menu.navigationPath?.toLowerCase().trim();
//
//     if (isSubmenu) {
//       final routeSegments = currentRoute
//           .split('/')
//           .where((segment) => segment.isNotEmpty)
//           .toList();
//
//       if (routeSegments.length > 1) {
//         final selectedSubMenu = menu.submenus?.firstWhereOrNull(
//               (submenu) =>
//           submenu.navigationPath?.split('/').last == routeSegments.last,
//         );
//         if (selectedSubMenu != null) {
//           return (true, selectedSubMenu);
//         }
//       }
//     }
//
//     return (isSelectedMenu, null);
//   }
//
//   void _handleNavigation(
//       BuildContext ctx,
//       SidebarItemModel menu, {
//         SidebarSubmenuModel? submenu,
//       }) {
//     rootScaffoldKey.currentState?.closeDrawer();
//     String? _route;
//
//     if (menu.sidebarItemType == SidebarItemType.tile) {
//       _route = menu.navigationPath;
//     } else if (menu.sidebarItemType == SidebarItemType.submenu) {
//       final _mainRoute = menu.navigationPath;
//       final _submenuRoute = submenu?.navigationPath;
//       if (_mainRoute != null && _submenuRoute != null) {
//         _route = _mainRoute + _submenuRoute;
//       }
//     }
//
//     if (_route == null || _route.isEmpty) {
//       ScaffoldMessenger.of(rootScaffoldKey.currentContext!).showSnackBar(
//         const SnackBar(content: Text('Unknown Route')),
//       );
//       return;
//     }
//
//     ctx.go(_route);
//   }
// }
