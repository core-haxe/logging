package logging;

class Logger implements ILogger {
    private var _ref:String = null;
    private var _instanceId:String = null;
    
    public function new(ref:Class<Dynamic> = null, instanceId:String = null) {
        if (ref != null) {
            _ref = Type.getClassName(ref);
        }
        _instanceId = instanceId;
    }

    public function info(message:String, data:Any = null) {
        log(LogLevel.Info, message, data);
    }

    public function debug(message:String, data:Any = null) {
        log(LogLevel.Debug, message, data);
    }

    public function error(message:String, data:Any = null) {
        log(LogLevel.Error, message, data);
    }

    public function warn(message:String, data:Any = null) {
        log(LogLevel.Warning, message, data);
    }

    public function data(message:String, data:Any = null) {
        log(LogLevel.Data, message, data);
    }

    public function performance(message:String, data:Any = null) {
        log(LogLevel.Performance, message, data);
    }

    private function log(level:LogLevel, message:String, data:Any = null) {
        LogManager.instance.log({
            timestamp: Date.now().toString(),
            level: level,
            message: message,
            data: data,
            ref: _ref,
            instanceId: _instanceId
        });
    }
}