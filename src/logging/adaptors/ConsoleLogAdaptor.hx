package logging.adaptors;

typedef ConsoleLogAdapatorConfig = {
    > BaseLogAdaptorConfig,
    var ?prefix:String;
}

class ConsoleLogAdaptor implements ILogAdaptor {
    private var _config:ConsoleLogAdapatorConfig;
    private var _formatter:ILogLineFormatter = null;

    public function new(config:ConsoleLogAdapatorConfig = null) {
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
        if (_config.prefix != null) {
            sb.add(_config.prefix);
        }

        config.formatter.format(data, sb);

        print(sb.toString(), data.data);
    }

    private inline function print(s:String, data:Any = null) {
        #if js
        if (data != null) {
            js.Browser.console.log(s, config.formatter.formatObject(data));
        } else {
            js.Browser.console.log(s);
        }
        #elseif sys
        Sys.println(s);
        #else
        trace(s);
        #end
    }
}