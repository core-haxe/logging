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

        var stats = FileSystem.stat(filename);
        if (stats.size > maxSizeBytes) {
            FileSystem.deleteFile(filename);
        }

        var file = File.append(filename, false);
        if (data.data != null) {
            file.writeString(sb.toString() + ", " + data.data + "\n");
        } else {
            file.writeString(sb.toString() + "\n");
        }

        file.close();
    }
}