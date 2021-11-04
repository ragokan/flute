import '../flute.dart';
import 'flute_utilities/index.dart';

/// The implementation of [Flute].
///
/// We use it as a private class because it is not optimal to have multiple
/// Flute classes.
class _Flute with FluteFunctions {}

/// The root of [Flute] library's utilities.
///
/// This class has shortcuts for routing, small utilities of context like
/// size of the device and has usage with widgets like show bottom modal sheet.
// ignore: non_constant_identifier_names
final _Flute Flute = _Flute();
