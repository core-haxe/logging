package logging.adaptors;

import sys.FileSystem;
import sys.io.File;

typedef CallbackLogAdapatorConfig = {
    > BaseLogAdaptorConfig,
    var ?filename:String;
    var ?maxSizeBytes:Int;
}

class FileLogAdaptor implements ILogAdaptor {
    private var _config:CallbackLogAdapatorConfig;
    
    public function new(config:CallbackLogAdapatorConfig = null) {
        _config = config;
        if (_config == null) {
            _config = {};
        }
    }

    public var config(get, null):BaseLogAdaptorConfig;
    private function get_config():BaseLogAdaptorConfig {
        return _config;
    }

    public function processLogData(data:LogData) {
        var sb = new StringBuf();
        config.formatter.format(data, sb);

        var filename = data.ref + ".log";
        if (_config.filename != null) {
            filename = _config.filename;
        }
        var maxSizeBytes:Int = 41943040; // 40mb default
        if (_config.maxSizeBytes != null) {
            maxSizeBytes = _config.maxSizeBytes;
        }

        if (!FileSystem.exists(filename)) {
            File.saveContent(filename, "");
        }
        var stats = FileSystem.stat(filename);
        if (stats.size > maxSizeBytes) {
            FileSystem.deleteFile(filename);
        }

        var fileData:String = null;
        if (data.data != null) {
            fileData = sb.toString() + ", " + data.data + "\n";
        } else {
            fileData = sb.toString() + "\n";
        }

        #if nodejs // File.append doesnt actually append on nodejs under OSX (and probably other haxe targets)

        var file = js.node.Fs.openSync(filename, "a"); // 'a' = append
        js.node.Fs.writeSync(file, fileData);
        js.node.Fs.closeSync(file);

        #else

        var file = File.append(filename, false);
        file.writeString(filefileData);
        file.close();

        #end
    }
}