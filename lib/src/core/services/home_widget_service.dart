import 'package:home_widget/home_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeWidgetServiceProvider = Provider((ref) => HomeWidgetService());

class HomeWidgetService {
  static const String _groupId = 'group.dart_vader_notes'; 
  final String _androidWidgetName = 'WidgetProvider'; // Class name in AndroidManifest

  Future<void> updateWidget() async {
    // Save data if needed
    // await HomeWidget.saveWidgetData('title', 'New Note');
    // await HomeWidget.updateWidget(
    //   name: _androidWidgetName,
    //   androidName: _androidWidgetName, 
    //   iOSName: 'DartVaderWidget',
    // );
  }

  Future<void> init() async {
    // Check if launched from widget
    final uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    // Handle navigation if needed
  }
}
