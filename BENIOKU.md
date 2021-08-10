# flute

## Flutter kod kankan. Hepsi bir arada; state yönetimi, navigasyon yönetimi(dinamik yönlendirme), yerel depolama, dependency aşılama, yerelleştirme, en iyi kullanımlar ile hazırlanmış en iyi eklentilere de sahip bir kütüphane!

[![pub puanı](https://badges.bar/flute/pub%20points)](https://pub.dev/packages/flute/score)
[![beğeniler](https://badges.bar/flute/likes)](https://pub.dev/packages/flute/score)
[![popülerlik](https://badges.bar/flute/popularity)](https://pub.dev/packages/flute/score)
[![GitHub Repo yıldızları](https://img.shields.io/github/stars/ragokan/flute?label=github%20stars)](https://github.com/ragokan/flute)
[![pub versiyonu](https://img.shields.io/pub/v/flute)](https://pub.dev/packages/flute)
[![GitHub son commit](https://img.shields.io/github/last-commit/ragokan/flute)](https://github.com/ragokan/flute)

### [Buraya tıklayarak discord kanalımıza katılabilirsiniz, Türkçe kanalımız bulunmakta!](https://discord.gg/2pg7B73U8j)

&nbsp;

## _Alt kısım için not; birçok şeyi bilerek Türkçe'ye çevirmedim çünkü hem anlamı yok hem de mantığını kaybediyor._

&nbsp;

## Özellikler

- [State Management](#state-management)
  - [Create Controller](#create-controller)
  - [Use Controller](#use-controller)
  - [Update Controller](#update-controller)
  - [Flutos](#flutos)
  - [Watch Controller](#watch-controller)
  - [State Methods](#state-methods)
- [Utilities + Navigation](#utilities)
  - [Routing Management 🚀](#routing-management)
  - [Theme Management](#theme-management)
- [Local Storage](#local-storage)
- [Localization](#localization)
- [Extensions](#extensions)
- [Dependency Injection](#dependency-injection)

&nbsp;

# State Management

#### Controlleri Oluştur

Q: Çalışması için ne yapmalıyım?
A: Sadece normal bir sınıf oluştur, bu sınıf *FluteController*i extendlesin, görüntüyü güncellemek için de _update()_ veya _setState((){})_ methodlarını kullanabilirsin.

Q: Peki bu metotlar görüntüyü nasıl güncelliyor?
A: Model, controller ve görüntü arasında 'MVC' yapısını uygulayan bir iletişim var. Siz bu metotları kullandığınız an görüntü(builder) direkt bundan haber alır ve güncellenir. Yani şema tam olarak;

Model -> Controller -> Model  
Görüntü(View) -> Controller -> Görüntü(View)  
Controller hepsinin temel kaynağı.

```dart
class SayaçController extends FluteController {
  int sayı = 0;

  void arttır() => setState(() => sayı++);

  void azalt() {
    sayı--;
    update();
  }
}

SayaçController sayaçController = SayaçController();
```

Asenkron olarak güncellemeler için _setStateAsync_ fonksiyonunu da kullanabilirsiniz.

---

#### Controlleri Kullanma

```dart
// Bu kadar basit!
FluteBuilder(
      controller: sayaçController,
      builder: () => Text('${sayaçController.sayı}'),
    );
```

---

#### Controller ile Görüntüyü Güncelleme

```dart
    main(){
        // Stateyi contexte ihtiyaç duymadan herhangi bir yerden değiştirebilirsin.
        sayaçController.arttır();
    }

    // Widget İçerisinde
    ElevatedButton(
                  onPressed: sayaçController.arttır,
                  child: const Text('Arttır'),
                )
    // Ya da
     ElevatedButton(
                  onPressed: () => sayaçController
                      .setState(() => sayaçController.sayı--),
                  child: const Text('Azalt'),
                )
```

---

#### Flutos

Fluto, state managementi _dependency injection_ ile kullanmanın yoludur. Eğer onun ne olduğunu tam bilmiyorsanız bizim [Dependency Injection Rehberi](#dependency-injection)'mizi okumanızı öneririm..

```dart

Fluto<SayaçController>(
  (controller) => Text('${controller.sayı}')
);
// Çok basit, değil mi?
// _Fluto_ kullanmak için, ilk başta SayaçControlleri inject etmeliyiz.

Flute.inject(SayaçController);
```

```dart
// FlutoBuilder - Flutonun daha fazla özellik ve buildere sahip hali.
  FlutoBuilder<SayaçController>(
    inject: SayaçController(), // İsteğe bağlı, isterseniz yukarıdaki gibi de *inject* edebilirsiniz.
    builder: (controller) => Text('${controller.sayı}'),
    // Burada diğer FluteBuilder özelliklerini kullanabilirsin.
  );
```

---

#### Watch Controller

Watcher ile state değişimlerini widget dışında izleyebilirsiniz.

```dart
    FluteWatcher(
    watch: sayaçController,
    onChange: (SayaçController controller) {
      print(controller.sayı);
    },
  );
  sayaçController.arttır();

  // FluteWatcher bize izlemeyi durdurmamız için bir fonksiyon dönderir.

  final stopWatching = FluteWatcher(/* kod buraya */);
  // *stopWatching* fonksiyonunu çağırdığımızda da izleme sona erer.
  stopWatching();
```

```dart
// Aynı işlemi Fluto ile de yapabilirsiniz.
FlutoWatcher<SayaçController>(
  (controller) => print(controller.sayı))
// Tabii başta *inject* etmeniz gerekiyor.
```

#### State Methods

State metotları Flutter *StatefulWidget*in özellikleri gibi çalışır.

```dart
class SayaçController extends FluteController{
  int sayı = 0;

  /// FluteBuilder yerleştiğinde çalışır.
  @override
  void initState() {
    sayı++;
  }
  /// FluteBuilder yok olduğunda çalışır.
  @override
  void dispose() {
    sayı = 0;
  }
}
```

Ben kişisel olarak stateful widget kullanmak yerine metotları bu şekilde kullanırım.  
Example:

```dart
class EditProductController extends FluteController {
  final priceFocusNode = FocusNode();

  void submitForm(){
    // Flute ile bildiğiniz gibi herhangi bir yerden contexte ihtiyaç duymadan push işlemi yapabilirsiniz.
    Flute.pushNamed('/productUpdatedSuccessfully/31')
  }

  @override
  void dispose() {
    // diğer focusNode [dispose] metotları.
    priceFocusNode.dispose();
  }
}
```

# İşlevler

### Contexte ihtiyaç duymadan navigasyon.

### İlk başta uygulamamıza Flute gücü sağlayalım.

```dart
// Sadece başına *Flute* yazmamız yeterli.

FluteMaterialApp(/*  Buradaki kod [MaterialApp] kodu ile tamamen aynı */);

// Veya
FluteCupertinoApp(/*  Buradaki kod [CupertinoApp] kodu ile tamamen aynı */);

// Veya
Material/CupertinoApp(
    navigatorKey: Flute.navigatorKey,
    navigatorObservers: [FluteObserver()]);
```

## Sonrasında tüm Flute özelliklerine sahip olabilirsiniz.

_Tüm Flute kullanımları navigator kullanımı ile aynıdır, sadece daha az kod yazmanız gerekir :),_

_For example: Flute.pushNamed('/secondPage') = Navigator.of(context).pushNamed('secondPage')_

```dart
Flute.width;
Flute.height;
Flute.aspectRatio;
Flute.devicePixelRatio;
Flute.isLandscape;
Flute.isPortrait;
Flute.theme;

Flute.showSnackBar();
Flute.showToast(); // Widget oluşturmaya ihtiyaç duymadan snackbar gösterir.
Flute.showModal();
Flute.showDialog();

Flute.push();
Flute.pushReplacement();
Flute.pushNamed();
Flute.pushReplacementNamed();
Flute.pop();
Flute.arguments;
Flute.routeName;
```

## Routing Management

### Dinamik url için kullanım

```
/posts/:id
/posts/23
```

Bu ':id' dinamik bir değişken, değil mi?
_Flute_ ile bu değişkenlere rahatça erişebilirsiniz!

```dart
FluteMaterialApp(
      routes: {
        '/': (ctx) => FirstPage(),
        '/second/:id': (ctx) => SecondPage(),
      }
);
```

Şimdi, ne zaman bunu yaparsenız;

```dart
ElevatedButton(
  onPressed: () => Flute.pushNamed(
    /// You can add any kind of arguments
    '/second/33?name=Rago&postId=123&isMaterial=true',
    arguments: 'This is an extra argument'),
    child: const Text('Go to second page'),
  )
```

Sizi 2. sayfaya [id] parametresi de [33] olarak gönderir.

Dahası, bu argümanlara kolaylıkla erişebilirsiniz;

```dart
print(Flute.arguments);
// sonuç
{'id' : '33', 'name' : 'Rago', 'postId' : 123, 'isMaterial' : true, 'arguments': 'This is an extra argument'};
// Evet, ekstra argüment de hemen buraya geliyor.
```

Canlı bir örnek için _example/flutter_dynamic_routing/lib/main.dart_ dosyasını ziyaret edin.

## Theme Management

```dart
// Başlangıç olarak bu bize uygulamanın ana controllerini veriyor.
Flute.app; /* or */ Flute.use<AppController>();

// Sonrasında da tüm kullanımlara erişebiliyorsunuz.

Flute.app.setThemeData();
Flute.app.setThemeMode();
Flute.app.setCupertinoThemeData();

Flute.app.locale;
Flute.app.setLocale();
```

# Local Storage

### _FluteStorage_ ile yerel depolamaya veri kaydedebilirsiniz.

### Kullanımı ve işlemleri SharedPereferences gibi asenkron değil, GetStorage gibi senkrondur.

#### _FluteStorage_ inanılmaz bir şekilde hızlıdır çünkü okuma işlemleri için hafızayı kullanır!

```dart
// Web dışı tüm platformlarda init etmek için 'await' kullanmanız gerekiyor, sonrasında tabii hiç gerekmiyor.

void main() async{
  // Sadece 'init' fonksyiyonu asenkron olarak çalışıyor.
  await FluteStorage.init();


  // Kullanım
  final box = FluteStorage; // Kolay referans için

  box.write('sayı', 0);

  final int sayı = box.read<int>('sayı');
  // Bu kadar basit!

  print('Count is $sayı');
}
```

Diğer Kullanımlar

```dart
  box.watchKey('sayı', () =>
    print('Bu fonksiyon sayı ne zaman değişirse çalışır.');
  );

  box.watchAll(() =>
    print('Bu fonksiyon storage ne zaman değişirse çalışır.');
  );

  box.removeKey('sayı'); // Anahtarı yok eder

  box.readAllKeys(); // Depolamadaki tüm anahtarları verir

  box.readAllValues(); // Depolamadaki tüm değerleri verir

  box.readAll(); // Depolamadaki tüm veriyi verir

  box.clearStorage(); // Depodaki tüm anahtar ve değerleri siler

  box.deleteStorage(); // Depoyu diskten tamamen yok eder.
```

### Watch FluteStorage With FluteBuilder

```dart

// Ne zaman sayı değişirse bu builder tekrardan çalışır
FluteBuilder(
      controller: yourController,
      watchStorageKeys: ['sayı'],
      builder: () => Text('${box.read('sayı')}'),
    );
```

# Localization

#### Flute ile uygulamanızı lokalize edebilirsiniz.

```dart
// Kullanımı da çok basit
// Başta çevirilerinizi bu şekilde belirtiyorsunuz.
const translations = {
  'en': {
    'hello': 'Hello from Flute!',
  },
  'tr': {
    'hello': "Flute'dan selamlar!",
  },
};
```

```dart
// Sonrasında da uygulamaya veriyorsunuz
FluteMaterialApp /* or FluteCupertinoApp */(
  translations: translations,
  /* Hiçbir değişime uğramadan kodunuzun geri kalanı */);
```

```dart
// Kullanımı mı ? O çok daha basit
Text('hello'.loc); // Bu dil Türkçe iken "Flute'dan Selamlar" yazısı verecek.

// Hadi dili değiştirip tekrar deneyelim
Flute.app.setLocale(Locale('en','US'));
// Şu anda da 'Hello from Flute!' diyor, çünkü 'translations' verisinde o şekilde belirttik.
```

# Extensions

```dart
// Context Extensionları
context.width;
context.height;
context.aspectRatio;
context.devicePixelRatio;
context.isLandscape;
context.isPortrait;
context.theme;
context.arguments;
context.routeName;
```

# Dependency Injection

### Dependency injection ile değişkenleri uygulamanın her yerinde kullanabilirsiniz ve _Flute_ ile bunu yapmak çok basit.

```dart
// Örnek değişken;
class Sayaç(){
  sayı = 0;
}

// Enjekte edelim
Flute.inject(Sayaç());


// Herhangi bir yerde kullanalım
Flute.use<Sayaç>();

// Tip desteği ile de kullanabilirsiniz
final sayaç = Flute.use<Sayaç>();

// İstediğiniz şekilde kullanın! Örneğin;
sayaç.sayı++;
// veya
Flute.use<Sayaç>().sayı++;
```

Son olarak, diyelim ki değişken ile işiniz bitti, neden hafızada yer kaplasın ki?

```dart
// Sayaç sonsuza dek gitmiş olacak!
Flute.eject<Sayaç>();
```

#### Daha fazla bilgi için testleri ve örnekleri kontrol edebilirsiniz!
