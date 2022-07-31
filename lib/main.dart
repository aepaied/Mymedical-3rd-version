import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:my_medical_app/controllers/deep_link_controller.dart';
import 'package:my_medical_app/defaultTheme/screen/ShSplashScreen.dart';
import 'package:my_medical_app/main/store/AppStore.dart';
import 'package:my_medical_app/main/utils/AppTheme.dart';
import 'package:my_medical_app/no_internet.dart';
import 'package:my_medical_app/notificaion_click_controller.dart';
import 'package:my_medical_app/services/notification_service.dart';
import 'package:my_medical_app/utils/CartCounter.dart';
import 'package:my_medical_app/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

//starting app
AppStore appStore = AppStore();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.getToken().then((token) {
    Helpers.setFcmToken(token);
  });
  await NotificationService().init(); // <----
  await Firebase.initializeApp();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '12345',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      playSound: true,
      enableVibration: true,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    _showNotification(1, message.notification.title, message.notification.body,
        message.data.toString());

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences.setMockInitialValues({});
  await translator.init(
    localeType:
        LocalizationDefaultType.device, //Starts with the device langauge
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/lang/',
  );
  await GetStorage.init();
  runApp(LocalizedApp(child: MyApp()));
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }

  // Or do other work.
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum UniLinksType { string, uri }

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  configureNotifications() async {
//    final FirebaseMessaging  = FirebaseMessaging();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {}
    });

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<dynamic> onSelectNotification(_) async {
    NotificationClickController notificationClickController =
        Get.isRegistered<NotificationClickController>()
            ? Get.find()
            : Get.put(NotificationClickController(_));
    notificationClickController.handleNotification();
  }

  String _latestLink = 'Unknown';
  Uri _latestUri;
  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;
  StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print(result);
      if (result == ConnectivityResult.none) {
        Get.off(() => NoInternet());
      } else {
        Get.off(() => ShSplashScreen());
      }
    });

    initPlatformState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    configureNotifications();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      print(link);
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });
    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      initialLink = initialUri?.toString();
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = initialUri;
      _latestLink = initialLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    DeepLinkController _deepLinkController = Get.put(DeepLinkController());
    _deepLinkController.currentDeepURL.value = _latestLink;
    return Observer(
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CartCounter(),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: ShSplashScreen(),
          theme: !appStore.isDarkModeOn
              ? AppThemeData.lightTheme
              : AppThemeData.darkTheme,
          localizationsDelegates: translator.delegates,
          // Android + iOS Delegates
          locale: translator.locale,
          // Active locale
          supportedLocales: translator.locals(), // Locals list
        ),
      ),
    );
  }
}
