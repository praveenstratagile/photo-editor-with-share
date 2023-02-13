import 'package:flutter/material.dart';
import 'package:photo_editor_with_share/stories_editor.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter stories editor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageEditorWithText(
                            editorBackgroundColor: const Color(0xff007480),
                            sampleText:
                                'هذه هي الطريقة التي ننشئ بها حزمة للتطبيقات The watson have a family and he is well handsome gentleman. this text is used to determine the shadow effect that occure between texts',
                            //fontFamilyList: const ['Shizuru', 'Aladin'],
                            galleryThumbnailQuality: 300,
                            imageAssetPath: "assets/images/yakinLogo.png",
                            //isCustomFontList: true,
                            exitMsg: "the is the way to save ",
                            onDone: (uri) {
                              debugPrint(uri);
                              Share.shareFiles([uri]);
                            },
                          )));
            },
            child: const Text('Open Stories Editor'),
          ),
        ));
  }
}
