import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:provider/provider.dart';
import 'package:photo_editor_with_share/src/domain/models/editable_items.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/control_provider.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:photo_editor_with_share/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:photo_editor_with_share/src/domain/sevices/save_as_image.dart';
import 'package:photo_editor_with_share/src/presentation/utils/Extensions/hexColor.dart';
import 'package:photo_editor_with_share/src/presentation/utils/constants/app_enums.dart';
import 'package:photo_editor_with_share/src/presentation/widgets/animated_onTap_button.dart';

/// create item of type GIF
Future createGiphyItem(
    {required BuildContext context, required giphyKey}) async {
  final _editableItem =
      Provider.of<DraggableWidgetNotifier>(context, listen: false);
  _editableItem.giphy = await ModalGifPicker.pickModalSheetGif(
    context: context,
    apiKey: giphyKey,
    rating: GiphyRating.r,
    sticker: true,
    backDropColor: Colors.black,
    crossAxisCount: 3,
    childAspectRatio: 1.2,
    topDragColor: Colors.white.withOpacity(0.2),
  );

  /// create item of type GIF
  if (_editableItem.giphy != null) {
    _editableItem.draggableWidget.add(EditableItem()
      ..type = ItemType.gif
      ..gif = _editableItem.giphy!
      ..position = const Offset(0.0, 0.0));
  }
}

/// custom exit dialog
Future<bool> exitDialog({required context, required contentKey,
String discardEditText = 'Discard Edits?',
String exitMsg = "If you go back now, you'll lose all the edits you've made.",
String cancelText ="cancel",
String discardText = "Discard",
String saveDraftText = "Save Draft"
}) async {
  return (await showDialog(
        context: context,
        barrierColor: Colors.black38,
        barrierDismissible: true,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetAnimationDuration: const Duration(milliseconds: 300),
          insetAnimationCurve: Curves.ease,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 25, bottom: 5, right: 20, left: 20),
              alignment: Alignment.center,
              height: 280,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xff007480),//HexColor.fromHex('#262626'),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white10,
                        offset: Offset(0, 1),
                        blurRadius: 4),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   Text(discardEditText,
                    style:const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   Text(exitMsg,
                    style:const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                        letterSpacing: 0.1),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  /// discard
                  AnimatedOnTapButton(
                    onTap: () async {
                      _resetDefaults(context: context);
                      Navigator.of(context).pop(true);
                    },
                    child: Text(discardText,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent.shade200,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                    child: Divider(
                      color: Colors.white10,
                    ),
                  ),

                  /// save and exit
                  AnimatedOnTapButton(
                    onTap: () async {
                      final _paintingProvider =
                          Provider.of<PaintingNotifier>(context, listen: false);
                      final _widgetProvider =
                          Provider.of<DraggableWidgetNotifier>(context,
                              listen: false);
                      if (_paintingProvider.lines.isNotEmpty ||
                          _widgetProvider.draggableWidget.isNotEmpty) {
                        /// save image
                        var response = await takePicture(
                            contentKey: contentKey,
                            context: context,
                            saveToGallery: true);
                        if (response) {
                          _dispose(
                              context: context, message: 'Successfully saved');
                        } else {
                          _dispose(context: context, message: 'Error');
                        }
                      } else {
                        _dispose(context: context, message: 'Draft Empty');
                      }
                    },
                    child:  Text(saveDraftText,
                      style:const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                    child: Divider(
                      color: Colors.white10,
                    ),
                  ),

                  ///cancel
                  AnimatedOnTapButton(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child:  Text(cancelText,
                      style:const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )) ??
      false;
}

_resetDefaults({required BuildContext context}) {
  final _paintingProvider =
      Provider.of<PaintingNotifier>(context, listen: false);
  final _widgetProvider =
      Provider.of<DraggableWidgetNotifier>(context, listen: false);
  final _controlProvider = Provider.of<ControlNotifier>(context, listen: false);
  final _editingProvider =
      Provider.of<TextEditingNotifier>(context, listen: false);
  _paintingProvider.lines.clear();
  _widgetProvider.draggableWidget.clear();
  _widgetProvider.setDefaults();
  _paintingProvider.resetDefaults();
  _editingProvider.setDefaults();
  _controlProvider.mediaPath = '';
}

_dispose({required context, required message}) {
  _resetDefaults(context: context);
  Fluttertoast.showToast(msg: message);
  Navigator.of(context).pop(true);
}
