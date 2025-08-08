# flute

Minimal, fast, dependency-light state utilities and helpers for Flutter apps.

## Install

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flute: ^2.0.1
```

Then run:

```sh
flutter pub get
```

## Usage

Import the library:

```dart
import 'package:flute/flute.dart';
```

### Storage

Initialize once (e.g., in `main`):

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FluteStorage.init();
  runApp(const MyApp());
}
```

Write and read values:

```dart
await FluteStorage.put('token', 'Bearer abc');
final token = FluteStorage.get<String>('token');
```

Listen to changes:

```dart
final cancel = FluteStorage.listen<String>('token', (value) {
  debugPrint('Token changed: $value');
});
// cancel();
```

### API requests

```dart
final api = FluteApiService(endPoint: 'https://api.example.com');
final response = await api.get<Map<String, dynamic>>('/users',
  queryParameters: {'page': 1},
);
```

### Navigator helpers

```dart
context.pushEasy(const DetailsPage());
context.pop();
```

### Utilities

```dart
final stop = Flute.setInterval(const Duration(seconds: 5), () {
  debugPrint('tick');
});
Flute.setTimeout(const Duration(seconds: 20), stop);

Flute.addPostFrameCallback(() {
  debugPrint('ran after first frame');
});
```

## Testing

Run all tests:

```sh
flutter test
```

## Development

- Run `flutter analyze` and `flutter test` before pushing.
- CI uses GitHub Actions to run analyze and tests on stable channel.

## License

MIT