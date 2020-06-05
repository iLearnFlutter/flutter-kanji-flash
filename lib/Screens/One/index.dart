import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_html/style.dart';
import 'package:kanji_flash/Screens/One/data.dart';

class OneScreen extends StatefulWidget {
  const OneScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  OneScreenState createState() => new OneScreenState();
}

class OneScreenState extends State<OneScreen> with TickerProviderStateMixin {
  static const HTML_DATA = """
                  <html>
                    <body>
                      <main>
                         {{ _kanji }}
                      </main>
                    </body>
                  </html>
                 """;
  static const HTML_DATA_HINT = """
                  <html>
                    <body>
                      <main>
                          {{ _kanji }}
                      </main>
                      <footer>
                        
                        <table>
                          <colgroup>
                            <col width="35%" />
                            <col width="25%" />
                            <col width="30%" />
                            <col width="10%" />
                        </colgroup>
                            <tr>
                              <td></td>
                              <th>Hán Việt:</th>
                              <td>{{ _hanviet }}</td>
                              <td></td>
                            </tr>
                            <tr>
                              <td></td>
                              <th>Kun:</th>
                              <td>{{ _kun }}</td>
                              <td></td>
                            </tr>
                            <tr>
                              <td></td>
                              <th>On:</th>
                              <td>{{ _on }}</td>
                              <td></td>
                            </tr>
                        </table>

                      </footer>
                    </body>
                  </html>
                 """;

  String _buildHtmlContent(KanjiData kanji, bool isShownHint) {
    if (!isShownHint) {
      return HTML_DATA.replaceFirst('{{ _kanji }}', kanji?.radical ?? '');
    } else {
      return HTML_DATA_HINT
          .replaceFirst('{{ _kanji }}', kanji?.radical ?? '')
          .replaceFirst('{{ _hanviet }}', kanji?.hint?.hanviet ?? '')
          .replaceFirst('{{ _kun }}', kanji?.hint?.kun ?? '')
          .replaceFirst('{{ _on }}', kanji?.hint?.on ?? '');
    }
  }

  double _dragStart;
  double _dragEnd;
  List<KanjiData> _kanjiList = new List<KanjiData>();
  int _index;
  bool _isShownHint;
  @override
  void initState() {
    super.initState();
    DataListBuilder.build().then((value) => setState(() {
          _kanjiList.addAll(value);
          for (KanjiData item in _kanjiList) {
            print(item.radical);
          }
        }));
    _index = 0;
    _isShownHint = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size _mainFrameSize =
        new Size(screenSize.width - 10, screenSize.height * 8 / 12 - 10);
    Size _kanjiFrameSize = new Size(
        _mainFrameSize.width - 10, _mainFrameSize.height * 6 / 12 - 10);
    return (new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        child: new Container(
          width: screenSize.width,
          height: screenSize.height,
          alignment: Alignment.bottomCenter,
          color: Colors.blueGrey[50],
          child: new Html(
            data: _buildHtmlContent(
                _index < _kanjiList.length
                    ? _kanjiList.elementAt(_index)
                    : null,
                _isShownHint),
            style: {
              "html": Style(
                backgroundColor: Colors.blueGrey[50],
                //backgroundColor: Colors.red,
                alignment: Alignment.topCenter,
                width: _mainFrameSize.width,
                height: _mainFrameSize.height,
              ),
              "main": Style(
                //backgroundColor: Colors.yellow,
                alignment: Alignment.center,
                height: _kanjiFrameSize.height,
                textAlign: TextAlign.center,
                fontStyle: FontStyle.normal,
                fontSize: FontSize.percent(800),
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
              "footer": Style(
                //backgroundColor: Colors.green,
                height: _mainFrameSize.height * 3 / 12 - 10,
                color: Colors.blueGrey,
                alignment: Alignment.topCenter,
                fontStyle: FontStyle.normal,
                fontSize: FontSize.large,
                fontWeight: FontWeight.normal,
              ),
              "table": Style(
                height: _mainFrameSize.height * 3 / 12 - 10,
                alignment: Alignment.center,
              ),
              "th": Style(
                alignment: Alignment.center,
                textAlign: TextAlign.left,
              ),
              "td": Style(
                alignment: Alignment.center,
                textAlign: TextAlign.left,
              )
            },
          ),
        ),
        onHorizontalDragStart: (details) {
          setState(() {
            _dragStart = details.globalPosition.direction;
          });
        },
        onHorizontalDragUpdate: (details) {
          setState(() {
            _dragEnd = _dragStart + details.primaryDelta;
          });
        },
        onHorizontalDragEnd: (details) {
          _nextKanji();
        },
        onDoubleTap: () {
          setState(() {
            _isShownHint = !_isShownHint;
          });
        },
      ),
    ));
  }

  void _nextKanji() {
    setState(() {
      if (_dragStart > _dragEnd) {
        decreaseIndex();
      } else if (_dragStart < _dragEnd) {
        increaseIndex();
      }
    });
  }

  void increaseIndex() {
    _index++;
    if (_index >= _kanjiList.length) {
      _index = 0;
    }
  }

  void decreaseIndex() {
    if (_index <= 0) {
      _index = _kanjiList.length;
    }
    _index--;
  }
}
