import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/icons/custom_icons.dart';
import 'package:crosscheck/core/widgets/task_calendar/task_calendar.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  late Widget testWidget;

  group("DateTime Now", () {
    setUp(() {
      testWidget = const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(),
          ),
        ),
      );
    });

    testWidgets("Should display task calendar properly", (WidgetTester tester) async {
      final now = DateTime.now();
      final month = DateFormat("MMM y").format(now);
      
      await tester.pumpWidget(testWidget);
      
      expect(find.byKey(const Key("textMonth")), findsOneWidget);
      Text textMonth = tester.widget<Text>(find.byKey(const Key("textMonth")));
      expect(textMonth.data, month);

      expect(find.byKey(const Key("buttonPrevious")), findsOneWidget);
      expect(find.byKey(const Key("buttonNext")), findsOneWidget);
      expect(find.byKey(const Key("iconChevronLeft")), findsOneWidget);
      expect(find.byKey(const Key("iconChevronRight")), findsOneWidget);

      SvgPicture iconChevronLeft = tester.widget<SvgPicture>(find.byKey(const Key("iconChevronLeft")));
      final assetChevronLeft = iconChevronLeft.pictureProvider as ExactAssetPicture;
      expect(assetChevronLeft.assetName, CustomIcons.chevronLeft);

      SvgPicture iconChevronRight = tester.widget<SvgPicture>(find.byKey(const Key("iconChevronRight")));
      final assetChevronRight = iconChevronRight.pictureProvider as ExactAssetPicture;
      expect(assetChevronRight.assetName, CustomIcons.chevronRight);

      expect(find.text("Sun"), findsOneWidget);
      expect(find.text("Mon"), findsOneWidget);
      expect(find.text("Tue"), findsOneWidget);
      expect(find.text("Wed"), findsOneWidget);
      expect(find.text("Thu"), findsOneWidget);
      expect(find.text("Fri"), findsOneWidget);
      expect(find.text("Sat"), findsOneWidget);
      
      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      expect(textDays.length, 42);

    });
  });

  group("Initial calendar that is displayed on each month", () {
    testWidgets("Should display initial month (January) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 1, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Jan 2022"), findsOneWidget);
      expect(find.text("26"), findsNWidgets(2)); // 2021-12-26 & 2022-01-26
      expect(find.text("27"), findsNWidgets(2)); // 2021-12-27 & 2022-01-27
      expect(find.text("28"), findsNWidgets(2)); // 2021-12-28 & 2022-01-28
      expect(find.text("29"), findsNWidgets(2)); // 2021-12-29 & 2022-01-29
      expect(find.text("30"), findsNWidgets(2)); // 2021-12-30 & 2022-01-30
      expect(find.text("31"), findsNWidgets(2)); // 2021-12-31 & 2022-01-31
      expect(find.text("1"), findsNWidgets(2)); // 2022-01-01 & 2022-02-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-01-02 & 2022-02-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-01-03 & 2022-02-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-01-04 & 2022-02-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-01-05 & 2022-02-05
      
      // Date only availabile in current month
      List<String> currentDays = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (February) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 2, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Feb 2022"), findsOneWidget);
      expect(find.text("1"), findsNWidgets(2)); // 2022-02-01 & 2022-03-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-02-02 & 2022-03-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-02-03 & 2022-03-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-02-04 & 2022-03-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-02-05 & 2022-03-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-02-06 & 2022-03-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-02-07 & 2022-03-07
      expect(find.text("8"), findsNWidgets(2)); // 2022-02-08 & 2022-03-08
      expect(find.text("9"), findsNWidgets(2)); // 2022-02-09 & 2022-03-09
      expect(find.text("10"), findsNWidgets(2)); // 2022-02-10 & 2022-03-10
      expect(find.text("11"), findsNWidgets(2)); // 2022-02-11 & 2022-03-11
      expect(find.text("12"), findsNWidgets(2)); // 2022-02-12 & 2022-03-12
      
      // Date only availabile in current month
      List<String> currentDays = ["13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (March) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 3, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Mar 2022"), findsOneWidget);
      expect(find.text("27"), findsNWidgets(2)); // 2022-02-27 & 2022-03-27
      expect(find.text("28"), findsNWidgets(2)); // 2022-02-28 & 2022-03-28
      expect(find.text("1"), findsNWidgets(2)); // 2022-03-01 & 2022-04-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-03-02 & 2022-04-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-03-03 & 2022-04-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-03-04 & 2022-04-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-03-05 & 2022-04-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-03-06 & 2022-04-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-03-07 & 2022-04-07
      expect(find.text("8"), findsNWidgets(2)); // 2022-03-08 & 2022-04-08
      expect(find.text("9"), findsNWidgets(2)); // 2022-03-09 & 2022-04-09
      
      // Date only availabile in current month
      List<String> currentDays = ["10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "29", "30", "31"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["27", "28", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (April) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 4, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Apr 2022"), findsOneWidget);
      expect(find.text("27"), findsNWidgets(2)); // 2022-03-27 & 2022-04-27
      expect(find.text("28"), findsNWidgets(2)); // 2022-03-28 & 2022-04-28
      expect(find.text("29"), findsNWidgets(2)); // 2022-03-29 & 2022-04-29
      expect(find.text("30"), findsNWidgets(2)); // 2022-03-30 & 2022-04-30
      expect(find.text("31"), findsOneWidget); // 2022-03-31
      expect(find.text("1"), findsNWidgets(2)); // 2022-04-01 & 2022-05-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-04-02 & 2022-05-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-04-03 & 2022-05-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-04-04 & 2022-05-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-04-05 & 2022-05-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-04-06 & 2022-05-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-04-07 & 2022-05-07
      
      // Date only availabile in current month
      List<String> currentDays = ["8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (May) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 5, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("May 2022"), findsOneWidget);
      expect(find.text("1"), findsNWidgets(2)); // 2022-05-01 & 2022-06-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-05-02 & 2022-06-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-05-03 & 2022-06-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-05-04 & 2022-06-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-05-05 & 2022-06-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-05-06 & 2022-06-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-05-07 & 2022-06-07
      expect(find.text("8"), findsNWidgets(2)); // 2022-05-08 & 2022-06-08
      expect(find.text("9"), findsNWidgets(2)); // 2022-05-09 & 2022-06-09
      expect(find.text("10"), findsNWidgets(2)); // 2022-05-10 & 2022-06-10
      expect(find.text("11"), findsNWidgets(2)); // 2022-05-11 & 2022-06-11
      
      // Date only availabile in current month
      List<String> currentDays = ["13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (June) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 6, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Jun 2022"), findsOneWidget);
      expect(find.text("29"), findsNWidgets(2)); // 2022-05-29 & 2022-06-29
      expect(find.text("30"), findsNWidgets(2)); // 2022-05-30 & 2022-06-30
      expect(find.text("31"), findsOneWidget); // 2022-05-31
      expect(find.text("1"), findsNWidgets(2)); // 2022-06-01 & 2022-07-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-06-02 & 2022-07-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-06-03 & 2022-07-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-06-04 & 2022-07-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-06-05 & 2022-07-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-06-06 & 2022-07-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-06-07 & 2022-07-07
      expect(find.text("8"), findsNWidgets(2)); // 2022-06-08 & 2022-07-08
      expect(find.text("9"), findsNWidgets(2)); // 2022-06-09 & 2022-07-09    
      
      // Date only availabile in current month
      List<String> currentDays = ["10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (July) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 7, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Jul 2022"), findsOneWidget);
      expect(find.text("26"), findsNWidgets(2)); // 2022-06-29 & 2022-07-29
      expect(find.text("27"), findsNWidgets(2)); // 2022-06-29 & 2022-07-29
      expect(find.text("28"), findsNWidgets(2)); // 2022-06-29 & 2022-07-29
      expect(find.text("29"), findsNWidgets(2)); // 2022-06-29 & 2022-07-29
      expect(find.text("30"), findsNWidgets(2)); // 2022-06-30 & 2022-07-30
      expect(find.text("1"), findsNWidgets(2)); // 2022-07-01 & 2022-08-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-07-02 & 2022-08-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-07-03 & 2022-08-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-07-04 & 2022-08-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-07-05 & 2022-08-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-07-06 & 2022-08-06
      
      // Date only availabile in current month
      List<String> currentDays = ["7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "31"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (August) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 8, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Aug 2022"), findsOneWidget);
      expect(find.text("31"), findsNWidgets(2)); // 2022-07-31 & 2022-08-31
      expect(find.text("1"), findsNWidgets(2)); // 2022-08-01 & 2022-09-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-08-02 & 2022-09-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-08-03 & 2022-09-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-08-04 & 2022-09-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-08-05 & 2022-09-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-08-06 & 2022-09-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-08-07 & 2022-09-07
      expect(find.text("8"), findsNWidgets(2)); // 2022-08-08 & 2022-09-08
      expect(find.text("9"), findsNWidgets(2)); // 2022-08-09 & 2022-09-09
      expect(find.text("10"), findsNWidgets(2)); // 2022-08-10 & 2022-09-10
      
      // Date only availabile in current month
      List<String> currentDays = ["11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (September) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 9, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Sep 2022"), findsOneWidget);
      expect(find.text("28"), findsNWidgets(2)); // 2022-08-28 & 2022-09-28
      expect(find.text("29"), findsNWidgets(2)); // 2022-08-29 & 2022-09-29
      expect(find.text("30"), findsNWidgets(2)); // 2022-08-30 & 2022-09-30
      expect(find.text("31"), findsOneWidget); // 2022-08-31
      expect(find.text("1"), findsNWidgets(2)); // 2022-09-01 & 2022-10-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-09-02 & 2022-10-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-09-03 & 2022-10-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-09-04 & 2022-10-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-09-05 & 2022-10-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-09-06 & 2022-10-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-09-07 & 2022-10-07
      expect(find.text("8"), findsNWidgets(2)); // 2022-09-08 & 2022-10-08
      
      // Date only availabile in current month
      List<String> currentDays = ["9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (October) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 10, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Oct 2022"), findsOneWidget);
      expect(find.text("25"), findsNWidgets(2)); // 2022-09-28 & 2022-10-28
      expect(find.text("26"), findsNWidgets(2)); // 2022-09-28 & 2022-10-28
      expect(find.text("27"), findsNWidgets(2)); // 2022-09-28 & 2022-10-28
      expect(find.text("28"), findsNWidgets(2)); // 2022-09-28 & 2022-10-28
      expect(find.text("29"), findsNWidgets(2)); // 2022-09-29 & 2022-10-29
      expect(find.text("30"), findsNWidgets(2)); // 2022-09-30 & 2022-10-30
      expect(find.text("1"), findsNWidgets(2)); // 2022-10-01 & 2022-11-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-10-02 & 2022-11-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-10-03 & 2022-11-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-10-04 & 2022-11-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-10-05 & 2022-11-05
      
      // Date only availabile in current month
      List<String> currentDays = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "31"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (November) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 11, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Nov 2022"), findsOneWidget);
      expect(find.text("30"), findsNWidgets(2)); // 2022-10-30 & 2022-11-30
      expect(find.text("31"), findsOneWidget); // 2022-10-31
      expect(find.text("1"), findsNWidgets(2)); // 2022-11-01 & 2022-12-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-11-02 & 2022-12-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-11-03 & 2022-12-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-11-04 & 2022-12-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-11-05 & 2022-12-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-11-06 & 2022-12-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-11-07 & 2022-12-07
      expect(find.text("8"), findsNWidgets(2)); // 2022-11-08 & 2022-12-08
      expect(find.text("9"), findsNWidgets(2)); // 2022-11-09 & 2022-12-09
      expect(find.text("10"), findsNWidgets(2)); // 2022-11-10 & 2022-12-10
      
      // Date only availabile in current month
      List<String> currentDays = ["11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should display initial month (December) properly", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 12, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      expect(find.text("Dec 2022"), findsOneWidget);
      expect(find.text("27"), findsNWidgets(2)); // 2022-11-27 & 2022-12-27
      expect(find.text("28"), findsNWidgets(2)); // 2022-11-28 & 2022-12-28
      expect(find.text("29"), findsNWidgets(2)); // 2022-11-29 & 2022-12-29
      expect(find.text("30"), findsNWidgets(2)); // 2022-11-30 & 2022-12-30
      expect(find.text("1"), findsNWidgets(2)); // 2022-12-01 & 2023-01-01
      expect(find.text("2"), findsNWidgets(2)); // 2022-12-02 & 2023-01-02
      expect(find.text("3"), findsNWidgets(2)); // 2022-12-03 & 2023-01-03
      expect(find.text("4"), findsNWidgets(2)); // 2022-12-04 & 2023-01-04
      expect(find.text("5"), findsNWidgets(2)); // 2022-12-05 & 2023-01-05
      expect(find.text("6"), findsNWidgets(2)); // 2022-12-06 & 2023-01-06
      expect(find.text("7"), findsNWidgets(2)); // 2022-12-07 & 2023-01-07
      
      // Date only availabile in current month
      List<String> currentDays = ["8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26"];
      for (var i = 0; i < currentDays.length; i++) {
        expect(find.text(currentDays[i].toString()), findsOneWidget);
      }

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });
  });

  group("Calendar navigation", () {
    testWidgets("Should go to next month by click chevron right button", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 1, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["27", "28", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonNext")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonNext")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }
    });

    testWidgets("Should go to previous month by click chevron left button", (WidgetTester tester) async {
      testWidget = MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: DateTime(2022, 12, 1),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);

      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<String> dates = ["27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "1", "2", "3", "4", "5", "6", "7"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["27", "28", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

      await tester.ensureVisible(find.byKey(const Key("buttonPrevious")));
      await tester.pump();
      await tester.tap(find.byKey(const Key("buttonPrevious")));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = ["26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "1", "2", "3", "4", "5"];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i]);
      }

    });

    testWidgets("Should get active and selected date", (WidgetTester tester) async {
      final initialDate = DateTime(2022, 7, 18);
      testWidget = MaterialApp(
        theme: SettingsModel.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: initialDate,
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<DateTime> dates = [
        DateTime(2022, 6, 26), 
        DateTime(2022, 6, 27), 
        DateTime(2022, 6, 28), 
        DateTime(2022, 6, 29), 
        DateTime(2022, 6, 30), 
        DateTime(2022, 7, 1), 
        DateTime(2022, 7, 2), 
        DateTime(2022, 7, 3), 
        DateTime(2022, 7, 4), 
        DateTime(2022, 7, 5), 
        DateTime(2022, 7, 6), 
        DateTime(2022, 7, 7), 
        DateTime(2022, 7, 8), 
        DateTime(2022, 7, 9), 
        DateTime(2022, 7, 10), 
        DateTime(2022, 7, 11), 
        DateTime(2022, 7, 12), 
        DateTime(2022, 7, 13), 
        DateTime(2022, 7, 14), 
        DateTime(2022, 7, 15), 
        DateTime(2022, 7, 16), 
        DateTime(2022, 7, 17), 
        DateTime(2022, 7, 18), 
        DateTime(2022, 7, 19), 
        DateTime(2022, 7, 20), 
        DateTime(2022, 7, 21), 
        DateTime(2022, 7, 22), 
        DateTime(2022, 7, 23), 
        DateTime(2022, 7, 24), 
        DateTime(2022, 7, 25), 
        DateTime(2022, 7, 26), 
        DateTime(2022, 7, 27), 
        DateTime(2022, 7, 28), 
        DateTime(2022, 7, 29), 
        DateTime(2022, 7, 30), 
        DateTime(2022, 7, 31), 
        DateTime(2022, 8, 1), 
        DateTime(2022, 8, 2), 
        DateTime(2022, 8, 3), 
        DateTime(2022, 8, 4), 
        DateTime(2022, 8, 5), 
        DateTime(2022, 8, 6)
      ];

      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i].day.toString());
      }

      for (var i = 0; i < textDays.length; i++) {
        Container container = tester.widget(find.ancestor(of: find.byWidget(textDays[i]), matching: find.byType(Container)));
        final decoration = container.decoration as BoxDecoration;
        
        if (initialDate.isAtSameMomentAs(dates[i])) {
          expect(decoration.color, CustomColors.primary);
          expect(decoration.border, Border.all(color: CustomColors.primary));
          continue;
        }

        expect(decoration.color, isNot(CustomColors.primary));
        expect(decoration.border, Border.all(color: Colors.transparent));
      }

    });

    testWidgets("Should select date properly", (WidgetTester tester) async {
      final initialDate = DateTime(2022, 7, 18);
      testWidget = MaterialApp(
        theme: SettingsModel.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: initialDate,
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      List<DateTime> dates = [
        DateTime(2022, 6, 26), 
        DateTime(2022, 6, 27), 
        DateTime(2022, 6, 28), 
        DateTime(2022, 6, 29), 
        DateTime(2022, 6, 30), 
        DateTime(2022, 7, 1), 
        DateTime(2022, 7, 2), 
        DateTime(2022, 7, 3), 
        DateTime(2022, 7, 4), 
        DateTime(2022, 7, 5), 
        DateTime(2022, 7, 6), 
        DateTime(2022, 7, 7), 
        DateTime(2022, 7, 8), 
        DateTime(2022, 7, 9), 
        DateTime(2022, 7, 10), 
        DateTime(2022, 7, 11), 
        DateTime(2022, 7, 12), 
        DateTime(2022, 7, 13), 
        DateTime(2022, 7, 14), 
        DateTime(2022, 7, 15), 
        DateTime(2022, 7, 16), 
        DateTime(2022, 7, 17), 
        DateTime(2022, 7, 18), 
        DateTime(2022, 7, 19), 
        DateTime(2022, 7, 20), 
        DateTime(2022, 7, 21), 
        DateTime(2022, 7, 22), 
        DateTime(2022, 7, 23), 
        DateTime(2022, 7, 24), 
        DateTime(2022, 7, 25), 
        DateTime(2022, 7, 26), 
        DateTime(2022, 7, 27), 
        DateTime(2022, 7, 28), 
        DateTime(2022, 7, 29), 
        DateTime(2022, 7, 30), 
        DateTime(2022, 7, 31), 
        DateTime(2022, 8, 1), 
        DateTime(2022, 8, 2), 
        DateTime(2022, 8, 3), 
        DateTime(2022, 8, 4), 
        DateTime(2022, 8, 5), 
        DateTime(2022, 8, 6)
      ];

      for (var i = 0; i < dates.length; i++) {
        if (dates[i].isBefore(DateTime(2022, 7, 1)) || dates[i].isAfter(DateTime(2022, 7, 31))) {
          continue;
        }

        Key buttonKey = Key("button${DateFormat("yyyyMMdd").format(dates[i])}");
        await tester.ensureVisible(find.byKey(buttonKey));
        await tester.pump();
        expect(find.byKey(buttonKey), findsOneWidget);
        await tester.tap(find.byKey(buttonKey));
        await tester.pump();

        Key containerKey = Key("container${DateFormat("yyyyMMdd").format(dates[i])}");

        for (var j = 0; j < dates.length; j++) {
          if (dates[j].isBefore(DateTime(2022, 7, 1)) || dates[j].isAfter(DateTime(2022, 7, 31))) {
            continue;
          }

          Key containerKey2 = Key("container${DateFormat("yyyyMMdd").format(dates[j])}");
          Container container = tester.widget<Container>(find.byKey(containerKey2));
          final decoration = container.decoration as BoxDecoration;
          
          if (containerKey == containerKey2) {
            expect(decoration.border, Border.all(color: CustomColors.primary));
            continue;
          }

          expect(decoration.border, Border.all(color: Colors.transparent));
        }  

      }
      
    });

    testWidgets("Should get value from callback properly", (WidgetTester tester) async {
      final initialDate = DateTime(2022, 7, 18);
      DateTime? callbackValue;
      testWidget = MaterialApp(
        theme: SettingsModel.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: initialDate,
              onSelectDate: (value) {
                callbackValue = value;
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      List<DateTime> dates = [
        DateTime(2022, 6, 26), 
        DateTime(2022, 6, 27), 
        DateTime(2022, 6, 28), 
        DateTime(2022, 6, 29), 
        DateTime(2022, 6, 30), 
        DateTime(2022, 7, 1), 
        DateTime(2022, 7, 2), 
        DateTime(2022, 7, 3), 
        DateTime(2022, 7, 4), 
        DateTime(2022, 7, 5), 
        DateTime(2022, 7, 6), 
        DateTime(2022, 7, 7), 
        DateTime(2022, 7, 8), 
        DateTime(2022, 7, 9), 
        DateTime(2022, 7, 10), 
        DateTime(2022, 7, 11), 
        DateTime(2022, 7, 12), 
        DateTime(2022, 7, 13), 
        DateTime(2022, 7, 14), 
        DateTime(2022, 7, 15), 
        DateTime(2022, 7, 16), 
        DateTime(2022, 7, 17), 
        DateTime(2022, 7, 18), 
        DateTime(2022, 7, 19), 
        DateTime(2022, 7, 20), 
        DateTime(2022, 7, 21), 
        DateTime(2022, 7, 22), 
        DateTime(2022, 7, 23), 
        DateTime(2022, 7, 24), 
        DateTime(2022, 7, 25), 
        DateTime(2022, 7, 26), 
        DateTime(2022, 7, 27), 
        DateTime(2022, 7, 28), 
        DateTime(2022, 7, 29), 
        DateTime(2022, 7, 30), 
        DateTime(2022, 7, 31), 
        DateTime(2022, 8, 1), 
        DateTime(2022, 8, 2), 
        DateTime(2022, 8, 3), 
        DateTime(2022, 8, 4), 
        DateTime(2022, 8, 5), 
        DateTime(2022, 8, 6)
      ];

      for (var i = 0; i < dates.length; i++) {
        if (dates[i].isBefore(DateTime(2022, 7, 1)) || dates[i].isAfter(DateTime(2022, 7, 31))) {
          continue;
        }

        Key buttonKey = Key("button${DateFormat("yyyyMMdd").format(dates[i])}");
        await tester.ensureVisible(find.byKey(buttonKey));
        await tester.pump();
        expect(find.byKey(buttonKey), findsOneWidget);
        await tester.tap(find.byKey(buttonKey));
        await tester.pump();

        expect(callbackValue, dates[i]);

      }
      
    });

    testWidgets("Should go to next month when click a date of next month in displayed current month", (WidgetTester tester) async {
      final initialDate = DateTime(2022, 7, 18);
      final selected = DateTime(2022, 8, 3);
      testWidget = MaterialApp(
        theme: SettingsModel.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: initialDate,
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<DateTime> dates = [
        DateTime(2022, 6, 26), 
        DateTime(2022, 6, 27), 
        DateTime(2022, 6, 28), 
        DateTime(2022, 6, 29), 
        DateTime(2022, 6, 30), 
        DateTime(2022, 7, 1), 
        DateTime(2022, 7, 2), 
        DateTime(2022, 7, 3), 
        DateTime(2022, 7, 4), 
        DateTime(2022, 7, 5), 
        DateTime(2022, 7, 6), 
        DateTime(2022, 7, 7), 
        DateTime(2022, 7, 8), 
        DateTime(2022, 7, 9), 
        DateTime(2022, 7, 10), 
        DateTime(2022, 7, 11), 
        DateTime(2022, 7, 12), 
        DateTime(2022, 7, 13), 
        DateTime(2022, 7, 14), 
        DateTime(2022, 7, 15), 
        DateTime(2022, 7, 16), 
        DateTime(2022, 7, 17), 
        DateTime(2022, 7, 18), 
        DateTime(2022, 7, 19), 
        DateTime(2022, 7, 20), 
        DateTime(2022, 7, 21), 
        DateTime(2022, 7, 22), 
        DateTime(2022, 7, 23), 
        DateTime(2022, 7, 24), 
        DateTime(2022, 7, 25), 
        DateTime(2022, 7, 26), 
        DateTime(2022, 7, 27), 
        DateTime(2022, 7, 28), 
        DateTime(2022, 7, 29), 
        DateTime(2022, 7, 30), 
        DateTime(2022, 7, 31), 
        DateTime(2022, 8, 1), 
        DateTime(2022, 8, 2), 
        DateTime(2022, 8, 3), 
        DateTime(2022, 8, 4), 
        DateTime(2022, 8, 5), 
        DateTime(2022, 8, 6)
      ];

      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i].day.toString());
      }

      Key buttonKey = Key("button${DateFormat("yyyyMMdd").format(selected)}"); await tester.ensureVisible(find.byKey(buttonKey));
      await tester.pump();
      expect(find.byKey(buttonKey), findsOneWidget);
      await tester.tap(find.byKey(buttonKey));
      await tester.pump();

      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = [
        DateTime(2022, 7, 31), 
        DateTime(2022, 8, 1), 
        DateTime(2022, 8, 2), 
        DateTime(2022, 8, 3), 
        DateTime(2022, 8, 4), 
        DateTime(2022, 8, 5), 
        DateTime(2022, 8, 6), 
        DateTime(2022, 8, 7), 
        DateTime(2022, 8, 8), 
        DateTime(2022, 8, 9), 
        DateTime(2022, 8, 10), 
        DateTime(2022, 8, 11), 
        DateTime(2022, 8, 12), 
        DateTime(2022, 8, 13), 
        DateTime(2022, 8, 14), 
        DateTime(2022, 8, 15), 
        DateTime(2022, 8, 16), 
        DateTime(2022, 8, 17), 
        DateTime(2022, 8, 18), 
        DateTime(2022, 8, 19), 
        DateTime(2022, 8, 20), 
        DateTime(2022, 8, 21), 
        DateTime(2022, 8, 22), 
        DateTime(2022, 8, 23), 
        DateTime(2022, 8, 24), 
        DateTime(2022, 8, 25), 
        DateTime(2022, 8, 26), 
        DateTime(2022, 8, 27), 
        DateTime(2022, 8, 28), 
        DateTime(2022, 8, 29), 
        DateTime(2022, 8, 30), 
        DateTime(2022, 8, 31), 
        DateTime(2022, 9, 1), 
        DateTime(2022, 9, 2), 
        DateTime(2022, 9, 3), 
        DateTime(2022, 9, 4), 
        DateTime(2022, 9, 5), 
        DateTime(2022, 9, 6),
        DateTime(2022, 9, 7),
        DateTime(2022, 9, 8),
        DateTime(2022, 9, 9),
        DateTime(2022, 9, 10),
      ];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i].day.toString());
        
        Key containerKey2 = Key("container${DateFormat("yyyyMMdd").format(dates[i])}");
        Container container = tester.widget<Container>(find.byKey(containerKey2));
        final decoration = container.decoration as BoxDecoration;
          
        if (DateFormat("yyyy-MM-dd").format(selected) == DateFormat("yyyy-MM-dd").format(dates[i])) {
          expect(decoration.border, Border.all(color: CustomColors.primary));
          continue;
        }

        expect(decoration.border, Border.all(color: Colors.transparent));
      }
      
    });

    testWidgets("Should go to previous month when click a date of previous month in displayed current month", (WidgetTester tester) async {
      final initialDate = DateTime(2022, 7, 18);
      final selected = DateTime(2022, 6, 28);
      testWidget = MaterialApp(
        theme: SettingsModel.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskCalendar(
              initialDate: initialDate,
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      
      List<Text> textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      List<DateTime> dates = [
        DateTime(2022, 6, 26), 
        DateTime(2022, 6, 27), 
        DateTime(2022, 6, 28), 
        DateTime(2022, 6, 29), 
        DateTime(2022, 6, 30), 
        DateTime(2022, 7, 1), 
        DateTime(2022, 7, 2), 
        DateTime(2022, 7, 3), 
        DateTime(2022, 7, 4), 
        DateTime(2022, 7, 5), 
        DateTime(2022, 7, 6), 
        DateTime(2022, 7, 7), 
        DateTime(2022, 7, 8), 
        DateTime(2022, 7, 9), 
        DateTime(2022, 7, 10), 
        DateTime(2022, 7, 11), 
        DateTime(2022, 7, 12), 
        DateTime(2022, 7, 13), 
        DateTime(2022, 7, 14), 
        DateTime(2022, 7, 15), 
        DateTime(2022, 7, 16), 
        DateTime(2022, 7, 17), 
        DateTime(2022, 7, 18), 
        DateTime(2022, 7, 19), 
        DateTime(2022, 7, 20), 
        DateTime(2022, 7, 21), 
        DateTime(2022, 7, 22), 
        DateTime(2022, 7, 23), 
        DateTime(2022, 7, 24), 
        DateTime(2022, 7, 25), 
        DateTime(2022, 7, 26), 
        DateTime(2022, 7, 27), 
        DateTime(2022, 7, 28), 
        DateTime(2022, 7, 29), 
        DateTime(2022, 7, 30), 
        DateTime(2022, 7, 31), 
        DateTime(2022, 8, 1), 
        DateTime(2022, 8, 2), 
        DateTime(2022, 8, 3), 
        DateTime(2022, 8, 4), 
        DateTime(2022, 8, 5), 
        DateTime(2022, 8, 6)
      ];

      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i].day.toString());
      }

      Key buttonKey = Key("button${DateFormat("yyyyMMdd").format(selected)}"); await tester.ensureVisible(find.byKey(buttonKey));
      await tester.pump();
      expect(find.byKey(buttonKey), findsOneWidget);
      await tester.tap(find.byKey(buttonKey));
      await tester.pump();
      
      textDays = tester.widgetList<Text>(find.textContaining(RegExp(r"^[0-9]+$"), skipOffstage: false)).toList();
      dates = [
        DateTime(2022, 5, 29), 
        DateTime(2022, 5, 30), 
        DateTime(2022, 5, 31), 
        DateTime(2022, 6, 1), 
        DateTime(2022, 6, 2), 
        DateTime(2022, 6, 3), 
        DateTime(2022, 6, 4), 
        DateTime(2022, 6, 5), 
        DateTime(2022, 6, 6), 
        DateTime(2022, 6, 7), 
        DateTime(2022, 6, 8), 
        DateTime(2022, 6, 9), 
        DateTime(2022, 6, 10), 
        DateTime(2022, 6, 11), 
        DateTime(2022, 6, 12), 
        DateTime(2022, 6, 13), 
        DateTime(2022, 6, 14), 
        DateTime(2022, 6, 15), 
        DateTime(2022, 6, 16), 
        DateTime(2022, 6, 17), 
        DateTime(2022, 6, 18), 
        DateTime(2022, 6, 19), 
        DateTime(2022, 6, 20), 
        DateTime(2022, 6, 21), 
        DateTime(2022, 6, 22), 
        DateTime(2022, 6, 23), 
        DateTime(2022, 6, 24), 
        DateTime(2022, 6, 25), 
        DateTime(2022, 6, 26), 
        DateTime(2022, 6, 27), 
        DateTime(2022, 6, 28), 
        DateTime(2022, 6, 29), 
        DateTime(2022, 6, 30), 
        DateTime(2022, 7, 1), 
        DateTime(2022, 7, 2), 
        DateTime(2022, 7, 3), 
        DateTime(2022, 7, 4), 
        DateTime(2022, 7, 5), 
        DateTime(2022, 7, 6),
        DateTime(2022, 7, 7),
        DateTime(2022, 7, 8),
        DateTime(2022, 7, 9),
      ];
      for (var i = 0; i < textDays.length; i++) {
        expect(textDays[i].data, dates[i].day.toString());
        
        Key containerKey2 = Key("container${DateFormat("yyyyMMdd").format(dates[i])}");
        Container container = tester.widget<Container>(find.byKey(containerKey2));
        final decoration = container.decoration as BoxDecoration;
          
        if (DateFormat("yyyy-MM-dd").format(selected) == DateFormat("yyyy-MM-dd").format(dates[i])) {
          expect(decoration.border, Border.all(color: CustomColors.primary));
          continue;
        }

        expect(decoration.border, Border.all(color: Colors.transparent));
      }
      
    });

  });
  
}