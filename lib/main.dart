import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:kanji_flash/Screens/One/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lướt Kanji',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OneScreen(title: 'Lướt Kanji'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const htmlData = """
                  <html>
                    <body>
                      <main>
                        <ruby>
                          漢<rt>かん</rt>
                          字<rt>じ</rt>
                        </ruby>
                      </main>
                    </body>
                  </html>
                 """;

class _MyHomePageState extends State<MyHomePage> {
  void _settings() {
    // do setings
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Html(
            data: htmlData,
            style: {
              "html": Style(
                backgroundColor: Colors.blueGrey[50],
                alignment: Alignment.center,
              ),
              "main": Style(
                color: Colors.blueGrey,
                textAlign: TextAlign.center,
                fontStyle: FontStyle.normal,
                fontSize: FontSize.percent(550),
                fontWeight: FontWeight.bold,
              ),
            },
            customRender: {
              "flutter": (RenderContext context, Widget child, attributes, _) {
                return FlutterLogo(
                  style: (attributes['horizontal'] != null)
                      ? FlutterLogoStyle.horizontal
                      : FlutterLogoStyle.markOnly,
                  textColor: context.style.color,
                  size: context.style.fontSize.size * 5,
                );
              },
            },
            onLinkTap: (url) {
              print("Opening $url...");
            },
            onImageTap: (src) {
              print(src);
            },
            onImageError: (exception, stackTrace) {
              print(exception);
            }),
      ),
      backgroundColor: Colors.blueGrey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: _settings,
        child: Icon(Icons.settings),
      ),
    );
  }
}
