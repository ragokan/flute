export './flute_provider.dart';

import 'package:flute/flute.dart';

final counterNotifier = FluteNotifierProvider((_) => FluteNotifier<int>(0));
