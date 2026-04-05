import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/command/async_command.dart';
import 'package:flutter/material.dart';

class AsyncIconButton<R> extends StatelessWidget {
  final AsyncActionNotifier<R> notifier;
  final AsyncCommand<R> command;
  final Icon icon;
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? splashRadius;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final MouseCursor? mouseCursor;
  final String? tooltip;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final bool? isSelected;
  final Widget? selectedIcon;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;

  const AsyncIconButton({super.key,
    required this.notifier,
    required this.command,
    required this.icon,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.isSelected,
    this.selectedIcon,
    this.onLongPress,
    this.onHover,
    this.style,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor,
      mouseCursor: mouseCursor,
      tooltip: tooltip,
      enableFeedback: enableFeedback,
      constraints: constraints,
      isSelected: isSelected,
      selectedIcon: selectedIcon,
      onPressed: notifier.isExecuting ? null : () => notifier.execute(command),
      onLongPress: onLongPress,
      onHover: onHover,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }
}
