//
// Generated file. Do not edit.
// This file is generated from template in file `flutter_tools/lib/src/flutter_plugins.dart`.
//

// @dart = 2.18

import 'dart:io'; // flutter_ignore: dart_io_import.
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:rich_clipboard_android/rich_clipboard_android.dart';
import 'package:google_maps_flutter_ios/google_maps_flutter_ios.dart';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:rich_clipboard_ios/rich_clipboard_ios.dart';
import 'package:rich_clipboard_linux/rich_clipboard_linux.dart';
import 'package:rich_clipboard_macos/rich_clipboard_macos.dart';
import 'package:rich_clipboard_windows/rich_clipboard_windows.dart';

@pragma('vm:entry-point')
class _PluginRegistrant {

  @pragma('vm:entry-point')
  static void register() {
    if (Platform.isAndroid) {
      try {
        GoogleMapsFlutterAndroid.registerWith();
      } catch (err) {
        print(
          '`google_maps_flutter_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

      try {
        ImagePickerAndroid.registerWith();
      } catch (err) {
        print(
          '`image_picker_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

      try {
        MethodChannelRichClipboard.registerWith();
      } catch (err) {
        print(
          '`rich_clipboard_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

    } else if (Platform.isIOS) {
      try {
        GoogleMapsFlutterIOS.registerWith();
      } catch (err) {
        print(
          '`google_maps_flutter_ios` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

      try {
        ImagePickerIOS.registerWith();
      } catch (err) {
        print(
          '`image_picker_ios` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

      try {
        MethodChannelRichClipboard.registerWith();
      } catch (err) {
        print(
          '`rich_clipboard_ios` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

    } else if (Platform.isLinux) {
      try {
        MethodChannelRichClipboard.registerWith();
      } catch (err) {
        print(
          '`rich_clipboard_linux` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

    } else if (Platform.isMacOS) {
      try {
        MethodChannelRichClipboard.registerWith();
      } catch (err) {
        print(
          '`rich_clipboard_macos` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

    } else if (Platform.isWindows) {
      try {
        RichClipboardWindows.registerWith();
      } catch (err) {
        print(
          '`rich_clipboard_windows` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

    }
  }
}
