import 'package:comizy/services/change_notifiers/async_action_notifier.dart';
import 'package:comizy/services/command/async_command.dart';
import 'package:flutter/material.dart';

class AsyncElevatedButton<R> extends StatelessWidget {
  final AsyncActionNotifier<R> notifier;
  final AsyncCommand<R>? command;
  final Widget child;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;

  const AsyncElevatedButton({
    super.key,
    required this.notifier,
    required this.command,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          notifier.isExecuting || command == null ? null : () => notifier.execute(command!),
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      statesController: statesController,
      child: notifier.isExecuting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : child,
    );
  }
}
