import 'package:flutter/material.dart';
import 'package:flute/flute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const FluteMaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Color primaryColor = Flute.theme.primaryColor == Colors.blue
                    ? Colors.red
                    : Colors.blue;
                Flute.app.setThemeData(
                  ThemeData(
                    primaryColor: primaryColor,
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Change App Color'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Flute.app.setThemeData(
                Flute.isDarkMode
                    ? ThemeData(
                        brightness: Brightness.light,
                        primaryColor: Flute.theme.primaryColor,
                        elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Flute.theme.primaryColor),
                          ),
                        ))
                    : ThemeData(
                        brightness: Brightness.dark,
                        primaryColor: Flute.theme.primaryColor,
                        elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Flute.theme.primaryColor),
                          ),
                        )),
              ),
              child: const Text('Change App Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
