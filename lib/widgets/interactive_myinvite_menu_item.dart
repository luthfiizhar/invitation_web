import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:navigation_example/widgets/interactive_myinvite_menu.dart';
import 'package:navigation_example/widgets/interactive_text.dart';
import 'package:universal_html/html.dart' as html;

class InteractiveMyInviteMenuItem extends MouseRegion {
  static final appContainer =
      html.window.document.querySelectorAll('flt-glass-pane')[0];

  // bool selected;

  InteractiveMyInviteMenuItem(
      {Widget? child, String? text, bool? selected, String? routeName})
      : super(
          onHover: (PointerHoverEvent evt) {
            appContainer.style.cursor = 'pointer';
          },
          onExit: (PointerExitEvent evt) {
            appContainer.style.cursor = 'default';
          },
          child: InteractiveMyInviteMenu(text: text!, selected: selected!),
        );
}
