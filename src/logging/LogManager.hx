package logging;

import haxe.Timer;
import logging.adaptors.NullLogAdaptor;
import logging.formatters.DefaultFormatter;

using StringTools;

class LogManager {
    private static var _instance:LogManager = null;
    public static var instance(get, null):LogManager;
    private static function get_instance():LogManager {
        if (_instance == null) {
            _instance = new LogManager();
        }
        return _instance;
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // instance
    ///////////////////////////////////////////////////////////////////////////
    private var _queue:Array<LogData> = [];
    private var _adaptors:Array<ILogAdaptor> = [];

    public var StartDelay:Int = 50;

    private function new() {
    }

    private var _started:Bool = false;
    private function start() {
        if (_started == true) {
            return;
        }

        // lets start with a very slight delay, in case a bunch of other adaptors are added (might need revision here)
        _started = true;
        Timer.delay(() -> {
            if (_adaptors.length == 0) { // lets add at least one adaptor so the log queue doesnt build up
                _adaptors.push(new NullLogAdaptor());
            }
            processQueue();
        }, StartDelay);
    }

    public function log(data:LogData) {
        _queue.push(data);
        processQueue();
    }

    private function processQueue() {
        if (_adaptors.length == 0) {
            return;
        }
        while (_queue.length > 0) {
            var data = _queue.shift();
            processLogData(data);
        }
    }

    private var _shouldLogDebug:Null<Bool> = null;
    public var shouldLogDebug(get, null):Bool;
    private function get_shouldLogDebug():Bool {
        if (_shouldLogDebug != null) {
            return _shouldLogDebug;
        }

        _shouldLogDebug = willRespondToLevel(LogLevel.Debug);
        return _shouldLogDebug;
    }

    private var _shouldLogData:Null<Bool> = null;
    public var shouldLogData(get, null):Bool;
    private function get_shouldLogData():Bool {
        if (_shouldLogData != null) {
            return _shouldLogData;
        }

        _shouldLogData = willRespondToLevel(LogLevel.Data);
        return _shouldLogData;
    }

    private var _shouldLogWarnings:Null<Bool> = null;
    public var shouldLogWarnings(get, null):Bool;
    private function get_shouldLogWarnings():Bool {
        if (_shouldLogWarnings != null) {
            return _shouldLogWarnings;
        }

        _shouldLogWarnings = willRespondToLevel(LogLevel.Warning);
        return _shouldLogWarnings;
    }

    private function willRespondToLevel(level:LogLevel):Bool {
        var willRespond = false;
        for (a in _adaptors) {
            if (a.config.disabled) {
                continue;
            }

            if (a.config.levels == null) {
                willRespond = true;
                continue;
            }

            if (a.config.levels.contains(level)) {
                willRespond = true;
                break;
            }
        }
        return willRespond;
    }

    private function processLogData(data:LogData) {
        for (a in _adaptors) {
            var allow = !a.config.disabled;

            if (allow && a.config.levels != null) {
                if (!a.config.levels.contains(data.level)) {
                    allow = false;
                }
            }
            if (allow && data.ref != null && a.config.packages != null) {
                for (p in a.config.packages) {
                    if (!data.ref.startsWith(p)) {
                        allow = false;
                        break;
                    }
                }
            }

            if (allow == true) {
                a.processLogData(data);
            }
        }
    }

    public function addAdaptor(adaptor:ILogAdaptor) {
        if (adaptor.config.formatter == null) {
            adaptor.config.formatter = new DefaultFormatter();
        }
        _adaptors.push(adaptor);
        _shouldLogDebug = null;
        _shouldLogWarnings = null;
        start();
    }

    public function clearAdaptors() {
        _adaptors = [];
        _adaptors.push(new NullLogAdaptor());
    }
}