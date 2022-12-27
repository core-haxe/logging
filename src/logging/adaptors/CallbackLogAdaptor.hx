package logging.adaptors;

typedef CallbackLogAdapatorConfig = {
    > BaseLogAdaptorConfig,
    var ?callbacks:Array<LogData->Void>;
}

class CallbackLogAdaptor implements ILogAdaptor {
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
        if (_config.callbacks != null) {
            for (cb in _config.callbacks) {
                cb(data);
            }
        }
    }
}