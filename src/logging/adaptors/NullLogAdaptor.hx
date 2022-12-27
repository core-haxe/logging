package logging.adaptors;

class NullLogAdaptor implements ILogAdaptor {
    private var _config:BaseLogAdaptorConfig;
    
    public function new() {
        _config = {};
    }

    public var config(get, null):BaseLogAdaptorConfig;
    private function get_config():BaseLogAdaptorConfig {
        return _config;
    }

    public function processLogData(data:LogData) {
    }
}