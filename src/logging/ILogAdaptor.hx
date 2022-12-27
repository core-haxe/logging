package logging;

interface ILogAdaptor {
    var config(get, null):BaseLogAdaptorConfig;
    function processLogData(data:LogData):Void;
}