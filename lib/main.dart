import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robot/views/SplachScreen/splashScreen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'vendor/i18n/initialize_i18n.dart' show initializeI18n;
import 'vendor/i18n/constant.dart' show languages;
import 'vendor/i18n/localizations.dart' show MyLocalizationsDelegate;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}


String selectedNotificationPayload;

var language = '';
var loadingText = "";
var url = '';
var bodyProgress;
var errorTitle = "";
var errorContent = "";

bool runOnce = false;
String languageType = "";

void main() async{
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown]
  );
  
  final prefs = await SharedPreferences.getInstance();
  final key = 'language';
  language = prefs.getString(key) ?? "";

  if (language == "") {
    language = 'en';
    loadingText = "Loading...";
    errorTitle = "Server busy";
    errorContent = "Server busy, Please try again later";
    prefs.setString(key, language);
  } else {
    if (language == "en") {
      loadingText = "Loading...";
      errorTitle = "Server busy";
      errorContent = "Server busy, Please try again later";
      prefs.setString(key, language);
    } else if (language == "zh") {
      loadingText = "加载中...";
      errorTitle = "服务器繁忙";
      errorContent = "服务器繁忙中, 请稍后再试";
      prefs.setString(key, language);
    }  else if (language == "id") {
      loadingText = "Memuat...";
      errorTitle = "Server sibuk";
      errorContent = "Server sibuk, Silakan coba lagi nanti";
      prefs.setString(key, language);
    } else if (language == "ms") {
      loadingText = "Đang tải...";
      errorTitle = "Máy chủ bận";
      errorContent = "Máy chủ bận rộn xin vui lòng thử lại sau";
      prefs.setString(key, language);
    } else if (language == "th") {
      loadingText = "กำลังโหลด...";
      errorTitle = "เซิร์ฟเวอร์ไม่ว่าง";
      errorContent = "เซิร์ฟเวอร์ไม่ว่างโปรดลองอีกครั้งในภายหลัง";
      prefs.setString(key, language);
    }
  }

  Map<String, Map<String, String>> localizedValues = await initializeI18n();
  runApp(MyApp(url,localizedValues, notificationAppLaunchDetails));
}

class ChineseCupertinoLocalizations implements CupertinoLocalizations {
  final materialDelegate = GlobalMaterialLocalizations.delegate;
  final widgetsDelegate = GlobalWidgetsLocalizations.delegate;
  final local = const Locale('zh');

  MaterialLocalizations ml;

  Future init() async {
    ml = await materialDelegate.load(local);
  }

  @override
  String get alertDialogLabel => ml.alertDialogLabel;

  @override
  String get anteMeridiemAbbreviation => ml.anteMeridiemAbbreviation;

  @override
  String get copyButtonLabel => ml.copyButtonLabel;

  @override
  String get cutButtonLabel => ml.cutButtonLabel;

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.mdy;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String datePickerDayOfMonth(int dayIndex) {
    return dayIndex.toString();
  }

  @override
  String datePickerHour(int hour) {
    return hour.toString().padLeft(2, "0");
  }

  @override
  String datePickerHourSemanticsLabel(int hour) {
    return "$hour" + "时";
  }

  @override
  String datePickerMediumDate(DateTime date) {
    return ml.formatMediumDate(date);
  }

  @override
  String datePickerMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    return "$minute" + "分";
  }

  @override
  String datePickerMonth(int monthIndex) {
    return "$monthIndex";
  }

  @override
  String datePickerYear(int yearIndex) {
    return yearIndex.toString();
  }

  @override
  String get pasteButtonLabel => ml.pasteButtonLabel;

  @override
  String get postMeridiemAbbreviation => ml.postMeridiemAbbreviation;

  @override
  String get selectAllButtonLabel => ml.selectAllButtonLabel;

  @override
  String timerPickerHour(int hour) {
    return hour.toString().padLeft(2, "0");
  }

  @override
  String timerPickerHourLabel(int hour) {
    return "$hour".toString().padLeft(2, "0") + "时";
  }

  @override
  String timerPickerMinute(int minute) {
    return minute.toString().padLeft(2, "0");
  }

  @override
  String timerPickerMinuteLabel(int minute) {
    return minute.toString().padLeft(2, "0") + "分";
  }

  @override
  String timerPickerSecond(int second) {
    return second.toString().padLeft(2, "0");
  }

  @override
  String timerPickerSecondLabel(int second) {
    return second.toString().padLeft(2, "0") + "秒";
  }

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _ChineseDelegate();

  static Future<CupertinoLocalizations> load(Locale locale) async {
    var localizaltions = ChineseCupertinoLocalizations();
    await localizaltions.init();
    return SynchronousFuture<CupertinoLocalizations>(localizaltions);
  }

  @override
  String get todayLabel => null;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ChineseDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const _ChineseDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'zh';
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return ChineseCupertinoLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) {
    return false;
  }
}

class TraditionalChineseCupertinoLocalizations
    implements CupertinoLocalizations {
  final materialDelegate = GlobalMaterialLocalizations.delegate;
  final widgetsDelegate = GlobalWidgetsLocalizations.delegate;
  final local = const Locale('ms');

  MaterialLocalizations ml;

  Future init() async {
    ml = await materialDelegate.load(local);
  }

  @override
  String get alertDialogLabel => ml.alertDialogLabel;

  @override
  String get anteMeridiemAbbreviation => ml.anteMeridiemAbbreviation;

  @override
  String get copyButtonLabel => ml.copyButtonLabel;

  @override
  String get cutButtonLabel => ml.cutButtonLabel;

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.mdy;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String datePickerDayOfMonth(int dayIndex) {
    return dayIndex.toString();
  }

  @override
  String datePickerHour(int hour) {
    return hour.toString().padLeft(2, "0");
  }

  @override
  String datePickerHourSemanticsLabel(int hour) {
    return "$hour" + "時";
  }

  @override
  String datePickerMediumDate(DateTime date) {
    return ml.formatMediumDate(date);
  }

  @override
  String datePickerMinute(int minute) {
    return minute.toString().padLeft(2, '0');
  }

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    return "$minute" + "分";
  }

  @override
  String datePickerMonth(int monthIndex) {
    return "$monthIndex";
  }

  @override
  String datePickerYear(int yearIndex) {
    return yearIndex.toString();
  }

  @override
  String get pasteButtonLabel => ml.pasteButtonLabel;

  @override
  String get postMeridiemAbbreviation => ml.postMeridiemAbbreviation;

  @override
  String get selectAllButtonLabel => ml.selectAllButtonLabel;

  @override
  String timerPickerHour(int hour) {
    return hour.toString().padLeft(2, "0");
  }

  @override
  String timerPickerHourLabel(int hour) {
    return "$hour".toString().padLeft(2, "0") + "時";
  }

  @override
  String timerPickerMinute(int minute) {
    return minute.toString().padLeft(2, "0");
  }

  @override
  String timerPickerMinuteLabel(int minute) {
    return minute.toString().padLeft(2, "0") + "分";
  }

  @override
  String timerPickerSecond(int second) {
    return second.toString().padLeft(2, "0");
  }

  @override
  String timerPickerSecondLabel(int second) {
    return second.toString().padLeft(2, "0") + "秒";
  }

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _TraditionalChineseDelegate();

  static Future<CupertinoLocalizations> load(Locale locale) async {
    var localizaltions = TraditionalChineseCupertinoLocalizations();
    await localizaltions.init();
    return SynchronousFuture<CupertinoLocalizations>(localizaltions);
  }

  @override
  String get todayLabel => null;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TraditionalChineseDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _TraditionalChineseDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'ms';
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return ChineseCupertinoLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) {
    return false;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatefulWidget {
  final url;
  final Map<String, Map<String, String>> localizedValues;
  final NotificationAppLaunchDetails notificationAppLaunchDetails;

  MyApp(
    this.url,this.localizedValues, 
    this.notificationAppLaunchDetails, {
    Key key,
  }) : super(key: key);

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _saveLanguage(var language) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("language", language);

    if (language == 'zh') {
      setState(() {
        languageType = "成功更改语言";
        loadingText = "加载中...";
        errorTitle = "服务器繁忙";
        errorContent = "服务器繁忙中,请稍后再试";
      });
    } else if (language == 'en') {
      setState(() {
        languageType = "Change Language Successful";
        loadingText = "Loading...";
        errorTitle = "Server busy";
        errorContent = "Server busy, Please try again later";
      });
    } else if (language == 'id') {
      setState(() {
        languageType = "Ubah Bahasa Berhasil";
        loadingText = "Memuat...";
        errorTitle = "Server sibuk";
        errorContent = "Server sibuk, Silakan coba lagi nanti";
      });
    } else if (language == 'ms') {
      setState(() {
        languageType = "Thay đổi ngôn ngữ thành công";
        loadingText = "Đang tải...";
        errorTitle = "Máy chủ bận";
        errorContent = "Máy chủ bận rộn xin vui lòng thử lại sau";
      });
    } else if (language == 'th') {
      setState(() {
        languageType = "เปลี่ยนภาษาสำเร็จ";
        loadingText = "กำลังโหลด...";
        errorTitle = "เซิร์ฟเวอร์ไม่ว่าง";
        errorContent = "เซิร์ฟเวอร์ไม่ว่างโปรดลองอีกครั้งในภายหลัง";
      });
    }

    Fluttertoast.showToast(
        msg: languageType,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFDCDCDC),
        textColor: Colors.black,
        timeInSecForIos: 2);
  }

  onChangeLanguage(var setLanguage) {
    setState(() {
      language = setLanguage;
    });
    _saveLanguage(setLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(language),
      /*localizationsDelegates: [
        MyLocalizationsDelegate(widget.localizedValues),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],*/
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        MyLocalizationsDelegate(widget.localizedValues),
        ChineseCupertinoLocalizations.delegate,
        TraditionalChineseCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: languages.map((language) => Locale(language, '')), 

      builder: (context, child) {
        return MediaQuery(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      theme: ThemeData(
        canvasColor: Colors.white,
        backgroundColor: Colors.white,
        indicatorColor: Color.fromRGBO(247, 182, 50, 1),
        buttonColor: Color.fromRGBO(12, 59, 113, 1),
        // accentColor: Color.fromRGBO(247, 182, 50, 1),
        primaryColor: Colors.grey[100],
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline3: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black),
          headline4: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline5: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
          bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
          caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        
        textSelectionColor: Color(0xff5A718B),
      ),
      home: Scaffold(
        body: SplashScreen(widget.url,this.onChangeLanguage, widget.notificationAppLaunchDetails)
        // body: TopViewing()
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;  
  }
}
