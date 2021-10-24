/// flute is the simplest state management solution ever, at least I think so.
///
/// It depends on nothing, works really fast with minimum code usage.
///
/// With flute, you don't need to wrap your material app for state,
/// you don't need any complex libraries and most importantly your don't
///  need context to have a state or update state.
library flute;

// Directly exporting provider instead of installing provider, too.
export 'package:provider/provider.dart';

export 'src/flute_constants.dart';
export 'src/flute_extensions/index.dart';
export 'src/flute_instance.dart';
export 'src/flute_provider/index.dart';
export 'src/flute_providers/index.dart';
export 'src/flute_storage/flute_storage.dart';
export 'src/flute_utilities/index.dart';
export 'src/flute_widgets/index.dart';
export 'src/flute_forms/index.dart';
export 'src/other/index.dart';


/// Formlara bir şeyler yapalım.
/// Validatörler yapalım
/// Validate için for loop atalım.