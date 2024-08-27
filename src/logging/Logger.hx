package logging;

import haxe.crypto.Sha1;

class Logger implements ILogger {
    private var _ref:String = null;
    private var _instanceId:String = null;
    
    public function new(ref:Class<Dynamic> = null, instanceId:String = null, generateInstanceId:Bool = false) {
        if (ref != null) {
            _ref = Type.getClassName(ref);
        }
        _instanceId = instanceId;
        if (_instanceId == null && generateInstanceId) {
            _instanceId = generateUuid();
        }
    }

    #if !no_inlined_logger
    inline
    #end
    public function info(message:String, data:Dynamic = null) {
        log(LogLevel.Info, message, data);
    }

    #if !no_inlined_logger
    inline
    #end
    public function debug(message:String, data:Dynamic = null) {
        log(LogLevel.Debug, message, data);
    }

    #if !no_inlined_logger
    inline
    #end
    public function error(message:String, data:Dynamic = null) {
        log(LogLevel.Error, message, data);
    }

    #if !no_inlined_logger
    inline
    #end
    public function warn(message:String, data:Dynamic = null) {
        log(LogLevel.Warning, message, data);
    }

    #if !no_inlined_logger
    inline
    #end
    public function data(message:String, data:Dynamic = null) {
        log(LogLevel.Data, message, data);
    }

    #if !no_inlined_logger
    inline
    #end
    public function performance(message:String, data:Dynamic = null) {
        log(LogLevel.Performance, message, data);
    }

    private var _measurements:Map<String, Float> = null;
    #if !no_inlined_logger
    inline
    #end
    public function beginMeasure(name:String) {
        if (_measurements == null) {
            _measurements = [];
        }

        _measurements.set(name, Date.now().getTime());
    }

    #if !no_inlined_logger
    inline
    #end
    public function endMeasure(name:String) {
        if (_measurements == null) {
            _measurements = [];
        }

        if (_measurements.exists(name)) {
            var start = _measurements.get(name);
            var time = Math.round(Date.now().getTime() - start);
            performance(name + " " + time + "ms");
            _measurements.remove(name);
        }
    }

    #if !no_inlined_logger
    inline
    #end
    private function log(level:LogLevel, message:String, data:Dynamic = null) {
        LogManager.instance.log({
            timestamp: Date.now().toString(),
            level: level,
            message: message,
            data: data,
            ref: _ref,
            instanceId: _instanceId
        });
    }

    private static var _uniqueIds:Map<String, Int> = null;
    public function createUniqueInstanceId(prefix:String = null) {
        if (_uniqueIds == null) {
            _uniqueIds = [];
        }
        var key = _ref;
        if (prefix != null) {
            key += "_" + prefix;
        }
        var n = 0;
        if (_uniqueIds.exists(key)) {
            n = _uniqueIds.get(key);
            n++;
        }
        _uniqueIds.set(key, n);
        if (prefix != null) {
            _instanceId = prefix + n;
        } else {
            _instanceId = "instance" + n;
        }
    }

    // certainly not unique, but probably "unique enough" (for logging)
    private function generateUuid():String {
        var uuid = "";
        for (i in 0...8) {
            var n = Date.now().getTime() + Std.random(0xffffff) * Std.random(0xffffff);
            var hash = Sha1.encode(Std.string(n));
            var c1 = hash.charAt(Std.random(hash.length));
            var c2 = hash.charAt(Std.random(hash.length));
            var c3 = hash.charAt(Std.random(hash.length));
            var c4 = hash.charAt(Std.random(hash.length));
            uuid += c1 + c2 + c3 + c4;
            if (i == 1 || i == 2 || i == 3 || i == 4) {
                uuid += "-";
            }
        }
        return uuid;
    }
}