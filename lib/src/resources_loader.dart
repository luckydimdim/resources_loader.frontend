import 'dart:async';
import 'dart:html';
import 'dart:collection';
import 'package:angular2/core.dart';
import 'handler.dart';

@Injectable()
class ResourcesLoaderService  {

  SplayTreeMap _loadedLinks;
  SplayTreeMap _loadedScripts;

  ResourcesLoaderService(){
    _loadedLinks = new SplayTreeMap();
    _loadedScripts = new SplayTreeMap();
  }

  void loadStyle(String url,String file, {onData(), onError(error), onDone()}){

      var originalFileName = file;

      file = file.toLowerCase();

      if (_loadedLinks.containsKey(file)) {

        Handler handler = _loadedLinks[file];

        if (handler.state == 'loading') {

          if (onData != null)
            handler.onDataCallbacks.add(onData);

          if (onError != null)
            handler.onErrorCallbacks.add(onError);

          if (onDone != null)
            handler.onDoneCallbacks.add(onDone);
        }
        else if (onData != null)
            onData();
      }
      else {

        var handler = new Handler();

        handler.state = 'loading';

        if (onData != null)
          handler.onDataCallbacks.add(onData);

        if (onError != null)
          handler.onErrorCallbacks.add(onError);

        if (onDone != null)
          handler.onDoneCallbacks.add(onDone);

        _loadedLinks[file] = handler;

        var commonLink = new LinkElement()
          ..type = 'text/css'
          ..rel = 'stylesheet'
          ..href = url + originalFileName;
        document.head.append(commonLink);

        commonLink.onLoad.listen((e) => _onData(e, _loadedLinks,file), onError: (error) => _onError(_loadedLinks, file, error), onDone: () => _onDone(_loadedLinks,file));
      }
  }

  void loadScript(String url,String file, bool async, {onData(), onError(error), onDone()}){

    var originalFileName = file;
    file = file.toLowerCase();

    if (_loadedScripts.containsKey(file)) {

      Handler handler = _loadedScripts[file];

      if (handler.state == 'loading') {

        if (onData != null)
          handler.onDataCallbacks.add(onData);

        if (onError != null)
          handler.onErrorCallbacks.add(onError);

        if (onDone != null)
          handler.onDoneCallbacks.add(onDone);
      }
      else if (onData != null)
        onData();
    }
    else {

      var handler = new Handler();

      handler.state = 'loading';

      if (onData != null)
        handler.onDataCallbacks.add(onData);

      if (onError != null)
        handler.onErrorCallbacks.add(onError);

      if (onDone != null)
        handler.onDoneCallbacks.add(onDone);

      _loadedScripts[file] = handler;

      var gridScript = new ScriptElement()
        ..async = async
        ..type = 'text/javascript'
        ..src = url + originalFileName;
      document.head.append(gridScript);

      gridScript.onLoad.listen((e) => _onData(e,_loadedScripts,file), onError: (error) => _onError(_loadedScripts, file, error), onDone: () => _onDone(_loadedScripts,file));
    }
  }

  Future<bool> loadScriptAsync(String url, String file, bool async) {
    var _c = new Completer();

    var originalFileName = file;
    file = file.toLowerCase();

    if (_loadedScripts.containsKey(file)) {
      Handler handler = _loadedScripts[file];

      if (handler.state == 'loading')
        handler.onCompleterCallbacks.add(_c);
      else
        _c.complete(true);
    }
    else {
      var handler = new Handler();

      handler.state = 'loading';

      handler.onCompleterCallbacks.add(_c);

      _loadedScripts[file] = handler;

      var gridScript = new ScriptElement()
        ..async = async
        ..type = 'text/javascript'
        ..src = url + originalFileName;
      document.head.append(gridScript);


      gridScript.onLoad.listen((_) => _Process(_c, _loadedScripts, file, true));
      gridScript.onError.listen((_) => _Process(_c, _loadedScripts, file, false));

    }

    return _c.future;
  }

  void _Process(Completer c, SplayTreeMap map, String file, bool success) {
    Handler handler = map[file];

    handler.state = 'data';

    handler.onCompleterCallbacks.forEach((value) {
      value.complete(success);
    });

    handler.onCompleterCallbacks.clear();
  }

  void _onData(dynamic event, SplayTreeMap map, String file){
    Handler handler = map[file];

    handler.state = 'data';

    handler.onDataCallbacks.forEach((value) {
        value();
    });

    handler.onDataCallbacks.clear();

  }

  void _onError(SplayTreeMap map, String file, dynamic error){

    Handler handler = map[file];

    handler.state = 'error';

    handler.onErrorCallbacks.forEach((value) {
      value(error);
    });

    handler.onDataCallbacks.clear();

  }

  void _onDone(SplayTreeMap map, String file){
    Handler handler = map[file];

    handler.state = 'done';

    handler.onDoneCallbacks.forEach((value) {
      value();
    });

    handler.onDoneCallbacks.clear();

  }

}
