import 'package:flutter/material.dart';

@immutable
class Change<State> {
  const Change({required this.currentState, required this.nextState});

  /// The current [State] at the time of the [Change].
  final State currentState;

  /// The next [State] at the time of the [Change].
  final State nextState;

  /// Better string output.
  @override
  String toString() =>
      'Change(currentState: $currentState, nextState: $nextState)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Change<State> &&
        other.currentState == currentState &&
        other.nextState == nextState;
  }

  @override
  int get hashCode => currentState.hashCode ^ nextState.hashCode;
}
