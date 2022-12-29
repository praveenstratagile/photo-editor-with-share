// ignore_for_file: must_be_immutable
library photo_editor_with_share;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/control_provider.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/gradient_notifier.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:photo_editor_with_share/src/presentation/main_view/main_view.dart';

export 'package:photo_editor_with_share/stories_editor.dart';

class ImageEditorWithText extends StatefulWidget {
  /// editor custom font families
  final List<String>? fontFamilyList;

  /// editor custom font families package
  final bool? isCustomFontList;

  /// giphy api key
  final String sampleText;

  /// editor custom color gradients
  final List<List<Color>>? gradientColors;

  /// editor custom logo
  final Widget? middleBottomWidget;

  /// on done
  final Function(String)? onDone;

  /// on done button Text
  final Widget? onDoneButtonStyle;

  /// on back pressed
  final Future<bool>? onBackPress;

  /// editor custom color palette list
  final List<Color>? colorList;

  /// editor background color
  final Color? editorBackgroundColor;

  /// gallery thumbnail quality
  final int? galleryThumbnailQuality;
  final String tapToTypeText;
  final String discardEditText;
  final String exitMsg ;
  final String cancelText ;
  final String discardText;
  final String saveDraftText;
  final String shareText;
  final String? bottomSubText;
  final String? imageAssetPath;

  const ImageEditorWithText(
      {Key? key,
      required this.sampleText,
      required this.onDone,
      this.tapToTypeText = "Tap to Type",
      this.discardEditText = 'Discard Edits?',
      this.exitMsg = "If you go back now, you'll lose all the edits you've made.",
      this.cancelText ="cancel",
      this.discardText = "Discard",
      this.saveDraftText = "Save Draft",
      this.shareText="Share",
      this.imageAssetPath,
      this.bottomSubText,
      this.middleBottomWidget,
      this.colorList,
      this.gradientColors,
      this.fontFamilyList,
      this.isCustomFontList,
      this.onBackPress,
      this.onDoneButtonStyle,
      this.editorBackgroundColor,
      this.galleryThumbnailQuality})
      : super(key: key);

  @override
  _ImageEditorWithTextState createState() => _ImageEditorWithTextState();
}

class _ImageEditorWithTextState extends State<ImageEditorWithText> {
  @override
  void initState() {
    Paint.enableDithering = true;
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (_, __) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ControlNotifier()),
            ChangeNotifierProvider(create: (_) => ScrollNotifier()),
            ChangeNotifierProvider(create: (_) => DraggableWidgetNotifier()),
            ChangeNotifierProvider(create: (_) => GradientNotifier()),
            ChangeNotifierProvider(create: (_) => PaintingNotifier()),
            ChangeNotifierProvider(create: (_) => TextEditingNotifier()),
          ],
          child: MainView(
            sampleText: widget.sampleText,
            tapToTypeText:widget.tapToTypeText,
            discardEditText:widget.discardEditText,
            exitMsg :widget.exitMsg ,
            cancelText :widget.cancelText ,
            discardText:widget.discardText,
            saveDraftText:widget.saveDraftText,
            shareText:widget.shareText,
            bottomSubText:widget.bottomSubText,
            imageAssetPath: widget.imageAssetPath,
            onDone: widget.onDone,
            fontFamilyList: widget.fontFamilyList,
            isCustomFontList: widget.isCustomFontList,
            middleBottomWidget: widget.middleBottomWidget,
            gradientColors: widget.gradientColors,
            colorList: widget.colorList,
            onDoneButtonStyle: widget.onDoneButtonStyle,
            onBackPress: widget.onBackPress,
            editorBackgroundColor: widget.editorBackgroundColor,
            galleryThumbnailQuality: widget.galleryThumbnailQuality,
          ),
        ),
      ),
    );
  }
}
